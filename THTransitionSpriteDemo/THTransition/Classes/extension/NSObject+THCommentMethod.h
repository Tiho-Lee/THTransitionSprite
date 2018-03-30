//
//  NSObject+THCommentMethod.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/26.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (THCommentMethod)
+ (void)swizzledMethodWithOriginSEL:(SEL)originSEL swizzledSEL:(SEL)swizzledSEL;
@end
