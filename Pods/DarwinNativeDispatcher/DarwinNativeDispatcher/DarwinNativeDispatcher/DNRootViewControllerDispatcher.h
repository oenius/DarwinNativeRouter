//
//  DNRootViewControllerDispatcher.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNRootViewControllerDispatcher : NSObject

+ (instancetype)dispatcher;

- (DNRootViewControllerDispatcher *(^)(__kindof UIViewController *controller))replaceRootControllerWithController;

@end
