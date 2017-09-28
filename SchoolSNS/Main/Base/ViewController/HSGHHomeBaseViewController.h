//
//  HSGHHomeBaseViewController.h
//  SchoolSNS
//
//  Created by huaral on 2017/7/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHHomeBaseViewController : UIViewController
- (void)leftBarItemBtnClicked:(UIButton *)btn;
- (void)addLeftNavigationBarBtnWithString:(NSString *)string;
- (void)addRightNavigationBarBtnWithString:(NSString *)string;
- (void)addRightNavigationBarImage:(NSString *)string;
- (void)rightBarItemBtnClicked:(UIButton *)btn;
- (void)setNavigationBarIsHidden:(BOOL)isHidden;

- (void)setRightButtonClickable:(BOOL)clickable;


@end
