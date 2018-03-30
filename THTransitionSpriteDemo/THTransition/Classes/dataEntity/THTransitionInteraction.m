//
//  THTransitionInteraction.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THTransitionInteraction.h"
#import <objc/runtime.h>

const NSString *kCEPinchGestureKey_ = @"kCEVerticalSwipeGestureKey";

@interface THTransitionInteraction()

@property (nonatomic , strong) UIPanGestureRecognizer *panGes;
@property (nonatomic , strong) UIPinchGestureRecognizer *pinchGes;

@property (nonatomic , assign) BOOL shouldCompleteTransition;
@property (nonatomic , assign) CGFloat startScale;

@property (nonatomic , assign) THTransitionInteractionPresetGestureType presetGesType;
@property (nonatomic , weak) UIViewController *targetVC;

@end

@implementation THTransitionInteraction

+ (instancetype)interactionWithPresetGestureType:(THTransitionInteractionPresetGestureType)gestureType
{
    THTransitionInteraction *instance = [[self alloc] init];
    instance.presetGesType = gestureType ;
    switch (gestureType) {
        case THTransitionInteractionPresetGestureTypeVerticalPan:
        case THTransitionInteractionPresetGestureTypeHorizontalPan:
            instance.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector(handleGesture:)];
            break;
        case THTransitionInteractionPresetGestureTypePinch:
        instance.pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:instance action:@selector(handlePinchGes:)];
        break;
        default:
            break;
    }
    return instance;
}

- (void)bindTargetViewC:(UIViewController *)targetVC
{
    self.targetVC = targetVC ;
    switch (self.presetGesType) {
        case THTransitionInteractionPresetGestureTypeVerticalPan:
        case THTransitionInteractionPresetGestureTypeHorizontalPan:
            if (self.panGes.view) {
                [self.panGes.view removeGestureRecognizer:self.panGes];
            }
            [targetVC.view addGestureRecognizer:self.panGes];
            break;
        case THTransitionInteractionPresetGestureTypePinch:
            if (self.pinchGes.view) {
                [self.pinchGes.view removeGestureRecognizer:self.pinchGes];
            }
            [targetVC.view addGestureRecognizer:self.pinchGes];
            break;
        default:
            break;
    }
}


- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handlePinchGes:(UIPinchGestureRecognizer *)pinchGes
{
    
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.gestureStartCallback) {
               self.interactionInProgress = self.gestureStartCallback(self, self.targetVC , [gestureRecognizer velocityInView:gestureRecognizer.view].x > 0);
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.interactionInProgress) {
                // compute the current position
                if (THTransitionInteractionPresetGestureTypeHorizontalPan == self.presetGesType) {
                    CGFloat fraction = fabs(translation.x / 200.0);
                    fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                    _shouldCompleteTransition = (fraction > 0.5);
                    
                    // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
                    if (fraction >= 1.0)
                        fraction = 0.99;
                    
                    [self updateInteractiveTransition:fraction];
                    NSLog(@"%@" , self);
                }else if (THTransitionInteractionPresetGestureTypeVerticalPan == self.presetGesType)
                {
                    CGFloat fraction = fabs(translation.y / 200.0);
                    fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                    _shouldCompleteTransition = (fraction > 0.5);
                    
                    // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
                    if (fraction >= 1.0)
                        fraction = 0.99;
                    
                    [self updateInteractiveTransition:fraction];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress)
            {
                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            
            break;
        default:
            break;
    }
}

-(id)copy
{
    THTransitionInteraction *instance = [[THTransitionInteraction alloc] init];
    instance.presetGesType = self.presetGesType ;
    switch (self.presetGesType) {
        case THTransitionInteractionPresetGestureTypeVerticalPan:
        case THTransitionInteractionPresetGestureTypeHorizontalPan:
            instance.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector(handleGesture:)];
            break;
        case THTransitionInteractionPresetGestureTypePinch:
            instance.pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:instance action:@selector(handlePinchGes:)];
            break;
        default:
            break;
    }
    return instance;    
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    THTransitionInteraction *instance = [[THTransitionInteraction alloc] init];
    instance.presetGesType = self.presetGesType ;
    switch (self.presetGesType) {
        case THTransitionInteractionPresetGestureTypeVerticalPan:
        case THTransitionInteractionPresetGestureTypeHorizontalPan:
            instance.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector(handleGesture:)];
            break;
        case THTransitionInteractionPresetGestureTypePinch:
            instance.pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:instance action:@selector(handlePinchGes:)];
            break;
        default:
            break;
    }
    return instance;  
}

@end
