//
//  THTransitionAnimationBinder.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THTransitionCommon.h"
#import "THTransitionAnimation.h"
#import "THTransitionAnimationProtol.h"
#import "THTransitionInteractionProtol.h"

@interface THTransitionAnimationBinder : NSObject <THTransitionAnimationProvider , THTransitionAnimationBinder , THTransitionInteractionProvider , THTransitionInteractionBinder>
/// 转场手势映射表 key  转场类型  value 动画对象 THTransitionInteraction
@property (nonatomic , strong , readonly) NSMutableDictionary<NSNumber * , THTransitionInteraction *> *interactionMap ;

- (BOOL)hasCustomAnimationType;

@end
