//
//  ViewController.m
//  DarwinNativeRouter
//
//  Created by YURI_JOU on 16/3/28.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "ViewController.h"
#import "DNRouter.h"
#import "UIViewController+DNRouterExtra.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak typeof(self) weakSelf = self;
  

}

- (IBAction)handleClick:(id)sender
{
  UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
  UIViewController *controller1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];

  UITabBarController *tabController = [[UITabBarController alloc]init];
  
  [tabController setViewControllers:@[controller,controller1]];
  [self presentViewController:tabController animated:YES completion:nil];
  

}

- (void)dn_viewDidLoadQuery:(NSDictionary *)queryItems
{

}

- (void)dn_viewDidLoadQueryId:(NSString *)qid
{

}

- (IBAction)dispatcher:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
  UIViewController *personal = [UIViewController new];
  personal.userId = @"10238372";
  [self.navigationController pushViewController:personal animated:YES];
    [[DNRouter router]open:@"dnr://user/10238372/profile"];
}

- (IBAction)present:(id)sender
{
  [[DNRouter router]open:@"/home/something"];
}

@end
