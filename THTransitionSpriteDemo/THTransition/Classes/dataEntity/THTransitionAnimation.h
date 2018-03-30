//
//  THTransitionAnimation.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/13.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THTransitionCommon.h"
#import "THTransitionInteraction.h"
/// 本框架预设的几个动画实现
typedef NS_ENUM(NSInteger , THTransitionAnimationPresetType)
{
    // 视图分片破碎
    THTransitionAnimationPresetTypeExplode,
    // 翻转
    THTransitionAnimationPresetTypeTurn,
};

/// 转场动画实体model
@interface THTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic , assign) NSTimeInterval animationDuration ;
@property (nonatomic , assign) BOOL  reverseable;

@property (nonatomic , assign) THTransitionAnimationType animationType;
@property (nonatomic , copy  ) animationActionBlockType animationAction;
@property (nonatomic , strong) id<UIViewControllerAnimatedTransitioning> animationEntity;
@property (nonatomic , strong) THTransitionInteraction *interaction;

+ (instancetype)animationWithBolck:(animationActionBlockType)animationBlock
                          duration:(NSTimeInterval)duration
                       reverseable:(BOOL)reverseable
                   animationEntity:(id<UIViewControllerAnimatedTransitioning>)animationEntity;

- (instancetype)initWithBolck:(animationActionBlockType)animationBlock
                     duration:(NSTimeInterval)duration
                  reverseable:(BOOL)reverseable
              animationEntity:(id<UIViewControllerAnimatedTransitioning>)animationEntity;

+ (instancetype)presetAnimationWithType:(THTransitionAnimationPresetType)presetType
                               duration:(NSTimeInterval)duration;

#ifdef DEBUG
@property (nonatomic , strong) NSString *name;
+ (instancetype)testInstanceWithName:(NSString *)name;
#endif
@end
