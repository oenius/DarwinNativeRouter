//
//  DNRouter.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

///---------------
/// @name DNRouter
///---------------

@interface DNRouter : NSObject

///---------------
/// @name DarwinNativeRouter handling
///---------------

/**
 Returns the default singleton instance.
 */
+ (instancetype)router;

/**
 If not set, then uses the first scheme value setted in info.plist.
 Returns a entirely new router instance.
 */
+ (instancetype)registNativeWithScheme:(NSString *)scheme;

/**
 Just like the router of 404 & index.html action in the web application.
 Default router action will be executed when just routed to the scheme.
 notFound router action will be executed when the path not matched.
 */
+ (instancetype)defaultRouterWithController:(__kindof UIViewController *(^)(void))controller
                                     action:(void(^)(__kindof UIViewController *controller)) action;

+ (instancetype)notFoundRouterWithController:(__kindof UIViewController *(^)(void))controller
                                      action:(void(^)(__kindof UIViewController *controller)) action;

///---------------
/// @name DarwinNativeRouter path & action mapping settings
///---------------

/**
 @param path The path route formate supports static & dynamic uri. Static example: '/profile/'. Dynamic example: '/user/:userId/', and regix also supported.
 */
+ (instancetype)routerWithName:(NSString *)name
                          path:(NSString *)path
                    controller:(__kindof UIViewController *(^)(void))controller
                        action:(void(^)(__kindof UIViewController *controller)) action;

/**
 @param path The path route formate supports static & dynamic uri. Static example: '/profile/'. Dynamic example: '/user/1991/profile/'. Also regix supported.
 @param navigationController The navigationController to support './', '../', '/'.
 */
+ (instancetype)routerWithName:(NSString *)name
                          path:(NSString *)path
          navigationController:(UINavigationController *)navigationController
                    controller:(__kindof UIViewController *(^)(void))controller
                        action:(void(^)(__kindof UIViewController *controller))action;

///---------------
/// @name DarwinNativeRouter router behavior
///---------------

/**
 @param path supports './', '../', '/'.
 */
- (__kindof UIViewController *)open:(NSString *)path;

/**
 Return YES when can route to path.
 */
- (BOOL)canOpen:(NSString *)path;

/**
 @param name execute the action map the name.
 */
- (__kindof UIViewController *)redirect:(NSString *)name;

/**
 Return YES when can route to name.
 */
- (BOOL)canRedirect:(NSString *)name;

@end


