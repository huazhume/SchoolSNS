//
//  HSGHMsgBaseView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BaseViewDelegate <NSObject>
//跳转界面
- (void)pushViewVC:(UIViewController *)vc;


@end

@interface HSGHMsgBaseView : UIView
@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, weak)id <BaseViewDelegate> delegate;
- (NSArray *)removeIndexItem:(NSArray *)array WithIndexPath:(NSIndexPath *)indexPath;


@end
