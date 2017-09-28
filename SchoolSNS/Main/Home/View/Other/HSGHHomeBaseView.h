//
//  HSGHHomeBaseView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "HSGHKeyBoardView.h"
#import "HSGHHomeModelFrame.h"

typedef void (^FawordSuccBlock)();

typedef enum {
    HOME_FIRST_MODE = 1001,
    HOME_SECOND_MODE,
    HOME_THIRD_MODE,
} HOME_MODE;

typedef enum {
    EDIT_FORWARD_MODE = 1006,
    HOME_COMMENT_MODE,
    HOME_REPLAY_MODE,
    ZONE_EDIT_SIGNATURE
} EDIT_MODE;

@protocol BaceViewDelegate <NSObject>
- (void)pushViewVC:(UIViewController *)vc;
//up
- (void)qqianUpWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath *)indexPath;
//more
- (void)qqianMoreWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath *)indexPath;
//comment forwoad
- (void)qqianCommentAndForwardWithHomeType:(HOME_MODE)mode andEdit:(EDIT_MODE)editMode andMainIndex:(NSIndexPath *)mainIndexPath andNomalIndex:(NSIndexPath *)nomalIndex;

- (void)qqianAddFrinedWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath *)indexPath;

- (void)navAndTabIsHidden:(BOOL)isHidden ;

- (void)qqianRemoveHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath;

- (void)cancelQqianUpWithHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TabBarItemDelegate <NSObject>
- (void)setTabBarItemEnable:(TAB_CENTER_MODE)mode;
@end

typedef void (^LoadMoreDataBlock)();//下拉加载更多block
@interface HSGHHomeBaseView : UIView

@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) NSArray<HSGHHomeQQianModelFrame*>* dataFrameArr;
@property (nonatomic, copy) LoadMoreDataBlock loadMoreDataBlock;//下拉加载更多
//new
- (void)reloadData:(NSArray *)data andIndex:(NSIndexPath*)indexPath;
- (void)setData:(NSArray *)frameArr;
- (void)reloadData:(NSArray *)data ;
- (void)replaceData:(NSArray*)frameArr WithIndex:(NSInteger)index ;
- (void)forwardWithQqianVO:(HSGHHomeQQianModel *)qqiansVO ;
- (void)forwardWithQqianVO:(HSGHHomeQQianModel *)qqiansVO succBlock:(FawordSuccBlock)succBlock;

@property(nonatomic, weak) id<BaceViewDelegate> delegate;
@property(nonatomic, weak) id<TabBarItemDelegate> tabDelegate;

@property(nonatomic, assign) CGFloat oldOffset;

@end
