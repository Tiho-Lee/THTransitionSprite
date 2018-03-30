//
//  THTransitionInteractionProtol.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THTransitionInteraction.h"
#import "THTransitionCommon.h"

@class THTransitionInteraction ;
@protocol THTransitionAnimationClassBinder;

@protocol THTransitionInteractionProvider <NSObject>
- (THTransitionInteraction *)interactionForType:(THTransitionAnimationType)animationType;
@end

@protocol THTransitionInteractionBinder <NSObject>

- (void)bindInteraction:(THTransitionInteraction *)interaction
              forType:(THTransitionAnimationType)animationType;

@end

@protocol THTransitionInteractionClassProvider <NSObject>
+ (THTransitionInteraction *)classInteractionForType:(THTransitionAnimationType)animationType;
@end

@protocol THTransitionInteractionClassBinder <NSObject>

+ (Class<THTransitionInteractionClassBinder,THTransitionAnimationClassBinder>)classBindInteraction:(THTransitionInteraction *)interaction
                forType:(THTransitionAnimationType)animationType;

@end
