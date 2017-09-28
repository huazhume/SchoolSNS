//
//  BFLNavigationBarView.h
//  BFLive
//
//  Created by BaoFeng on 15/11/26.
//  Copyright © 2015年 BF. All rights reserved.
//  自定义导航视图

#import <UIKit/UIKit.h>

@interface HSGHNavigationBarView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bottomLine;
@property (nonatomic, weak) id  target;
@property (nonatomic, assign) SEL action;



/**
 *  自定义导航条
 *
 *  @param target 父类控制器
 *
 */

+ (instancetype)navigationBarWithTarget:(id)target;
/**
 *  设置标题
 */
- (void)setNavTitle:(NSString *)title;

/**
 *  设置标题以及左边返回按钮
 */
- (void)setNavTitle:(NSString *)title backAction:(SEL)action;

/**
 *  设置文字按钮
 */
- (UIButton *)setItemTitle:(NSString *)title
              action:(SEL)action
              isLeft:(BOOL)isLeft;

/**
 *  设置图片按钮
 */
- (void)setItemImage:(UIImage *)image
         selectImage:(UIImage *)selectImage
              action:(SEL)action
              isLeft:(BOOL)isLeft;
/**
 *  设置左边item的文字颜色
 */
-(void)setLeftTitleColor:(UIColor *)color;
@end
