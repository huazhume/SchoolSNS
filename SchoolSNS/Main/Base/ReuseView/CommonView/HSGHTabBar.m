//
//  DWTabBar.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "HSGHTabBar.h"

#import "HSGHPublishButton.h"

#define ButtonNumber 5


@interface HSGHTabBar ()

@property (nonatomic, strong) HSGHPublishButton *publishButton;/**< 发布按钮 */

@end

@implementation HSGHTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        HSGHPublishButton *button = [HSGHPublishButton publishButton];
        [button addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];
        self.publishButton = button;
        
    }
    
    return self;
}

- (void)clickPublish {
    
    if (self.publishdelegate && [self.delegate respondsToSelector:@selector(showTopicCategorySelectedView)]) {
        [self.publishdelegate performSelector:@selector(showTopicCategorySelectedView) withObject:nil];
    }
    
}

-(void)layoutSubviews{
    
    
    HSLog(@"%s",__func__);
    
    [super layoutSubviews];
    
    CGFloat barWidth = self.frame.size.width;
    CGFloat barHeight = self.frame.size.height;
    
    CGFloat buttonW = barWidth / ButtonNumber;
    CGFloat buttonH = barHeight - 2;
    CGFloat buttonY = 1;
    
    NSInteger buttonIndex = 0;
    
    self.publishButton.center = CGPointMake(barWidth * 0.5, barHeight * 0.3);
    
    for (UIView *view in self.subviews) {
        
        NSString *viewClass = NSStringFromClass([view class]);
        if (![viewClass isEqualToString:@"UITabBarButton"]) continue;

        CGFloat buttonX = buttonIndex * buttonW;
        if (buttonIndex >= 2) { // 右边2个按钮
            buttonX += buttonW;
        }
        
        view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        buttonIndex ++;
        
        
    }
}


@end
