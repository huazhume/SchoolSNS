//
//  HSGHFriendFirstTableViewCell.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHFriendViewModel.h"


typedef void(^CallBackblock)(NSInteger state);
typedef void(^YuanQiBackblock)();//缘起
typedef void(^IgnoreBackblock)();//忽略

@class HSGHFriendSingleModel;

@interface HSGHFriendFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *friendIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendUniversity;
@property (weak, nonatomic) IBOutlet UIImageView *universityImage;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (copy, nonatomic) CallBackblock block;
@property (copy, nonatomic) YuanQiBackblock yuanQiBackblock;
@property (copy, nonatomic) IgnoreBackblock ignoreBackblock;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uniHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (weak, nonatomic) IBOutlet UILabel *systemInstLabel;

@property (nonatomic, strong) HSGHFriendSingleModel* model;

- (void)setup:(FRINED_CATE_TYPE)type;

- (void)updateInfo:(HSGHFriendSingleModel*)data;
@end
