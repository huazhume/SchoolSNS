//
//  HSGHMessageVC.h
//  SchoolSNS
//
//  Created by 陈位 on 2017/8/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseViewController.h"

@interface HSGHMessageVC : HSGHHomeBaseViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)prepareData:(NSArray *)dataArr;

@end
