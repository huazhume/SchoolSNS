//
//  HSGHHomeMainCellCommentView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHDetailCommentView.h"
#import "HSGHDetailCommentCell.h"
#import "HSGHHomeModel.h"
#import "HSGHCommentHeaderView.h"
#import "YYText.h"
#import "HSGHFriendDetailViewModel.h"
#import "HSGHFriendViewModel.h"
#import "HSGHUserInf.h"
#import "HSGHTools.h"
#import "HSGHNetworkSession.h"
#import "AppDelegate.h"
#import "HSGHZoneVC.h"
#import "HSGHHomeViewModel.h"

@interface HSGHDetailCommentView () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

{
    //    UILabel *label;
    HSGHHomeQQianModelFrame * modelFrame;
}
@property(strong, nonatomic) IBOutlet HSGHCommentHeaderView *commentHeaderView;
@property(strong, nonatomic) IBOutlet UIView *commentFooterView;
@property(strong, nonatomic) NSArray<HSGHHomeReplay *> *datalist;
@property (strong,nonatomic) NSArray<HSGHHomeVOCommentFrame *> * cellFrame;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HSGHDetailCommentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"HSGHDetailCommentView"
                                  owner:self
                                options:nil];
    self.view.frame =
    CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.view];
}

- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF {
    _qqianVo = modelF.model;
    modelFrame = modelF;
    self.datalist = modelF.model.partReplay;
    _cellFrame = modelF.commentFrameArr;
    [self.tableView reloadData];
    self.commentHeaderView.textLab.text = [NSString stringWithFormat:@"%ld条评论", [_qqianVo.replyCount integerValue] + [_qqianVo.forwardCount integerValue]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _datalist = [NSArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HSGHDetailCommentCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MainCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.userInteractionEnabled = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    UITapGestureRecognizer * getsturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewClicked)];
    [self.tableView addGestureRecognizer:getsturer];
    self.tableView.userInteractionEnabled = YES;
}

- (void)tableViewClicked {
    if(_block){
        self.block();
        
    }
}
#pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    return self.commentHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_cellFrame[indexPath.row] cellHeight];
}

- (void)goin:(UIButton *)button {
     HSGHHomeReplay *replay = _datalist[button.tag - 800];
    [HSGHZoneVC enterOtherZone:replay.fromUser.userId];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHHomeReplay *replay = _datalist[indexPath.row];
    HSGHDetailCommentCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    NSMutableAttributedString *string =
    [HSGHFriendDetailViewModel generateAttributedStringWithCommentItemModel:replay];
    
    if (string != nil) {
        cell.textLab.attributedText = string;
    }
    if (replay.fromUser.picture.srcUrl && [replay.fromUser.picture.srcUrl hasPrefix:@"http"]) {
        [cell.icon sd_setBackgroundImageWithURL:[NSURL URLWithString:replay.fromUser.picture.srcUrl]
                                       forState:UIControlStateNormal
                               placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]

                                        options:SDWebImageAllowInvalidSSLCertificates
                                      completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                          if (image) {
                                              cell.icon.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                          }
                                      }];
    }
    cell.icon.tag = 800+ indexPath.row;
    [cell.icon addTarget:self action:@selector(goin:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.universityImage sd_setImageWithURL:[NSURL URLWithString:replay.fromUser.unvi.iconUrl] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    cell.username.text = replay.fromUser.displayName;
    cell.universityLab.text = replay.fromUser.unvi.name;
    if(replay.up == YES){
        [cell.upBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_dz_s"] forState:UIControlStateNormal];
    }else{
        [cell.upBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_dz_n"] forState:UIControlStateNormal];
    }
    
    cell.upBtn.tag = 2222+ indexPath.row;
    [cell.upBtn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
    HSGH_FRIEND_MODE mode = (HSGH_FRIEND_MODE)[replay.friendStatus integerValue];
    if(mode == FRIEND_FROM && modelFrame.friendMode == FRIEND_CATE_THIRD){
        
        cell.friendPassBtnRightCos.constant = 4;
        cell.addingLab.hidden = YES;
        cell.toFriend.hidden = YES;
        cell.friendPassbgVIew.hidden = NO;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passFriendBtnClick:)];
        cell.friendPassbgVIew.userInteractionEnabled = YES;
        [cell.friendPassbgVIew addGestureRecognizer:tap];
        cell.friendPassbgVIew.tag = indexPath.row + 4000;
        cell.toFriend.tag = cell.friendPassbgVIew.tag + 1000;
        [cell.friendPassBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.singleModel.picture.srcUrl]
                                                           forState:UIControlStateNormal
                                                   placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                                            options:SDWebImageAllowInvalidSSLCertificates
                                                          completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                                              if (image) {
                                                                  cell.friendPassBtn.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                                              }
                                                          }];
        [cell.friendPassBtn addTarget:self action:@selector(goInZone:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (modelFrame.friendMode == FRIEND_CATE_SECOND){
        cell.friendPassBtnRightCos.constant = 4;
        cell.upBtn.hidden = YES;
        cell.upLab.hidden = YES;
        if(mode == FRIEND_MODE_TWO){
            cell.addingLab.hidden = YES;
            cell.toFriend.hidden = YES;
            cell.friendPassbgVIew.hidden = NO;
            cell.friendImageTo.image = [UIImage imageNamed:@"icon_bhl"];
//            cell.friendPassbgVIew.userInteractionEnabled = NO;
            [cell.friendPassBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:replay.friendApplyUser.picture.srcUrl]
                                                    forState:UIControlStateNormal
                                            placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                                     options:SDWebImageAllowInvalidSSLCertificates
                                                   completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                                       if (image) {
                                                           cell.friendPassBtn.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                                       }
                                                   }];
            [cell.friendPassBtn addTarget:self action:@selector(goInZone:) forControlEvents:UIControlEventTouchUpInside];
            cell.friendPassBtn.tag = indexPath.row + 2000;
        }else if (mode == FRIEND_MODE_ONE){
            cell.addingLab.hidden = YES;
            cell.toFriend.hidden = NO;
            cell.friendPassbgVIew.hidden = YES;
            [cell.toFriend setImage:[UIImage imageNamed:@"friend_all"] forState:UIControlStateNormal];
            cell.toFriend.userInteractionEnabled = NO;
        }else {
            cell.addingLab.hidden = YES;
            cell.toFriend.hidden = YES;
            cell.friendPassbgVIew.hidden = YES;
        }
    }
    else{
        cell.friendPassBtnRightCos.constant = 76;
        cell.friendPassbgVIew.hidden = YES;
         [HSGHFriendViewModel fetchAddBtnStateWithCurrentUserId:replay.fromUser.userId WithOtherId:nil WithQQianMode:modelFrame.mode FriendMode:modelFrame.friendMode WithMode:replay.friendStatus WithBtn:cell.toFriend WithAddLabel:cell.addingLab];
        cell.toFriend.tag = indexPath.row;
    }
    cell.upLab.text = [NSString stringWithFormat:@"%@",replay.upCount];
    if([replay.upCount integerValue]== 0){
        cell.upLab.text = [NSString stringWithFormat:@""];
//        cell.upLabWidth.constant = [HSGHTools widthOfLab:cell.upLab];
    }else{
//        cell.upLabWidth.constant = [HSGHTools widthOfLab:cell.upLab];
    }
    cell.upLab.tag = 3333 + indexPath.row;
    [cell.toFriend addTarget:self action:@selector(clickAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.timeLab.text = [HSGHTools getLocalDateFormateUTCDate:_qqianVo.friendAddTime];
    cell.timeHeight.constant =  [_cellFrame[indexPath.row] timeHeight];
    
    //给内容添加一个事件
    UITapGestureRecognizer * textTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickText:)];
    cell.textLab.userInteractionEnabled = YES;
    [cell.contentView addGestureRecognizer:textTap];
    
     cell.addingLab.tag = cell.toFriend.tag + 2000;
    
    //红心
    if(modelFrame.mode == QQIAN_FRIEND && (modelFrame.friendMode == FRIEND_CATE_THIRD || modelFrame.friendMode == FRIEND_CATE_SECOND)){
        cell.upBtn.hidden = YES;
        cell.upLab.hidden = YES;
    }else {
        cell.upLab.hidden = NO;
        cell.upBtn.hidden = NO;
    }
    
    if(modelFrame.mode == QQIAN_MSG){
        UILongPressGestureRecognizer *longPressGr =
        [[UILongPressGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [cell.contentView addGestureRecognizer:longPressGr];
         cell.contentView.userInteractionEnabled = YES;
    }
     cell.contentView.tag = 1000 + indexPath.row;
   return cell;
}
- (void)longPressToDo:(UILongPressGestureRecognizer *)recognizer {
    UIView * view = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // end
        UIAlertView * alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                              message:@"删除此条消息？"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:@"取消", nil];
        alerView.tag = 1000 + view.tag;
        [alerView show];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        
    }
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    HSLog(@"_____%ld", buttonIndex);
    if(alertView.tag >= 2000){
        if (buttonIndex == 0) {
            HSGHHomeReplay *replay = _datalist[alertView.tag - 2000];
            [[AppDelegate instanceApplication] indicatorShow];
            [HSGHHomeViewModel fetchRemoveWithParams:@{@"replyId":replay.replayId} :^(BOOL success) {
               [[AppDelegate instanceApplication] indicatorDismiss];
                if(success){
                    self.upCommet(3000, [NSIndexPath indexPathForRow:alertView.tag - 2000 inSection:0]);
                }else{
                    Toast * toset = [[Toast alloc]initWithText:@"删除评论失败" delay:1.5f duration:2];
                    [toset show];
                    
                }
            }];
        }
    }
}



- (void)goInZone:(UIButton *)button {
    NSString * userID ;
    if (modelFrame.friendMode == FRIEND_CATE_SECOND){
         HSGHHomeReplay *replay = _datalist[button.tag - 2000];
        userID = replay.friendApplyUser.userId;

    }else if(modelFrame.friendMode == FRIEND_CATE_THIRD){
        userID = self.singleModel.userId;
        
    }
    [HSGHZoneVC enterOtherZone:userID];
}

- (void)passFriendBtnClick:(UITapGestureRecognizer *)gesture {
    UIView * view = gesture.view;
    UIButton * btn = (UIButton *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:view.tag - 4000 inSection:0]] viewWithTag:view.tag + 1000];
    HSGHHomeReplay *replay = _datalist[view.tag - 4000];
    UIView * superView = btn.superview;
    UILabel * label = [(UILabel *)superView viewWithTag:btn.tag + 2000];
    
    if(self.addblock){
        self.addblock(btn,replay.friendStatus,replay.replayId,label,view,[NSIndexPath indexPathForRow:view.tag - 4000 inSection:0]);
    }
}


- (void)clickText:(UITapGestureRecognizer *)tapGesturer {
    UIView * cellView = tapGesturer.view;
    if(self.commentBlock){
        self.commentBlock([NSIndexPath indexPathForRow:cellView.tag - 1000 inSection:0]);
    }
}

//点赞
- (void)clickUpBtn:(UIButton *)btn {
    HSGHHomeReplay *replay = _datalist[btn.tag - 2222];
    if(replay.up == NO){
        [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
                       appendParams:@{
                                      @"replyId" : replay.replayId,
                                       @"qqianId" : _qqianVo.qqianId,
                                      }
                        returnClass:[self class]
                              block:^(id obj, NetResStatus status, NSString* errorDes) {
                                  [[AppDelegate instanceApplication]indicatorDismiss];
                               if (status == 0) {
                                      //点赞成功
                                   
                                  } else {
                                      HSLog(@"点赞失败啦");
                                      
                                  }
                              }];
        [btn setBackgroundImage:[[UIImage imageNamed:@"common_icon_dz_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        HSGHDetailCommentCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag - 2222 inSection:0]];
        NSInteger number = [replay.upCount integerValue];
        cell.upLab.text = [NSString stringWithFormat:@"%ld",++number];
        if(_upCommet){
            self.upCommet(1000,[NSIndexPath indexPathForRow:btn.tag - 2222 inSection:0]);
        }
    }else{
        //取消点赞
        [HSGHNetworkSession postReq:HSGHUpCancel
                       appendParams:@{
                                      @"replyId" : replay.replayId,
                                      @"qqianId" : _qqianVo.qqianId,
                                      }
                        returnClass:[self class]
                              block:^(id obj, NetResStatus status, NSString* errorDes) {
                                  [[AppDelegate instanceApplication]indicatorDismiss];
                                  if (status == 0) {
                                      //点赞成功
                                      
                                  } else {
                                      HSLog(@"取消点赞失败啦");
                                      
                                  }
                              }];
        self.upCommet(2000,[NSIndexPath indexPathForRow:btn.tag - 2222 inSection:0]);
        [btn setBackgroundImage:[[UIImage imageNamed:@"common_icon_dz_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        HSGHDetailCommentCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag - 2222 inSection:0]];
        NSInteger number = [replay.upCount integerValue];
        cell.upLab.text = [NSString stringWithFormat:@"%ld",--number];
    }
}
//加好友
- (IBAction)clickAddFriend:(id)sender
{
    HSGHHomeReplay *replay = _datalist[((UIButton *)sender).tag];
    UIView * superView = ((UIButton *)sender).superview;
    UILabel * label = [(UILabel *)superView viewWithTag:((UIButton *)sender).tag + 2000];
    if(self.addblock){
        self.addblock((UIButton *)sender,replay.friendStatus,replay.replayId,label,nil,[NSIndexPath indexPathForRow:((UIButton *)sender).tag inSection:0]);
    }
}








- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    
    return self.commentFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    if ([_qqianVo.replyCount integerValue] + [_qqianVo.forwardCount integerValue] > 3) {
        return 30;
    }
    return 30;
}

- (UIView *)commentHeaderView {
    if (!_commentHeaderView) {
        _commentHeaderView =  [[[NSBundle mainBundle] loadNibNamed:@"HSGHCommentHeaderView"
                                                             owner:self
                                                           options:nil] lastObject];
    }
    return _commentHeaderView;
}
- (UIView *)commentFooterView {
    if (!_commentFooterView) {
        _commentFooterView =
        [[[NSBundle mainBundle] loadNibNamed:@"HSGHCommentMoreView"
                                       owner:self
                                     options:nil] lastObject];
    }
    return _commentFooterView;
}


@end
