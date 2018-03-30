//
//  THControllerTransitionManager.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/13.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THControllerTransitionManager.h"
#import "UIViewController+THTranstionAnimationSupport.h"

#define IdPtr_2_IntVal(idPtr) @((NSInteger)((__bridge void *)idPtr))

@implementation THControllerTransitionManager

+ (instancetype)SingleManager
{
    static dispatch_once_t onceToken;
    static THControllerTransitionManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[THControllerTransitionManager alloc] init];
    });
    return instance;
}

- (THTransitionAnimation *)seekAnimationForType:(THTransitionAnimationType)animationType vc:(UIViewController *)vc
{
    THTransitionAnimation  *res = nil ;
    NSTimeInterval duration = 0 ;
    THTransitionInteraction *interAction = nil ;
    if ([vc respondsToSelector:@selector(enableCustomAnimationForType:)]) {
        if (![vc enableCustomAnimationForType:animationType]) {
            res = nil;
        }else
        {
            if ([vc respondsToSelector:@selector(animationForType:)]) {
                THTransitionAnimation *animation = [vc animationForType:animationType];
                duration = [vc durationForType:animationType];
                interAction = [vc interactionForType:animationType];
                res = animation;
            }
        }
    }
    if (res == nil) {
        if ([vc.class respondsToSelector:@selector(classEnableCustomAnimationForType:)]) {
            if (![vc.class classEnableCustomAnimationForType:animationType]) {
                res = nil;
            }else
            {
                if ([vc.class respondsToSelector:@selector(classAnimationForType:)]) {
                    THTransitionAnimation *animation = [vc.class classAnimationForType:animationType];
                    duration = [vc.class classDurationForType:animationType];
                    interAction = [vc interactionForType:animationType];
                    res = animation;
                }
            }
        }
    }
    
    if (res && duration > 0) {
        res.animationDuration = duration ;
    }
    res.interaction = interAction ;
    
    return res ;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    id animation =  [self seekAnimationForType:THTransitionAnimationTypePresent vc:presented];
    if (animation) {
        return animation;
    }
    if ([self.nextDelegate respondsToSelector:@selector(animationControllerForPresentedController:presentingController:sourceController:)]) {
        return [self.nextDelegate animationControllerForPresentedController:presented presentingController:presenting sourceController:source];
    }
    return nil ;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id animation =  [self seekAnimationForType:THTransitionAnimationTypeDismiss vc:dismissed];
    if (animation) {
        return animation;
    }
    if ([self.nextDelegate respondsToSelector:@selector(animationControllerForDismissedController:)]) {
        return [self.nextDelegate animationControllerForDismissedController:dismissed];
    }
    return nil ;
}


- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    THTransitionAnimation *animation = animator ;
    if ([animation isKindOfClass:[THTransitionAnimation class]]) {
        return animation.interaction;
    }

    if ([self.nextDelegate respondsToSelector:@selector(interactionControllerForPresentation:)]) {
        return [self.nextDelegate interactionControllerForPresentation:animator];
    }
    return nil ;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    THTransitionAnimation *animation = animator ;
    if ([animation isKindOfClass:[THTransitionAnimation class]]) {
        NSLog(@"interactionControllerForDismissal %@" , animation.interaction);
        return animation.interaction;
    }
    
    if ([self.nextDelegate respondsToSelector:@selector(interactionControllerForDismissal:)]) {
        return [self.nextDelegate interactionControllerForDismissal:animator];
    }
    return nil ;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    if ([self.nextDelegate respondsToSelector:@selector(presentationControllerForPresentedViewController:presentingViewController:sourceViewController:)]) {
        return [self.nextDelegate presentationControllerForPresentedViewController:presented presentingViewController:presenting sourceViewController:source];
    }
    return nil ;
}



- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    THTransitionAnimationType transitionType = THTransitionAnimationTypeFromUINavigationControllerOperation(operation);
    id animation =  [self seekAnimationForType:transitionType vc:fromVC];
    if (animation) {
        return animation;
    }
    if ([self.nextDelegate_nav respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.nextDelegate_nav navigationController:navigationController
                           animationControllerForOperation:operation
                                        fromViewController:fromVC
                                          toViewController:toVC];
    }
    return nil ;
}

@end

