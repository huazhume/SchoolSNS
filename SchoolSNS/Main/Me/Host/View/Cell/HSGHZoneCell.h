//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//
#import "HSGHHomeFirstCellView.h"
#import "HSGHHomeModelFrame.h"

@interface HSGHZoneCell : UITableViewCell
  
@property (weak, nonatomic) IBOutlet HSGHHomeFirstCellView *publicCellView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

- (void)setContentFrame:(HSGHHomeQQianModelFrame *)frame isFriend:(BOOL)isFriend;

- (void)mark:(BOOL)marked;
@end
