//
//  AppDelegate.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "AppDelegate.h"
#import <DarwinNativeDispatcher.h>
#import "DarwinNativeRouter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  [DNRouter routerWithName:@"home" path:@"/home" controller:^__kindof UIViewController *{
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
    controller.view.backgroundColor = [UIColor orangeColor];
    return controller;
  } action:^(__kindof UIViewController *controller) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [DNDispatcher dispatcher].defaultNavigationController.animation(YES).pushViewController(controller);
    });
    
  }];
  
  [DNRouter routerWithName:@"profile" path:@"/user/:id"
      navigationController:(UINavigationController *)self.window.rootViewController
                controller:^__kindof UIViewController *{
                  
                  UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
                  controller.view.backgroundColor = [UIColor orangeColor];
                  
    return controller;
                  
  } action:^(__kindof UIViewController *controller) {
    
    [(UINavigationController *)self.window.rootViewController pushViewController:controller animated:YES];
    
  }];

  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//  if([[DNRouter router]canOpen:url.absoluteString])
//  {
//    [[DNRouter router]open:url.absoluteString];
//    return YES;
//  }
  return NO;
}

@end
