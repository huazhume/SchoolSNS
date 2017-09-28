//
//  HSGHPublishView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PublishBtnClicked)(int tag);

@interface HSGHPublishView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UILabel *photoLab;
@property (weak, nonatomic) IBOutlet UILabel *textLab;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UILabel *videoTextLab;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBtnToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBtnToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoLabToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoBtnToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoLabToBottom;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnToBottom;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (copy, nonatomic) PublishBtnClicked block;

@end
