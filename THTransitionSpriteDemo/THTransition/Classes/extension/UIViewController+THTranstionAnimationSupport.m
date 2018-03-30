//
//  UIViewController+THTranstionAnimationSupport.m
//  THTransitionDemo
//
//  Created by chld - mac on 2018/3/13.
//  Copyright © 2018年 THPersonal. All rights reserved.
//

#import "UIViewController+THTranstionAnimationSupport.h"
#import "THControllerTransitionManager.h"
#import <objc/runtime.h>
#import "NSObject+THCommentMethod.h"

@interface UIViewController()
@property (nonatomic , strong , readonly) THTransitionAnimationBinder *th_TABinder;
@end

@implementation UIViewController (THTranstionAnimationSupport)

- (instancetype)swizzled_init
{
    if ([self swizzled_init]) {
        [self configInstancePatamsWhenInit];
    }
    return self ;
}

- (instancetype)swizzled_initWithCoder:(NSCoder *)aDecoder
{
    if ([self swizzled_initWithCoder:aDecoder])
    {
//        [self configInstancePatamsWhenInit];
    }
    return self ;
}

- (void)configInstanceParamsWhenInit
{
    // 如果当前类绑定了转场参数 就把需要用到的参数同步到当前对象
    if ([[self class] classHasCustomAnimationType])
    {
        if ([self isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *tmpSelf = (UINavigationController *)self;
            tmpSelf.delegate = [THControllerTransitionManager SingleManager] ;
        }else
        {
            [self swizzled_setTransitioningDelegate:[THControllerTransitionManager SingleManager]];
            NSMutableDictionary<NSNumber * , THTransitionInteraction *> *interactionMap = [[[self class] classGetAnimationBinder] interactionMap];
            [interactionMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, THTransitionInteraction * _Nonnull obj, BOOL * _Nonnull stop)
             {
                THTransitionInteraction *tmpObj = obj.copy;
                [self.th_TABinder bindInteraction:tmpObj forType:key.integerValue];
                [tmpObj bindTargetViewC:self];
                [tmpObj setGestureStartCallback:^BOOL(THTransitionInteraction *interaction, UIViewController *targetVC , BOOL isRight) {
                    if (isRight)
                    {
                        [targetVC dismissViewControllerAnimated:YES completion:nil];
                    }else
                    {
                        UIViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                        [targetVC presentViewController:vc animated:YES completion:nil];
                    }
                    return YES;
                }];
            }];
        }
    }
}


- (void)bindEnable:(BOOL)enable forType:(THTransitionAnimationType)animationType
{
    [self bindAnimation:nil forType:animationType duartion:0 enable:enable];
    if ([self.th_TABinder hasCustomAnimationType])
    {
        self.transitioningDelegate = [THControllerTransitionManager SingleManager];
    }else
    {
        THControllerTransitionManager *manager = (THControllerTransitionManager *)self.transitioningDelegate;
        if ([manager isKindOfClass:[THControllerTransitionManager class]]) {
            [self swizzled_setTransitioningDelegate:manager.nextDelegate];
            manager.nextDelegate = nil ;
        }
    }
}

+ (THTransitionAnimationBinder *)classGetAnimationBinder
{
    THTransitionAnimationBinder *binder = objc_getAssociatedObject(self, _cmd);
    // hahaha
    if (binder == nil) {
        binder = [[THTransitionAnimationBinder alloc] init];
        objc_setAssociatedObject(self, _cmd, binder, OBJC_ASSOCIATION_RETAIN);
    }
    return binder;
}

+ (Class<THTransitionAnimationClassBinder,THTransitionInteractionClassBinder>)classBindAnimation:(THTransitionAnimation *)animation forType:(THTransitionAnimationType)animationType
{
    
    [self classBindAnimation:animation forType:animationType duartion:0 enable:-1];
    return [self class];
}

+ (Class<THTransitionAnimationClassBinder,THTransitionInteractionClassBinder>)classBindDuartion:(NSTimeInterval)duration forType:(THTransitionAnimationType)animationType
{
    [self classBindAnimation:nil forType:animationType duartion:duration enable:-1];
    return [self class];
}

+ (Class<THTransitionAnimationClassBinder,THTransitionInteractionClassBinder>)classBindEnable:(BOOL)enable forType:(THTransitionAnimationType)animationType
{
    [self classBindAnimation:nil forType:animationType duartion:0 enable:enable];
    return [self class];
}

+ (Class<THTransitionAnimationClassBinder,THTransitionInteractionClassBinder>)classBindAnimation:(THTransitionAnimation *)animation forType:(THTransitionAnimationType)animationType duartion:(NSTimeInterval)duration enable:(NSInteger)enable
{
    [[self classGetAnimationBinder] bindAnimation:animation forType:animationType duartion:duration enable:enable];
    return [self class];
}

- (void)bindAnimation:(THTransitionAnimation *)animation forType:(THTransitionAnimationType)animationType
{
    [self bindAnimation:animation forType:animationType duartion:0 enable:-1];
}

- (void)bindDuartion:(NSTimeInterval)duration forType:(THTransitionAnimationType)animationType
{
    [self bindAnimation:nil forType:animationType duartion:duration enable:-1];
}

- (THTransitionAnimationBinder *)th_TABinder
{
    THTransitionAnimationBinder *binder = objc_getAssociatedObject(self, _cmd);
    if (binder == nil) {
        binder = [[THTransitionAnimationBinder alloc] init];
        self.th_TABinder = binder;
    }
    return binder;
}

- (void)setTh_TABinder:(THTransitionAnimationBinder *)th_TABinder
{
    objc_setAssociatedObject(self, @selector(th_TABinder), th_TABinder, OBJC_ASSOCIATION_RETAIN);
}

- (void)bindAnimation:(THTransitionAnimation *)animation
              forType:(THTransitionAnimationType)animationType
             duartion:(NSTimeInterval)duration
               enable:(NSInteger)enable
{
    [self.th_TABinder bindAnimation:animation forType:animationType duartion:duration enable:enable];
    
    if (enable > -1) {
        if ([self.th_TABinder hasCustomAnimationType])
        {
            self.transitioningDelegate = [THControllerTransitionManager SingleManager];
        }else
        {
            THControllerTransitionManager *manager = (THControllerTransitionManager *)self.transitioningDelegate;
            if ([manager isKindOfClass:[THControllerTransitionManager class]]) {
                [self swizzled_setTransitioningDelegate:manager.nextDelegate];
                manager.nextDelegate = nil ;
            }
        }
    }
}

- (NSTimeInterval)durationForType:(THTransitionAnimationType)animationType
{
    return [self.th_TABinder durationForType:animationType];
}

- (THTransitionAnimation *)animationForType:(THTransitionAnimationType)animationType
{
    return [self.th_TABinder animationForType:animationType];
}

- (BOOL)enableCustomAnimationForType:(THTransitionAnimationType)animationType
{
    return [self.th_TABinder enableCustomAnimationForType:animationType];
}

+ (NSTimeInterval)classDurationForType:(THTransitionAnimationType)animationType
{
    if (![[self classGetAnimationBinder] containType:animationType]) {
        if ([class_getSuperclass(self) respondsToSelector:@selector(classDurationForType:)]) {
            return [class_getSuperclass(self) classDurationForType:animationType];
        }
        return 0;
    }
    return [[self classGetAnimationBinder] durationForType:animationType];
}

+ (THTransitionAnimation *)classAnimationForType:(THTransitionAnimationType)animationType
{
    if (![[self classGetAnimationBinder] containType:animationType]) {
        if ([class_getSuperclass(self) respondsToSelector:@selector(classAnimationForType:)]) {
            return [class_getSuperclass(self) classAnimationForType:animationType];
        }
        return nil;
    }
    return [[self classGetAnimationBinder] animationForType:animationType];
}

+ (BOOL)classEnableCustomAnimationForType:(THTransitionAnimationType)animationType
{
    if (![[self classGetAnimationBinder] containType:animationType])
    {
        if ([class_getSuperclass(self) respondsToSelector:@selector(classEnableCustomAnimationForType:)]) {
            return [class_getSuperclass(self) classEnableCustomAnimationForType:animationType];
        }
        return NO;
    }
    return [[self classGetAnimationBinder] enableCustomAnimationForType:animationType];
}

+ (BOOL)classHasCustomAnimationType
{
    if (![[self classGetAnimationBinder] hasCustomAnimation]) {
        if ([class_getSuperclass(self) respondsToSelector:@selector(classHasCustomAnimationType)]) {
            return [class_getSuperclass(self) classHasCustomAnimationType];
        }
        return NO;
    }
    return [[self classGetAnimationBinder] hasCustomAnimationType];
}

- (BOOL)containType:(THTransitionAnimationType)animationType { 
    return [self.th_TABinder containType:animationType];
}

- (BOOL)hasCustomAnimation
{
    return [self.th_TABinder hasCustomAnimation];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledMethodWithOriginSEL:@selector(init) swizzledSEL:@selector(swizzled_init)];
        [self swizzledMethodWithOriginSEL:@selector(initWithCoder:) swizzledSEL:@selector(swizzled_initWithCoder:)];
        [self swizzledMethodWithOriginSEL:@selector(setTransitioningDelegate:) swizzledSEL:@selector(swizzled_setTransitioningDelegate:)];
    });
}

- (void)swizzled_setNavigationController:(UINavigationController * _Nullable)navigationController
{
    [self swizzled_setNavigationController:navigationController];
}

/// hook setTransitioningDelegate 目的是为了本框架中使用的delegate不覆盖用户的delegate 可以实现框架和用户自定义delegate共同提供不同转场类型的动画
- (void)swizzled_setTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    // 外部调用 setdelegate nil 意图是把外层用户自己设置的delegate清掉
    // 这时不要清空THControllerTransitionManager
    // 而是把THControllerTransitionManager存储的用户自定义delegate清掉
    if (transitioningDelegate == nil && [self.transitioningDelegate isKindOfClass:[THControllerTransitionManager class]])
    {
        THControllerTransitionManager *manager = (THControllerTransitionManager *)self.transitioningDelegate ;
        manager.nextDelegate = nil ;
        // 触发外层setter 外层调用者可能重写这个方法做事情
        [self swizzled_setTransitioningDelegate:manager];
        return;
    }
    // 外部调用 setdelegate  意图是让用户自己创建的的delegate接收转场回调 但是如果用户使用我们的框架产生了THControllerTransitionManager 那么优先走THControllerTransitionManager回调
    // 而把用户自定义delegate 在THControllerTransitionManager临时存储 当THControllerTransitionManager没有返回正确的数值时 在回调外层delegate
    if ([self.transitioningDelegate isKindOfClass:[THControllerTransitionManager class]] &&
        ![transitioningDelegate isKindOfClass:[THControllerTransitionManager class]])
    {
        THControllerTransitionManager *manager = (THControllerTransitionManager *)self.transitioningDelegate ;
        manager.nextDelegate = transitioningDelegate ;
        // 触发外层setter 外层调用者可能重写这个方法做事情
        [self swizzled_setTransitioningDelegate:manager];
        return;
    }
    
    if (self.transitioningDelegate != nil &&
        ![self.transitioningDelegate isKindOfClass:[THControllerTransitionManager class]] &&
        [transitioningDelegate isKindOfClass:[THControllerTransitionManager class]]) {
        THControllerTransitionManager *manager = (THControllerTransitionManager *)transitioningDelegate ;
        manager.nextDelegate = self.transitioningDelegate ;
        // 触发外层setter 外层调用者可能重写这个方法做事情
        [self swizzled_setTransitioningDelegate:manager];
        return ;
    }
    
    // 触发外层setter 外层调用者可能重写这个方法做事情
    [self swizzled_setTransitioningDelegate:transitioningDelegate];
}

+ (void)classClearAllBind
{
    return [[self classGetAnimationBinder] clearAllBind];
}
- (void)clearAllBind
{
    [self.th_TABinder clearAllBind];
}

- (void)setTh_bindTA:(th_bindTA_chainCodeSupport)th_bindTA
{
    objc_setAssociatedObject(self, @selector(th_bindTA), th_bindTA, OBJC_ASSOCIATION_COPY);
}

- (th_bindTA_chainCodeSupport)th_bindTA
{
    th_bindTA_chainCodeSupport block = objc_getAssociatedObject(self, _cmd);
    if (block == nil) {
        __weak typeof(self) weakSelf = self ;
        block = ^UIViewController *(THTransitionAnimation *animation, THTransitionAnimationType type, NSTimeInterval duration, BOOL enable) {
            [weakSelf bindAnimation:animation forType:type duartion:duration enable:enable];
            return weakSelf;
        };
        self.th_bindTA = block;
    }
    return block;
}

- (void)setTh_bindTA_enable:(th_bindTA_chainCodeSupport_enable)th_bindTA_enable
{
    objc_setAssociatedObject(self, @selector(th_bindTA_enable), th_bindTA_enable, OBJC_ASSOCIATION_COPY);
}

- (th_bindTA_chainCodeSupport_enable)th_bindTA_enable
{
    th_bindTA_chainCodeSupport_enable block = objc_getAssociatedObject(self, _cmd);
    if (block == nil) {
        __weak typeof(self) weakSelf = self ;
        block = ^UIViewController *( THTransitionAnimationType type, BOOL enable) {
            [weakSelf bindEnable:enable forType:type];
            return weakSelf;
        };
        self.th_bindTA_enable = block;
    }
    return block;
}


- (void)setTh_bindTA_duration:(th_bindTA_chainCodeSupport_duration)th_bindTA_duration
{
    objc_setAssociatedObject(self, @selector(th_bindTA_duration), th_bindTA_duration, OBJC_ASSOCIATION_COPY);
}

- (th_bindTA_chainCodeSupport_duration)th_bindTA_duration
{
    th_bindTA_chainCodeSupport_duration block = objc_getAssociatedObject(self, _cmd);
    if (block == nil) {
        __weak typeof(self) weakSelf = self ;
        block = ^UIViewController *(THTransitionAnimationType type, NSTimeInterval duration) {
            [weakSelf bindDuartion:duration forType:type];
            return weakSelf;
        };
        self.th_bindTA_duration = block;
    }
    return block;
}


- (void)setTh_bindTA_animation:(th_bindTA_chainCodeSupport_animation)th_bindTA_animation
{
    objc_setAssociatedObject(self, @selector(th_bindTA_animation), th_bindTA_animation, OBJC_ASSOCIATION_COPY);
}

- (th_bindTA_chainCodeSupport_animation)th_bindTA_animation
{
    th_bindTA_chainCodeSupport_animation block = objc_getAssociatedObject(self, _cmd);
    if (block == nil) {
        __weak typeof(self) weakSelf = self ;
        block = ^UIViewController *(THTransitionAnimation *animation, THTransitionAnimationType type) {
            [weakSelf bindAnimation:animation forType:type];
            return weakSelf;
        };
        self.th_bindTA_animation = block;
    }
    return block;
}



- (void)bindInteraction:(THTransitionInteraction *)interaction forType:(THTransitionAnimationType)animationType {
    [self.th_TABinder bindInteraction:interaction forType:animationType];
}

- (THTransitionInteraction *)interactionForType:(THTransitionAnimationType)animationType {
    return [self.th_TABinder interactionForType:animationType];
}
+ (Class<THTransitionAnimationClassBinder,THTransitionInteractionClassBinder>)classBindInteraction:(THTransitionInteraction *)interaction forType:(THTransitionAnimationType)animationType {
    [[self classGetAnimationBinder] bindInteraction:interaction forType:animationType];
    return [self class];
}

+ (THTransitionInteraction *)classInteractionForType:(THTransitionAnimationType)animationType {
    if (![[self classGetAnimationBinder] containType:animationType]) {
        if ([class_getSuperclass(self) respondsToSelector:@selector(classInteractionForType:)]) {
            return [class_getSuperclass(self) classInteractionForType:animationType];
        }
        return nil;
    }
    
    return [[self classGetAnimationBinder] interactionForType:animationType];
}

+ (void)setTh_bindTA_animation_class:(th_bindTA_chainCodeSupport_animation_class)th_bindTA_animation_class
{
    objc_setAssociatedObject(self, @selector(th_bindTA_animation_class), th_bindTA_animation_class, OBJC_ASSOCIATION_COPY);
}

+ (th_bindTA_chainCodeSupport_animation_class)th_bindTA_animation_class
{
    th_bindTA_chainCodeSupport_animation_class block = objc_getAssociatedObject(self, _cmd);
    if (block == nil) {
        block = ^Class (THTransitionAnimation *animation, THTransitionAnimationType type) {
            [self classBindAnimation:animation forType:type];
            return self;
        };
        self.th_bindTA_animation_class = block;
    }
    return block;
}

+ (void)setTh_bindTA_class:(th_bindTA_chainCodeSupport_class)th_bindTA_class
{
    objc_setAssociatedObject(self, @selector(th_bindTA_class), th_bindTA_class, OBJC_ASSOCIATION_COPY);
}

+ (th_bindTA_chainCodeSupport_class)th_bindTA_class
{
    th_bindTA_chainCodeSupport_class block = objc_getAssociatedObject(self, _cmd);
    if (block == nil) {
        block = ^Class(THTransitionAnimation *animation, THTransitionAnimationType type, NSTimeInterval duration, BOOL enable) {
            [self classBindAnimation:animation forType:type duartion:duration enable:enable];
            return self;
        };
        self.th_bindTA_class = block;
    }

    return block;
}

+ (void)th_commitBindConfig:(NSDictionary *)config
{
    NSArray<NSNumber *> *typeList = config[th_bindTypeKey];
    NSArray<NSNumber *> *durationList = config[th_bindDurationKey];
    NSArray<NSNumber *> *enableList = config[th_bindEnableKey];
    NSArray<THTransitionAnimation *> *animationList = config[th_bindAnimationKey];
    NSArray<THTransitionInteraction *> *interactionList = config[th_bindInteractionKey];

    if (typeList.count == 0)
    {
        return ;
    }
    
    [typeList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THTransitionAnimationType animationType = obj.integerValue;
        THTransitionAnimation *a = animationList.count > idx ? animationList[idx] : (THTransitionAnimation*)kObjPlaceholder;
        NSTimeInterval duration = durationList.count > idx ? [durationList[idx] doubleValue] : kFloatPlaceholder;
        NSInteger enable = enableList.count > idx ? [enableList[idx] integerValue] : kIntPlaceholder;
        [self classBindAnimation:a forType:animationType duartion:duration enable:enable];
        THTransitionInteraction *interaction = interactionList.count > idx ? interactionList[idx] : (THTransitionInteraction*)kObjPlaceholder;
        [self classBindInteraction:interaction forType:animationType];
    }];
}

@end
