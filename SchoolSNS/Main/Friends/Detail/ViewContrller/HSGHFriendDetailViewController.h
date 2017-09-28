//
//  HSGHFriendDetailViewController.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseViewController.h"
#import "HSGHFriendBaseView.h"
#import "HSGHFriendViewModel.h"



typedef void(^PopBlock)();

@interface HSGHFriendDetailViewController : HSGHHomeBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, copy) PopBlock  popCallBackBlock;
@property (nonatomic ,assign) FRINED_CATE_MODE mode;
@property (strong, nonatomic) HSGHFriendSingleModel * model;


@end
