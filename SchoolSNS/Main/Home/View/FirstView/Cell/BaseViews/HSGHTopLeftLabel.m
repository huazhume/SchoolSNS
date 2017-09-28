//
//  HSGHTopLeftLabel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/31.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHTopLeftLabel.h"

@implementation HSGHTopLeftLabel
//- (void)awakeFromNib {
//    [super awakeFromNib];
//}

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
@end
