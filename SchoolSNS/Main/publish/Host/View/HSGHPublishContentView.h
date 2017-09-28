//
//  HSGHPublishContentView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHFirstHeaderView.h"
#import "HSGHFirstContentView.h"


@interface HSGHPublishContentView : UIView
@property (weak, nonatomic) IBOutlet HSGHFirstHeaderView *headerView;
@property (weak, nonatomic) IBOutlet HSGHFirstContentView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIView *locationView;

@end
