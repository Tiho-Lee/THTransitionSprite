//
//  THTransitionCommon.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 默认动画时长 AD : animation duration 缩写
#define kDefaultAD (0.8)

#define kFloatEndSign (-2.0)
#define kIntEndSign (-2)
#define kObjEndSign (nil)

#define kFloatPlaceholder (-1.0)
#define kIntPlaceholder (-1)
#define kObjPlaceholder ([NSNull null])

#define TH_ARR_INT(...) th_makeArr_int(__VA_ARGS__,kIntEndSign)
#define TH_ARR_FLT(...) th_makeArr_double(__VA_ARGS__,kFloatEndSign)
#define TH_ARR_OBJ(...) th_makeArr_obj(__VA_ARGS__,kObjEndSign)

/// 转场类型定义
typedef NS_OPTIONS(NSInteger ,THTransitionAnimationType )
{
    /// 非法类型 可以用它类判断一个位置枚举类值否是有效的转场类型值
    THTransitionAnimationTypeInvalid = 0 ,
    /// modal present
    THTransitionAnimationTypePresent = 1 << 0,
    /// modal dismiss
    THTransitionAnimationTypeDismiss = 1 << 1,
    /// nav push
    THTransitionAnimationTypePush = 1 << 2,
    /// nav pop
    THTransitionAnimationTypePop = 1 << 3,
    /// 不用系统容器vc时 用户自定义的vc入场模式
    THTransitionAnimationTypeCustomIn = 1 << 4,
    /// 不用系统容器vc时 用户自定义的vc退场模式
    THTransitionAnimationTypeCustomOut = 1 << 5,
    /// tabbar 切换item
    THTransitionAnimationTypeTabBarSwitch = 1 << 6 ,
    /// modal present and dismiss
    THTransitionAnimationTypeModalAll = THTransitionAnimationTypePresent | THTransitionAnimationTypeDismiss,
    /// nav push and pop
    THTransitionAnimationTypeNavAll = THTransitionAnimationTypePush | THTransitionAnimationTypePop,
    /// 所有的入场类型
    THTransitionAnimationTypeAllIn = THTransitionAnimationTypePresent | THTransitionAnimationTypePush | THTransitionAnimationTypeCustomIn ,
    /// 所有的退场类型
    THTransitionAnimationTypeAllOut = THTransitionAnimationTypePush | THTransitionAnimationTypePop | THTransitionAnimationTypeCustomOut,
    /// 所有类型的并集  可以用它类判断一个位置枚举类值否是有效的转场类型值
    THTransitionAnimationTypeAll = THTransitionAnimationTypeModalAll | THTransitionAnimationTypeNavAll | THTransitionAnimationTypeCustomIn | THTransitionAnimationTypeCustomOut |THTransitionAnimationTypeTabBarSwitch,
};

typedef void(^animationActionBlockType)(id <UIViewControllerContextTransitioning> transitionContext, THTransitionAnimationType animationType);
/// 判断 type 是否是合法的转场类型
FOUNDATION_EXPORT BOOL isValidType(THTransitionAnimationType type);
/// 判断 containerType 中是否包含 targetType
FOUNDATION_EXPORT BOOL THTransitionAnimationTypeContain(THTransitionAnimationType containerType , THTransitionAnimationType targetType);

/// 判断 sourceType targetType 两个类型中是否有交集 如果有 就返回交集类型 没有就返回 THTransitionAnimationTypeInvalid
FOUNDATION_EXPORT THTransitionAnimationType THTransitionAnimationTypeIntersection(THTransitionAnimationType sourceType , THTransitionAnimationType targetType);

/// 从sourceType 排除 targetType 会判断 targetType 的合法性 如果不合法 就不做remove操作 失败返回NO
FOUNDATION_EXPORT BOOL THTransitionAnimationTypeRemove(THTransitionAnimationType *sourceType , THTransitionAnimationType targetType);

/// 为sourceType 添加 targetType 会判断 targetType 的合法性 如果不合法 就不做add操作 失败返回NO
FOUNDATION_EXPORT BOOL THTransitionAnimationTypeAdd(THTransitionAnimationType *sourceType , THTransitionAnimationType targetType);

FOUNDATION_EXPORT THTransitionAnimationType THTransitionAnimationTypeFromUINavigationControllerOperation(UINavigationControllerOperation sourceType);



/// 从转场上线文中取出fromvc VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIViewController *fromVC_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext);
/// 从转场上线文中取出tovc VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIViewController *toVC_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext);
/// 从转场上线文中取出fromview VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIView *fromView_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext);
/// 从转场上线文中取出toview VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIView *toView_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext);


/// 转场类型 key
FOUNDATION_EXTERN NSString *const th_bindTypeKey;
/// 转场动画 key
FOUNDATION_EXTERN NSString *const th_bindAnimationKey;
/// 转场时长 key
FOUNDATION_EXTERN NSString *const th_bindDurationKey;
/// 某个转场类型开关 key
FOUNDATION_EXTERN NSString *const th_bindEnableKey;
/// 手势转场 key
FOUNDATION_EXTERN NSString *const th_bindInteractionKey;

/// 根据输入的int 构造NSArray 请用TH_ARR_INT调用 , 尾数不传固定的结束标志会导致死循环
FOUNDATION_EXTERN NSArray *th_makeArr_int(int value , ...);
/// 根据输入的double 构造NSArray 请用TH_ARR_FLT调用 , 尾数不传固定的结束标志会导致死循环
FOUNDATION_EXTERN NSArray *th_makeArr_double(double value , ...);
/// 根据输入的obj 构造NSArray 请用TH_ARR_OBJ调用 , 尾数不传固定的结束标志会导致死循环
FOUNDATION_EXTERN NSArray *th_makeArr_obj(id objc , ...);


#import "THTransitionAnimationProtol.h"
#import "THTransitionInteractionProtol.h"
