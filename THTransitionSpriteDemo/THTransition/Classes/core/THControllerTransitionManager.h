//
//  THControllerTransitionManager.h
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/13.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THTransitionCommon.h"


@interface THControllerTransitionManager : NSObject <UIViewControllerTransitioningDelegate , UINavigationControllerDelegate>

+ (instancetype)SingleManager;

@property (nonatomic , weak) id<UIViewControllerTransitioningDelegate> nextDelegate;
@property (nonatomic , weak) id<UINavigationControllerDelegate> nextDelegate_nav;

@end
