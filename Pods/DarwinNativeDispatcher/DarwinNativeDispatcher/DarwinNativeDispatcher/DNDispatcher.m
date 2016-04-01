//
//  DNActor.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNDispatcher.h"
#import "DNNavigationControllerDispatcher.h"
#import "DNTabbarControllerDispatcher.h"
#import "DNAlertViewControllerDispatcher.h"
#import "DNRootViewControllerDispatcher.h"

@implementation DNDispatcher

+ (instancetype)dispatcher
{
  static DNDispatcher *dispatcher;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispatcher = [[self.class alloc]init];
  });
  return dispatcher;
}

- (DNTabbarControllerDispatcher *)defaultTabbarController
{
  return [DNTabbarControllerDispatcher dispatcher];
}

- (DNTabbarControllerDispatcher *(^)(__kindof UITabBarController *))tabbarController
{
  return ^DNTabbarControllerDispatcher *(__kindof UITabBarController *controller){
  
     return [[DNTabbarControllerDispatcher alloc]initWithTabBarController:controller];
  };
}

- (DNNavigationControllerDispatcher *)defaultNavigationController
{
  return [DNNavigationControllerDispatcher dispatcher];
}

- (DNNavigationControllerDispatcher *(^)(__kindof UINavigationController *controller))navigationController
{
  return ^DNNavigationControllerDispatcher *(__kindof UINavigationController *controller){
    
    return [[DNNavigationControllerDispatcher alloc]initWithNavigationController:controller];
  };
}

- (DNAlertViewControllerDispatcher *)alertViewController
{
  return [DNAlertViewControllerDispatcher dispatcher];
}

- (DNRootViewControllerDispatcher *)rootViewController;
{
  return [DNRootViewControllerDispatcher dispatcher];
}

@end
