//
//  UIView+Frame.h
//  BFSports
//
//  Created by 坡王 on 16/3/25.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

@property(nonatomic,assign)CGFloat centerx;
@property(nonatomic,assign)CGFloat centery;

@end
