//
//  HSGHIconCollectionViewCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFabuCollectionViewCell.h"

@implementation HSGHFabuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.userBack.layer.cornerRadius = 15;
    self.userBack.layer.masksToBounds = YES;

    self.userBack.layer.borderWidth = 0.5;
}

@end
