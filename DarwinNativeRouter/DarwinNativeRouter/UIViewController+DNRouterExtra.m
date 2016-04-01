//
//  UIViewController+DNRouterExtra.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "UIViewController+DNRouterExtra.h"

#import <objc/runtime.h>

static const void *pushAnimated = &pushAnimated;
static const void *popAnimated = &popAnimated;

@implementation UIViewController (DNRouterExtra)
@dynamic dn_pushAnimationNeeded, dn_popAnimationNeeded;

- (BOOL)dn_popAnimationNeeded
{
  return [objc_getAssociatedObject(self, popAnimated) boolValue];
}

- (BOOL)dn_pushAnimationNeeded
{
  return [objc_getAssociatedObject(self, pushAnimated) boolValue];
}

- (void)setDn_popAnimationNeeded:(BOOL)dn_popAnimationNeeded
{
  objc_setAssociatedObject(self, popAnimated, @(dn_popAnimationNeeded), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDn_pushAnimationNeeded:(BOOL)dn_pushAnimationNeeded
{
  objc_setAssociatedObject(self, pushAnimated, @(dn_pushAnimationNeeded), OBJC_ASSOCIATION_ASSIGN);
}

- (void)dn_viewDidLoadQuery:(NSDictionary *)queryItems{}
- (void)dn_viewDidLoadQueryId:(NSString *)qid{}

@end
