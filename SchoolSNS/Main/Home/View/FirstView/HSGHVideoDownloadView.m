//
//  HSGHVideoDownloadView.m
//  SchoolSNS
//
//  Created by hemdenry on 2017/9/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHVideoDownloadView.h"

@implementation HSGHVideoDownloadView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.progressLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:15 startAngle:-M_PI*0.5 endAngle:1.5*M_PI clockwise:YES];
    self.progressLayer.path = path.CGPath;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.lineWidth = 30;
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.progressLayer];
}

- (void)setProgress:(CGFloat)progress {
    [self.progressLayer setStrokeEnd:progress];
}

@end
