//
//  THTransitionCommon.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THTransitionCommon.h"

NSString *const th_bindTypeKey = @"th_bindTypeKey";
NSString *const th_bindAnimationKey = @"th_bindAnimationKey";
NSString *const th_bindDurationKey = @"th_bindDurationKey";
NSString *const th_bindEnableKey = @"th_bindEnableKey";
NSString *const th_bindInteractionKey = @"th_bindInteractionKey";

FOUNDATION_EXPORT inline BOOL isValidType(THTransitionAnimationType type)
{
    return (type & THTransitionAnimationTypeAll) != THTransitionAnimationTypeInvalid;
}

FOUNDATION_EXPORT inline BOOL  THTransitionAnimationTypeContain(THTransitionAnimationType containerType , THTransitionAnimationType targetType)
{
    return (containerType | targetType) == containerType ;
}

/// 判断 sourceType targetType 两个类型中是否有交集 如果有 就返回交集类型 没有就返回 THTransitionAnimationTypeInvalid
FOUNDATION_EXPORT inline THTransitionAnimationType THTransitionAnimationTypeIntersection(THTransitionAnimationType sourceType , THTransitionAnimationType targetType)
{
    return sourceType & targetType ;
}


/// 从sourceType 排除 targetType
FOUNDATION_EXPORT inline BOOL THTransitionAnimationTypeRemove(THTransitionAnimationType *sourceType , THTransitionAnimationType targetType)
{
    if (!isValidType(targetType)) {
        return NO;
    }
    *sourceType &= ~(*sourceType & targetType);
    return YES;
}

/// 为sourceType 添加 targetType
FOUNDATION_EXPORT inline BOOL THTransitionAnimationTypeAdd(THTransitionAnimationType *sourceType , THTransitionAnimationType targetType)
{
    if (!isValidType(targetType))
    {
        return NO;
    }
    *sourceType |= targetType ;
    return YES;
}

/// 从转场上线文中取出fromvc VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIViewController *fromVC_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext)
{
    return [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}
/// 从转场上线文中取出tovc VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIViewController *toVC_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext)
{
    return [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}
/// 从转场上线文中取出fromview VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIView *fromView_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext)
{
    return [transitionContext viewForKey:UITransitionContextFromViewKey];
}
/// 从转场上线文中取出toview VCCT view controller ContextTransitioning
FOUNDATION_EXPORT UIView *toView_of_UIVCCT(id<UIViewControllerContextTransitioning> transitionContext)
{
    return [transitionContext viewForKey:UITransitionContextToViewKey];
}

FOUNDATION_EXPORT THTransitionAnimationType THTransitionAnimationTypeFromUINavigationControllerOperation(UINavigationControllerOperation sourceType)
{
    switch (sourceType) {
        case UINavigationControllerOperationPop:
            return THTransitionAnimationTypePop;
        case UINavigationControllerOperationPush:
            return THTransitionAnimationTypePush;
        default:
            return THTransitionAnimationTypeInvalid;
            break;
    }
}

NSArray *th_makeArr_int(int value , ...)
{
    va_list typeList ;
    int tmpValue ;
    va_start(typeList, value);
    NSMutableArray *arrM = [NSMutableArray array];
    if (value == kIntEndSign) {
        return  arrM.copy;
    }
    [arrM addObject:@(value)];
    while (1) {
        tmpValue = va_arg(typeList, int);
        if (kIntEndSign == tmpValue) {
            break;
        }
        [arrM addObject:@(tmpValue)];
    }
    
    return arrM.copy;
}

NSArray *th_makeArr_double(double value , ...)
{
    va_list typeList ;
    double tmpValue ;
    va_start(typeList, value);
    NSMutableArray *arrM = [NSMutableArray array];
    if (value == kFloatEndSign) {
        return  arrM.copy;
    }
    [arrM addObject:@(value)];
    while (1) {
        tmpValue = va_arg(typeList, double);
        if (kFloatEndSign == tmpValue) {
            break;
        }
        [arrM addObject:@(tmpValue)];
    }
    
    return arrM.copy;
}

NSArray *th_makeArr_obj(id objc , ...)
{
    va_list typeList ;
    id tmpValue ;
    va_start(typeList, objc);
    NSMutableArray *arrM = [NSMutableArray array];
    while (1) {
        tmpValue = va_arg(typeList, id);
        if (kObjEndSign == tmpValue) {
            break;
        }
        [arrM addObject:tmpValue];
    }
    return arrM.copy;
}

