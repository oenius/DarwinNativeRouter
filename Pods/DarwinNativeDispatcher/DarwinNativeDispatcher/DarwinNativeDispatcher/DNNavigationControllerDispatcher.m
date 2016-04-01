//
//  DNNavigationControllerDispatcher.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNNavigationControllerDispatcher.h"
#import "UIViewController+DNDExtra.h"
#import "DNTabbarControllerDispatcher.h"

@interface DNNavigationControllerDispatcher()

@property (nonatomic, strong)UINavigationController *navigationController;
@property (nonatomic, assign)BOOL bAnimation;
@property (nonatomic, assign)BOOL bHideBar;

@end

@implementation DNNavigationControllerDispatcher

+ (instancetype)dispatcher
{
  static DNNavigationControllerDispatcher *dispatcher;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      dispatcher = [[self.class alloc]init];
    });
  });
  
  dispatcher.navigationController = [[UIApplication sharedApplication].delegate.window.rootViewController viewControllerOfClass:[UINavigationController class]];
  
  return dispatcher;
}

+ (instancetype)dispatcherWithNavigationController:(__kindof UINavigationController *)controller
{
  DNNavigationControllerDispatcher * dispatcher = [DNNavigationControllerDispatcher dispatcher];
  dispatcher.navigationController = controller;
  return dispatcher;
}

- (instancetype)initWithNavigationController:(__kindof UINavigationController *)controller
{
  self = [super init];
  if(self)
  {
    if([controller isKindOfClass:[UINavigationController class]]) self.navigationController = controller;
  }
  return self;
}

- (DNTabbarControllerDispatcher *)tabBarController
{
  id controller;
  if([self.navigationController.topViewController isKindOfClass:[UITabBarController class]])
  {
    controller = self.navigationController.topViewController;
  }
  return [[DNTabbarControllerDispatcher alloc]initWithTabBarController:controller];
}

- (DNNavigationControllerDispatcher *(^)(BOOL animation))animation
{
  return ^DNNavigationControllerDispatcher *(BOOL animation)
  {
    self.bAnimation = animation;
    return self;
  };
}

- (DNNavigationControllerDispatcher *(^)(BOOL hideBar))hidesBottomBarWhenPushed
{
  return ^DNNavigationControllerDispatcher *(BOOL hideBar)
  {
    self.bHideBar = hideBar;
    return self;
  };
}

- (DNNavigationControllerDispatcher *)resetToInitial
{
  [self.navigationController popToRootViewControllerAnimated:self.bAnimation];
  return self;
}

- (DNNavigationControllerDispatcher *)popViewController
{
  [self.navigationController popViewControllerAnimated:self.bAnimation];
  return self;
}

- (DNNavigationControllerDispatcher *(^)(__kindof UIViewController *controller))pushViewController
{
  return ^DNNavigationControllerDispatcher *(__kindof UIViewController *controller){
    controller.hidesBottomBarWhenPushed = self.bHideBar;
    [self.navigationController pushViewController:controller animated:self.bAnimation];
    return self;
  };
}

- (DNNavigationControllerDispatcher *)dismissViewController
{
  if(!self.navigationController.presentedViewController) return self;
  [self.navigationController.presentedViewController dismissViewControllerAnimated:self.bAnimation
                                                                        completion:nil];
  return self;
}

- (DNNavigationControllerDispatcher *(^)(__kindof UIViewController *controller))presentViewController
{
  return ^DNNavigationControllerDispatcher *(__kindof UIViewController *controller){
    [self.navigationController presentViewController:controller
                                            animated:self.bAnimation
                                          completion:nil];
    return self;
  };
}

@end
