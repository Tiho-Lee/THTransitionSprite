//
//  NSObject+THCommentMethod.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/26.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "NSObject+THCommentMethod.h"
#import <objc/runtime.h>
@implementation NSObject (THCommentMethod)

+ (void)swizzledMethodWithOriginSEL:(SEL)originSEL swizzledSEL:(SEL)swizzledSEL
{
    Method originalMethod = class_getInstanceMethod([self class],originSEL);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSEL);
    BOOL didAddMethod = class_addMethod([self class], originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod([self class], swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
