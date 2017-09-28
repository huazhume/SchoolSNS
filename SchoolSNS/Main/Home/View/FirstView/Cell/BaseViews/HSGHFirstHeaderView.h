//
//  HSGHHomeMainCellHeaderView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"
#import "SchoolSNS-Swift.h"


typedef void(^HeaderBlock) (NSInteger type, NSString * key);

@interface HSGHFirstHeaderView : UIView
@property(nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet AnimatableButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLab;
@property (weak, nonatomic) IBOutlet UILabel *universityLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageANameWidth;

@property (weak, nonatomic) IBOutlet UIImageView *universityIcon;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@property (nonatomic,copy) HeaderBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uiniBack;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *addingLab;

@property (weak, nonatomic) IBOutlet UIView *friendPassbgView;
@property (weak, nonatomic) IBOutlet AnimatableButton *friendPassBtn;

@property (weak, nonatomic) IBOutlet UILabel *otherVisiableLabel;

@property (weak, nonatomic) IBOutlet UIImageView *frinedImageTo;





-(void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF;

@end
