//
//  HSGHMessageVC.m
//  SchoolSNS
//
//  Created by 陈位 on 2017/8/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMessageVC.h"
#import "PPBadgeView.h"
#import "HSGHMsgTableViewCell.h"
#import "HSGHMsgDetailViewController.h"
#import "AppDelegate.h"
#import "PPBadgeView.h"
#import "HSGHMsgDetailViewModel.h"

CGFloat itemWH = 25;
CGFloat space = 5;

@interface HSGHMessageVC () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _indexPage;
}

@property (nonatomic, strong) UIView *navView;
@property(nonatomic, strong) NSArray* dataArray;
@property(nonatomic, strong) NSArray* indexArray;
@property(nonatomic, strong) UIView *indexView;
@property(nonatomic, strong) NSArray* lastDataArray;
@property(nonatomic, strong) UILabel *navTitleLabel;

@property(nonatomic, strong) UIView * failView;//无数据时显示
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property(nonatomic, strong) NSMutableDictionary *msgDic;

@end

@implementation HSGHMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    if (!self.lastDataArray.count) {
        [self loadMsgViewData];
    }
    
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MsgHasReadedNotif:) name:@"MsgDetailVC_2_MsgVC" object:nil];
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshNotificationData:) name:@"msg_refreshData" object:nil];
    
    _failView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHMsgCommontFailView" owner:self options:nil]lastObject];
    _failView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    [self.tableView addSubview:_failView];
    _failView.hidden = YES;
    
    [self.view addSubview:self.indexView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigatView];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Notification

- (void)refleshNotificationData:(NSNotification *)notifi {
    __weak typeof(self) weakSelf = self;
    _indexPage = 0;
    [HSGHMessageModel fetchMessageViewModelArrWithType:0 Page: _indexPage:^(BOOL success, NSArray *array) {
        //[[AppDelegate instanceApplication] indicatorDismiss];
        if (success ) {
            [weakSelf prepareData:array];
            [weakSelf.tableView reloadData];
        } else {
            
        }
    }];
}

- (void)MsgHasReadedNotif:(NSNotification *)notifi {
    NSDictionary *dic = notifi.userInfo;
    if (dic.count) {
        NSString *messageId = dic[@"messageId"];
        NSMutableArray *array = [NSMutableArray array];
        for (HSGHSingleMsg *msg in _lastDataArray) {
            if (![msg.messageId isEqualToString:messageId]) {
                [array addObject:msg];
            }
        }
        _lastDataArray = array;
        [self dealwithMsgTip];
        [self dealwithData:_lastDataArray];
        [self.tableView reloadData];
        return;
    }
    __weak typeof(self) weakSelf = self;
    _indexPage = 0;
    [HSGHMessageModel fetchMessageViewModelArrWithType:0 Page: _indexPage:^(BOOL success, NSArray *array) {
        //[[AppDelegate instanceApplication] indicatorDismiss];
        if (success ) {
            [weakSelf prepareData:array];
        } else {
        }
    }];
    
    //    NSString *tmpMessageId = [notifi userInfo][@"messageId"];
    //    HSLog(@"----MsgHasReadedNotif----messageId=%@",tmpMessageId);
    //
    //    HSGHSingleMsg *msg = [[_lastDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"messageId==%@",tmpMessageId]] lastObject];
    //    NSMutableArray *marr = [NSMutableArray arrayWithArray:_lastDataArray];
    //    [marr removeObject:msg];
    //
    //    _lastDataArray = [marr copy];
    //
    //    [self dealwithMsgTip];
    //    [self dealwithData:_lastDataArray];
    //    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSGHMsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell"];
    HSGHSingleMsg* data = _dataArray[indexPath.section][indexPath.row];
    [cell updateInfo:data];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH-30, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    icon.image = [UIImage imageNamed:_indexArray[section]];
    [headerView addSubview:icon];
    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHSingleMsg* data = _dataArray[indexPath.section][indexPath.row];
    HSGHMsgDetailViewController* msgDetailVC;
    id array = self.msgDic[data.messageId];
    if ([array isKindOfClass:[NSArray class]] && [array count]) {
        msgDetailVC = [[HSGHMsgDetailViewController alloc] initWithDataArray:array];
    }else{
        msgDetailVC = [HSGHMsgDetailViewController new];
    }
    
    msgDetailVC.messageId = data.messageId;
    msgDetailVC.userId = data.user.userId;
    [self.navigationController pushViewController:msgDetailVC animated:YES];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return _indexView.subviews;
    return @[@"",@""];
}

- (NSArray *)removeIndexItem:(NSArray *)array WithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    [muArr removeObjectAtIndex:indexPath.row];
    return muArr;
}

#pragma mark - private method

- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, HSGH_SCREEN_WIDTH, 33)];
        
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _navTitleLabel.textColor = HEXRGBCOLOR(0x272727);
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.text = @"消息";
        _navTitleLabel.size = CGSizeMake(100, 33);
        _navTitleLabel.center = CGPointMake(HSGH_SCREEN_WIDTH/2, 16);
        [_navView addSubview:_navTitleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, HSGH_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
        [_navView addSubview:lineView];
    }
    return _navView;
}//

/** 自定义导航栏 */
- (void)setUpNavigatView {
    [self addLeftNavigationBarBtnWithString:@""];
    
    [self.view addSubview:self.navView];
}

/** tableView */
- (void)setUpTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 53, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT-53-44);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HSGHMsgTableViewCell"
            bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"msgCell"];
}

/** 加载消息页的数据 */
- (void)loadMsgViewData {//HSGHSingleMsg
    __weak typeof(self) weakSelf = self;
    
    [self.indicatorView startAnimating];
    _indexPage = 0;
    [HSGHMessageModel fetchMessageViewModelArrWithType:0 Page: _indexPage:^(BOOL success, NSArray *array) {
        [self.indicatorView stopAnimating];
        if (success ) {
            [weakSelf prepareData:array];
        } else {
        }
    }];
}


/** 处理消息数字提醒 */
- (void)dealwithMsgTip {
    HSLog(@"---messageVC---dealwithAddMeTip---");
    _failView.hidden = (_lastDataArray.count==0) ? NO : YES;
    
    if (_lastDataArray.count > 0) {
        _navTitleLabel.text = [NSString stringWithFormat:@"消息(%zd)",_lastDataArray.count];
    } else {
        _navTitleLabel.text = @"消息";
    }
    ViewController* tabVC = (ViewController*)self.tabBarController;
    if (_lastDataArray.count==0) {
        [tabVC.tabBar.items[3] pp_hiddenBadge];
    } else if (_lastDataArray.count < 99 ) {
        [tabVC.tabBar.items[3] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",_lastDataArray.count]];
    } else {
        [tabVC.tabBar.items[3] pp_addBadgeWithText:@"99+"];
    }
}


- (void)dealwithData:(NSArray *)array {
    //评论回复 3
    NSMutableArray *rstMarr = [NSMutableArray array];
    NSMutableArray *indexMarr = [NSMutableArray array];
    NSArray *commArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type==3"]];
    if (commArray.count>0) {
        [rstMarr addObject:commArray];
        [indexMarr addObject:@"msg_index_comm"];
    }
    
    //@ 1
    NSArray *ATArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type==1"]];
    if (ATArray.count>0) {
        [rstMarr addObject:ATArray];
        [indexMarr addObject:@"msg_index_at"];
    }
    
    //转发 4
    NSArray *forwardArr = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type==4"]];
    if (forwardArr.count>0) {
        [rstMarr addObject:forwardArr];
        [indexMarr addObject:@"msg_index_zhuanfa"];
    }
    
    //点赞 2
    NSArray *dianzArr = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type==2"]];
    if (dianzArr.count>0) {
        [rstMarr addObject:dianzArr];
        [indexMarr addObject:@"msg_index_dzan"];
    }
    
    _dataArray = [rstMarr copy];
    _indexArray = [indexMarr copy];
    
    for (UIView *view in _indexView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_indexArray.count > 0) {
        CGFloat viewH = itemWH*_indexArray.count + (_indexArray.count-1)*space;
        CGFloat tmpY = (HSGH_SCREEN_HEIGHT-viewH)*0.5;
        _indexView.frame = CGRectMake(HSGH_SCREEN_WIDTH-itemWH, tmpY, itemWH, viewH);
        
        for (int i=0;i<_indexArray.count;i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *imgName = [NSString stringWithFormat:@"%@_r",_indexArray[i]];
            NSString *selImgName = [NSString stringWithFormat:@"%@_r_select",_indexArray[i]];
            [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:selImgName] forState:UIControlStateSelected];
            button.frame = CGRectMake(0, (itemWH+5)*i, itemWH, itemWH);
            button.tag = 1010+i;
            [button addTarget:self action:@selector(indexViewButtonClick:) forControlEvents:UIControlEventTouchDown];
            [_indexView addSubview:button];
        }
        
        ((UIButton *)[_indexView viewWithTag:1010]).selected = YES;
    }
}

- (UIView *)indexView {
    if (!_indexView) {
        _indexView = [[UIView alloc] init];
        _indexView.frame = CGRectMake(HSGH_SCREEN_WIDTH-itemWH, 200, itemWH, 0);
        UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
        [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_indexView addGestureRecognizer:upRecognizer];
        
        UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
        [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_indexView addGestureRecognizer:downRecognizer];
    }
    return _indexView;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint point = [recognizer locationInView:_indexView];
            HSLog(@"Swipe down - Ended location: %f,%f", point.x, point.y);
        }
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint point = [recognizer locationInView:_indexView];
            HSLog(@"Swipe up - Ended location: %f,%f", point.x, point.y);
        }
        
//        CGPoint point = [recognizer locationInView:[self view]];
//        NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
    }
    
}

- (void)indexViewButtonClick:(UIButton *)btn {
    HSLog(@"-------indexViewButtonClick----%zd",btn.tag);
    for (int i=0;i<_indexArray.count; i++) {
        ((UIButton *)[_indexView viewWithTag:1010+i]).selected = NO;
    }
    btn.selected = YES;
    
    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:btn.tag-1010];
    [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self changeIndexViewSelectButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changeIndexViewSelectButton];
}

- (void)changeIndexViewSelectButton {
    UITableViewCell *cell = [[self.tableView visibleCells] firstObject];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HSLog(@"---scrollViewDidEndDecelerating---%zd",indexPath.section);
    
    if (_indexArray.count>0) {
        for (int i=0;i<_indexArray.count; i++) {
            if (i==indexPath.section) {
                ((UIButton *)[_indexView viewWithTag:1010+i]).selected = YES;
            } else {
                ((UIButton *)[_indexView viewWithTag:1010+i]).selected = NO;
            }
        }
    }
}

#pragma  mark - setter and getter

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(HSGH_SCREEN_WIDTH/2, HSGH_SCREEN_HEIGHT/2);
        [self.view addSubview:self.indicatorView];
    }
    return _indicatorView;
}

- (void)prepareData:(NSArray *)dataArr {
    _lastDataArray = dataArr;
    [self dealwithMsgTip];
    [self dealwithData:_lastDataArray];
    [self.tableView reloadData];
    [self.msgDic removeAllObjects];
    self.msgDic = [NSMutableDictionary dictionary];
    for (HSGHSingleMsg *model in dataArr) {
        [self.msgDic setObject:@"0" forKey:model.messageId];
    }
    
    for (NSString *key in self.msgDic.allKeys) {
        [HSGHMsgDetailViewModel fetchFriendDetailWithMsgID:key :^(BOOL success, NSArray *array) {
            if (success) {
                self.msgDic[key] = array;
            }
        }];
    }
}
@end
