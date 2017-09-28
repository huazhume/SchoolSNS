//
//  HSGHBaseNavigationViewController.m
//  HSGHNBC
//
//  Created by Qianqian li on 2017/2/14.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHBaseNavigationViewController.h"
#import "HSGHBaseViewController.h"

@interface HSGHBaseNavigationViewController ()

@end

@implementation HSGHBaseNavigationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.frame = CGRectMake(0,self.view.frame.size.height - 44 , HSGH_SCREEN_WIDTH, 49);
    self.navigationController.navigationBar.frame = CGRectMake(0,9, HSGH_SCREEN_WIDTH, 44);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configNavigationBar];
}

/**
 导航初始化
 */
- (void)configNavigationBar {
  
  [self.navigationBar setTitleTextAttributes:@{
    NSFontAttributeName : [UIFont systemFontOfSize:14.f],
    NSForegroundColorAttributeName : [UIColor colorWithRed:39 / 255.0
                                                     green:39 / 255.0
                                                      blue:39 / 255.0
                                                     alpha:1]
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
  return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.topViewController.supportedInterfaceOrientations;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  return self.topViewController;
}


@end
