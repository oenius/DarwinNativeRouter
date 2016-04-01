//
//  UIViewController+DNRouterExtra.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DNRouterExtra)

@property (nonatomic, assign)BOOL dn_pushAnimationNeeded;
@property (nonatomic, assign)BOOL dn_popAnimationNeeded;

- (void)dn_viewDidLoadQuery:(NSDictionary *)queryItems;
- (void)dn_viewDidLoadQueryId:(NSString *)qid;

@end
