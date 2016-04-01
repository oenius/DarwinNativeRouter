//
//  DNRouterCenter.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DNRouterCenter.h"

@implementation DNAction


@end

@interface DNRouterCenter()

@property (nonatomic, strong)NSMutableArray *pathPatterns;

@property (nonatomic, strong)NSMutableDictionary *nameActionMapping;
@property (nonatomic, strong)NSMutableDictionary *nameControllerMapping;

@property (nonatomic, strong)NSMutableDictionary *pathActionMapping;
@property (nonatomic, strong)NSMutableDictionary *pathControllerMapping;

@end

@implementation DNRouterCenter

+ (instancetype)defaultCenter
{
  static DNRouterCenter *defaultCenter;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    defaultCenter = [[self.class alloc]init];
  });
  
  return defaultCenter;
}

- (NSMutableArray *)pathPatterns
{
  if(!_pathPatterns)
  {
    _pathPatterns = [@[] mutableCopy];
  }
  return _pathPatterns;
}

- (NSMutableDictionary *)nameActionMapping
{
  if(!_nameActionMapping)
  {
    _nameActionMapping = [@{} mutableCopy];
  }
  return _nameActionMapping;
}

- (NSMutableDictionary *)nameControllerMapping
{
  if(!_nameControllerMapping)
  {
    _nameControllerMapping = [@{} mutableCopy];
  }
  return _nameControllerMapping;
}

- (NSMutableDictionary *)pathActionMapping
{
  if(!_pathActionMapping)
  {
    _pathActionMapping = [@{} mutableCopy];
  }
  return _pathActionMapping;
}

- (NSMutableDictionary *)pathControllerMapping
{
  if(!_pathControllerMapping)
  {
    _pathControllerMapping = [@{} mutableCopy];
  }
  return _pathControllerMapping;
}

- (void)addName:(NSString *)name
           path:(NSString *)path
     controller:(__kindof UIViewController *(^)(void))controller
         action:(void(^)(__kindof UIViewController *controller))action;
{
  path = [self dn_parsePath:path];
  
  self.nameActionMapping[name] = action;
  self.nameControllerMapping[name] = controller;
  
  self.pathActionMapping[path] = action;
  self.pathControllerMapping[path] = controller;
  
  if([self dn_isDynamicPattern:path])
  {
    [self.pathPatterns insertObject:path atIndex:0];
  }
  else
  {
    [self.pathPatterns addObject:path];
  }
}

- (DNAction *)actionOfName:(NSString *)name
{
  if(![self.nameControllerMapping objectForKey:name]) return nil;
  DNAction *action = [[DNAction alloc]init];
  action.action = self.nameActionMapping[name];
  action.controller = self.nameControllerMapping[name];
  action.behavior = DNActionAttachedBehavior;
  return action;
}

- (NSArray *)actionsOfPath:(NSString *)path
{
  NSDictionary *queryItems = [self queryItemsInPath:path];
  NSMutableArray *actions = [@[] mutableCopy];
  NSRange ar = [self dn_rangeOfActionPattern:path];
  NSMutableString *mp = [path mutableCopy];
  
  NSString *scheme;
  NSRange sr = [self dn_rangeOfSchemePattern:path scheme:&scheme];
  
  if(scheme && ![[scheme lowercaseString] isEqualToString:[self.scheme lowercaseString]]) return nil;
  if(sr.location != NSNotFound)
  {
    [mp deleteCharactersInRange:sr];
  }
  
  //normal scheme action
  if(ar.location == NSNotFound)
  {
    
  }
  else if(ar.length < 3)
  {
    
    DNAction *pop = [self dn_popActionOfRange:ar];
    
    if(pop) [actions addObject:pop];
    
    if(ar.length > 0) [mp deleteCharactersInRange:ar];
    while(mp.length > 0)
    {
      NSString *pattern, *queryId;
      NSRange mpr = [self dn_rangeOfPattern:mp pattern:&pattern queryId:&queryId];
      if(mpr.location != NSNotFound)
      {
        DNAction *action = [[DNAction alloc]init];
        action.behavior = DNActionAttachedBehavior;
        action.queryItems = queryItems;
        action.queryId = queryId;
        
        action.controller = self.pathControllerMapping[pattern];
        action.action = self.pathActionMapping[pattern];
        
        [actions addObject:action];
        
        [mp deleteCharactersInRange:mpr];
      }
      else
      {
          mp = [@"" mutableCopy];
      }
    }
    
    return actions;
  }
  return nil;
}

- (NSString *)dn_parsePath:(NSString *)path
{
  NSString *pattern = @"[\\$]+";
  NSRange range = [path rangeOfString:pattern
                              options:NSRegularExpressionSearch];
  
  if(range.location != NSNotFound) path = [path stringByReplacingCharactersInRange:range withString:@""];
  
  NSString *dynamic = @"(:)([^s][^/]*)";
  NSRange dr = [path rangeOfString:dynamic
                              options:NSRegularExpressionSearch];
  if(dr.location != NSNotFound) path = [path stringByReplacingCharactersInRange:dr withString:@"([^s][^/]*)"];
  
  path = [NSString stringWithFormat:@"^%@",path];
  return path;
}

- (BOOL)dn_isDynamicPattern:(NSString *)path
{
  if([path hasSuffix:@"(:)([^s][^/]*)"])
  {
    return YES;
  }
  return NO;
}

- (DNAction *)dn_popActionOfRange:(NSRange)range
{
  DNAction *action = [[DNAction alloc]init];
  if(range.length == 2) {action.behavior = DNActionPopBehavior; return action;}
  if(range.length == 0) {action.behavior = DNActionPopToRootBehavior; return action;}
  return nil;
}

//match scheme
- (NSRange )dn_rangeOfSchemePattern:(NSString *)path scheme:(NSString **)scheme
{
  NSString *pattern = @"(^[a-zA-z]+)(:/)";

  NSRange range = [path rangeOfString:pattern
                              options:NSRegularExpressionSearch];
  
  if(range.location != NSNotFound)
  {
    *scheme = [path substringWithRange:range];
    NSString *schemePattern = @"(^[a-zA-z]+)";
    NSRange r = [*scheme rangeOfString:schemePattern options:NSRegularExpressionSearch];
    if(r.location != NSNotFound) *scheme = [*scheme substringWithRange:r];
  }
  return range;
}

//match ./ ../ or /
- (NSRange )dn_rangeOfActionPattern:(NSString *)path
{
  NSString *pattern = @"^\\.*";
  NSRange range = [path rangeOfString:pattern
                              options:NSRegularExpressionSearch];
  return range;
}

//match pattern

- (NSRange)dn_rangeOfPattern:(NSString *)path pattern:(NSString **)pattern queryId:(NSString **)queryId
{
  NSRange range;
  for(NSString *p in self.pathPatterns)
  {
    range = [path rangeOfString:p
                        options:NSRegularExpressionSearch];
    *pattern = p;
    if([*pattern hasSuffix:@"([^s][^/]*)"] && range.location != NSNotFound)
    {
      NSString *p = @"(^/[^s]+/[^\\?/]+)";
      
      path = [path substringWithRange:range];
      NSRange sr = [path rangeOfString:p
                               options:NSRegularExpressionSearch];

      if(sr.location != NSNotFound)
      {
        path = [path substringWithRange:sr];
        p = @"(^/[^s]+/)";
        sr = [path rangeOfString:p
                         options:NSRegularExpressionSearch];
        if(sr.location != NSNotFound)
        {
          *queryId = [path substringWithRange:NSMakeRange(sr.length + sr.location, path.length - sr.length)];
        }
      }
    }
    if(range.location != NSNotFound)
    {
      return range;
    }
  }
  return range;
}

- (NSDictionary *)queryItemsInPath:(NSString *)path
{
  NSMutableDictionary *queryItems = [@{} mutableCopy];
  NSMutableString *qp = [path mutableCopy];
  NSRange range = [qp rangeOfString:@"?"];
  if(range.location < 1 || range.location == NSNotFound) return nil;
  [qp deleteCharactersInRange:NSMakeRange(0, range.location + 1)];
  
  NSString *pattern = @"([^s][^=][^&]*)=([^s][^=][^&]*)";
  while (qp.length > 0) {
    NSRange r = [qp rangeOfString:pattern options:NSRegularExpressionSearch];
    if(r.location != NSNotFound)
    {
      NSString *matched = [qp substringWithRange:r];
      NSArray *sliced = [matched componentsSeparatedByString:@"="];
      if(sliced.count == 2)
      {
        NSString *key = [self dn_trimDontCareCharacters:sliced[0]];
        NSString *value = [self dn_trimDontCareCharacters:sliced[1]];
        queryItems[key] = value;
      }
      [qp deleteCharactersInRange:r];
    }
    else
    {
      qp = [@"" mutableCopy];
    }
  }
  if(queryItems.allKeys.count == 0) return nil;
  return [queryItems copy];
}

- (NSString *)dn_trimDontCareCharacters:(NSString *)c
{
  c = [c stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  c = [c stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&?"]];
  return c;;
}


@end
