//
//  HSGHUpViewController.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHUpViewController.h"
#import "HSGHFriendFirstTableViewCell.h"
#import "HSGHHomeModel.h"
#import "HSGHUpViewModel.h"
#import "HSGHTools.h"
#import "HSGHFriendViewModel.h"
#import "HSGHUserInf.h"
#import "AppDelegate.h"
#import "HSGHScrollZoneVC.h"
#import "HSGHZoneVC.h"

@interface HSGHUpViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray* _upDataList;
    UILabel* label;
    NSInteger _pager;
}
@end

@implementation HSGHUpViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _upDataList = [NSArray new];

    self.title = @"点赞的人";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  HSGH_NAVGATION_HEIGHT, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT - 53) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HSGHFriendFirstTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"upcell"];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 40)];
    UIImageView* imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 24, 24)];
    imageV.image = [UIImage imageNamed:@"common_icon_dz_s"];
    [view addSubview:imageV];

    label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, HSGH_SCREEN_WIDTH - 40, 40)];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"%@人点赞", _qqianVo.upCount];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView setSeparatorColor:HEXRGBCOLOR(0xefefef)];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pager = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HSGHUpViewModel fetchUpViewModelArrWithPage:_pager
                                             WithQqianId:_qqianVo.
                                                 qqianId:^(BOOL success, NSArray* array) {
                                                     if (success && array.count > 0) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [weakSelf.tableView.mj_header endRefreshing];
                                                             _upDataList = [NSArray arrayWithArray:array];
                                                             [weakSelf.tableView reloadData];
                                                         });
                                                     }
                                                 }];
        });
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pager++;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HSGHUpViewModel fetchUpViewModelArrWithPage:_pager
                                             WithQqianId:_qqianVo.
                                                 qqianId:^(BOOL success, NSArray* array) {
                                                     if (success && array.count > 0) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [weakSelf.tableView.mj_header endRefreshing];
                                                             NSMutableArray* mu = [NSMutableArray arrayWithArray:_upDataList];
                                                             [mu addObjectsFromArray:array];
                                                             _upDataList = [NSArray arrayWithArray:mu];
                                                             [weakSelf.tableView reloadData];
                                                         });
                                                     }
                                                 }];

        });
    }];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _upDataList.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HSGHFriendFirstTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"upcell"];
    HSGHHomeUserInfo* up = _upDataList[indexPath.row];
    [cell setup:FRIEND_CATE_OTHER];
    cell.friendName.text = up.displayName;
    cell.friendUniversity.text = up.unvi.name;
    [cell.friendIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:up.picture.srcUrl]
                                            forState:UIControlStateNormal
                                    placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]

                                             options:SDWebImageAllowInvalidSSLCertificates
                                           completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                               if (image) {
                                                   cell.friendIconBtn.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                               }
                                           }];
    [cell.universityImage sd_setImageWithURL:[NSURL URLWithString:up.unvi.iconUrl] placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"] options:SDWebImageAllowInvalidSSLCertificates];
    cell.contentHeight.constant = [HSGHTools getWidthWidthString:cell.friendUniversity.text font:cell.friendUniversity.font width:HSGH_SCREEN_WIDTH - 96].height + 14;
    cell.passBtn.tag = indexPath.row;
    [cell.passBtn addTarget:self action:@selector(passBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [HSGHFriendViewModel fetchAddBtnStateWithCurrentUserId:up.userId WithOtherId:nil WithQQianMode:QQIAN_HOME FriendMode:0 WithMode:up.friendStatus WithBtn:cell.passBtn];
    
    [cell.friendIconBtn addTarget:self action:@selector(passBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.passBtn setImage:[UIImage imageNamed:[HSGHFriendViewModel getFriendStateImageWithMode:(HSGH_FRIEND_MODE)[up.friendStatus integerValue]]] forState:UIControlStateNormal];
    cell.passBtn.hidden = YES;
    cell.friendIconBtn.tag = indexPath.row;
    return cell;
}




- (IBAction)passBtnClicked:(id)sender
{
    UIButton* button = (UIButton*)sender;
     HSGHHomeUserInfo* up = _upDataList[button.tag];
    [HSGHZoneVC enterOtherZone:up.userId];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHHomeUserInfo* up = _upDataList[indexPath.row];
    [HSGHScrollZoneVC enterOtherZone:up.userId];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
