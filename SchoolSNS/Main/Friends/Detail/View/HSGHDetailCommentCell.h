//
//  HSGHDetailCommentCell.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
#import "SchoolSNS-Swift.h"


@interface HSGHDetailCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *iconbgView;
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *universityImage;
@property (weak, nonatomic) IBOutlet UILabel *universityLab;
@property (weak, nonatomic) IBOutlet UIView *textViewLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeHeight;
@property (strong, nonatomic) YYLabel * textLab;
@property (weak, nonatomic) IBOutlet UIButton *toFriend;
@property (weak, nonatomic) IBOutlet UILabel *upLab;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLabWidth;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *addingLab;
@property (weak, nonatomic) IBOutlet UIView *friendPassbgVIew;
@property (weak, nonatomic) IBOutlet AnimatableButton *friendPassBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendPassBtnRightCos;

@property (weak, nonatomic) IBOutlet UIImageView *friendImageTo;



@end
