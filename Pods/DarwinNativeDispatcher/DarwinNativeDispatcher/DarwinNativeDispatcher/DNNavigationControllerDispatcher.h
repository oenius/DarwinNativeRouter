//
//  DNNavigationControllerDispatcher.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNTabbarControllerDispatcher;
@interface DNNavigationControllerDispatcher : NSObject

+ (instancetype)dispatcher;
+ (instancetype)dispatcherWithNavigationController:(__kindof UINavigationController *)controller;

- (instancetype)initWithNavigationController:(__kindof UINavigationController *)controller;

- (DNTabbarControllerDispatcher *)tabBarController;

- (DNNavigationControllerDispatcher *)resetToInitial;

- (DNNavigationControllerDispatcher *(^)(BOOL animation))animation;
- (DNNavigationControllerDispatcher *(^)(BOOL hideBar))hidesBottomBarWhenPushed;

- (DNNavigationControllerDispatcher *)popViewController;
- (DNNavigationControllerDispatcher *(^)(__kindof UIViewController *controller))pushViewController;

- (DNNavigationControllerDispatcher *)dismissViewController;
- (DNNavigationControllerDispatcher *(^)(__kindof UIViewController *controller))presentViewController;

@end
