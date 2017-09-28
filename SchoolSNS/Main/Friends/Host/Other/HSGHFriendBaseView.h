//
//  HSGHFriendBaseView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    FRIEND_CATE_FRIST = 1001,
    FRIEND_CATE_SECOND,
    FRIEND_CATE_THIRD,
    FRIEND_CATE_FORTH,
} FRINED_CATE_MODE;


@protocol BaseViewDelegate <NSObject>
//跳转界面
- (void)pushViewVC:(UIViewController *)vc WithType:(FRINED_CATE_MODE)mode;

//
- (void)searchDetailWithText:(NSString *)searchKey;


- (void)navAndTabIsHidden:(BOOL)isHidden ;

@end


@interface HSGHFriendBaseView : UIView
@property(nonatomic, strong) UITableView *mainTableView;
- (NSArray *)removeIndexItem:(NSArray *)array WithIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic, weak) id<BaseViewDelegate> delegate;

@end
