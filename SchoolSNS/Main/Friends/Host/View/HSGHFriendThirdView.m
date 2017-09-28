//
//  HSGHFriendThirdView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendThirdView.h"
#import "HSGHFriendFirstTableViewCell.h"
#import "HSGHFriendDetailViewController.h"
#import "HSGHFriendViewModel.h"
#import "HSGHTools.h"
#import "AppDelegate.h"

@interface HSGHFriendThirdView () <UITableViewDelegate, UITableViewDataSource,
    UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, copy) NSArray* dataArray;

@property(nonatomic, strong)  UIView * failView;//无数据时显示
@property(nonatomic, strong) NSString *currIgnoreUserid;
@end
@implementation HSGHFriendThirdView

- (void)awakeFromNib
{
    [super awakeFromNib];
    //  [self addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.alwaysBounceHorizontal = NO;
    self.mainTableView.alwaysBounceVertical = YES;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HSGHFriendFirstTableViewCell" bundle:[NSBundle mainBundle]]
                                                forCellReuseIdentifier:@"firstCell"];
    self.mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HSGH_SCREEN_WIDTH, 0.01f)];
    
    
    _failView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHFriendAddMeFailView" owner:self options:nil]lastObject];
    _failView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    [self.mainTableView addSubview:_failView];
    _failView.hidden = YES;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    HSGHFriendFirstTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
    [cell setup:FRIEND_CATE_MEDAO];
    
    HSGHFriendSingleModel* model = _dataArray[indexPath.row];
    if (model) {
        [cell updateInfo:model];
    }
//    cell.block = ^(NSInteger state) {
//        if(state == 1000){
//            _dataArray = [NSArray arrayWithArray:[self removeIndexItem:_dataArray WithIndexPath:indexPath]];
//            [self.mainTableView reloadData];
//        }
//    };
    
    __weak typeof(self) weakSelf = self;
    cell.ignoreBackblock = ^{
        ////friendApply/user/receive/remove
        HSLog(@"---userId=%@",model.userId);
        weakSelf.currIgnoreUserid = model.userId;
        [[[UIAlertView alloc] initWithTitle:@"" message:@"忽略此条信息" delegate:weakSelf cancelButtonTitle:@"确定"
                          otherButtonTitles:@"取消",nil] show];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    HSGHFriendDetailViewController* detailVC = [HSGHFriendDetailViewController new];
    detailVC.model = _dataArray[indexPath.row];
    detailVC.mode = FRIEND_CATE_THIRD;
    [self.delegate pushViewVC:detailVC WithType:FRIEND_CATE_THIRD];
}

- (void)setDataArray:(NSArray*)dataArray {
    _dataArray = dataArray;
    _failView.hidden = (_dataArray.count==0) ? NO : YES;
    [self.mainTableView reloadData];
}


#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    HSLog(@"_____%ld",buttonIndex);
    NSString * url = HSGHServerReceiveOtherFriendRemoveURL;
    
    if (buttonIndex==0) {
        [[AppDelegate instanceApplication] indicatorShow];
        [HSGHFriendViewModel fetchRemoveWithUrl:url Params:@{@"userId":self.currIgnoreUserid} :^(BOOL success) {
            [[AppDelegate instanceApplication] indicatorDismiss];
            if(success == YES){
                //删除好友成功
                HSLog(@"___删除成功__self.currIgnoreUserid=%@",self.currIgnoreUserid);
                
                [self dealwithIgnoreSuccess];
                
            }else{
                //删除好友失败
                [[[UIAlertView alloc] initWithTitle:@"" message:@"删除失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
        }];
    }
}

#pragma mark - dealwithIgnoreSuccess

- (void)dealwithIgnoreSuccess {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@" userId == %@ ",self.currIgnoreUserid];
    NSArray *preArr = [self.dataArray filteredArrayUsingPredicate:pred];
    //HSGHFriendSingleModel
    
    if (preArr.count > 0) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataArray];
        [mArr removeObject:[preArr lastObject]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [mArr copy];
            [self.mainTableView reloadData];
            
            NSDictionary * userDic = @{@"sign":@(5)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"msg_refreshData" object:nil userInfo:userDic];//通知控制器更新数据
        });
    }
    
    
}

@end

