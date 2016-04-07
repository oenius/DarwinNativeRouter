//
//  DNRouter.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNRouter.h"
#import "DNRouterCenter.h"
#import "UIViewController+DNRouterExtra.h"

@interface DNRouter()

@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, strong)UINavigationController *navigationController;

@end


@implementation DNRouter

+ (instancetype)router
{
  static DNRouter *router;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    router = [[self.class alloc]init];
  });
  
  return router;
}

+ (instancetype)registNativeWithScheme:(NSString *)scheme
{
  [DNRouter router].scheme = scheme;
  return [DNRouter router];
}

+ (instancetype)defaultRouterWithController:(__kindof UIViewController *(^)(void))controller
                                     action:(void(^)(__kindof UIViewController *controller))action
{
  DNRouter *router = [DNRouter router];
  return router;
}

+ (instancetype)notFoundRouterWithController:(__kindof UIViewController *(^)(void))controller
                                      action:(void(^)(__kindof UIViewController *controller))action
{

  DNRouter *router = [DNRouter router];
  return router;
}

+ (instancetype)routerWithName:(NSString *)name
                          path:(NSString *)path
                    controller:(__kindof UIViewController *(^)(void))controller
                        action:(void(^)(__kindof UIViewController *controller)) action;
{
  
  [[DNRouterCenter defaultCenter]addName:name path:path controller:controller action:action];
  return [DNRouter router];
}

+ (instancetype)routerWithName:(NSString *)name
                          path:(NSString *)path
          navigationController:(UINavigationController *)navigationController
                    controller:(__kindof UIViewController *(^)(void))controller
                        action:(void(^)(__kindof UIViewController *controller))action
{
  [DNRouter router].navigationController = navigationController;
  [[DNRouterCenter defaultCenter]addName:name path:path controller:controller action:action];
  return [DNRouter router];
}

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    [DNRouterCenter defaultCenter].scheme = self.scheme;
  }
  return self;
}

- (__kindof UIViewController *)open:(NSString *)path
{
  NSArray<DNAction *> *actions = [[DNRouterCenter defaultCenter]actionsOfPath:path];
  
  if(!actions) return nil;
  for(DNAction *action in actions)
  {
    if(action.behavior == DNActionAttachedBehavior)
    {
      if(action.action)
      {
        UIViewController *controller = action.controller();
        if([controller respondsToSelector:@selector(dn_viewDidLoadQuery:)])
        {
          [controller dn_viewDidLoadQuery:action.queryItems];
        }
        
        if([controller respondsToSelector:@selector(dn_viewDidLoadQueryId:)])
        {
          [controller dn_viewDidLoadQueryId:action.queryId];
        }

        if(controller && [controller isKindOfClass:[UIViewController class]]) action.action(controller);
      }
    }
    
    if(action.behavior == DNActionPopBehavior && self.navigationController)
    {
      [self.navigationController popViewControllerAnimated:self.navigationController.topViewController.dn_popAnimationNeeded];
    }
    
    if(action.behavior == DNActionPopToRootBehavior && self.navigationController)
    {
      [self.navigationController popToRootViewControllerAnimated:NO];
    }
  }
  
  return nil;
}

- (BOOL)canOpen:(NSString *)path
{
  NSArray<DNAction *> *actions = [[DNRouterCenter defaultCenter]actionsOfPath:path];
  if(!actions) return NO;
  return YES;
}

- (__kindof UIViewController *)redirect:(NSString *)name
{
  DNAction *action = [[DNRouterCenter defaultCenter]actionOfName:name];
  if(!action) return nil;
  UIViewController *controller = action.controller();
  if(controller && [controller isKindOfClass:[UIViewController class]]) action.action(controller);
  return controller;
}

- (BOOL)canRedirect:(NSString *)name;
{
  if([[DNRouterCenter defaultCenter]actionOfName:name]) return YES;
  return NO;
}

- (NSString *)scheme
{
  if(!_scheme)
  {
    NSArray *urls = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    id values = urls.firstObject;
    if(values && [values isKindOfClass:[NSDictionary class]])
    {
      _scheme = [[values objectForKey:@"CFBundleURLSchemes"] firstObject];
    }
  }
  return _scheme;
}

@end
