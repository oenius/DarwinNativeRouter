//
//  DNRouterCenter.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/29.
//  Copyright © 2016年 oenius. All rights reserved.
//

#define DN_REGEX_SCHEME  @"^([\\w- .]+)"
#define DN_REGEX_SCHEME_PREFIX  @"^([\\w- .]+)(://)"

#define DN_REGEX_STATIC_PATH    @"^([\\w- .]+)"
#define DN_REGEX_DYNAMIC_PATH  @"^(/)([\\w- .]+)(/:)"
#define DN_REGEX_DYNAMIC_VALUE_PATH @"(:[\\w- .]+)"

#define DN_REGEX_DYNAMIC_VALUE_SUFFIX @"([\\w- .]+)$"

#define DN_REGEX_PARAMS_SUFFIX @"(\\?[\\w- .&=]+)$"
#define DN_REGEX_PARAMS_UNIT @"([\\w- ]+)(=)([\\w- ]+)$"

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
  NSDictionary *queryItems = [self queryItemsInPath:&path];
  NSMutableArray *actions = [@[] mutableCopy];
  
  NSRange ar = [self dn_rangeOfActionPattern:path];
  NSMutableString *mp = [path mutableCopy];
  
  NSString *scheme;
  mp = [self dn_removeRangeOfSchemePattern:path scheme:&scheme];
  
  if((scheme && ![[scheme lowercaseString] isEqualToString:[self.scheme lowercaseString]]) || !mp) return nil;
  
  //normal scheme action
  if(ar.length < 3)
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
  //remove the last '/' characters to make uniform path
  NSString *pattern = @"(/+)$";
  NSRange range = [path rangeOfString:pattern
                              options:NSRegularExpressionSearch];
  
  if(range.location != NSNotFound) path = [path stringByReplacingCharactersInRange:range withString:@""];
  
  
  //the dynamic path should have prior right for matching
  NSRange dr = [path rangeOfString:DN_REGEX_DYNAMIC_PATH
                              options:NSRegularExpressionSearch];
  if(dr.location != NSNotFound)
  {
    dr = [path rangeOfString:DN_REGEX_DYNAMIC_VALUE_PATH
                     options:NSRegularExpressionSearch];
    path = [path stringByReplacingCharactersInRange:dr
                                         withString:DN_REGEX_DYNAMIC_VALUE_SUFFIX];
  }
  
  //return path regex should match from head
  path = [NSString stringWithFormat:@"^%@",path];
  return path;
}

- (BOOL)dn_isDynamicPattern:(NSString *)path
{
  if([path hasSuffix:DN_REGEX_DYNAMIC_VALUE_SUFFIX])
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
- (NSMutableString *)dn_removeRangeOfSchemePattern:(NSString *)path scheme:(NSString **)scheme
{
  NSRange range = [path rangeOfString:DN_REGEX_SCHEME_PREFIX
                              options:NSRegularExpressionSearch];
  NSMutableString *ms = [path mutableCopy];
  
  if(range.location != NSNotFound)
  {
    NSRange sr = [path rangeOfString:DN_REGEX_SCHEME
                                options:NSRegularExpressionSearch];
    *scheme = [path substringWithRange:sr];
    
    [ms deleteCharactersInRange:NSMakeRange(sr.location, sr.length + 2)];
    return ms;
  }
  
  return ms;
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
    
    if(range.location != NSNotFound)
    {
      *pattern = p;
      
      if([self dn_isDynamicPattern:p])
      {
        NSString *dynamicPart = [path substringWithRange:range];
        
        NSRange dr = [path rangeOfString:DN_REGEX_DYNAMIC_VALUE_SUFFIX
                                 options:NSRegularExpressionSearch];
        
        if(dr.location != NSNotFound) *queryId = [dynamicPart substringWithRange:dr];
        return range;
      }
      
      return range;
    }
  }
  return range;
}

- (NSDictionary *)queryItemsInPath:(NSString **)path
{
  NSMutableDictionary *queryItems = [@{} mutableCopy];
  
  NSRange paramsRange = [*path rangeOfString:DN_REGEX_PARAMS_SUFFIX
                                    options:NSRegularExpressionSearch];
  

  
  if(paramsRange.location == NSNotFound) return nil;
  
  NSMutableString *mParams = [[*path substringWithRange:paramsRange] mutableCopy];
  
  NSMutableString *mPath = [*path mutableCopy];
  [mPath deleteCharactersInRange:paramsRange];
  *path = mPath;
  
  while (mParams.length > 0) {
    NSRange r = [mParams rangeOfString:DN_REGEX_PARAMS_UNIT
                               options:NSRegularExpressionSearch];
    
    if(r.location != NSNotFound)
    {
      NSString *matched = [mParams substringWithRange:r];
      NSArray *sliced = [matched componentsSeparatedByString:@"="];
      if(sliced.count == 2)
      {
        NSString *key = [self dn_trimDontCareCharacters:sliced[0]];
        NSString *value = [self dn_trimDontCareCharacters:sliced[1]];
        queryItems[key] = value;
      }
      [mParams deleteCharactersInRange:NSMakeRange(r.location - 1, r.length + 1)];
    }
    else
    {
      mParams = [@"" mutableCopy];
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
