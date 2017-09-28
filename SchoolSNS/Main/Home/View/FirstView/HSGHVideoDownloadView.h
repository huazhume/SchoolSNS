//
//  HSGHVideoDownloadView.h
//  SchoolSNS
//
//  Created by hemdenry on 2017/9/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHVideoDownloadView : UIView

@property (nonatomic,strong) CAShapeLayer *progressLayer;

- (void)setProgress:(CGFloat)progress;
@end
