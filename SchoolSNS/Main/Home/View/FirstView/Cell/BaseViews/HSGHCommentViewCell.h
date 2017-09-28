///
//  HSGHCommentViewCell.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"

typedef void(^LongPressBlock)();

@interface HSGHCommentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView * textBgView;
@property (copy, nonatomic) LongPressBlock block;
@property (weak, nonatomic) IBOutlet UILabel *textHeight;
@property (strong, nonatomic) YYLabel * textLab;

@end
