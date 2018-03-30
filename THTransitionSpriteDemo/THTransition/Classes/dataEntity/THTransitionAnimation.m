//
//  THTransitionAnimation.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/13.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THTransitionAnimation.h"
#import "THPresetTransitionAnimation.h"
@implementation THTransitionAnimation


+ (instancetype)presetAnimationWithType:(THTransitionAnimationPresetType)presetType
                               duration:(NSTimeInterval)duration
{
    THTransitionAnimation * animation = nil ;
    switch (presetType) {
        case THTransitionAnimationPresetTypeTurn:
            animation = [[THTransitionPresetAnimation_turn alloc] init];
            break;
        case THTransitionAnimationPresetTypeExplode:
            animation = [[THTransitionPresetAnimation_explode alloc] init];
            break;
        default:
            break;
    }
    animation.animationDuration = duration ;
    return animation ;
}

+ (instancetype)animationWithBolck:(animationActionBlockType)animationBlock
                          duration:(NSTimeInterval)duration
                       reverseable:(BOOL)reverseable
                   animationEntity:(id<UIViewControllerAnimatedTransitioning>)animationEntity
{
    return [[self alloc] initWithBolck:animationBlock duration:duration reverseable:reverseable animationEntity:animationEntity];
}

- (instancetype)initWithBolck:(animationActionBlockType)animationBlock
                     duration:(NSTimeInterval)duration
                  reverseable:(BOOL)reverseable
              animationEntity:(id<UIViewControllerAnimatedTransitioning>)animationEntity
{
    if (self = [super init]){
        _animationDuration = duration;
        _animationAction = [animationBlock copy];
        _reverseable = reverseable;
        _animationEntity = animationEntity;
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]){
        self.animationDuration = kDefaultAD;
    }
    return self;
}
// 不允许存在返回0的情况 这里做一个判断 如果是零 就返回默认值
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.animationEntity respondsToSelector:@selector(transitionDuration:)]) {
        return [self.animationEntity transitionDuration:transitionContext] ?:kDefaultAD;
    }
    return self.animationDuration ?: kDefaultAD;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.animationEntity respondsToSelector:@selector(animateTransition:)]) {
        [self.animationEntity animateTransition:transitionContext];
        return ;
    }
    if (self.animationAction)
    {
        self.animationAction(transitionContext, _animationType);
        return ;
    }
    /// 如果上面都没有 直接结束转场 防止由于使用者api调用不当引起界面卡住
    [transitionContext completeTransition:[transitionContext transitionWasCancelled]];
}



#ifdef DEBUG
- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"   name : %@" , _name];
}

+ (instancetype)testInstanceWithName:(NSString *)name
{
    THTransitionAnimation *instance = [[self alloc] init];
    instance.name = name ;
    return instance ;
}
#endif
@end
