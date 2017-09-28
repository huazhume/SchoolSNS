//
//  HSGHRootViewController.h
//  HSGHNBC
//
//  Created by Qianqian li on 2017/2/13.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHBaseNavigationView.h"


@protocol HSGHViewControllerDelegate <NSObject>

- (void)keyBoardIsHidden:(BOOL)hidden;

@end


@interface HSGHBaseViewController : UIViewController

@property (nonatomic ,strong)HSGHBaseNavigationView *navigationBarView;
- (void)leftBarItemBtnClicked:(UIButton *)btn;
- (void)addLeftNavigationBarBtnWithString:(NSString *)string;
- (void)addRightNavigationBarBtnWithString:(NSString *)string;
- (void)rightBarItemBtnClicked:(UIButton *)btn;

- (void)setNavigationBarIsHidden:(BOOL)state;

@end

