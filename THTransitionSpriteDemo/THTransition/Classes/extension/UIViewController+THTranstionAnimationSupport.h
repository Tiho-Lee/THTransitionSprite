//
//  UIViewController+THTranstionAnimationSupport.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/13.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THTransitionCommon.h"
#import "THTransitionAnimationBinder.h"



typedef UIViewController *(^th_bindTA_chainCodeSupport)(THTransitionAnimation *animation, THTransitionAnimationType animationType, NSTimeInterval duration,BOOL enable);
typedef UIViewController *(^th_bindTA_chainCodeSupport_enable)(THTransitionAnimationType animationType,BOOL enable);
typedef UIViewController *(^th_bindTA_chainCodeSupport_animation)(THTransitionAnimation *animation, THTransitionAnimationType animationType);
typedef UIViewController *(^th_bindTA_chainCodeSupport_duration)(THTransitionAnimationType animationType, NSTimeInterval duration);

typedef Class(^th_bindTA_chainCodeSupport_class)(THTransitionAnimation *animation, THTransitionAnimationType animationType, NSTimeInterval duration,BOOL enable);
typedef Class(^th_bindTA_chainCodeSupport_enable_class)(THTransitionAnimationType animationType,BOOL enable);
typedef Class(^th_bindTA_chainCodeSupport_animation_class)(THTransitionAnimation *animation, THTransitionAnimationType animationType);
typedef Class(^th_bindTA_chainCodeSupport_duration_class)(THTransitionAnimationType animationType, NSTimeInterval duration);

@interface UIViewController (THTranstionAnimationSupport) <THTransitionAnimationProvider , THTransitionAnimationBinder , THTransitionAnimationClassBinder , THTransitionAnimationClassProvider , THTransitionInteractionBinder , THTransitionInteractionProvider , THTransitionInteractionClassBinder , THTransitionInteractionClassProvider>

/// 为实现链式编程 提供的block属性 内部调用 THTransitionAnimationBinder协议中的方法
@property (nonatomic , copy , readonly) th_bindTA_chainCodeSupport th_bindTA;
@property (nonatomic , copy , readonly) th_bindTA_chainCodeSupport_enable th_bindTA_enable;
@property (nonatomic , copy , readonly) th_bindTA_chainCodeSupport_animation th_bindTA_animation;
@property (nonatomic , copy , readonly) th_bindTA_chainCodeSupport_duration th_bindTA_duration;

@property (class , nonatomic , copy , readonly) th_bindTA_chainCodeSupport_class th_bindTA_class;
@property (class , nonatomic , copy , readonly) th_bindTA_chainCodeSupport_enable_class th_bindTA_enable_class;
@property (class , nonatomic , copy , readonly) th_bindTA_chainCodeSupport_animation_class th_bindTA_animation_class;
@property (class , nonatomic , copy , readonly) th_bindTA_chainCodeSupport_duration_class th_bindTA_duration_class;

+ (void)th_commitBindConfig:(NSDictionary *)config;

/// 不要主动调用 这是暴露出来给子类重载用的 且子类必须调用super
- (instancetype)swizzled_initWithCoder:(NSCoder *)aDecoder;

- (void)configInstancePatamsWhenInit;

@end


