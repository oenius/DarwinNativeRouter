//
//  DNRootViewControllerDispatcher.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNRootViewControllerDispatcher.h"

@implementation DNRootViewControllerDispatcher

+ (instancetype)dispatcher
{
  static DNRootViewControllerDispatcher *dispatcher;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      dispatcher = [[self.class alloc]init];
    });
  });
  return dispatcher;
}

- (DNRootViewControllerDispatcher *(^)(__kindof UIViewController *controller))replaceRootControllerWithController
{
  return ^DNRootViewControllerDispatcher *(UIViewController *controller)
  {
    [[UIApplication sharedApplication].delegate.window.rootViewController removeFromParentViewController];
    [UIApplication sharedApplication].delegate.window.rootViewController = controller;
    return self;
  };
}

@end
