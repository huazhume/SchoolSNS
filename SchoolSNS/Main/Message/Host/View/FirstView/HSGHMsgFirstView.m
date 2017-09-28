//
//  HSGHMsgFirstView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMsgFirstView.h"
#import "HSGHMsgTableViewCell.h"
#import "HSGHMsgDetailViewController.h"

@interface HSGHMsgFirstView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* dataArray;

@property(nonatomic, strong)  UIView * failView;//无数据时显示

@end

@implementation HSGHMsgFirstView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.mainTableView
                   registerNib:[UINib nibWithNibName:@"HSGHMsgTableViewCell"
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:@"msgCell"];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    _failView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHMsgCommontFailView" owner:self options:nil]lastObject];
    _failView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    [self.mainTableView addSubview:_failView];
    _failView.hidden = YES;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HSGHMsgTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell"];
    HSGHSingleMsg* data = _dataArray[indexPath.row];
    [cell updateInfo:data];
    cell.block = ^(NSInteger state) {
        if(state == 1000){
            _dataArray = [NSArray arrayWithArray:[self removeIndexItem:_dataArray WithIndexPath:indexPath]];
            [self.mainTableView reloadData];
            
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 70;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    HSGHMsgDetailViewController* msgDetailVC = [HSGHMsgDetailViewController new];
    HSGHSingleMsg* data = _dataArray[indexPath.row];
    msgDetailVC.messageId = data.messageId;
    msgDetailVC.userId = data.user.userId;
    [self.delegate pushViewVC:msgDetailVC];
}

- (void)setDataArray:(NSArray*)dataArray
{
    _dataArray = dataArray;
    _failView.hidden = (_dataArray.count==0) ? NO : YES;
    
    [self.mainTableView reloadData];
}
@end
