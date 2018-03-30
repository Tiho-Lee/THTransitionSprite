//
//  THTransitionPresetAnimation_explode.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/14.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "THTransitionPresetAnimation_explode.h"
#import "CEExplodeAnimationController.h"
@implementation THTransitionPresetAnimation_explode

- (instancetype)init
{
    if (self = [super init])
    {
        self.animationEntity = [[CEExplodeAnimationController alloc] init];
        self.animationDuration = kDefaultAD;
        self.reverseable = YES ;
    }
    return self;
}

@end
