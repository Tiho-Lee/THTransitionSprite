//
//  THTransitionAnimationBinder.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THTransitionAnimationBinder.h"

@interface THTransitionAnimationBinder()

// 动画类和时长分开存储 目的是动画和时长可以任意组合  可以几种转场类型公用一个动画 但每种转场类型有不同的时长 反之亦然

/// 动画类 映射表  key  转场类型  value 动画对象 THTransitionAnimation
@property (nonatomic , strong) NSMutableDictionary<NSNumber * , THTransitionAnimation *> *animationMap ;
/// 动画时长 映射表  key  转场类型  value 动画时长
@property (nonatomic , strong) NSMutableDictionary<NSNumber * , NSNumber *> *durationMap ;
/// 动画是否开启
@property (nonatomic , strong) NSMutableDictionary<NSNumber * , NSNumber *> *enableMap ;

/// 转场手势映射表 key  转场类型  value 动画对象 THTransitionInteraction
@property (nonatomic , strong) NSMutableDictionary<NSNumber * , THTransitionInteraction *> *interactionMap ;

@end

@implementation THTransitionAnimationBinder


#pragma mark - value getter start


- (id)valueForAnimationType:(THTransitionAnimationType)animationType map:(NSDictionary *)map
{
    if (!isValidType(animationType)) {
        return nil;
    }
    if (animationType == THTransitionAnimationTypeAll) {
        return [map allValues];
    }
    __block id res = nil;
    [map enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        THTransitionAnimationType sourceType = key.integerValue;
        if (THTransitionAnimationTypeContain(sourceType, animationType)) {
            res = obj;
            *stop = YES;
        }
    }];
    return res;
}

- (NSTimeInterval)durationForType:(THTransitionAnimationType)animationType
{
    return [[self valueForAnimationType:animationType map:self.durationMap] doubleValue];
}
- (THTransitionAnimation *)animationForType:(THTransitionAnimationType)animationType
{
    return [self valueForAnimationType:animationType map:self.animationMap];
}

- (BOOL)enableCustomAnimationForType:(THTransitionAnimationType)animationType
{
    return [[self valueForAnimationType:animationType map:self.enableMap] boolValue];
}
#pragma mark value getter end

#pragma mark - bind method start

- (NSString *)description
{
    return [NSString stringWithFormat:@"animation : %@ , duration : %@" , self.animationMap , self.durationMap];
}

- (void)bindAnimation:(THTransitionAnimation *)animation
              forType:(THTransitionAnimationType)animationType
{
    [self bindAnimation:animation forType:animationType duartion:0 enable:-1];
}

- (void)bindDuartion:(NSTimeInterval)duration
             forType:(THTransitionAnimationType)animationType
{
    [self bindAnimation:nil forType:animationType duartion:duration enable:-1];
}

- (void)bindEnable:(BOOL)enable
           forType:(THTransitionAnimationType)animationType
{
    [self bindAnimation:nil forType:animationType duartion:0 enable:enable];
}

- (void)bindAnimation:(THTransitionAnimation *)animation
              forType:(THTransitionAnimationType)animationType
             duartion:(NSTimeInterval)duration
               enable:(NSInteger)enable
{
    if (!isValidType(animationType))
    {
        NSLog(@"THTransitionAnimationBinder bind animation failed , reason : paramter illegal");
        return ;
    }

    if (animation && ![animation isKindOfClass:[NSNull class]]) {
        [self mergeMap:self.animationMap targetValue:animation targetType:animationType compareValue:NO];
    }
    if (duration > 0) {
        [self mergeMap:self.durationMap targetValue:@(duration) targetType:animationType compareValue:YES];
    }
    if (enable >= 0) {
        [self mergeMap:self.enableMap targetValue:@(enable) targetType:animationType compareValue:YES];
    }
}

/// 相同的animation 和duration 要合并类型 新的animation 对应的type如果原来就有 要从原有的key中剔除
- (void)mergeMap:(NSMutableDictionary *)map
     targetValue:(id)targetValue
      targetType:(THTransitionAnimationType)targetType_
    compareValue:(BOOL)compareValue
{
    __block THTransitionAnimationType targetType = targetType_ ;
    
    BOOL(^compareEqual)(id,id,BOOL) = ^BOOL(id v1 , id v2 , BOOL compareValue){
        if (compareValue) {
            if ([v1 respondsToSelector:@selector(doubleValue)] &&
                [v2 respondsToSelector:@selector(doubleValue)]) {
                return fabs( [v1 doubleValue] - [v2 doubleValue]) <= 0.0000001 ;
            }else
            {
                return NO;
            }
        }else
        {
            return v1 == v2 ;
        }
    };
    
    [map enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull type_key, id _Nonnull value, BOOL * _Nonnull stop) {
        THTransitionAnimationType sourceType = type_key.integerValue;
        if (!isValidType(targetType)) {
            *stop = YES;
            return  ;
        }
        
        if (compareEqual(value , targetValue , compareValue)) {
            [map removeObjectForKey:type_key];
            if (isValidType(sourceType))
            {
                [map setObject:value forKey:@(sourceType | targetType)];
            }
            targetType = THTransitionAnimationTypeInvalid;
            *stop = YES;
        }else
        {
            THTransitionAnimationType intersectionType =  THTransitionAnimationTypeIntersection(sourceType, targetType);
            if (isValidType(intersectionType)) {
                THTransitionAnimationTypeRemove(&sourceType, intersectionType);
                [map removeObjectForKey:type_key];
                if (isValidType(sourceType))
                {
                    [map setObject:value forKey:@(sourceType)];
                }
                
            }
        }
    }];
    if (isValidType(targetType))
    {
        [map setObject:targetValue forKey:@(targetType)];
    }
}

#pragma mark bind metho end

#pragma mark - map lazy load start

- (NSMutableDictionary<NSNumber *,THTransitionAnimation *> *)animationMap

{
    if (!_animationMap) {
        _animationMap = [NSMutableDictionary dictionary];
    }
    return _animationMap;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)durationMap
{
    if (!_durationMap) {
        _durationMap = [NSMutableDictionary dictionary];
    }
    return _durationMap;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)enableMap
{
    if (!_enableMap) {
        _enableMap = [NSMutableDictionary dictionary];
    }
    return _enableMap ;
}

- (NSMutableDictionary<NSNumber *,THTransitionInteraction *> *)interactionMap
{
    if (!_interactionMap) {
        _interactionMap = [NSMutableDictionary dictionary];
    }
    return _interactionMap;
}

#pragma mark map lazy load end


- (BOOL)hasCustomAnimationType
{
    __block BOOL has = NO;
    [self.enableMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.boolValue == YES) {
            has = YES;
            *stop = YES;
        }
    }];
    return has;
}

- (BOOL)hasCustomAnimation
{
    return self.animationMap.count > 0 ;
}

- (BOOL)containType:(THTransitionAnimationType)animationType
{
    __block BOOL contain = NO;
    [self.animationMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, THTransitionAnimation * _Nonnull obj, BOOL * _Nonnull stop) {
        if (THTransitionAnimationTypeContain(key.integerValue, animationType)) {
            contain = YES;
            *stop = YES;
        }
    }];
    return contain;
}



- (void)clearAllBind
{
    [self.animationMap removeAllObjects];
    [self.durationMap removeAllObjects];
    [self.enableMap removeAllObjects];
}

- (THTransitionInteraction *)interactionForType:(THTransitionAnimationType)animationType
{
    
    return  [self valueForAnimationType:animationType map:self.interactionMap];;
}


- (void)bindInteraction:(THTransitionInteraction *)interaction
                forType:(THTransitionAnimationType)animationType
{
    if (interaction == nil ||
        !isValidType(animationType) ||
        [interaction isKindOfClass:[NSNull class]])
    {
        
        if (![interaction isKindOfClass:[NSNull class]])
        {
            NSLog(@"THTransitionAnimationBinder bind animation failed , reason : paramter illegal");
        }
        
        return ;
    }
    
        [self mergeMap:self.interactionMap targetValue:interaction targetType:animationType compareValue:NO];
}
@end


