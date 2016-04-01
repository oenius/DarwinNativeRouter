//
//  DNRouterCenter.h
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DNActionBehavior)
{
  DNActionPopBehavior,
  DNActionPopToRootBehavior,
  DNActionAttachedBehavior,
  DNActionDynamicUndefineBehavior
};

@interface DNAction : NSObject

@property (nonatomic, assign)DNActionBehavior behavior;
@property (nonatomic, strong)NSDictionary *queryItems;

@property (nonatomic, copy)NSString *queryId;

@property (nonatomic, copy) UIViewController *(^controller)(void);
@property (nonatomic, copy) void *(^action)(UIViewController *controller);

@end

@interface DNRouterCenter : NSObject

@property (nonatomic, copy)NSString *scheme;

+ (instancetype)defaultCenter;

- (void)addName:(NSString *)name
           path:(NSString *)path
     controller:(__kindof UIViewController *(^)(void))controller
         action:(void(^)(__kindof UIViewController *controller))action;

- (DNAction *)actionOfName:(NSString *)name;
- (NSArray *)actionsOfPath:(NSString *)path;

@end
