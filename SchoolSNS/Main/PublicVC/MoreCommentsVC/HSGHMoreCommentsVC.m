//
//  HSGHAllCommentsViewController.m
//  SchoolSNS
//
//  Created by hemdenry on 2017/9/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMoreCommentsVC.h"
#import "YYText.h"
#import "HSGHCommentKeyboardView.h"
#import "HSGHCommentKeyboardModel.h"
#import "SchoolSNS-Swift.h"
#import "HSGHNetworkSession.h"
#import "HSGHAtViewController.h"
#import "HSGHMoreCommentsViewCell.h"
#import "HSGHMoreCommentsModel.h"
#import "HSGHHomeViewModel.h"

#define onceShowSecond (5)

@interface HSGHMoreCommentsVC ()<UITableViewDataSource, UITableViewDelegate , YYTextViewDelegate, HSGHMoreCommentsViewCellProtocol> {
 //   HSGHCommentKeyboardView *_keyBoardView;
    UIView *_keyboardBGView;
    NSIndexPath * _deleteIndexPath;
    
}

@property (nonatomic, strong) HSGHMoreCommentsModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HSGHCommentKeyboardView *keyBoardView;

/**
 用来记录每个一级回复展开多少条二级回复
 */
@property (nonatomic, strong) NSMutableArray <NSNumber *>*showRowsArray;

@end

@implementation HSGHMoreCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [HSGHMoreCommentsModel new];
    [self setupView];
    [self addKVO];
    [self setupRefresh];
    
    [self loadTableViewData];
    __weak typeof(self) weakSelf = self;
    _keyBoardView.atButtonClickBlock = ^{
        
        HSGHAtViewController* atViewController = [HSGHAtViewController new];
        atViewController.block = ^(BOOL isSuccess , HSGHFriendSingleModel* model) {
            if(isSuccess){
                if (![model.displayName isEqualToString:@""]) {
                    [weakSelf.keyBoardView updateATInfo:model.displayName userId:model.userId];
                }
            }else{
                weakSelf.keyBoardView.inputTextView.text = [NSString stringWithFormat:@"%@@",weakSelf.keyBoardView.inputTextView.text];
            }
        };
        //AT 数组
        atViewController.blockArr = ^(BOOL isAt,NSArray *modelArr) {
            HSLog(@"---AT---array---count=%zd",modelArr.count);
            [weakSelf.keyBoardView updateATInfo:modelArr];
        };
        
        [weakSelf.navigationController pushViewController:atViewController animated:YES];
    };
}

- (void)dealloc {
    HSLog(@"dealloc HSGHMoreCommentsVC");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)leftBarItemBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
    self.title = @"所有评论";
    
    UIView *contentView = self.view;
    contentView.backgroundColor = [UIColor whiteColor];
    _keyBoardView = [[NSBundle mainBundle] loadNibNamed:@"HSGHCommentKeyboardView" owner:nil options:nil].lastObject;
    _keyBoardView.frame = CGRectMake(0, contentView.height - 50, contentView.width, 50);
    _keyBoardView.inputTextView.delegate = self;
    [_keyBoardView setCommentMode:_userId name:_userName];
    
    __weak typeof(self) weakSelf = self;
    _keyBoardView.clickBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _keyBoardView.sendClick = ^{
        [weakSelf sendNewMessage];
    };
    
    [contentView addSubview:_keyBoardView];
    _keyBoardView.checkButton.enabled = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HSGH_NAVGATION_HEIGHT, contentView.width, contentView.height - _keyBoardView.height - HSGH_NAVGATION_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"HSGHMoreCommentsViewCell" bundle:nil] forCellReuseIdentifier:[HSGHMoreCommentsViewCell class].description];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:_tableView];
    
    [self setupKeyboardBgView];
    [contentView bringSubviewToFront:_keyBoardView];
    
}

/** 加载数据 */
- (void)loadTableViewData {
    [self.model requestAllComment:self.qqianId isRefreshAll:YES block:^(BOOL success, BOOL hasMore) {
        if (success) {
            [self.showRowsArray removeAllObjects];
            self.showRowsArray = [NSMutableArray array];
            for (int i = 0; i < self.model.dataArr.count; ++i) {
                [self.showRowsArray addObject:@(onceShowSecond)];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.model requestAllComment:weakSelf.qqianId isRefreshAll:YES block:^(BOOL success, BOOL hasMore) {
            [weakSelf endRefresh];
            if (success) {
                for (NSInteger i = self.showRowsArray.count; i < self.model.dataArr.count; ++i) {
                    [self.showRowsArray addObject:@(onceShowSecond)];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.keyBoardView setCommentMode:weakSelf.userId name:weakSelf.userName];
            }
        }];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.model requestAllComment:weakSelf.qqianId isRefreshAll:NO block:^(BOOL success, BOOL hasMore) {
            [weakSelf endRefresh];
            if (success) {
                for (NSInteger i = self.showRowsArray.count; i < self.model.dataArr.count; ++i) {
                    [self.showRowsArray addObject:@(onceShowSecond)];
                }
                [weakSelf.tableView reloadData];
            }
        }];
    }];
}

- (void)setupKeyboardBgView {
    _keyboardBGView = [[UIView alloc]initWithFrame:_tableView.bounds];
    _keyboardBGView.backgroundColor = HEXRGBACOLOR(0x000000, 0.4);
    [self.view addSubview:_keyboardBGView];
    _keyboardBGView.alpha = 0.0;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(restoreKeyboard)];
    [_keyboardBGView addGestureRecognizer:tap];
    UISwipeGestureRecognizer* swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(restoreKeyboard)];
    [_keyboardBGView addGestureRecognizer:swipeGes];
}


- (void)endRefresh {
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

#pragma mark-addKVO

- (void)addKVO {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)keyboardChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        _keyboardBGView.alpha = 0.4;
        CGFloat keyboardHeight = keyboardEndFrame.size.height;
        _keyBoardView.top = self.view.height - keyboardHeight - _keyBoardView.height;
    } else {
        _keyboardBGView.alpha = 0.0;
        _keyBoardView.top = self.view.height - _keyBoardView.height;
        
        if (_keyBoardView.inputTextView.text && _keyBoardView.inputTextView.text.length == 0) {
            [self clearKeyboardStatus];
        }
    }
    
    [UIView commitAnimations];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 400) {
        return NO;
    }
//    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
//        //按下回车
//        [self.keyBoardView.inputTextView resignFirstResponder];
//        return NO;
//    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.bounds.size.width, MAXFLOAT)].height);
    
    if (_keyBoardView.height != height + 9 && (height + 9) < 100 && (height + 9) > 50) {
        _keyBoardView.top -= height + 9 - _keyBoardView.height;
        _keyBoardView.height = height + 9;
    }
    [_keyBoardView.checkButton setEnabled:self.keyBoardView.inputTextView.text.length>0];
}
//发送消息
- (void)sendNewMessage {
    [self restoreKeyboard];
    NSString* content = [_keyBoardView fetchToServerContent];
    //去除首尾空格和换行
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    while ([content containsString:@"\n\n\n"]) {
        content = [content stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
    }
    if (content.length <= 0) {
        Toast *toast = [[Toast alloc] initWithText:@"无效文本，请重新输入" delay:0 duration:1.f];
        [toast show];
        return;
    }
    __weak typeof(self) weakSelf = self;
    if (_keyBoardView.isReplyMode) {//二级回复
        [[AppDelegate instanceApplication] indicatorShowWithFull];
        [self clearKeyboardStatus];
        [HSGHCommentKeyboardModel sendReply:_qqianId replyId:_currentReplyId content:content block:^(BOOL success) {
            [[AppDelegate instanceApplication] indicatorDismiss];
            if (success) {
                NSInteger section = _currentIndexPath.section;
                if (self.showRowsArray.count > section) {
                    NSNumber *num = self.showRowsArray[section];
                    [self.showRowsArray removeObjectAtIndex:section];
                    [self.showRowsArray insertObject:num atIndex:0];
                }
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            else {
                Toast* toast = [[Toast alloc]initWithText:@"发布失败，请稍后再试" delay:0 duration:1.f];
                [toast show];
            }
        }];
    }
    else {//一级回复
        [[AppDelegate instanceApplication] indicatorShowWithFull];
        [self clearKeyboardStatus];
        [HSGHCommentKeyboardModel sendComment:_qqianId content:content block:^(BOOL success) {
            [[AppDelegate instanceApplication] indicatorDismiss];
            if (success) {
                [self.showRowsArray insertObject:@(onceShowSecond) atIndex:0];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            else {
                Toast* toast = [[Toast alloc]initWithText:@"发布失败，请稍后再试" delay:0 duration:1.f];
                [toast show];
            }
        }];
    }
}

#pragma mark --- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HSGHMoreCommentsLayoutModel *model = self.model.dataArr[section];
    NSInteger count = self.showRowsArray[section].integerValue;
    return MIN(model.conversationArray.count, count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HSGHMoreCommentsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSGHMoreCommentsViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HSGHMoreCommentsViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HSGHMoreCommentsLayoutModel *data = self.model.dataArr[section];
    cell.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, data.layout.isExtended ? data.layout.extendedWholeHeight : data.layout.normalWholeHeight);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
    [cell updateInfo:data indexPath:indexPath needClickMore:data.layout.isShowMore refreshIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.block = ^(NSString * userId,NSIndexPath *indexPath){
        //改变 所有状态
        [weakSelf.model changeFriendStateWithFromUserId:userId indexPath:indexPath];
    };
    
    cell.delegate = self;
    [cell setToDetail:NO];
    cell.qqianId = self.qqianId;
    if ([data.cellReplay.fromUser.userId isEqualToString:[HSGHUserInf shareManager].userId]) { //isMine To delete
        UILongPressGestureRecognizer* longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClickToDelete:)];
        [cell addGestureRecognizer:longGes];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HSGHMoreCommentsLayoutModel* data = self.model.dataArr[section];
    return data.layout.normalWholeHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    HSGHMoreCommentsLayoutModel *model = self.model.dataArr[section];
    NSInteger count = self.showRowsArray[section].integerValue;
    NSInteger arrayCount = model.conversationArray.count;
    if (count >= arrayCount) {
        return 0.5;
    }else{
        return 25;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HSGHMoreCommentsLayoutModel *model = self.model.dataArr[section];
    NSInteger count = self.showRowsArray[section].integerValue;
    NSInteger arrayCount = model.conversationArray.count;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 0.5)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(26, 0, HSGH_SCREEN_WIDTH-26, 0.5)];
    [lineView addSubview:line];
    line.backgroundColor = HEXRGBCOLOR(0xE0E0E0);
    if (count >= arrayCount) {
        return lineView;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 25)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.left.equalTo(view);
            make.bottom.equalTo(view);
            make.height.equalTo(@0.5);
        }];
        UIButton *moreBtn = [UIButton new];
        [moreBtn setTitleColor:HEXRGBCOLOR(0x747474) forState:UIControlStateNormal];
        [moreBtn setTitle:@"展开更多" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view);
            make.centerY.equalTo(view);
            make.height.equalTo(view);
            make.width.equalTo(@100);
        }];
        moreBtn.tag = section;//用来识别第几行
        [moreBtn addTarget:self action:@selector(showMoreRows:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
}

- (void)showMoreRows:(UIButton *)btn {
    NSInteger section = btn.tag;
    NSInteger count = self.showRowsArray[section].integerValue;
    count += onceShowSecond;
    self.showRowsArray[section] = @(count);
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHMoreCommentsLayoutModel *model = self.model.dataArr[indexPath.section];
    HSGHMoreCommentsLayoutModel* data = model.conversationArray[indexPath.row];
    return data.layout.normalWholeHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHMoreCommentsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSGHMoreCommentsViewCell class].description forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HSGHMoreCommentsLayoutModel *model = self.model.dataArr[indexPath.section];
    HSGHMoreCommentsLayoutModel* data = model.conversationArray[indexPath.row];
    
    [cell updateInfo:data indexPath:indexPath needClickMore:data.layout.isShowMore refreshIndexPath:indexPath];
    //  [cell setExtended:data.layout.isExtended];
    __weak typeof(self) weakSelf = self;
    cell.block = ^(NSString * userId ,NSIndexPath *indexPath){
        //改变 所有状态
        [weakSelf.model changeFriendStateWithFromUserId:userId indexPath:indexPath];
    };
    
    cell.delegate = self;
    [cell setToDetail:YES];
    cell.qqianId = self.qqianId;
    if ([data.cellReplay.fromUser.userId isEqualToString:[HSGHUserInf shareManager].userId]) { //isMine To delete
        UILongPressGestureRecognizer* longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClickToDelete:)];
        [cell addGestureRecognizer:longGes];
    }
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark cellDelegate
//长按删除
- (void)longClickToDelete:(UILongPressGestureRecognizer *)sender {
    HSGHMoreCommentsViewCell *cell = (HSGHMoreCommentsViewCell *)sender.view;
    _deleteIndexPath = cell.indexPath;
    if (sender.state == UIGestureRecognizerStateBegan) {
        // end
        UIAlertView * alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"删除此条消息？"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:@"取消", nil];
        [alerView show];
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        HSGHMoreCommentsLayoutModel *data = self.model.dataArr[_deleteIndexPath.section];
        if (_deleteIndexPath.row < 0) {//点击的一级回复
        }else{//点击二级回复
            data = data.conversationArray[_deleteIndexPath.row];
        }
        
        [[AppDelegate instanceApplication] indicatorShow];
        [HSGHHomeViewModel fetchRemoveWithParams:@{@"replyId":data.cellReplay.replayId} :^(BOOL success) {
            [[AppDelegate instanceApplication] indicatorDismiss];
            if(success){
                if (_deleteIndexPath.row < 0) {
                    [self.showRowsArray removeObjectAtIndex:_deleteIndexPath.section];
                }
                [_tableView.mj_header beginRefreshing];
                
            }else{
                Toast * toset = [[Toast alloc]initWithText:@"删除评论失败" delay:0.1f duration:2];
                [toset show];
            }
        }];
    }
    
}

- (void)longClickToReport:(id)sender {
    
}

//点击整个cell
- (void)clickWholeButton:(NSIndexPath *)indexPath {
    HSGHMoreCommentsLayoutModel *layoutModel = self.model.dataArr[indexPath.section];
    _currentIndexPath = indexPath;
    if (indexPath.row < 0) {//点击的一级回复
    }else{//点击二级回复
        layoutModel = layoutModel.conversationArray[indexPath.row];
    }
    HSGHHomeReplay* data = layoutModel.cellReplay;
    if (![data.fromUser.userId isEqualToString:[HSGHUserInf shareManager].userId]) {
        _currentReplyId = data.replayId;
        [_keyBoardView setReplayMode:data.fromUser.userId name:data.fromUser.displayName];
        [_keyBoardView.inputTextView becomeFirstResponder];
    }
}
//取消点赞
//- (void)cancelUP:(NSIndexPath *)indexPath block:(void (^)(BOOL))block {
//    HSGHMoreCommentsLayoutModel *dataModel = self.model.dataArr[indexPath.section];
//    if (indexPath.row < 0) {//点击的一级回复
//    }else{//点击二级回复
//        dataModel = dataModel.conversationArray[indexPath.row];
//    }
//    HSGHHomeReplay *data = dataModel.cellReplay;
//    
//    data.up = false;
//    data.upCount = [NSNumber numberWithInt:data.upCount.intValue - 1];
//    [HSGHNetworkSession postReq:HSGHUpCancel
//                   appendParams:@{
//                                  @"qqianId" : _qqianId,
//                                  @"replyId" : data.replayId
//                                  }
//                    returnClass:nil
//                          block:^(id obj, NetResStatus status, NSString *errorDes) {
//                              if (status == 0) {
//                                  if (block) {
//                                      block(true);
//                                  }
//                                  
//                              } else {
//                                  if (block) {
//                                      block(false);
//                                  }
//                              }
//                          }];
//}

//点赞
- (void)clickUP:(NSIndexPath *)indexPath block:(void(^)(BOOL success))block {
    HSGHMoreCommentsLayoutModel *dataModel = self.model.dataArr[indexPath.section];
    if (indexPath.row < 0) {//点击的一级回复
    }else{//点击二级回复
        dataModel = dataModel.conversationArray[indexPath.row];
    }
    HSGHHomeReplay *data = dataModel.cellReplay;
    data.up = true;
    data.upCount = [NSNumber numberWithInt:data.upCount.intValue + 1];
    [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL appendParams:@{@"qqianId" : _qqianId,@"replyId" : data.replayId} returnClass:nil block:^(id obj, NetResStatus status, NSString *errorDes) {
        if (status == 0) {
            if (block) {
                block(true);
            }
        } else {
            if (block) {
            block(false);
            }
        }
    }];
}
//查看更多（弃用）
//- (void)clickExtended:(NSIndexPath *)indexPath {
//    HSGHMoreCommentsLayoutModel *dataModel = self.model.dataArr[indexPath.section];
//    if (indexPath.row < 0) {//点击的一级回复
//    }else{//点击二级回复
//        dataModel = dataModel.conversationArray[indexPath.row];
//    }
//    dataModel.layout.isExtended = !dataModel.layout.isExtended;
//    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}


#pragma mark - keyboard

- (void)restoreKeyboard {
    [self.view endEditing:true];
}

- (void)clearKeyboardStatus {
    _keyBoardView.inputTextView.text = @"";
    [_keyBoardView setCommentMode:_userId name:_userName];
    _keyBoardView.height = 50;
    _keyBoardView.top = self.view.height - 50;
    [_keyBoardView.checkButton setEnabled:self.keyBoardView.inputTextView.text.length>0];
}

#pragma mark - public actions
+ (void)show:(NSString*)qqianID userID:(NSString*)userId name:(NSString*)name block:(void (^)(BOOL isChanged, NSArray* array))blockk {
    HSGHMoreCommentsVC *vc = [HSGHMoreCommentsVC new];
    vc.qqianId = qqianID;
    vc.userId = userId;
    vc.userName = name;
    UINavigationController *nav = [AppDelegate instanceApplication].fetchCurrentNav;
    [nav pushViewController:vc animated:YES];
}

+ (void)showWithArray:(NSArray *)array {
    
}

@end
