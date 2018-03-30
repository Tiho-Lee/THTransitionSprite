//
//  THTransitionPresetAnimation_turn.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THTransitionPresetAnimation_turn.h"

static inline CATransform3D rotate(float angle);
static void turnAnimationPerform(id<UIViewControllerContextTransitioning> transitionContext , BOOL reverse , NSTimeInterval duration);

@implementation THTransitionPresetAnimation_turn

- (instancetype)init
{
    if (self = [super init])
    {
        __weak typeof(self) weakSelf = self ;
        [self setAnimationAction:^(id<UIViewControllerContextTransitioning> transitionContext, THTransitionAnimationType animationType) {
            turnAnimationPerform(transitionContext, isValidType(animationType & THTransitionAnimationTypeAllOut),weakSelf.animationDuration);
        }];
        self.animationDuration = kDefaultAD;
        self.reverseable = YES ;
    }
    return self;
}

@end

static inline CATransform3D rotate(float angle)
{
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

static void turnAnimationPerform(id<UIViewControllerContextTransitioning> transitionContext , BOOL reverse , NSTimeInterval duration)
{
    UIViewController *fromVC = fromVC_of_UIVCCT(transitionContext);
    UIView *fromView = fromView_of_UIVCCT(transitionContext);
    UIView *toView = toView_of_UIVCCT(transitionContext);

    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    // reverse?
    float factor = reverse ? 1.0 : -1.0;
    
    // flip the to VC halfway round - hiding it
    toView.layer.transform = rotate(factor * -M_PI_2);
    
    // animate
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:duration/2.0
                                                                animations:^{
                                                                    // rotate the from view
                                                                    fromView.layer.transform = rotate(factor * M_PI_2);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:duration/2.0
                                                          relativeDuration:duration/2.0
                                                                animations:^{
                                                                    // rotate the to view
                                                                    toView.layer.transform =  rotate(0.0);
                                                                }];
                              } completion:^(BOOL finished) {
                                  fromView.layer.transform = CATransform3DIdentity;
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
}
