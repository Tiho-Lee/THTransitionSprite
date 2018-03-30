//
//  THTransitionAnimationProtol.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THTransitionInteractionClassBinder;
@class THTransitionAnimation;

@protocol THTransitionAnimationProvider<NSObject>

/// 根据type 取出之前绑定的time  如果type 非法 或者根据type 取出来的的不是唯一值  均返回 默认长度 kDefaultAD
- (NSTimeInterval)durationForType:(THTransitionAnimationType)animationType;
/// 根据type 取出之前绑定的THTransitionAnimation  如果type 非法 或者根据type 取出来的的不是唯一值  均返回 nil
- (THTransitionAnimation *)animationForType:(THTransitionAnimationType)animationType;
- (BOOL)enableCustomAnimationForType:(THTransitionAnimationType)animationType;
- (BOOL)containType:(THTransitionAnimationType)animationType;
- (BOOL)hasCustomAnimation;

@end

@protocol THTransitionAnimationClassProvider<NSObject>
+ (BOOL)classHasCustomAnimationType;
+ (NSTimeInterval)classDurationForType:(THTransitionAnimationType)animationType;
+ (THTransitionAnimation *)classAnimationForType:(THTransitionAnimationType)animationType;
+ (BOOL)classEnableCustomAnimationForType:(THTransitionAnimationType)animationType;
@end


@protocol THTransitionAnimationBinder<NSObject>

- (void)bindAnimation:(THTransitionAnimation *)animation
              forType:(THTransitionAnimationType)animationType;

- (void)bindDuartion:(NSTimeInterval)duration
             forType:(THTransitionAnimationType)animationType;

- (void)bindEnable:(BOOL)enable
           forType:(THTransitionAnimationType)animationType;


- (void)bindAnimation:(THTransitionAnimation *)animation
              forType:(THTransitionAnimationType)animationType
             duartion:(NSTimeInterval)duration
               enable:(NSInteger)enable;
- (void)clearAllBind;


@end

@protocol THTransitionAnimationClassBinder<NSObject>
/// 返回协议本身 支持链式调用
+ (Class<THTransitionAnimationClassBinder , THTransitionInteractionClassBinder>)classBindAnimation:(THTransitionAnimation *)animation
                                                   forType:(THTransitionAnimationType)animationType;
/// 返回协议本身 支持链式调用
+ (Class<THTransitionAnimationClassBinder , THTransitionInteractionClassBinder>)classBindDuartion:(NSTimeInterval)duration
                                                  forType:(THTransitionAnimationType)animationType;
/// 返回协议本身 支持链式调用
+ (Class<THTransitionAnimationClassBinder , THTransitionInteractionClassBinder>)classBindEnable:(BOOL)enable
                                                forType:(THTransitionAnimationType)animationType;

/// 返回协议本身 支持链式调用
+ (Class<THTransitionAnimationClassBinder , THTransitionInteractionClassBinder>)classBindAnimation:(THTransitionAnimation *)animation
                                                   forType:(THTransitionAnimationType)animationType
                                                  duartion:(NSTimeInterval)duration
                                                    enable:(NSInteger)enable;

+ (void)classClearAllBind;
@end

