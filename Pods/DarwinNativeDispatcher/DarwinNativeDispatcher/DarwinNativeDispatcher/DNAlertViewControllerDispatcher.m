//
//  DNAlertViewControllerDispatcher.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNAlertViewControllerDispatcher.h"

@interface DNAlertViewControllerDispatcher()

@property (nonatomic, strong)UIWindow *window;

@end

@implementation DNAlertViewControllerDispatcher

+ (instancetype)dispatcher
{
  static DNAlertViewControllerDispatcher *dispatcher;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      dispatcher = [[self.class alloc]init];
    });
  });
  return dispatcher;
}

- (DNAlertViewControllerDispatcher *)clearColor
{
  self.window.backgroundColor = [UIColor clearColor];
  return self;
}

- (DNAlertViewControllerDispatcher *(^)(UIColor *color))tintColor
{
  return ^DNAlertViewControllerDispatcher *(UIColor *color){
    self.window.backgroundColor = color;
    return self;
  };
}

- (UIWindow *)window
{
  if(!_window)
  {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
  }
  return _window;
}

- (DNAlertViewControllerDispatcher *(^)(UIViewController *controller))show
{
  return ^DNAlertViewControllerDispatcher *(UIViewController *controller)
  {
    if(!controller) return self;
    self.window.rootViewController = controller;
    self.window.hidden = NO;
    [self.window makeKeyAndVisible];
    return self;
  };
}

- (DNAlertViewControllerDispatcher *)hide
{
  self.window.hidden = YES;
  [self.window resignKeyWindow];
  [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
  return self;
}

@end
