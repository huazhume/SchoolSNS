//
//  HSGHAtViewController.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseViewController.h"
#import "HSGHFriendViewModel.h"


typedef void(^AtBlock)(BOOL isAt,HSGHFriendSingleModel * model);
typedef void(^AtBlockArr)(BOOL isAt,NSArray *modelArr);

@interface HSGHAtViewController : HSGHHomeBaseViewController
@property (nonatomic ,copy)AtBlock block;
@property (nonatomic ,copy)AtBlockArr blockArr;//多选时 传数组

@end
