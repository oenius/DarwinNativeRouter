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
  
  [DNRouter routerWithName:@"home" path:@"/home/something" controller:^__kindof UIViewController *{
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
    return controller;
                  
  } action:^(__kindof UIViewController *controller) {
    
    [DNDispatcher dispatcher].defaultNavigationController.animation(YES).pushViewController(controller);
    
  }];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  switch (type) {
    case 1001:
      //jumping code
      break;

    case 1002:
      //jumping code
      break;
    case 1003:
      //jumping code
      break;
    case 1004:
      //jumping code
      break;
      
    default:
      break;
  }
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  if([[DNRouter router]canOpen:url.absoluteString])
  {
    [[DNRouter router]open:url.absoluteString];
    return YES;
    
    [DNRouter defaultRouterWithController:^__kindof UIViewController *{
      
    } action:^(__kindof UIViewController *controller) {
      
    }];
    
    [DNRouter notFoundRouterWithController:^__kindof UIViewController *{
      
    } action:^(__kindof UIViewController *controller) {
      
    }];
  }
  return NO;
}

@end
