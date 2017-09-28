//
//  HSGHFriendDetailViewController.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseViewController.h"

typedef void(^PopBlock)();


@interface HSGHMsgDetailViewController : HSGHHomeBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (copy, nonatomic) NSString * messageId;
@property (copy, nonatomic) NSString * userId;
@property (nonatomic, copy) PopBlock  popCallBackBlock;

- (instancetype)initWithDataArray:(NSArray *)modelFrameArr;

@end
