//
//  HSGHUpTableViewCell.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHUpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *friendIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendUniversity;
@property (weak, nonatomic) IBOutlet UIImageView *universityImage;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@end
