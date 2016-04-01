//
//  UIViewController+DNDExtra.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/30.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "UIViewController+DNDExtra.h"

@implementation UIViewController (DNDExtra)

- (__kindof UIViewController *)viewControllerOfClass:(Class) iclass
{
  id controller = [self dnr_presentedViewController:self class:iclass];
  if(!controller) controller = [self dnr_childViewController:self class:iclass];
  return controller;
}

- (__kindof UIViewController *)dnr_childViewController:(UIViewController *)controller class:(Class) iclass
{
  
  NSArray *controllers = [controller childViewControllers];
  
  if(!controllers) return nil;
  if ([controllers count] == 0) return nil;
  if([controller isKindOfClass:iclass]) return controller;
  
  for (UIViewController *c in controllers) {
    
    [self dnr_childViewController:c class:iclass];
  }
  
  return nil;
}

- (__kindof UIViewController *)dnr_presentedViewController:(UIViewController *)controller class:(Class) iclass
{
  UIViewController *rlt;
  UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
  if([topVC isKindOfClass:iclass])
  {
    rlt = topVC;
  }
  while (topVC.presentedViewController)
  {
    topVC = topVC.presentedViewController;
    if([topVC isKindOfClass:iclass])
    {
      rlt = topVC;
    }
  }
  if([topVC isKindOfClass:iclass]) return topVC;
  return nil;
}


@end
