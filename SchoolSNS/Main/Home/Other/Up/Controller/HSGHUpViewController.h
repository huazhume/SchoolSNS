//
//  HSGHUpViewController.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseViewController.h"
#import "HSGHHomeModel.h"

@interface HSGHUpViewController : HSGHHomeBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)  HSGHHomeQQianModel * qqianVo;

@end
