//
//  DNTabbarControllerDispatcher.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNNavigationControllerDispatcher;
@interface DNTabbarControllerDispatcher : NSObject

+ (instancetype)dispatcher;
+ (instancetype)dispatcherWithTabbarController:(__kindof UITabBarController *)controller;

- (instancetype)initWithTabBarController:(__kindof  UITabBarController *)controller;

- (DNNavigationControllerDispatcher *)navigationController;

- (DNTabbarControllerDispatcher *(^)(BOOL animation))animation;
- (DNTabbarControllerDispatcher *(^)(BOOL hideBar))hidesBottomBarWhenPushed;

- (DNTabbarControllerDispatcher *)resetToInitial;

- (DNTabbarControllerDispatcher *(^)(NSInteger index))selectAtIndex;

- (DNTabbarControllerDispatcher *)popViewController;
- (DNTabbarControllerDispatcher *(^)(__kindof UIViewController *controller))pushViewController;

- (DNTabbarControllerDispatcher *)dismissController;
- (DNTabbarControllerDispatcher *(^)(__kindof UIViewController *controller))presentViewController;

- (DNTabbarControllerDispatcher *(^)(NSInteger index,NSString *badgeValue))setBadgeValue;

@end
