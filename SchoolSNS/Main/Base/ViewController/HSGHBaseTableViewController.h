//
//  HSGHBaseTableViewController.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHBaseTableViewController : UITableViewController
- (void)leftBarItemBtnClicked:(UIButton *)btn;
- (void)addLeftNavigationBarBtnWithString:(NSString *)string;
- (void)addRightNavigationBarBtnWithString:(NSString *)string;
- (void)addRightNavigationBarImage:(NSString *)string;
- (void)rightBarItemBtnClicked:(UIButton *)btn;
//- (void)setNavigationBarIsHidden:(BOOL)isHidden;
@end
