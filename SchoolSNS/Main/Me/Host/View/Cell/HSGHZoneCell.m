//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHZoneCell.h"

@implementation HSGHZoneCell {

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


//- (void)setContentFrame:(HSGHHomeQQianModelFrame *)frame {
//    [_publicCellView setContentFrame:frame];
//}

- (void)setContentFrame:(HSGHHomeQQianModelFrame *)frame isFriend:(BOOL)isFriend {
    [_publicCellView setContentFrame:frame WithIsFriend:isFriend];
}

- (void)mark:(BOOL)marked {
    _markImageView.image = [UIImage imageNamed:(marked ? @"zone_circle_red" : @"zone_circle_normal")];
}

@end
