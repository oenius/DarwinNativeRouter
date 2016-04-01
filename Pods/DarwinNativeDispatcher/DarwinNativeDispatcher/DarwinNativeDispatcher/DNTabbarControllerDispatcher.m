//
//  DNTabbarControllerDispatcher.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNTabbarControllerDispatcher.h"
#import "UIViewController+DNDExtra.h"
#import "DNNavigationControllerDispatcher.h"

@interface DNTabbarControllerDispatcher()

@property (nonatomic, strong)UITabBarController *tabbarController;

@property (nonatomic, assign)BOOL bAnimation;
@property (nonatomic, assign)BOOL bHideBar;

@end

@implementation DNTabbarControllerDispatcher

+ (instancetype)dispatcher
{
  static DNTabbarControllerDispatcher *dispatcher;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispatcher = [[self.class alloc]init];
  });
  return dispatcher;
}

+ (instancetype)dispatcherWithTabbarController:(__kindof UITabBarController *)controller
{
  DNTabbarControllerDispatcher *dispatcher = [DNTabbarControllerDispatcher dispatcher];
  dispatcher.tabbarController = controller;
  return dispatcher;
}

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    self.tabbarController = [[UIApplication sharedApplication].delegate.window.rootViewController viewControllerOfClass:[UITabBarController class]];
  }
  return self;
}

- (instancetype)initWithTabBarController:(__kindof  UITabBarController *)controller;
{
  self = [super init];
  if(self)
  {
    self.tabbarController = controller;
  }
  return self;
}

- (DNNavigationControllerDispatcher *)navigationController
{
  id controller = [self.tabbarController selectedViewController];
  DNNavigationControllerDispatcher *dispatcher = nil;
  if([controller isKindOfClass:[UINavigationController class]])
  {
    dispatcher = [[DNNavigationControllerDispatcher alloc]initWithNavigationController:controller];
  }
  return dispatcher;
}

- (DNTabbarControllerDispatcher *(^)(BOOL animation))animation
{
  return ^DNTabbarControllerDispatcher *(BOOL animation)
  {
    self.bAnimation = animation;
    return self;
  };
}

- (DNTabbarControllerDispatcher *(^)(BOOL hideBar))hidesBottomBarWhenPushed
{
  return ^DNTabbarControllerDispatcher *(BOOL hideBar)
  {
    self.bHideBar = hideBar;
    return self;
  };
}

- (DNTabbarControllerDispatcher *)resetToInitial
{
  if(!self.tabbarController) return self;
  
  [self.tabbarController setSelectedIndex:0];
  
  NSArray *controllers = [self.tabbarController viewControllers];
  
  for(id controller in controllers)
  {
    if([controller isKindOfClass:[UINavigationController class]])
    {
      [(UINavigationController *)controller popToRootViewControllerAnimated:NO];
    }
  }
  
  return self;
}

- (DNTabbarControllerDispatcher *(^)(NSInteger index))selectAtIndex
{
  return ^DNTabbarControllerDispatcher *(NSInteger index){
    [self.tabbarController setSelectedIndex:index];
    return self;
  };
}

- (DNTabbarControllerDispatcher *)popViewController
{
  if(self.navigationController)
  {
    [self.navigationController popViewController];
  }
  return self;
}

- (DNTabbarControllerDispatcher *(^)(__kindof UIViewController *controller))presentViewController
{
    return ^DNTabbarControllerDispatcher *(__kindof UIViewController *controller){
      [self.tabbarController presentViewController:controller animated:YES completion:nil];
      return self;
    };
}

- (DNTabbarControllerDispatcher *)dismissController
{
  if(!self.tabbarController.presentedViewController) return self;
  [self.tabbarController.presentedViewController dismissViewControllerAnimated:self.bAnimation
                                                                        completion:nil];
  return self;
}

- (DNTabbarControllerDispatcher *(^)(__kindof UIViewController *controller))pushViewController
{
  return ^DNTabbarControllerDispatcher *(__kindof UIViewController *controller){
    id viewcontroller = [self.tabbarController selectedViewController];
    if([viewcontroller respondsToSelector:@selector(pushViewController:animated:)])
    {
      [viewcontroller pushViewController:viewcontroller animated:self.bAnimation];
    }
    return self;
  };
}

- (DNTabbarControllerDispatcher *(^)(NSInteger index,NSString *badgeValue))setBadgeValue
{
  return ^DNTabbarControllerDispatcher *((NSInteger index, NSString *badgeValue)){
    NSArray *controllers = [self.tabbarController viewControllers];
    if(index < controllers.count && index > -1)
    {
      UIViewController *controller = self.tabbarController.viewControllers[index];
      UITabBarItem *item = controller.tabBarItem;
      [item setBadgeValue:badgeValue];
    }
    return self;
  };
}

@end
