//
//  THTransitionInteraction.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THTransitionCommon.h"
typedef NS_ENUM(NSInteger , THTransitionInteractionPresetGestureType)
{
    THTransitionInteractionPresetGestureTypeVerticalPan,
    THTransitionInteractionPresetGestureTypeHorizontalPan,
    THTransitionInteractionPresetGestureTypePinch,

};

@interface THTransitionInteraction : UIPercentDrivenInteractiveTransition<NSCopying>

@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic , assign) THTransitionAnimationType animationType;

@property (nonatomic , copy) BOOL(^gestureStartCallback)(THTransitionInteraction *interaction , UIViewController *targetVC , BOOL isRight);


+ (instancetype)interactionWithPresetGestureType:(THTransitionInteractionPresetGestureType)gestureType;

- (void)bindTargetViewC:(UIViewController *)targetVC;

@end
