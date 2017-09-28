//
//  WYCategoryButton.m
//  WYNews
//
//  Created by dai.fengyi on 15/6/29.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "HSGHCategoryButton.h"
#define kLabelSideMargin        25
#define kTopicLabelFont         14

#define kTopicHeaderHeight      44
#define kTopicHeaderBgColor     [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]
@implementation HSGHCategoryButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:HEXRGBCOLOR(0x4f4f4f) forState:UIControlStateNormal];
        [self setTitleColor:HEXRGBCOLOR(0xff520d) forState:UIControlStateSelected];
        
        self.iconImageView = [[UIImageView alloc]init];
        [self addSubview:self.iconImageView];
        self.titleLabel.font = HSLBoldFontSize(kTopicLabelFont);
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kTopicLabelFont]}];
    size.height = kTopicHeaderHeight;
    size.width = HSLFullScreenWidth/4;
    self.frame = (CGRect){self.bounds.origin, size};
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.iconImageView.y = self.titleLabel.y;
    self.iconImageView.x = CGRectGetMaxX(self.titleLabel.frame)+3;
    self.iconImageView.size = CGSizeMake(14, 14);
}
- (void)setScale:(CGFloat)scale
{
    //240, 215, 215
    _scale = scale;
 
 //   [self setTitleColor:[UIColor colorWithRed:(scale * (79 - 243.0) + 243.0)/255 green:(scale * (79 - 198.0) + 198.0)/255 blue:(scale * (79 - 198.0) + 198.0)/255 alpha:1] forState:UIControlStateNormal];
    
//    
//    [self setTitleColor:[UIColor colorWithRed:(scale * (243.0-79 ) + 79)/255 green:(scale * ( 198.0-79 ) + 79.0)/255 blue:(scale * (198.0-79) + 79.0)/255 alpha:1] forState:UIControlStateNormal];
//
//    
//    NSLog(@"\ncolor is %@", self.titleLabel.textColor);
//    self.transform = CGAffineTransformMakeScale(1 + 0.18 * scale, 1 + 0.18 * scale);
}
@end
