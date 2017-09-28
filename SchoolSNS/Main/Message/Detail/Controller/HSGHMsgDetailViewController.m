//
//  HSGHFriendDetailViewController.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMsgDetailViewController.h"
#import "HSGHAtViewController.h"
#import "HSGHCommentKBView.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHDetailTableViewCell.h"
#import "HSGHFriendDetailViewModel.h"
#import "HSGHFriendViewModel.h"
#import "HSGHHomeBaseView.h"
#import "HSGHHomeViewModel.h"
#import "HSGHMessageModel.h"
#import "HSGHMoreCommentsVC.h"
#import "HSGHMoreToolsAlertView.h"
#import "HSGHMsgDetailViewModel.h"
#import "HSGHUpViewController.h"
#import "HSGHZoneVC.h"

@interface HSGHMsgDetailViewController () <
UITableViewDelegate, UITableViewDataSource, YYTextViewDelegate> {
}
@property(nonatomic, strong) __block NSArray <HSGHHomeQQianModelFrame *>*modelFrameArr;
@property(strong, nonatomic) HSGHCommentKBView *keywordView;
@property(assign, nonatomic) CGFloat keyboardHeight;
@property(strong, nonatomic) UIView *keyboardBgView;
@property(assign, nonatomic) BOOL isRead;
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HSGHMsgDetailViewController {
    BOOL isPrepareLoad;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    isPrepareLoad = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (HSGHDetailTableViewCell *cell in self.mainTableView.visibleCells) {
        [cell.ContentView.image jp_stopPlay];
    }
}

- (instancetype)initWithDataArray:(NSArray *)modelFrameArr {
    if (self = [super init]) {
    //    [self.indicatorView stopAnimating];
        [self setModelFrameArr:modelFrameArr];
        [self.mainTableView reloadData];
        self.keywordView.editMode = HOME_COMMENT_MODE;
        self.keywordView.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.keywordView.HomeMode = HOME_FIRST_MODE;
        if (self.modelFrameArr.count > 0) {
            self.keywordView.textView.placeholderText = [NSString stringWithFormat:@"评论%@的新鲜事",((HSGHHomeQQianModelFrame *)self.modelFrameArr[0]).model.creator.displayName];
        }
    }
    return self;
}

/**
 消息改为已读
 */
- (void)setReaded {
    __weak typeof(self) weakSelf = self;
    [HSGHMessageModel fetchIsReadWithMessageId:weakSelf.messageId :^(BOOL success) {
        if(success == YES){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgDetailVC_2_MsgVC" object:nil];
            _isRead = YES;
        }
    }];
}

- (void)setupModel {
    //获取消息详情
    __weak typeof(self) weakSelf = self;
    
    [self.indicatorView startAnimating];
    [HSGHMsgDetailViewModel fetchFriendDetailWithMsgID: _messageId:^(BOOL success, NSArray *array) {
        [self.indicatorView stopAnimating];
         if (success) {
             [weakSelf setModelFrameArr:array];
             [weakSelf.mainTableView reloadData];
             weakSelf.keywordView.editMode = HOME_COMMENT_MODE;
             weakSelf.keywordView.indexPath =
             [NSIndexPath indexPathForRow:0 inSection:0];
             weakSelf.keywordView.HomeMode = HOME_FIRST_MODE;
             if (weakSelf.modelFrameArr.count > 0) {
                 weakSelf.keywordView.textView
                 .placeholderText = [NSString
                                     stringWithFormat:@"评论%@的新鲜事",
                                     ((HSGHHomeQQianModelFrame *)
                                      weakSelf.modelFrameArr[0])
                                     .model.creator
                                     .displayName];
             }
             [weakSelf setReaded];
         }
     }];
    
}

- (void)setUI {
    [self.mainTableView
     registerNib:[UINib nibWithNibName:@"HSGHDetailTableViewCell"
                                bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"MainCell"];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    //    self.navigationBarView.frame = CGRectMake(0, -64,
    //    self.view.bounds.size.width, 64);
    //    [self setNavigationBarIsHidden:NO];
    self.title = @"消息";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self addNotificattionCenter];
    _keyboardBgView = [[UIView alloc] init];
    _keyboardBgView.frame = CGRectMake(0, 53, self.view.frame.size.width,
                                       self.view.frame.size.height - 53);
    _keyboardBgView.backgroundColor = [UIColor blackColor];
    _keyboardBgView.alpha = 0.4;
    [self.view addSubview:_keyboardBgView];
    [self addKeyBoardView];
    _keyboardBgView.hidden = YES;
    UITapGestureRecognizer *gesturer = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(keyboardViewTapClicked:)];
    [_keyboardBgView addGestureRecognizer:gesturer];
    _keyboardBgView.userInteractionEnabled = YES;
    
    if (!self.modelFrameArr) {//网络加载数据
        _modelFrameArr = [NSArray new];
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(HSGH_SCREEN_WIDTH/2, HSGH_SCREEN_HEIGHT/2);
        [self.view addSubview:self.indicatorView];
        [self setupModel];
    }else{//事先已经加载好了，直接显示
        [self setReaded];
        _isRead = YES;
        [self.mainTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgDetailVC_2_MsgVC" object:nil userInfo:@{@"messageId":self.messageId}];
    }
}

- (void)keyboardViewTapClicked:(UITapGestureRecognizer *)gesture {
    [self.keywordView.textView resignFirstResponder];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - init

- (void)addKeyBoardView {
    self.keywordView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHCommentKBView"
                                                  owner:nil
                                                options:nil] lastObject];
    self.keywordView.frame =
    CGRectMake(0, HSGH_SCREEN_HEIGHT - 50, HSGH_SCREEN_WIDTH, 50);
    __weak HSGHMsgDetailViewController *weakSelf = self;
    __weak HSGHCommentKBView *weakkey = self.keywordView;
    if (_modelFrameArr.count > 0) {
        [self keyBoardShow:[NSIndexPath indexPathForRow:0 inSection:0]
                  WithType:HOME_COMMENT_MODE
      WithCommentIndexPath:nil];
    }
    self.keywordView.block = ^(NSIndexPath *indexPath, NSInteger homeMode,
                           NSIndexPath *commentIndex, NSInteger editMode) {
        //处理发布
        //[[AppDelegate instanceApplication] indicatorShow];
        NSArray *datalist = [NSArray arrayWithArray:weakSelf.modelFrameArr];
        HSGHHomeQQianModel *qqiansVO = ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
        __block HOME_MODE _homeMode = (HOME_MODE)homeMode;
        __block EDIT_MODE _editMode = (EDIT_MODE)editMode;
        NSString *content = [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:weakkey.textView];
        while ([content containsString:@"\n\n\n"]) {
            content = [content stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
        }
        
        if (editMode == HOME_COMMENT_MODE) {
            if (content.length <= 0) {
                Toast *toast = [[Toast alloc] initWithText:@"无效文本，请重新输入" delay:0 duration:1.f];
                [toast show];
                return;
            }
            //一级评论
            [weakSelf qqianUpWithHomeType:HOME_FIRST_MODE andEditType:HOME_COMMENT_MODE andIndex:indexPath WithReplyId:@"-1"];
            [HSGHHomeViewModel fetchCommentWithParams:@{
                @"qqianId" : qqiansVO.qqianId,
                @"content" : content}
                :^(BOOL success ,NSString * replyId) {
                    [[AppDelegate instanceApplication] indicatorDismiss];
                    
                    if (success == YES) {
                        HSGHHomeQQianModel *model = weakSelf.modelFrameArr.firstObject.model;
                        for (NSInteger i = model.partReplay.count - 1; i >= 0; --i) {
                            HSGHHomeReplay *replay = model.partReplay[i];
                            if (replay.replayId.integerValue == -1) {
                                replay.replayId = replyId;
                                break;
                            }
                        }
                    } else {
                        HSLog(@"评论失败");
                    }
            }];
            weakSelf.keywordView.textView.text = @"";
            
        } else if (editMode == EDIT_FORWARD_MODE) {
            //转发
            [HSGHHomeViewModel fetchForwardWithParams:@{
                @"qqianId" : qqiansVO.qqianId,
                @"type" : @0,
                @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:weakkey.textView]}
                :^(BOOL success, NSString *replaId) {
                    [[AppDelegate instanceApplication] indicatorDismiss];
                    if (success == YES) {
                        [weakSelf qqianUpWithHomeType:_homeMode andEditType:_editMode andIndex:indexPath WithReplyId:replaId];
                    } else {
                        HSLog(@"转发失败");
                    }
                    weakSelf.keywordView.textView.text = @"";
            }];
            
        } else if (HOME_REPLAY_MODE == editMode) {
            if (content.length <= 0) {
                Toast *toast = [[Toast alloc] initWithText:@"无效文本，请重新输入" delay:0 duration:1.f];
                [toast show];
                return;
            }
            //二级评论
            HSGHHomeReplay *reply = weakSelf.modelFrameArr[indexPath.row].model.partReplay[commentIndex.row];
            [weakSelf qqianReplayWithHomeType:HOME_FIRST_MODE andEditType:HOME_REPLAY_MODE andIndex:indexPath andCommentIndex:commentIndex WithId:@"-1"];
            
            [HSGHHomeViewModel fetchCommentWithParams:@{
                @"replyId" : reply.replayId,
                @"content" : content}
                :^(BOOL success, NSString *replyId) {
                    [[AppDelegate instanceApplication] indicatorDismiss];
                    if (success == YES) {
                        HSGHHomeQQianModel *model = weakSelf.modelFrameArr.firstObject.model;
                        for (NSInteger i = model.partReplay.count - 1; i >= 0; --i) {
                            HSGHHomeReplay *replay = model.partReplay[i];
                            if (replay.replayId.integerValue == -1) {
                                replay.replayId = replyId;
                                break;
                            }
                        }
                    } else {
                        HSLog(@"评论失败");
                    }
            }];
            weakSelf.keywordView.textView.text = @"";
        }
        [weakkey.textView resignFirstResponder];
    };
    
    self.keywordView.atBlock = ^{
        HSGHAtViewController *atViewController = [HSGHAtViewController new];
        atViewController.blockArr = ^(BOOL isAt,NSArray *modelArr) {
            // Todo  must change when friends is ok.
            
            HSLog(@"---msgDetailVC---block---count=%zd",modelArr.count);
            
            for (int i=0; i<modelArr.count; i++) {
                HSGHFriendSingleModel* model = modelArr[i];
                [HSGHCommentsCallFriendViewModel addOneFriend:model.displayName userId:model.userId location:weakSelf.keywordView.textView.selectedRange.location yyTextView:weakSelf.keywordView.textView];
            }
            
            
//            if (isSuccess == YES) {
//                [HSGHCommentsCallFriendViewModel
//                 addOneFriend:model.displayName
//                 userId:model.userId
//                 location:weakkey.textView.selectedRange.location
//                 yyTextView:weakkey.textView];
//            } else {
//                weakkey.textView.text =
//                [NSString stringWithFormat:@"%@@", weakkey.textView.text];
//            }
            
            
        };
        [weakSelf.navigationController pushViewController:atViewController
                                                 animated:YES];
    };
    [self.view addSubview:self.keywordView];
    
    self.keywordView.textView.delegate = self;
    self.keywordView.publishBtn.enabled = NO;
    [self.keywordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelFrameArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    [cell setcellFrame:_modelFrameArr[indexPath.row]];
    cell.timeView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    cell.ContentView.block = ^() {
        //查看更多
        [weakSelf qqianMoreWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
    };
    cell.ContentView.upBlock = ^(int type) {
        //点赞
        if (type == 1000) {
            [self qqianUpWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
        } else if (type == 2000) {
            //取消点赞
            [self cancelQqianUpWithHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
        }
    };
    
    cell.HeaderView.block = ^(NSInteger type, NSString *key) {
        if (type == 1000) {
            //进入空间
            [HSGHZoneVC enterOtherZone:key];
        } else if (type == 2000) {
            //加好友
            //加好友
            [weakSelf qqianAddFrinedWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
        } else if (type == 3000) {
            //举报
            HSGHMoreToolsAlertView *view =
            [[[NSBundle mainBundle] loadNibNamed:@"HSGHMoreToolsAlertView"
                                           owner:self
                                         options:nil] lastObject];
            view.model =
            ((HSGHHomeQQianModelFrame *)_modelFrameArr[(NSUInteger)indexPath.row])
            .model;
            view.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
            view.block = ^(NSInteger type) {
                //                [self qqianRemoveHomeType:HOME_FIRST_MODE
                //                andIndexPath:indexPath];
            };
            [[AppDelegate instanceApplication].window.rootViewController.view
             addSubview:view];
            [view loadDataWithModel:((HSGHHomeQQianModelFrame *)
                                     _modelFrameArr[(NSUInteger)indexPath.row])
                       WithCellView:cell];
        }
    };
    cell.ToolView.block = ^(NSInteger tag) {
        if (tag == 3000) {
            //点赞
            [weakSelf qqianUpWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
        } else if (tag == 1000) {
            //评论
            //                    [self keyBoardShow:indexPath
            //                    WithType:HOME_COMMENT_MODE
            //                    WithCommentIndexPath:nil];
            //                    [self
            //                    adjustTableViewToFitKeyboardWithTableView:tableView
            //                    andIndexPath:indexPath
            //                    WithCommentHeight:[((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row])commentHeight]
            //                    + 20];
            if (_modelFrameArr.count > 0) {
                HSGHHomeQQianModel *model =
                ((HSGHHomeQQianModelFrame *)_modelFrameArr[indexPath.row]).model;
                [HSGHMoreCommentsVC show:model.qqianId
                                  userID:model.owner.userId
                                    name:model.owner.displayName
                                   block:^(BOOL isChanged, NSArray *array){
                                   }];
            }
        } else if (tag == 2000) {
            //转发
            //            [weakSelf keyBoardShow:indexPath WithType:EDIT_FORWARD_MODE
            //            WithCommentIndexPath:nil];
            //            [weakSelf
            //            adjustTableViewToFitKeyboardWithTableView:tableView
            //            andIndexPath:indexPath
            //            WithCommentHeight:[((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row])commentHeight]
            //            + 20];
            
            [self forwardWithQqianVO:((HSGHHomeQQianModelFrame *)_modelFrameArr[indexPath.row]).model];
            
        } else if (tag == 4000) {
            //进点赞列表
            //进点赞列表
            //            HSGHUpViewController* upVC = [HSGHUpViewController new];
            //            upVC.qqianVo =
            //            ((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row]).model;
            //            [weakSelf.navigationController pushViewController:upVC
            //            animated:YES];
            [self cancelQqianUpWithHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
        } else if (tag == 5000) {
            HSLog(@"删除");
        } else if (tag == 6000) {
            //进点赞列表
            HSGHUpViewController *upVC = [HSGHUpViewController new];
            upVC.qqianVo =
            ((HSGHHomeQQianModelFrame *)_modelFrameArr[(NSUInteger)indexPath.row])
            .model;
            [self.navigationController pushViewController:upVC animated:YES];
        }
    };
    
    cell.CommentView.block = ^{
        //        HSGHHomeQQianModel* model =
        //        ((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row]).model;
        //        [HSGHCommentsVC show:model.qqianId
        //                      userID:model.owner.userId
        //                        name:model.owner.displayName
        //                       block:^(BOOL isChanged, NSArray* array){
        //                       }];
    };
    
    cell.CommentView.upCommet = ^(NSInteger type, NSIndexPath *commentIndexpath) {
        if (type == 1000) {
            //点赞
            [self qqianUpWithIndexPath:indexPath
                  WIthCommentIndexPath:commentIndexpath
                              WithIsUp:YES];
        } else if (type == 2000) {
            //取消点赞
            [self qqianUpWithIndexPath:indexPath
                  WIthCommentIndexPath:commentIndexpath
                              WithIsUp:NO];
        } else if (type == 3000) {
            //删除评论
            [self qqianRemoveWithIndexPath:indexPath
                      WIthCommentIndexPath:commentIndexpath];
        }
    };
    
    cell.CommentView.commentBlock = ^(NSIndexPath *commentIndexPath) {
        HSLog(@"我要回复了");
        //        HSGHHomeReplay * reply = ((HSGHHomeQQianModelFrame
        //        *)_modelFrameArr[indexPath.row]).model.partReplay[commentIndexPath.row];
        
        [weakSelf keyBoardShow:indexPath
                      WithType:HOME_REPLAY_MODE
          WithCommentIndexPath:commentIndexPath];
        [weakSelf adjustTableViewToFitKeyboardWithTableView:tableView
                                               andIndexPath:indexPath
                                          WithCommentHeight:20];
    };
    /*
     FRIEND_NONE = 0,
     FRIEND_SELF = 1,
     FRIEND_TO = 3, // 你想
     FRIEND_FROM = 4, //对方向你发送了好友请求
     FRIEND_ALL = 2,
     FRIEND_UKNOW = 5,//通过这个给你发送过
     FRIEND_MODE_ONE = 11,
     FRIEND_MODE_TWO = 12,
     
     */
    
    cell.CommentView.addblock = ^(UIButton *btn, NSNumber *state,
                                  NSString *replayId, UILabel *lable,
                                  UIView *view, NSIndexPath *commentIndex) {
        [HSGHFriendViewModel
         fetchFriendShipWithMode:state
         WithBtn:btn
         WithUserID:_userId
         WithQqianId:nil
         WithReplayId:replayId
         WithCallBack:^(BOOL success, UIImage *image) {
             if (success) {
                 [btn setImage:image forState:UIControlStateNormal];
             } else {
                 [[[UIAlertView alloc]
                   initWithTitle:@""
                   message:
                   @"加好友失败，请稍后重试"
                   delegate:nil
                   cancelButtonTitle:@"确定"
                   otherButtonTitles:nil] show];
             }
         }
         WithAddLabel:lable];
        HSGH_FRIEND_MODE mode = (HSGH_FRIEND_MODE)[state integerValue];
        int friendMode = -1;
        if (mode == FRIEND_NONE) {
            friendMode = 3;
        } else if (mode == 5 || mode == 4) {
            friendMode = 2;
        }
        if (friendMode == -1) {
            //修改数据源
            [weakSelf
             qqianAddFriendWithIndexPath:indexPath
             WIthCommentIndexPath:commentIndex
             WithNUmber:[NSNumber numberWithInt:friendMode]];
        }
    };
    
    return cell;
}

- (void)qqianRemoveWithIndexPath:(NSIndexPath *)indexPath
            WIthCommentIndexPath:(NSIndexPath *)commetIndexpath {
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModel *qqiansVO =
    ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    NSMutableArray *mutableArr =
    [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    [mutableArr removeObjectAtIndex:commetIndexpath.row];
    qqiansVO.partReplay = [NSArray arrayWithArray:mutableArr];
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}

- (void)qqianUpWithIndexPath:(NSIndexPath *)indexPath
        WIthCommentIndexPath:(NSIndexPath *)commetIndexpath
                    WithIsUp:(BOOL)isUp {
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModel *qqiansVO =
    ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    NSMutableArray *mutableArr =
    [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    HSGHHomeReplay *replay = qqiansVO.partReplay[commetIndexpath.row];
    if (isUp) {
        replay.up = 1;
        replay.upCount =
        [NSNumber numberWithInteger:[replay.upCount integerValue] + 1];
    } else {
        replay.up = 0;
        replay.upCount =
        [NSNumber numberWithInteger:[replay.upCount integerValue] - 1];
    }
    [mutableArr replaceObjectAtIndex:commetIndexpath.row withObject:replay];
    qqiansVO.partReplay = [NSArray arrayWithArray:mutableArr];
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}

- (void)qqianAddFriendWithIndexPath:(NSIndexPath *)indexPath
               WIthCommentIndexPath:(NSIndexPath *)commetIndexpath
                         WithNUmber:(NSNumber *)friendNumber {
    
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModel *qqiansVO =
    ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    NSMutableArray *mutableArr =
    [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    HSGHHomeReplay *replay = qqiansVO.partReplay[commetIndexpath.row];
    replay.friendStatus = friendNumber;
    [mutableArr replaceObjectAtIndex:commetIndexpath.row withObject:replay];
    qqiansVO.partReplay = [NSArray arrayWithArray:mutableArr];
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
}

- (void)keyBoardShow:(NSIndexPath *)indexPath WithType:(EDIT_MODE)editMode
                            WithCommentIndexPath:(NSIndexPath *)commentIndexPath {
    if (isPrepareLoad) {
        [self.keywordView.textView becomeFirstResponder];
        self.keywordView.frame =
        CGRectMake(0, HSGH_SCREEN_HEIGHT - 50, HSGH_SCREEN_WIDTH, 50);
    }
    
    if (editMode == EDIT_FORWARD_MODE) {
        self.keywordView.editMode = EDIT_FORWARD_MODE;
        self.keywordView.indexPath = indexPath;
        self.keywordView.commentIndex = nil;
        self.keywordView.HomeMode = HOME_FIRST_MODE;
    } else if (editMode == HOME_COMMENT_MODE) {
        self.keywordView.editMode = HOME_COMMENT_MODE;
        self.keywordView.indexPath = indexPath;
        self.keywordView.HomeMode = HOME_FIRST_MODE;
    } else if (editMode == HOME_REPLAY_MODE) {
        self.keywordView.editMode = HOME_REPLAY_MODE;
        self.keywordView.indexPath = indexPath;
        self.keywordView.HomeMode = HOME_FIRST_MODE;
        self.keywordView.commentIndex = commentIndexPath;
    }
    if (editMode == HOME_REPLAY_MODE) {
        //回复
        self.keywordView.textView.placeholderText =
        [NSString stringWithFormat:@"回复%@",
         ((HSGHHomeQQianModelFrame *)
          _modelFrameArr[indexPath.row])
         .model.partReplay[commentIndexPath.row]
         .fromUser.displayName];
        
    } else if (editMode == EDIT_FORWARD_MODE) {
        //转发
        NSString *userName =
        ((HSGHHomeQQianModelFrame *)_modelFrameArr[indexPath.row])
        .model.creator.displayName;
        if ([userName isEqualToString:@""] || userName == nil) {
            self.keywordView.textView.placeholderText =
            [NSString stringWithFormat:@"转发此条匿名新鲜事"];
        } else {
            self.keywordView.textView.placeholderText =
            [NSString stringWithFormat:@"转发%@的新鲜事",
             ((HSGHHomeQQianModelFrame *)
              _modelFrameArr[indexPath.row])
             .model.creator.displayName];
        }
        //计算tableView 中comment的高度
    } else if (editMode == HOME_COMMENT_MODE) {
        //评论
        self.keywordView.textView.placeholderText =
        [NSString stringWithFormat:@"评论%@的新鲜事",
         ((HSGHHomeQQianModelFrame *)
          _modelFrameArr[indexPath.row])
         .model.creator.displayName];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_modelFrameArr[indexPath.row] cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 50)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// 查看更多
- (void)qqianMoreWithHomeType:(HOME_MODE)mode
                     andIndex:(NSIndexPath *)indexPath {
    HSGHHomeQQianModelFrame *Frame =
    (HSGHHomeQQianModelFrame *)_modelFrameArr[indexPath.row];
    HSGHHomeQQianModel *qqiansVO = Frame.model;
    qqiansVO.contentIsMore = @(![qqiansVO.contentIsMore integerValue]);
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_modelFrameArr];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}
// 点赞
- (void)qqianUpWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath *)indexPath {
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModel *qqiansVO =
    ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    qqiansVO.upCount =
    [NSNumber numberWithInteger:[qqiansVO.upCount integerValue] + 1];
    qqiansVO.up = @1;
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:qqiansVO.partUp];
    //点赞成功 修改model
    HSGHHomeUp *modelup = [HSGHHomeUp new];
    HSGHHomeImage *image = [HSGHHomeImage new];
    image.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    modelup.picture = image;
    modelup.unvi.name = [HSGHUserInf shareManager].bachelorUniv.name;
    modelup.fullName =
    [NSString stringWithFormat:@"%@%@", [HSGHUserInf shareManager].firstName,
     [HSGHUserInf shareManager].lastName];
    modelup.userId = [HSGHUserInf shareManager].userId;
    [mutableArr insertObject:modelup atIndex:0];
    qqiansVO.partUp = [NSArray arrayWithArray:mutableArr];
    HSGHHomeQQianModelFrame *frame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [frame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:frame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}

// 二级回复
- (void)qqianReplayWithHomeType:(HOME_MODE)mode
                    andEditType:(EDIT_MODE)editMode
                       andIndex:(NSIndexPath *)indexPath
                andCommentIndex:(NSIndexPath *)commentIndex
                         WithId:(NSString *)replayId {
    
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModel *qqiansVO =
    ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    HSGHHomeReplay *replay = [HSGHHomeReplay new];
    HSGHHomeUserInfo *from = [HSGHHomeUserInfo new];
    HSGHHomeImage *creatorPicture = [HSGHHomeImage new];
    creatorPicture.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    HSGHHomeUniversity *uni = [HSGHHomeUniversity new];
    if ([HSGHUserInf shareManager].masterUniv.name != nil &&
        ![[HSGHUserInf shareManager].masterUniv.name isEqualToString:@""]) {
        uni.iconUrl = [HSGHUserInf shareManager].masterUniv.iconUrl;
        uni.name = [HSGHUserInf shareManager].masterUniv.name;
    } else if (![[HSGHUserInf shareManager].bachelorUniv.name
                 isEqualToString:@""] &&
               [HSGHUserInf shareManager].bachelorUniv.name != nil) {
        uni.iconUrl = [HSGHUserInf shareManager].bachelorUniv.iconUrl;
        uni.name = [HSGHUserInf shareManager].bachelorUniv.name;
        
    } else {
        uni.iconUrl = [HSGHUserInf shareManager].highSchool.iconUrl;
        uni.name = [HSGHUserInf shareManager].highSchool.name;
    }
    from.picture = creatorPicture;
    from.unvi = uni;
    from.displayName = [HSGHUserInf shareManager].nickName;
    from.userId = [HSGHUserInf shareManager].userId;
    from.friendStatus = @1;
    HSGHHomeUserInfo *to = qqiansVO.partReplay[commentIndex.row].fromUser;
    replay.toUser = to;
    replay.fromUser = from;
    replay.content = self.keywordView.textView.text;
    replay.replayId = replayId;
    qqiansVO.replyCount = @([qqiansVO.replyCount integerValue] + 1);
    
    NSMutableArray *replayArr =
    [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    //  [replayArr insertObject:replay atIndex:commentIndex.row];
    if (replayArr.count > commentIndex.row) {
        [replayArr insertObject:replay atIndex:commentIndex.row + 1];
    } else {
        [replayArr addObject:replay];
    }
    qqiansVO.partReplay = [NSArray arrayWithArray:replayArr];
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}

// 一级评论 转发
- (void)qqianUpWithHomeType:(HOME_MODE)mode
                andEditType:(EDIT_MODE)editMode
                   andIndex:(NSIndexPath *)indexPath
                WithReplyId:(NSString *)replyId {
    
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModelFrame *originFrame = datalist[indexPath.row];
    
    HSGHHomeQQianModel *qqiansVO = ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    HSGHHomeReplay *replay = [HSGHHomeReplay new];
    replay.replayId = replyId;
    HSGHHomeUserInfo *from = [HSGHHomeUserInfo new];
    HSGHHomeImage *creatorPicture = [HSGHHomeImage new];
    from.userId = [HSGHUserInf shareManager].userId;
    from.friendStatus = @1;
    creatorPicture.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    HSGHHomeUniversity *uni = [HSGHHomeUniversity new];
    
    if ([HSGHUserInf shareManager].bachelorUniv.city != 1 &&
        (![[HSGHUserInf shareManager].bachelorUniv.name isEqualToString:@""] && [HSGHUserInf shareManager].bachelorUniv.name != nil)) {
            uni.iconUrl = [HSGHUserInf shareManager].bachelorUniv.iconUrl;
            uni.name = [HSGHUserInf shareManager].bachelorUniv.name;
        } else if (([HSGHUserInf shareManager].masterUniv.name != nil && ![[HSGHUserInf shareManager].masterUniv.name isEqualToString:@""]) && [HSGHUserInf shareManager].bachelorUniv.city != 1) {
            //研究生
            uni.iconUrl = [HSGHUserInf shareManager].masterUniv.iconUrl;
            uni.name = [HSGHUserInf shareManager].masterUniv.name;
        } else if ([HSGHUserInf shareManager].highSchool.name != nil && ![[HSGHUserInf shareManager].highSchool.name isEqualToString:@""]) {
            uni.iconUrl = [HSGHUserInf shareManager].highSchool.iconUrl;
            uni.name = [HSGHUserInf shareManager].highSchool.name;
        }
    
    from.picture = creatorPicture;
    from.unvi = uni;
    from.displayName = [HSGHUserInf shareManager].nickName;
    from.userId = [HSGHUserInf shareManager].userId;
    replay.fromUser = from;
    //replay.content = self.keywordView.textView.text;
    replay.content = [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:self.keywordView.textView];
    if (editMode == HOME_COMMENT_MODE) {
        //评论
        qqiansVO.replyCount = @([qqiansVO.replyCount integerValue] + 1);
        
    } else if (editMode == EDIT_FORWARD_MODE) {
        qqiansVO.forwardCount = @([qqiansVO.forwardCount integerValue] + 1);
    }
    NSMutableArray *replayArr = [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    [replayArr insertObject:replay atIndex:0];
    
    qqiansVO.partReplay = [NSArray arrayWithArray:replayArr];
    HSGHHomeQQianModelFrame *voFrame = [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadData];
  //  [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
}
//取消点赞
- (void)cancelQqianUpWithHomeType:(HOME_MODE)mode
                     andIndexPath:(NSIndexPath *)indexPath {
    NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];
    HSGHHomeQQianModelFrame *modelF = datalist[indexPath.row];
    HSGHHomeQQianModel *model = modelF.model;
    model.up = @(0);
    model.upCount =
    [NSNumber numberWithUnsignedInteger:[model.upCount integerValue] - 1];
    //便利数组
    NSMutableArray *upModelArr = [NSMutableArray arrayWithArray:model.partUp];
    __block NSUInteger index = 999999;
    
    [model.partUp
     enumerateObjectsUsingBlock:^(HSGHHomeUp *_Nonnull obj, NSUInteger idx,
                                  BOOL *_Nonnull stop) {
         if ([[HSGHUserInf shareManager].userId isEqualToString:obj.userId]) {
             index = idx;
         }
     }];
    if (index != 999999) {
        [upModelArr removeObjectAtIndex:index];
    }
    model.partUp = [NSArray arrayWithArray:upModelArr];
    
    HSGHHomeQQianModelFrame *modelF2 =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [modelF2 setModel:model];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:modelF2];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}
- (void)qqianAddFrinedWithHomeType:(HOME_MODE)mode
                          andIndex:(NSIndexPath *)indexPath {
    NSArray *datalist = _modelFrameArr;
    
    HSGHHomeQQianModelFrame *Frame =
    (HSGHHomeQQianModelFrame *)datalist[indexPath.row];
    HSGHHomeQQianModel *qqiansVO = Frame.model;
    NSString *imageFileName = @"";
    switch ((HSGH_FRIEND_MODE)[qqiansVO.friendStatus integerValue]) {
        case FRIEND_NONE:
            imageFileName = FRIEND_TO_IMAGE;
            qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_TO];
            break;
        case FRIEND_TO:
            break;
        case FRIEND_FROM:
            imageFileName = FRIEND_ALL_IMAGE;
            qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_ALL];
            break;
        case FRIEND_ALL:
            break;
        case FRIEND_UKNOW:
            imageFileName = FRIEND_ALL_IMAGE;
            qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_ALL];
            break;
            
        default:
            break;
    }
    
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_MSG];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
}

- (void)adjustTableViewToFitKeyboardWithTableView:(UITableView *)tableView
                                     andIndexPath:(NSIndexPath *)indexPath
                                WithCommentHeight:(CGFloat)commentHeight {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    rect.origin.y = rect.origin.y - commentHeight + 64;
    [self adjustTableViewToFitKeyboardWithRect:rect WithTableView:tableView];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
                               WithTableView:(UITableView *)tableView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta =
    CGRectGetMaxY(rect) - (window.bounds.size.height - _keyboardHeight);
    
    CGPoint offset = tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [tableView setContentOffset:offset animated:YES];
}

#pragma mark - textVIew delegate

- (void)addNotificattionCenter {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillShowNotification
     object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillHideNotification
     object:nil];
}
//监听键盘 高度变化
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
        _keyboardBgView.hidden = NO;
        _keyboardHeight = keyboardEndFrame.size.height;
        [self textViewDidChange:self.keywordView.textView];
    } else {
        if (self.keywordView.textView.text == nil ||
            [self.keywordView.textView.text isEqualToString:@""]) {
            self.keywordView.editMode = HOME_COMMENT_MODE;
            self.keywordView.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            self.keywordView.HomeMode = HOME_FIRST_MODE;
            if (_modelFrameArr.count > 0) {
                self.keywordView.textView.placeholderText = [NSString
                                                         stringWithFormat:@"评论%@的新鲜事",
                                                         ((HSGHHomeQQianModelFrame *)_modelFrameArr[0])
                                                         .model.creator.displayName];
            }
        }
        //        self.keywordView.frame = CGRectMake(0, HSGH_SCREEN_HEIGHT- 45,
        //        HSGH_SCREEN_WIDTH,
        //                                45);
        _keyboardHeight = 0;
        [self textViewDidChange:self.keywordView.textView];
        _keyboardBgView.hidden = YES;
    }
    [UIView commitAnimations];
}

- (void)textViewDidChange:(YYTextView *)textView {
    
    CGSize contentSize = [self.keywordView.textView.text
                          sizeWithFont:[UIFont systemFontOfSize:14]
                          constrainedToSize:CGSizeMake(HSGH_SCREEN_WIDTH - 24, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    [self.keywordView.publishBtn setEnabled:self.keywordView.textView.text.length>0];
    if (contentSize.height > 35) {
        if (contentSize.height >= 60) {
            contentSize.height = 60;
        }
        [self.keywordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentSize.height+15);
            make.bottom.equalTo(self.view).offset(-_keyboardHeight);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    } else {
        [self.keywordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.bottom.equalTo(self.view).offset(-_keyboardHeight);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    }
}
- (BOOL)textView:(YYTextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
//        //按下回车
//       // self.keywordView.block(self.keywordView.indexPath, self.keywordView.HomeMode,self.keywordView.commentIndex, self.keywordView.editMode);
//        [self.keywordView.textView resignFirstResponder];
//        return NO;
//    }
    
//    if ([text isEqualToString:@"@"]) {
//        HSGHAtViewController *atViewController = [HSGHAtViewController new];
//        atViewController.block = ^(BOOL isSuccess, HSGHFriendSingleModel *model) {
//            // Todo  must change when friends is ok.
//            if (isSuccess == YES) {
//                [HSGHCommentsCallFriendViewModel
//                 addOneFriend:model.displayName
//                 userId:model.userId
//                 location:self.keywordView.textView.selectedRange.location
//                 yyTextView:self.keywordView.textView];
//            } else {
//                self.keywordView.textView.text =
//                [NSString stringWithFormat:@"%@@", self.keywordView.textView.text];
//            }
//        };
//        [self.navigationController pushViewController:atViewController
//                                             animated:YES];
//        return NO;
//    }
    return YES;
}

- (void)leftBarItemBtnClicked:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    //    if(_popCallBackBlock){
    //        _popCallBackBlock();
    //    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)forwardWithQqianVO:(HSGHHomeQQianModel *)qqiansVO {
    //转发
    [HSGHHomeViewModel fetchForwardWithParams:@{
                                                @"qqianId" : qqiansVO.qqianId,
                                                @"type" : @0,
                                                @"content" : @""
                                                }:^(BOOL success, NSString *replayId) {
                                                    [[AppDelegate instanceApplication] indicatorDismiss];
                                                    if (success == YES) {
                                                        Toast *toast =
                                                        [[Toast alloc] initWithText:@"转发成功!" delay:0 duration:1.f];
                                                        [toast show];
                                                        
                                                    } else {
                                                        //                    [[[UIAlertView alloc]initWithTitle:@""
                                                        //                    message:@"转发失败" delegate:nil
                                                        //                    cancelButtonTitle:@"确定" otherButtonTitles:
                                                        //                    nil]show];
                                                        HSLog(@"转发失败");
                                                        Toast *toast = [[Toast alloc]
                                                                        initWithText:@"出了一点小问题，请稍后再试!"
                                                                        delay:0
                                                                        duration:1.f];
                                                        [toast show];
                                                    }
                                                    
                                                }];
}

@end
