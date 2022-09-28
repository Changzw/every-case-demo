//
//  MethodSignature.m
//  xxxx
//
//  Created by Fri on 2022/9/23.
//

#import "MethodSignature.h"
#import <objc/runtime.h>
@implementation MethodSignature

- (void) test {
  // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
  NSMethodSignature * sig = [NSNumber instanceMethodSignatureForSelector:@selector (init)];
  NSLog(@"Signature: %@", sig);
  
  
  //--------------
  SEL myMethod = @selector(myLog);
  NSLog(@"myMethod: %s", myMethod);
  // 通过签名初始化
  NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
  NSLog(@"invocatin: %@", invocatin);
  // 设置 target
  [invocatin setTarget:self];
  // 设置 selecteor
  [invocatin setSelector:myMethod];
  // 消息调用
  [invocatin invoke];
  
  NSMethodSignature *sign1 = [@"" methodSignatureForSelector:@selector(initWithFormat:)];
  NSMethodSignature *sign2 = [NSClassFromString(@"NSString") instanceMethodSignatureForSelector:@selector(initWithFormat:)];
  NSLog(@"%@",sign1);
  NSLog (@"-----");
  NSLog(@"%@",sign2);
  
  Method m = class_getInstanceMethod(NSString.class, @selector(initWithFormat:));
  const char *c = method_getTypeEncoding(m);
  NSLog(@"%s", c);
  NSLog (@"-----");
}

-(void) myLog {
    NSLog (@"MyLog-----");
}
@end
