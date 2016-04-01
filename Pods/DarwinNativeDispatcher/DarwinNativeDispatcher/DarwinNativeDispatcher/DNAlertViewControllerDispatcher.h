//
//  DNAlertViewControllerDispatcher.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNAlertViewControllerDispatcher : NSObject

+ (instancetype)dispatcher;

- (DNAlertViewControllerDispatcher *(^)(UIViewController *controller))show;
- (DNAlertViewControllerDispatcher *)hide;

- (DNAlertViewControllerDispatcher *)clearColor;
- (DNAlertViewControllerDispatcher *(^)(UIColor *color))tintColor;

@end
