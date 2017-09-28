//
//  HSGHDetailTimeView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"

@interface HSGHDetailTimeView : UIView

@property(nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
- (void)setModelFrame:(HSGHHomeQQianModelFrame*)modelF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendAllImageWidth;
@property (weak, nonatomic) IBOutlet UIButton *timeFriendAllBtn;

@end
