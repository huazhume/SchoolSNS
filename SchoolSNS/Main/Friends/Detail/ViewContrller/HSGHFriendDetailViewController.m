//
//  HSGHFriendDetailViewController.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendDetailViewController.h"
#import "HSGHFriendDetailViewModel.h"

#import "HSGHAtViewController.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHDetailTableViewCell.h"
#import "HSGHHomeBaseView.h"
#import "HSGHHomeViewModel.h"
#import "HSGHMoreCommentsVC.h"
#import "HSGHMoreToolsAlertView.h"
#import "HSGHUpViewController.h"
#import "HSGHZoneVC.h"
#import "UITableView+VideoPlay.h"

@interface HSGHFriendDetailViewController () <
    UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
}
@property(nonatomic, strong) NSArray *modelFrameArr;
@property(strong, nonatomic) HSGHKeyBoardView *keywordView;

@end

@implementation HSGHFriendDetailViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tabBarController.tabBar.hidden = YES;
  [self setupModel];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendDetailVC_2_FriendVC" object:nil];

}

- (void)setupModel {
  //获取新鲜事儿
  __weak typeof(self) weakSelf = self;
  if (![_model.userId isEqualToString:@""] && _model.userId != nil) {
    [[AppDelegate instanceApplication] indicatorShow];
    [HSGHFriendDetailViewModel fetchFriendDetailWithUserID:_model.userId WithMode:self.mode :^(BOOL success, NSArray* array) {
                [[AppDelegate instanceApplication]indicatorDismiss];
                if (success && array.count > 0) {
                    [weakSelf setModelFrameArr:array];
                    [weakSelf.mainTableView reloadData];
                }
            }];
  }
  //    [HSGHFriendDetailViewModel fetchFistViewModelArr:^(BOOL success,
  //    NSArray* array) {
  //        if (success && array.count > 0) {
  //            [weakSelf setModelFrameArr:array];
  //            [weakSelf.mainTableView reloadData];
  //        }
  //
  //    }];
}

- (void)setUI {
  [self.mainTableView registerNib:[UINib nibWithNibName:@"HSGHDetailTableViewCell" bundle:[NSBundle mainBundle]]
      forCellReuseIdentifier:@"MainCell"];
  self.mainTableView.delegate = self;
  self.mainTableView.dataSource = self;
  //    self.navigationBarView.frame = CGRectMake(0, -64,
  //    self.view.bounds.size.width, 64);
  //    [self setNavigationBarIsHidden:NO];
  if (_mode == FRIEND_CATE_FRIST) {
    self.title = @"新鲜事";
  } else if (_mode == FRIEND_CATE_SECOND) {
    self.title = @"好友";
  } else if (_mode == FRIEND_CATE_THIRD) {
    self.title = @"加我";
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _modelFrameArr = [NSArray new];
  [self setUI];
}

#pragma mark - init

- (void)addKeyBoardView {
  _keywordView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHKeyBoardView"
                                                owner:self
                                              options:nil] lastObject];
  _keywordView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
  __weak HSGHFriendDetailViewController *weakSelf = self;
  __weak HSGHKeyBoardView *weakkey = _keywordView;
  _keywordView.block = ^(NSIndexPath *indexPath, NSInteger homeMode,
                         NSIndexPath *commentIndex, NSInteger editMode) {
    //处理发布
    [[AppDelegate instanceApplication] indicatorShow];
    NSArray *datalist = [NSArray arrayWithArray:weakSelf.modelFrameArr];
    HSGHHomeQQianModel *qqiansVO =
        ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    __block HOME_MODE _homeMode = (HOME_MODE)homeMode;
    __block EDIT_MODE _editMode = (EDIT_MODE)editMode;
    if (editMode == HOME_COMMENT_MODE) {
      //评论
      [HSGHHomeViewModel fetchCommentWithParams:@{
        @"qqianId" : qqiansVO.qqianId,
        @"content" : weakkey.textView.text
      }:^(BOOL success, NSString *replyId) {
        [[AppDelegate instanceApplication] indicatorDismiss];
        if (success == YES) {
          [weakSelf qqianUpWithHomeType:_homeMode
                            andEditType:_editMode
                               andIndex:indexPath
                            WithRelayId:replyId];

        } else {
          HSLog(@"评论失败");
        }
        weakSelf.keywordView.textView.text = @"";

      }];

    } else if (editMode == EDIT_FORWARD_MODE) {
      //转发
      //      [HSGHHomeViewModel fetchForwardWithParams:@{
      //        @"qqianId" : qqiansVO.qqianId,
      //        @"type" : @0,
      //        @"content" : [HSGHCommentsCallFriendViewModel
      //            convertToMatchedTextBindings:weakkey.textView]
      //      }:^(BOOL success, NSString *replyId) {
      //        [[AppDelegate instanceApplication] indicatorDismiss];
      //        if (success == YES) {
      [weakSelf qqianUpWithHomeType:_homeMode
                        andEditType:_editMode
                           andIndex:indexPath
                        WithRelayId:@"replayid"];

      //        } else {
      //          NSLog(@"转发失败");
      //        }
      weakSelf.keywordView.textView.text = @"";

      //      }];

    } else if (HOME_REPLAY_MODE == editMode) {
    }
    [weakSelf.keywordView removeFromSuperview];
  };
  _keywordView.atBlock = ^{

    HSGHAtViewController *atViewController = [HSGHAtViewController new];
    atViewController.block = ^(BOOL isSuccess, HSGHFriendSingleModel *model) {
      // Todo  must change when friends is ok.

      if (isSuccess == YES) {
        [HSGHCommentsCallFriendViewModel
            addOneFriend:model.displayName
                  userId:model.userId
                location:weakkey.textView.selectedRange.location
              yyTextView:weakkey.textView];
      } else {
        weakkey.textView.text =
            [NSString stringWithFormat:@"%@@", weakkey.textView.text];
      }
    };
    [weakSelf.navigationController pushViewController:atViewController
                                             animated:YES];
  };
  [self.view addSubview:_keywordView];
  [_keywordView startInputText];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _modelFrameArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HSGHDetailTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
  [cell setcellFrame:_modelFrameArr[indexPath.row] WithSingleModel:_model];
  if (_mode == FRIEND_CATE_SECOND) {
    if (indexPath.row == 1) { //第二条
      cell.timeView.friendAllImageWidth.constant = 0;
      cell.timeView.timeFriendAllBtn.hidden = YES;
      cell.timeView.timeLab.text = @"被忽略的请求";
      cell.timeView.width.constant =
          [HSGHTools widthOfLab:cell.timeView.timeLab] + 12;
    } else if (indexPath.row > 1) {
      cell.timeHeight = 0;
      cell.timeView.hidden = YES;
    }
  }
  //    HSGHHomeQQianModelFrame * modelF = _modelFrameArr[indexPath.row];
  cell.ContentView.block = ^() {
    //查看更多
    [self qqianMoreWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
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
      [self qqianAddFrinedWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
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
        [self qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
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
      [self qqianUpWithHomeType:HOME_FIRST_MODE andIndex:indexPath];
    } else if (tag == 1000) {
      //评论
      //            HSGHHomeQQianModelFrame * f =
      //            ((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row]);
      //
      //            [self keyBoardShow:indexPath WithType:HOME_COMMENT_MODE
      //            WithCommentIndexPath:nil];
      //            [self adjustTableViewToFitKeyboardWithTableView:tableView
      //            andIndexPath:indexPath WithCommentHeight:f.commentHeight];
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
      //            [self keyBoardShow:indexPath WithType:EDIT_FORWARD_MODE
      //            WithCommentIndexPath:nil];
      //            [self adjustTableViewToFitKeyboardWithTableView:tableView
      //            andIndexPath:indexPath
      //            WithCommentHeight:[((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row])commentHeight]
      //            + 20];
      [self forwardWithQqianVO:((HSGHHomeQQianModelFrame *)
                                    _modelFrameArr[indexPath.row])
                                   .model];

    } else if (tag == 4000) {
      //进点赞列表
      //            HSGHUpViewController* upVC = [HSGHUpViewController new];
      //            upVC.qqianVo =
      //            ((HSGHHomeQQianModelFrame*)_modelFrameArr[indexPath.row]).model;
      //            [self.navigationController pushViewController:upVC
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

  };
  cell.CommentView.addblock = ^(UIButton *btn, NSNumber *state,
                                NSString *replayId, UILabel *lable,
                                UIView *view, NSIndexPath *commentIndex) {
    [[AppDelegate instanceApplication] indicatorShow];
    [HSGHFriendViewModel
        fetchFriendShipWithMode:state
                        WithBtn:btn
                     WithUserID:_model.userId
                    WithQqianId:nil
                   WithReplayId:replayId
                   WithCallBack:^(BOOL success, UIImage *image) {
                     if (success) {
                       if (view != nil) {
                         view.hidden = YES;
                       }
                       btn.hidden = NO;
                       btn.userInteractionEnabled = NO;
                       [btn setImage:image forState:UIControlStateNormal];
                       if (view != nil) {
                         [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"newFriendNotication"
                                           object:nil];
                         dispatch_after(
                             dispatch_time(DISPATCH_TIME_NOW,
                                           (int64_t)(0.8 * NSEC_PER_SEC)),
                             dispatch_get_main_queue(), ^{
                               [[AppDelegate instanceApplication]
                                   indicatorDismiss];
                               [self.navigationController
                                   popViewControllerAnimated:YES];
                             });
                       } else {
                         [[AppDelegate instanceApplication] indicatorDismiss];
                       }
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
    if (friendMode != -1) {
      //修改数据源
      [self qqianAddFriendWithIndexPath:indexPath
                   WIthCommentIndexPath:commentIndex
                             WithNUmber:[NSNumber numberWithInt:friendMode]];
    }

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
    }
  };

  if (_mode == FRIEND_CATE_FORTH) {
    cell.HeaderView.addFriendButton.tag = indexPath.row;
    cell.HeaderView.friendPassbgView.hidden = YES;
    [cell.HeaderView.addFriendButton addTarget:self
                                        action:@selector(addFriendBtnClicked:)
                              forControlEvents:UIControlEventTouchUpInside];
    cell.HeaderView.addingLab.tag = cell.HeaderView.addFriendButton.tag + 3000;
  } else if (_mode == FRIEND_CATE_THIRD) {
    //加好友
    HSGH_FRIEND_MODE FState =
        (HSGH_FRIEND_MODE)[((HSGHHomeQQianModelFrame *)
                                _modelFrameArr[indexPath.row])
                               .model.friendStatus integerValue];
    if (FState == FRIEND_FROM) { //加我
      cell.HeaderView.addFriendButton.hidden = YES;
      cell.HeaderView.addingLab.hidden = YES;
      cell.HeaderView.friendPassbgView.hidden = NO;
      //显示
      UITapGestureRecognizer *gesTure = [[UITapGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(passFriend:)];
      cell.HeaderView.friendPassbgView.userInteractionEnabled = YES;
      [cell.HeaderView.friendPassbgView addGestureRecognizer:gesTure];
      cell.HeaderView.friendPassbgView.tag = indexPath.row + 2000;
      cell.HeaderView.addFriendButton.tag =
          cell.HeaderView.friendPassbgView.tag + 2000;
      cell.HeaderView.addingLab.tag =
          cell.HeaderView.addFriendButton.tag + 3000;
      [cell.HeaderView.friendPassBtn
          sd_setBackgroundImageWithURL:[NSURL
                                           URLWithString:_model.picture.srcUrl]
                              forState:UIControlStateNormal
                      placeholderImage:
                          [[UIImage imageNamed:@"usernone"]
                              imageWithRenderingMode:
                                  UIImageRenderingModeAlwaysOriginal]
                               options:SDWebImageAllowInvalidSSLCertificates
                             completed:^(UIImage *image, NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL) {
                               if (image) {
                                 cell.HeaderView.friendPassBtn.imageView
                                     .image = [image
                                     imageWithRenderingMode:
                                         UIImageRenderingModeAlwaysOriginal];
                               }
                             }];
      [cell.HeaderView.friendPassBtn addTarget:self
                                        action:@selector(goInZone:)
                              forControlEvents:UIControlEventTouchUpInside];

    } else {
      cell.HeaderView.addFriendButton.tag = indexPath.row;
      cell.HeaderView.addFriendButton.hidden = YES;
      cell.HeaderView.addingLab.hidden = YES;
      cell.HeaderView.friendPassbgView.hidden = YES;
    }
  } else if (_mode == FRIEND_CATE_SECOND) {
    HSGH_FRIEND_MODE FState =
        (HSGH_FRIEND_MODE)[((HSGHHomeQQianModelFrame *)
                                _modelFrameArr[indexPath.row])
                               .model.friendStatus integerValue];
    if (FState == FRIEND_MODE_TWO) { //加我
      cell.HeaderView.addFriendButton.hidden = YES;
      cell.HeaderView.addingLab.hidden = YES;
      cell.HeaderView.friendPassbgView.hidden = NO;
      //显示
      [cell.HeaderView.friendPassBtn
          sd_setBackgroundImageWithURL:
              [NSURL URLWithString:((HSGHHomeQQianModelFrame *)
                                        _modelFrameArr[indexPath.row])
                                       .model.friendApplyUser.picture.srcUrl]
                              forState:UIControlStateNormal
                      placeholderImage:
                          [[UIImage imageNamed:@"usernone"]
                              imageWithRenderingMode:
                                  UIImageRenderingModeAlwaysOriginal]
                               options:SDWebImageAllowInvalidSSLCertificates
                             completed:^(UIImage *image, NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL) {
                               if (image) {
                                 cell.HeaderView.friendPassBtn.imageView
                                     .image = [image
                                     imageWithRenderingMode:
                                         UIImageRenderingModeAlwaysOriginal];
                               }
                             }];
      [cell.HeaderView.friendPassBtn addTarget:self
                                        action:@selector(goInZone:)
                              forControlEvents:UIControlEventTouchUpInside];
      cell.HeaderView.friendPassBtn.tag = indexPath.row + 5000;
      cell.HeaderView.frinedImageTo.image = [UIImage imageNamed:@"icon_bhl"];
    } else if (FState == FRIEND_MODE_ONE) {
      cell.HeaderView.addFriendButton.hidden = NO;
      cell.HeaderView.addingLab.hidden = YES;
      cell.HeaderView.friendPassbgView.hidden = YES;
      [cell.HeaderView.addFriendButton
          setImage:[UIImage imageNamed:@"friend_all"]
          forState:UIControlStateNormal];
    } else {
      cell.HeaderView.addFriendButton.tag = indexPath.row;
      cell.HeaderView.addFriendButton.hidden = YES;
      cell.HeaderView.addingLab.hidden = YES;
      cell.HeaderView.friendPassbgView.hidden = YES;
    }
    cell.HeaderView.addFriendButton.userInteractionEnabled = NO;
  }

  cell.CommentView.commentBlock = ^(NSIndexPath *commentIndexPath) {
    HSLog(@"我要评论了");

    if (_mode == FRIEND_CATE_THIRD || _mode == FRIEND_CATE_SECOND) {

    } else {
      if (_modelFrameArr.count > 0) {
        HSGHHomeQQianModel *model =
            ((HSGHHomeQQianModelFrame *)_modelFrameArr[indexPath.row]).model;
        [HSGHMoreCommentsVC show:model.qqianId
                          userID:model.owner.userId
                            name:model.owner.displayName
                           block:^(BOOL isChanged, NSArray *array){
                           }];
      }
    }
  };
  return cell;
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
                                                WithMode:QQIAN_FRIEND];
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

- (void)goInZone:(UIButton *)button {
  NSString *userId;
  if (_mode == FRIEND_CATE_SECOND) {
    HSGHHomeQQianModelFrame *modelf = _modelFrameArr[button.tag - 5000];
    userId = modelf.model.friendApplyUser.userId;
  } else {
    userId = _model.userId;
  }
  [HSGHZoneVC enterOtherZone:userId];
}

- (void)passFriend:(UITapGestureRecognizer *)gesture {
  UIView *friendBgView = gesture.view;
  UITableViewCell *cell = [self.mainTableView
      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:friendBgView.tag - 2000
                                               inSection:0]];
  UIButton *button = (UIButton *)[cell viewWithTag:friendBgView.tag + 2000];

  UILabel *lable = (UILabel *)[button.superview viewWithTag:button.tag + 3000];
  [[AppDelegate instanceApplication] indicatorShow];
  [HSGHFriendViewModel
      fetchFriendShipWithMode:((HSGHHomeQQianModelFrame *)
                                   _modelFrameArr[friendBgView.tag - 2000])
                                  .model.friendStatus
                      WithBtn:button
                   WithUserID:_model.userId
                  WithQqianId:((HSGHHomeQQianModelFrame *)
                                   _modelFrameArr[friendBgView.tag - 2000])
                                  .model.qqianId
                 WithReplayId:nil
                 WithCallBack:^(BOOL success, UIImage *image) {
                   if (success) {
                     friendBgView.hidden = YES;
                     button.hidden = NO;
                     [button setImage:image forState:UIControlStateNormal];

                     [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"newFriendNotication"
                                       object:nil];
                     [[AppDelegate instanceApplication] indicatorDismiss];
                     dispatch_after(
                         dispatch_time(DISPATCH_TIME_NOW,
                                       (int64_t)(0.8 * NSEC_PER_SEC)),
                         dispatch_get_main_queue(), ^{
                           [[AppDelegate instanceApplication] indicatorDismiss];
                           [self.navigationController
                               popViewControllerAnimated:YES];
                         });
                   } else {
                       [[AppDelegate instanceApplication] indicatorDismiss];
                     [[[UIAlertView alloc]
                             initWithTitle:@""
                                   message:@"加好友失败，请稍后重试"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
                   }
                 }
                 WithAddLabel:lable];
}

- (void)addFriendBtnClicked:(UIButton *)btn {
  HSLog(@"添加好友了"); //添加好友
  UILabel *lable = (UILabel *)[btn.superview viewWithTag:btn.tag + 3000];
  [HSGHFriendViewModel
      fetchFriendShipWithMode:((HSGHHomeQQianModelFrame *)
                                   _modelFrameArr[btn.tag])
                                  .model.friendStatus
                      WithBtn:btn
                   WithUserID:_model.userId
                  WithQqianId:((HSGHHomeQQianModelFrame *)
                                   _modelFrameArr[btn.tag])
                                  .model.qqianId
                 WithReplayId:nil
                 WithCallBack:^(BOOL success, UIImage *image) {
                   if (success) {
                     [btn setImage:image forState:UIControlStateNormal];
                     btn.userInteractionEnabled = NO;
                   } else {
                     [[[UIAlertView alloc]
                             initWithTitle:@""
                                   message:@"加好友失败，请稍后重试"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
                   }
                 }
                 WithAddLabel:lable];
}
- (void)keyBoardShow:(NSIndexPath *)indexPath
                WithType:(EDIT_MODE)editMode
    WithCommentIndexPath:(NSIndexPath *)commentIndexPath {

  [self addKeyBoardView];
  [_keywordView.textView becomeFirstResponder];
  if (editMode == EDIT_FORWARD_MODE) {
    _keywordView.editMode = EDIT_FORWARD_MODE;
    _keywordView.indexPath = indexPath;
    _keywordView.commentIndex = nil;
    _keywordView.HomeMode = HOME_FIRST_MODE;
  } else if (editMode == HOME_COMMENT_MODE) {
    _keywordView.editMode = HOME_COMMENT_MODE;
    _keywordView.indexPath = indexPath;
    _keywordView.HomeMode = HOME_FIRST_MODE;
  }
  if (editMode == HOME_REPLAY_MODE) {
    //回复
    _keywordView.textView.placeholderText =
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
      _keywordView.textView.placeholderText =
          [NSString stringWithFormat:@"转发此条匿名新鲜事"];
    } else {
      _keywordView.textView.placeholderText =
          [NSString stringWithFormat:@"转发%@的新鲜事",
                                     ((HSGHHomeQQianModelFrame *)
                                          _modelFrameArr[indexPath.row])
                                         .model.creator.displayName];
    }
    //计算tableView 中comment的高度
  } else if (editMode == HOME_COMMENT_MODE) {
    //评论
    _keywordView.textView.placeholderText =
        [NSString stringWithFormat:@"评论%@的新鲜事",
                                   ((HSGHHomeQQianModelFrame *)
                                        _modelFrameArr[indexPath.row])
                                       .model.creator.displayName];
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_mode == FRIEND_CATE_SECOND) {
    if (indexPath.row > 1) { //第二条
      return [_modelFrameArr[indexPath.row] cellHeight] - 29;
    }
  }
  return [_modelFrameArr[indexPath.row] cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section {
  UIView *view =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 50)];
  return view;
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
  case FRIEND_UKNOW:
    imageFileName = FRIEND_ALL_IMAGE;
    qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_ALL];
    break;
    break;
  default:
    break;
  }

  HSGHHomeQQianModelFrame *voFrame =
      [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                                WithMode:QQIAN_FRIEND];
  [voFrame setModel:qqiansVO];
  NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
  [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
  _modelFrameArr = [NSArray arrayWithArray:arr];
  [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
  //发送一个通知
  if (_model != nil) {
    //        [HSGHFriendViewModel saveData:@[_model]
    //        WithType:FRIEND_CATE_SCHOLL ];
    //          [[NSNotificationCenter defaultCenter]
    //          postNotificationName:@"friendShipDaoNotication" object:nil
    //          userInfo:@{@"mode":@2,@"model":_model}];
  }
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
                                                WithMode:QQIAN_FRIEND];
  [voFrame setModel:qqiansVO];
  NSMutableArray *arr = [NSMutableArray arrayWithArray:_modelFrameArr];
  [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
  _modelFrameArr = [NSArray arrayWithArray:arr];
  [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
}

// 删除
- (void)qqianRemoveHomeType:(HOME_MODE)mode
               andIndexPath:(NSIndexPath *)indexPath {
  NSArray *datalist = _modelFrameArr;

  NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
  [arr removeObjectAtIndex:indexPath.row];
  _modelFrameArr = [NSArray arrayWithArray:arr];
  [self.mainTableView reloadData];
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
                                                WithMode:QQIAN_FRIEND];
  [frame setModel:qqiansVO];
  NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
  [arr replaceObjectAtIndex:indexPath.row withObject:frame];
  _modelFrameArr = [NSArray arrayWithArray:arr];
  [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
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
  __block NSUInteger index = 99999;

  [model.partUp
      enumerateObjectsUsingBlock:^(HSGHHomeUp *_Nonnull obj, NSUInteger idx,
                                   BOOL *_Nonnull stop) {
        if ([[HSGHUserInf shareManager].userId isEqualToString:obj.userId]) {
          index = idx;
        }
      }];
  if (index != 99999) {
    [upModelArr removeObjectAtIndex:index];
  }
  model.partUp = [NSArray arrayWithArray:upModelArr];

  HSGHHomeQQianModelFrame *modelF2 =
      [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                                WithMode:QQIAN_FRIEND];
  [modelF2 setModel:model];

  NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
  [arr replaceObjectAtIndex:indexPath.row withObject:modelF2];
  _modelFrameArr = [NSArray arrayWithArray:arr];
  [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
}

// 评论 转发
- (void)qqianUpWithHomeType:(HOME_MODE)mode
                andEditType:(EDIT_MODE)editMode
                   andIndex:(NSIndexPath *)indexPath
                WithRelayId:(NSString *)replayId {

  NSArray *datalist = [NSArray arrayWithArray:_modelFrameArr];

  HSGHHomeQQianModelFrame *originFrame = datalist[indexPath.row];
  if ([originFrame.model.forward integerValue] == NO) {
    HSGHHomeQQianModel *qqiansVO =
        ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    HSGHHomeReplay *replay = [HSGHHomeReplay new];
    replay.replayId = replayId;
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
    replay.fromUser = from;
    replay.content = _keywordView.textView.text;
    if (editMode == HOME_COMMENT_MODE) {
      //评论
      qqiansVO.replyCount = @([qqiansVO.replyCount integerValue] + 1);

    } else if (editMode == EDIT_FORWARD_MODE) {
      qqiansVO.forwardCount = @([qqiansVO.forwardCount integerValue] + 1);
    }
    NSMutableArray *replayArr =
        [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    [replayArr insertObject:replay atIndex:0];

    qqiansVO.partReplay = [NSArray arrayWithArray:replayArr];
    HSGHHomeQQianModelFrame *voFrame =
        [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                                  WithMode:QQIAN_FRIEND];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    _modelFrameArr = [NSArray arrayWithArray:arr];
    [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationNone];
  }
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
  CGFloat delta = CGRectGetMaxY(rect) -
                  (window.bounds.size.height - _keywordView.keyboardHeight);

  CGPoint offset = tableView.contentOffset;
  offset.y += delta;
  if (offset.y < 0) {
    offset.y = 0;
  }

  [tableView setContentOffset:offset animated:YES];
}
#pragma mark - textVIew delegate

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}
- (void)leftBarItemBtnClicked:(UIButton *)btn {
  //    if(self.popCallBackBlock){
  //        self.popCallBackBlock();
  //    }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
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

#pragma mark - notification


#pragma mark-video
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}
@end
