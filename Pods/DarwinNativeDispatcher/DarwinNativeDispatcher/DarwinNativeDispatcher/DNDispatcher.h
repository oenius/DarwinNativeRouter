//
//  DNActor.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class
DNTabbarControllerDispatcher,
DNNavigationControllerDispatcher,
DNRootViewControllerDispatcher,
DNAlertViewControllerDispatcher;

typedef NS_ENUM(NSInteger, DNDispatcherType) {
  DNDispatcherTypeDefault,
  DNDispatcherTypePush,
  DNDispatcherTypePresentation,
  DNDispatcherTypeOverlay,
};

@interface DNDispatcher : NSObject

+ (instancetype)dispatcher;

- (DNTabbarControllerDispatcher *)defaultTabbarController;
- (DNTabbarControllerDispatcher *(^)(__kindof UITabBarController *controller))tabbarController;

- (DNNavigationControllerDispatcher *)defaultNavigationController;
- (DNNavigationControllerDispatcher *(^)(__kindof UINavigationController *controller))navigationController;

- (DNRootViewControllerDispatcher *)rootViewController;

- (DNAlertViewControllerDispatcher *)alertViewController;

@end
