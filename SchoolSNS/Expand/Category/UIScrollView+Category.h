//
//  UIScrollView+Category.h
//  BFSports
//
//  Created by wayne on 16/7/5.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableViewPlaceholderView;

@interface UIScrollView (Category)

/**
 *  是否已设置placeholder
 */
@property (assign, nonatomic) BOOL didSetup;

@property (nonatomic, strong) UITableViewPlaceholderView * placeholderView;

/**
 *  @param  image   // 图片
 *  @param  title   // 标题
 *  @param  offsetY // 负数向上偏移,正数向下偏移,0时居中
 */
- (void)placeholderImage:(UIImage *)image title:(NSString *)title offsetY:(CGFloat)offsetY;
- (void)placeholderImage:(UIImage *)image title:(NSString *)title;
- (void)removePlaceholder;

@end


@interface UITableViewPlaceholderView : UIView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title offsetY:(CGFloat)offsetY;

@property (strong, nonatomic) UIImageView *placeholderImageView;

@property (strong, nonatomic) UILabel     *placeholderLabel;

@property (assign, nonatomic) CGFloat     offsetY;
@end
