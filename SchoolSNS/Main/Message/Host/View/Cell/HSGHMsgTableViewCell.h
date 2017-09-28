//
//  HSGHMsgTableViewCell.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHMessageModel.h"
#import "YYLabel.h"


typedef void(^CallBackblock)(NSInteger state);

@interface YYTextMatchBindingParserTwo :NSObject <YYTextParser>

@end

@interface HSGHMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *friendIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendUniversity;
@property (weak, nonatomic) IBOutlet UIImageView *universityImage;
@property (weak, nonatomic) IBOutlet UILabel *commentLabbg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (copy, nonatomic) CallBackblock block;

@property (strong, nonatomic) YYLabel * commentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *universityHeight;


- (void)updateInfo:(HSGHSingleMsg*)singleMsg;
@end
