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

+ (instancetype)router;

+ (instancetype)registNativeWithScheme:(NSString *)scheme;

/*
 * 定义默认行为
 * 404 & index
 */
+ (instancetype)defaultRouterWithController:(__kindof UIViewController *(^)(void))controller
                                     action:(void(^)(__kindof UIViewController *controller)) action;

+ (instancetype)notFoundRouterWithController:(__kindof UIViewController *(^)(void))controller
                                      action:(void(^)(__kindof UIViewController *controller)) action;

/*
 * /:id
 */

+ (instancetype)routerWithName:(NSString *)name
                          path:(NSString *)path
                    controller:(__kindof UIViewController *(^)(void))controller
                        action:(void(^)(__kindof UIViewController *controller)) action;

/*
 * navigation controller to handle pop action
 */
+ (instancetype)routerWithName:(NSString *)name
                          path:(NSString *)path
          navigationController:(UINavigationController *)navigationController
                    controller:(__kindof UIViewController *(^)(void))controller
                        action:(void(^)(__kindof UIViewController *controller))action;

/*
 * ./ 当前路径推送页面
 * ../ 上个路径推送页面
 */

- (__kindof UIViewController *)open:(NSString *)path;
- (BOOL)canOpen:(NSString *)path;

/*
 * 执行对应name的action
 */

- (__kindof UIViewController *)redirect:(NSString *)name;
- (BOOL)canRedirect:(NSString *)name;

@end


