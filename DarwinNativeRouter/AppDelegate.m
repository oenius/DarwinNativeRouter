//
//  AppDelegate.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "AppDelegate.h"
#import "DarwinNativeRouter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  //Do initialize the router
  [self applicationLoadRouter];
  
  return YES;
}

- (void)applicationLoadRouter
{
  [DNRouter routerWithName:@"MAIN" path:@"/home" controller:^__kindof UIViewController *{
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
    return controller;
  } action:^(__kindof UIViewController *controller) {
    [(UINavigationController *)self.window.rootViewController pushViewController:controller animated:NO];
  }];
  
  [DNRouter routerWithName:@"PROFILE" path:@"/user/:id" controller:^__kindof UIViewController *{
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
    return controller;
  } action:^(__kindof UIViewController *controller) {
    [(UINavigationController *)self.window.rootViewController pushViewController:controller animated:NO];
  }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  if([[DNRouter router]canOpen:url.absoluteString])
  {
    [[DNRouter router]open:url.absoluteString];
    return YES;
  }
  return NO;
}

@end
