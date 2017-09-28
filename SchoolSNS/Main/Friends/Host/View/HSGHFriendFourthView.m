//
//  HSGHFriendFourthView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendFourthView.h"
#import "HSGHFriendFirstTableViewCell.h"
#import "HSGHFriendDetailViewController.h"
#import "HSGHFriendViewModel.h"
#import "HSGHTools.h"

@interface HSGHFriendFourthView () <UITableViewDelegate, UITableViewDataSource,
UIScrollViewDelegate>


@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, copy) NSArray* dataArray;

@end


@implementation HSGHFriendFourthView



- (void)awakeFromNib {
  [super awakeFromNib];
//  [self addSubview:self.mainTableView];
  self.mainTableView.delegate = self;
  self.mainTableView.dataSource = self;
    self.mainTableView.alwaysBounceHorizontal = NO;
    self.mainTableView.alwaysBounceVertical = YES;
  [self.mainTableView
   registerNib:[UINib
                nibWithNibName:@"HSGHFriendFirstTableViewCell"
                bundle:[NSBundle mainBundle]]
   forCellReuseIdentifier:@"firstCell"];
    self.mainTableView.tableFooterView = [[UIView alloc]init];
    self.mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HSGH_SCREEN_WIDTH, 0.01f)];
  
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HSGHFriendFirstTableViewCell *cell =
  [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
  [cell setup:FRIEND_CATE_OTHERDAO];
    
    HSGHFriendSingleModel* model = _dataArray[indexPath.row];
    if (model) {
        [cell updateInfo:model];
    }
    cell.block = ^(NSInteger state) {
        if(state == 1000){
            _dataArray = [NSArray arrayWithArray:[self removeIndexItem:_dataArray WithIndexPath:indexPath]];
            [self.mainTableView reloadData];
            
        }
    };
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSGHFriendDetailViewController * detailVC = [HSGHFriendDetailViewController new] ;
    
    detailVC.model = _dataArray[indexPath.row];
    detailVC.mode = FRIEND_CATE_FORTH;
    [self.delegate pushViewVC:detailVC WithType:FRIEND_CATE_FORTH];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.mainTableView reloadData];
}

@end

