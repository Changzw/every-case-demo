// QGMP4FrameHWDecoder.m
// Tencent is pleased to support the open source community by making vap available.
//
// Copyright (C) 2020 THL A29 Limited, a Tencent company.  All rights reserved.
//
// Licensed under the MIT License (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
//
// http://opensource.org/licenses/MIT
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

#import "QGMP4FrameHWDecoder.h"
#import "QGVAPWeakProxy.h"
#import "QGMP4AnimatedImageFrame.h"
#import "QGBaseAnimatedImageFrame+Displaying.h"
#import <VideoToolbox/VideoToolbox.h>
#import "QGHWDMP4OpenGLView.h"
#import "QGMP4Parser.h"
#import "QGVAPSafeMutableArray.h"
#import "NSNotificationCenter+VAPThreadSafe.h"
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIDevice (HWD)

- (BOOL)hwd_isSimulator {
    static dispatch_once_t token;
    static BOOL isSimulator = NO;
    dispatch_once(&token, ^{
        NSString *model = [self machineName];
        if ([model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"]) {
            isSimulator = YES;
        }
    });
    return isSimulator;
}

- (NSString *)machineName {
    static dispatch_once_t token;
    static NSString *name;
    dispatch_once(&token, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machineName = malloc(size);
        sysctlbyname("hw.machine", machineName, &size, NULL, 0);
        name = [NSString stringWithUTF8String:machineName];
        free(machineName);
    });
    return name;
}

@end

@interface NSArray (SafeOperation)

@end

@implementation NSArray (SafeOperation)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        NSAssert(0, @"Error: access to array index which is beyond bounds! ");
        return nil;
    }
    
    return self[index];
}

@end

@interface QGMP4FrameHWDecoder() {
    
    NSMutableArray *_buffers;
    
    int _videoStream;
    int _outputWidth, _outputHeight;
    OSStatus _status;
    BOOL _isFinish;
    VTDecompressionSessionRef _mDecodeSession;
    CMFormatDescriptionRef  _mFormatDescription;
    NSInteger _finishFrameIndex;
    NSError *_constructErr;
    QGMP4ParserProxy *_mp4Parser;
}

@property (atomic, strong) dispatch_queue_t decodeQueue; //dispatch decode task
@property (nonatomic, strong) NSData *ppsData; //Picture Parameter Set
@property (nonatomic, strong) NSData *spsData; //Sequence Parameter Set
/** Video Parameter Set */
@property (nonatomic, strong) NSData *vpsData;

@end

NSString *const QGMP4HWDErrorDomain = @"QGMP4HWDErrorDomain";

@implementation QGMP4FrameHWDecoder

+ (NSString *)errorDescriptionForCode:(QGMP4HWDErrorCode)errorCode {
    
    NSArray *errorDescs = @[@"???????????????",@"??????????????????",@"???????????????????????????",@"?????????????????????",@"VTB??????desc??????",@"VTB??????session??????"];
    NSString *desc = @"";
    switch (errorCode) {
        case QGMP4HWDErrorCode_FileNotExist:
            desc = [errorDescs safeObjectAtIndex:0];
            break;
        case QGMP4HWDErrorCode_InvalidMP4File:
            desc = [errorDescs safeObjectAtIndex:1];
            break;
        case QGMP4HWDErrorCode_CanNotGetStreamInfo:
            desc = [errorDescs safeObjectAtIndex:2];
            break;
        case QGMP4HWDErrorCode_CanNotGetStream:
            desc = [errorDescs safeObjectAtIndex:3];
            break;
        case QGMP4HWDErrorCode_ErrorCreateVTBDesc:
            desc = [errorDescs safeObjectAtIndex:4];
            break;
        case QGMP4HWDErrorCode_ErrorCreateVTBSession:
            desc = [errorDescs safeObjectAtIndex:5];
            break;
            
        default:
            break;
    }
    return desc;
}

- (instancetype)initWith:(QGMP4HWDFileInfo *)fileInfo error:(NSError *__autoreleasing *)error{
    
    if (self = [super initWith:fileInfo error:error]) {
        _decodeQueue = dispatch_queue_create("com.qgame.vap.decode", DISPATCH_QUEUE_SERIAL);
        _mp4Parser = fileInfo.mp4Parser;
        BOOL isOpenSuccess = [self onInputStart];
        if (!isOpenSuccess) {
            VAP_Event(kQGVAPModuleCommon, @"onInputStart fail!");
            *error = _constructErr;
            self = nil;
            return nil;
        }
        [self registerNotification];
    }
    return self;
}

- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] hwd_addSafeObserver:self selector:@selector(hwd_didReceiveEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] hwd_addSafeObserver:self selector:@selector(hwd_didReceiveEnterBackgroundNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)hwd_didReceiveEnterBackgroundNotification:(NSNotification *)notification {
    
    [self onInputEnd];
}

- (void)decodeFrame:(NSInteger)frameIndex buffers:(NSMutableArray *)buffers {
    
    if (frameIndex == self.currentDecodeFrame) {
        VAP_Event(kQGVAPModuleCommon, @"already in decode");
        return ;
    }
    self.currentDecodeFrame = frameIndex;
    _buffers = buffers;
    dispatch_async(self.decodeQueue, ^{
        [self _decodeFrame:frameIndex];
    });
}

- (void)_decodeFrame:(NSInteger)frameIndex {
    
    if (_isFinish) {
        return ;
    }
    
    if (!_buffers) {
        return ;
    }
    
    if (self.spsData == nil || self.ppsData == nil) {
        return ;
    }
    
    //??????????????????
    NSDate *startDate = [NSDate date];
    NSData *packetData = [_mp4Parser readPacketOfSample:frameIndex];
    if (!packetData.length) {
        _finishFrameIndex = frameIndex;
        [self onInputEnd];
        return;
    }
    
    // ???????????????pts,pts??????parse mp4 box????????????
    uint64_t currentPts = [_mp4Parser.videoSamples[frameIndex] pts];
    
    CVPixelBufferRef outputPixelBuffer = NULL;
    // 4. get NALUnit payload into a CMBlockBuffer,
    CMBlockBufferRef blockBuffer = NULL;
    
    _status = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                 (void *)packetData.bytes,
                                                 packetData.length,
                                                 kCFAllocatorNull, NULL, 0,
                                                 packetData.length, 0,
                                                 &blockBuffer);    
    // 6. create a CMSampleBuffer.
    CMSampleBufferRef sampleBuffer = NULL;
    const size_t sampleSizeArray[] = {packetData.length};
    _status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                        blockBuffer,
                                        _mFormatDescription,
                                        1, 0, NULL, 1, sampleSizeArray,
                                        &sampleBuffer);
    
    if (blockBuffer) {
        CFRelease(blockBuffer);
    }
    // 7. use VTDecompressionSessionDecodeFrame
    if (@available(iOS 9.0, *)) {
        __typeof(self) __weak weakSelf = self;
        VTDecodeFrameFlags flags = 0;
        VTDecodeInfoFlags flagOut = 0;
        VTDecompressionSessionDecodeFrameWithOutputHandler(_mDecodeSession, sampleBuffer, flags, &flagOut, ^(OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef  _Nullable imageBuffer, CMTime presentationTimeStamp, CMTime presentationDuration) {
            CFRelease(sampleBuffer);
            __typeof(self) strongSelf = weakSelf;
            if (strongSelf == nil) {
                return;
            }
            
            if(status == kVTInvalidSessionErr) {
                VAP_Error(kQGVAPModuleCommon, @"decompress fail! frame:%@ kVTInvalidSessionErr error:%@", @(frameIndex), @(status));
            } else if(status == kVTVideoDecoderBadDataErr) {
                VAP_Error(kQGVAPModuleCommon, @"decompress fail! frame:%@ kVTVideoDecoderBadDataErr error:%@", @(frameIndex), @(status));
            } else if(status != noErr) {
                VAP_Error(kQGVAPModuleCommon, @"decompress fail! frame:%@ error:%@", @(frameIndex), @(status));
            }
            
            QGMP4AnimatedImageFrame *newFrame = [[QGMP4AnimatedImageFrame alloc] init];
            // imagebuffer??????frame???????????????
            CVPixelBufferRetain(imageBuffer);
            newFrame.pixelBuffer = imageBuffer;
            newFrame.frameIndex = frameIndex; //dts??????
            NSTimeInterval decodeTime = [[NSDate date] timeIntervalSinceDate:startDate]*1000;
            newFrame.decodeTime = decodeTime;
            newFrame.defaultFps =(int) strongSelf->_mp4Parser.fps;
            newFrame.pts = currentPts;
            
            // 8. insert into buffer
            [strongSelf->_buffers addObject:newFrame];
            
            // 9. sort
            [strongSelf->_buffers sortUsingComparator:^NSComparisonResult(QGMP4AnimatedImageFrame * _Nonnull obj1, QGMP4AnimatedImageFrame * _Nonnull obj2) {
                return [@(obj1.pts) compare:@(obj2.pts)];
            }];
        });
    } else {
        // 7. use VTDecompressionSessionDecodeFrame
        VTDecodeFrameFlags flags = 0;
        VTDecodeInfoFlags flagOut = 0;
        _status = VTDecompressionSessionDecodeFrame(_mDecodeSession, sampleBuffer, flags, &outputPixelBuffer, &flagOut);
        
        if(_status == kVTInvalidSessionErr) {
        } else if(_status == kVTVideoDecoderBadDataErr) {
        } else if(_status != noErr) {
        }
        CFRelease(sampleBuffer);
        
        QGMP4AnimatedImageFrame *newFrame = [[QGMP4AnimatedImageFrame alloc] init];
        // imagebuffer??????frame???????????????
        newFrame.pixelBuffer = outputPixelBuffer;
        newFrame.frameIndex = frameIndex;
        NSTimeInterval decodeTime = [[NSDate date] timeIntervalSinceDate:startDate]*1000;
        newFrame.decodeTime = decodeTime;
        newFrame.defaultFps = (int)_mp4Parser.fps;
        
        // 8. insert into buffer
        [_buffers addObject:newFrame];
        
        // 9. sort
        [_buffers sortUsingComparator:^NSComparisonResult(QGMP4AnimatedImageFrame * _Nonnull obj1, QGMP4AnimatedImageFrame * _Nonnull obj2) {
            return [@(obj1.pts) compare:@(obj2.pts)];
        }];
    }
}

#pragma mark - override

- (BOOL)shouldStopDecode:(NSInteger)nextFrameIndex {
    return _isFinish;
}

- (BOOL)isFrameIndexBeyondEnd:(NSInteger)frameIndex {
    
    if (_finishFrameIndex > 0) {
        return (frameIndex >= _finishFrameIndex);
    }
    return NO;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self _onInputEnd];
    self.fileInfo.occupiedCount --;
    if (self.fileInfo.occupiedCount <= 0) {
        
    }
}

#pragma mark - private methods

- (BOOL)onInputStart {
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:self.fileInfo.filePath]) {
        _constructErr = [NSError errorWithDomain:QGMP4HWDErrorDomain code:QGMP4HWDErrorCode_FileNotExist userInfo:[self errorUserInfo]];
        return NO;
    }
    
    _isFinish = NO;
    self.vpsData = nil;
    self.spsData = nil;
    self.ppsData = nil;
    _outputWidth = (int)_mp4Parser.picWidth;
    _outputHeight = (int)_mp4Parser.picHeight;
    
    BOOL paramsSetInitSuccess = [self initPPSnSPS];
    return paramsSetInitSuccess;
}

- (BOOL)initPPSnSPS {
    
    VAP_Info(kQGVAPModuleCommon, @"initPPSnSPS");
    if (self.spsData && self.ppsData) {
        VAP_Error(kQGVAPModuleCommon, @"sps&pps is already has value.");
        return YES;
    }
    
    self.spsData = _mp4Parser.spsData;
    self.ppsData = _mp4Parser.ppsData;
    self.vpsData = _mp4Parser.vpsData;
    
    // 2. create  CMFormatDescription
    if (self.spsData != nil && self.ppsData != nil && _mp4Parser.videoCodecID != QGMP4VideoStreamCodecIDUnknown) {
        if (_mp4Parser.videoCodecID == QGMP4VideoStreamCodecIDH264) {
            const uint8_t* const parameterSetPointers[2] = { (const uint8_t*)[self.spsData bytes], (const uint8_t*)[self.ppsData bytes] };
            const size_t parameterSetSizes[2] = { [self.spsData length], [self.ppsData length] };
            
            _status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                          2,
                                                                          parameterSetPointers,
                                                                          parameterSetSizes,
                                                                          4,
                                                                          &_mFormatDescription);
            if (_status != noErr) {
                VAP_Event(kQGVAPModuleCommon, @"CMVideoFormatDescription. Creation: %@.", (_status == noErr) ? @"successfully." : @"failed.");
                _constructErr = [NSError errorWithDomain:QGMP4HWDErrorDomain code:QGMP4HWDErrorCode_ErrorCreateVTBDesc userInfo:[self errorUserInfo]];
                return NO;
            }
        } else if (_mp4Parser.videoCodecID == QGMP4VideoStreamCodecIDH265) {
            if (@available(iOS 11.0, *)) {
                if(VTIsHardwareDecodeSupported(kCMVideoCodecType_HEVC)) {
                    const uint8_t* const parameterSetPointers[3] = {(const uint8_t*)[self.vpsData bytes], (const uint8_t*)[self.spsData bytes], (const uint8_t*)[self.ppsData bytes]};
                    const size_t parameterSetSizes[3] = {[self.vpsData length], [self.spsData length], [self.ppsData length]};
                    
                    _status = CMVideoFormatDescriptionCreateFromHEVCParameterSets(kCFAllocatorDefault,
                                                                                  3,                    // parameter_set_count
                                                                                  parameterSetPointers, // &parameter_set_pointers
                                                                                  parameterSetSizes,    // &parameter_set_sizes
                                                                                  4,                    // nal_unit_header_length
                                                                                  NULL,
                                                                                  &_mFormatDescription);
                    if (_status != noErr) {
                        VAP_Event(kQGVAPModuleCommon, @"CMVideoFormatDescription. Creation: %@.", (_status == noErr) ? @"successfully." : @"failed.");
                        _constructErr = [NSError errorWithDomain:QGMP4HWDErrorDomain code:QGMP4HWDErrorCode_ErrorCreateVTBDesc userInfo:[self errorUserInfo]];
                        return NO;
                    }
                } else {
                    VAP_Event(kQGVAPModuleCommon, @"H.265 decoding is un-supported because of the hardware");
                    return NO;
                }
            } else {
                VAP_Event(kQGVAPModuleCommon, @"System version is too low to support H.265 decoding");
                return NO;
            }
        }
    }
    
    // 3. create VTDecompressionSession
    CFDictionaryRef attrs = NULL;
    const void *keys[] = {kCVPixelBufferPixelFormatTypeKey};
    //      kCVPixelFormatType_420YpCbCr8Planar is YUV420
    //      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
    uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    const void *values[] = { CFNumberCreate(NULL, kCFNumberSInt32Type, &v) };
    attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        _status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                               _mFormatDescription,
                                               NULL,
                                               attrs,
                                               NULL,
                                               &_mDecodeSession);
        if (_status != noErr) {
            CFRelease(attrs);
            _constructErr = [NSError errorWithDomain:QGMP4HWDErrorDomain code:QGMP4HWDErrorCode_ErrorCreateVTBSession userInfo:[self errorUserInfo]];
            return NO;
        }
    } else {
        VTDecompressionOutputCallbackRecord callBackRecord;
        callBackRecord.decompressionOutputCallback = didDecompress;
        callBackRecord.decompressionOutputRefCon = NULL;
        
        _status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                               _mFormatDescription,
                                               NULL, attrs,
                                               &callBackRecord,
                                               &_mDecodeSession);
        if (_status != noErr) {
            CFRelease(attrs);
            _constructErr = [NSError errorWithDomain:QGMP4HWDErrorDomain code:QGMP4HWDErrorCode_ErrorCreateVTBSession userInfo:[self errorUserInfo]];
            return NO;
        }
    }
    CFRelease(attrs);
    return YES;
}

- (void)_onInputEnd  {
    if (_isFinish) {
        return ;
    }
    _isFinish = YES;
    if (_mDecodeSession) {
        VTDecompressionSessionWaitForAsynchronousFrames(_mDecodeSession);
        VTDecompressionSessionInvalidate(_mDecodeSession);
        CFRelease(_mDecodeSession);
        _mDecodeSession = NULL;
    }
    if (self.spsData || self.ppsData || self.vpsData) {
        self.spsData = nil;
        self.ppsData = nil;
        self.vpsData = nil;
    }
    if (_mFormatDescription) {
        CFRelease(_mFormatDescription);
        _mFormatDescription = NULL;
    }
}

- (void)onInputEnd {
    
    //??????????????????????????????????????????
    __weak __typeof(self) weakSelf = self;
    if ([NSThread isMainThread]) {
        dispatch_sync(self.decodeQueue, ^{
            [weakSelf _onInputEnd];
        });
    } else {
        dispatch_async(self.decodeQueue, ^{
            [weakSelf _onInputEnd];
        });
    }
}

//decode callback
void didDecompress(void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

- (NSDictionary *)errorUserInfo {
    NSDictionary *userInfo = @{@"location" : self.fileInfo.filePath ? : @""};
    return userInfo;
}

@end
