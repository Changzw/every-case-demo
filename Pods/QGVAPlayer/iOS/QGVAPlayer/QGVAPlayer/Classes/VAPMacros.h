// VAPMacros.h
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

#ifndef VAPMacros_h
#define VAPMacros_h

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#ifndef HWDSYNTH_DYNAMIC_PROPERTY_OBJECT
#define HWDSYNTH_DYNAMIC_PROPERTY_OBJECT(_dynamic_getter_, _dynamic_setter_, _association_policy_) \
- (void)_dynamic_setter_ : (id)object { \
[self willChangeValueForKey:@#_dynamic_getter_]; \
objc_setAssociatedObject(self, _cmd, object, _association_policy_); \
[self didChangeValueForKey:@#_dynamic_getter_]; \
} \
- (id)_dynamic_getter_ { \
return objc_getAssociatedObject(self, @selector(_dynamic_setter_:)); \
}
#endif

#ifndef HWDSYNTH_DYNAMIC_PROPERTY_CTYPE
#define HWDSYNTH_DYNAMIC_PROPERTY_CTYPE(_dynamic_getter_, _dynamic_setter_, _type_) \
- (void)_dynamic_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_dynamic_getter_]; \
NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
[self didChangeValueForKey:@#_dynamic_getter_]; \
} \
- (_type_)_dynamic_getter_ { \
_type_ cValue = { 0 }; \
NSValue *value = objc_getAssociatedObject(self, @selector(_dynamic_setter_:)); \
[value getValue:&cValue]; \
return cValue; \
}
#endif

#import "QGHWDShaderTypes.h"
#import <UIKit/UIKit.h>
#import "QGVAPMaskInfo.h"

extern NSInteger const kQGHWDMP4DefaultFPS;      //??????fps 25
extern NSInteger const kQGHWDMP4MinFPS;          //??????fps 1
extern NSInteger const QGHWDMP4MaxFPS;          //??????fps 60

extern NSInteger const VapMaxCompatibleVersion; //??????????????????

@class QGVAPSourceDisplayItem;

typedef UIView VAPView; //??????????????????

/* mp4??????????????????alpha?????????????????????*/
typedef NS_ENUM(NSInteger, QGHWDTextureBlendMode){
    
    QGHWDTextureBlendMode_AlphaLeft                 = 0,          // ??????alpha
    QGHWDTextureBlendMode_AlphaRight                = 1,          // ??????alpha
    QGHWDTextureBlendMode_AlphaTop                  = 2,          // ??????alpha
    QGHWDTextureBlendMode_AlphaBottom               = 3,          // ??????alpha
};

typedef void(^VAPImageCompletionBlock)(UIImage * image, NSError * error,NSString *imageURL);

typedef void(^VAPGestureEventBlock)(UIGestureRecognizer *gestureRecognizer, BOOL insideSource, QGVAPSourceDisplayItem *source);

#endif /* VAPMacros_h */
