//
//  HSGHForwardView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHForwardView : UIView
@property(nonatomic, strong) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTextHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *universityHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;


@property (weak, nonatomic) IBOutlet UILabel *topTextLab;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *universityLab;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BackgroundViewHeight;


@property (assign,nonatomic)CGFloat viewHeight;


//- (void)setFrames:(HSGHHomeForWardContentModelFrame *)frame;
@end
