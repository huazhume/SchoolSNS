//
//  HSGHCommentsView.m
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

#import "HSGHMoreCommentsViewCell.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHFriendViewModel.h"
#import "HSGHMoreCommentsExternView.h"
#import "HSGHMoreCommentsHelp.h"
#import "HSGHMoreCommentsLabel.h"
#import "HSGHTools.h"
#import "HSGHUserInf.h"
#import "HSGHZoneVC.h"
#import "NSAttributedString+YYText.h"


@interface HSGHMoreCommentsViewCell () {
  NSString *_currentUserID;
  HSGH_FRIEND_MODE _type;
    BOOL isDetail;
    __weak IBOutlet NSLayoutConstraint *headImageWidth;
    __weak IBOutlet NSLayoutConstraint *leftConstraint;
    __weak IBOutlet NSLayoutConstraint *schoolHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *schoolIconToTopCons;
    __weak IBOutlet NSLayoutConstraint *nameTopCons;
}
@property(nonatomic, strong) HSGHHomeReplay *repaly;
@property(weak, nonatomic) IBOutlet UILabel *addingLab;

@property(nonatomic, strong) HSGHMoreCommentsLabel *contentLabel;
//@property(nonatomic, strong) HSGHMoreCommentsExternView *replyViews;
@property(weak, nonatomic) IBOutlet UIView *detailsLine;
@property(weak, nonatomic) IBOutlet UIView *line;

@end

@implementation HSGHMoreCommentsViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    CGFloat width = HSGH_SCREEN_WIDTH - 57.5;
    if (self.repaly.toUser.userId && self.repaly.toUser.userId.integerValue != 0) {
        width -= 26;
    }
    _contentLabel = [[HSGHMoreCommentsLabel alloc] init];
    _contentLabel.userInteractionEnabled = true;
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.schoolImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self);
        make.right.equalTo(self.praiseButton);
    }];

//  _replyViews = [[HSGHMoreCommentsExternView alloc]
//      initWithFrame:CGRectMake(50, 90, [[self class] getLabelWidth], 1)];
//
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWholeButton:)];
    [_contentLabel addGestureRecognizer:tapGes];
//
//  [self addSubview:_replyViews];
}

- (void)updateCons:(NSString *)schoolName {
    NSUInteger rows = [HSGHTools calcLabelRows:_schoolLabel text:schoolName];
    if (rows > 1) {
        nameTopCons.constant = -3;
        schoolHeightConstraint.constant = 28;
        schoolIconToTopCons.constant = 6 + 6;
    } else {
        nameTopCons.constant = 0;
        schoolHeightConstraint.constant = 13;
        schoolIconToTopCons.constant = 3 + 6;
    }
}

- (void)updateUpNumberState {
    _numberLabel.hidden = _numberLabel.text.integerValue == 0;
}

- (void)updateInfo:(HSGHMoreCommentsLayoutModel *)layoutModel indexPath:(NSIndexPath *)indexPath needClickMore:(BOOL)needClickMore refreshIndexPath:(NSIndexPath *)refreshIndexPath {
    _repaly = layoutModel.cellReplay;
    _indexPath = indexPath;
    _refreshIndexPath = refreshIndexPath;
    
    _praiseButton.selected = _repaly.up;
    _numberLabel.text = [NSString stringWithFormat:@"%@", _repaly.upCount];
    [self updateUpNumberState];
    if (indexPath.row < 0 ) {
        _nameLabel.text = _repaly.fromUser.displayName;
    }else{
        NSString *str = [NSString stringWithFormat:@"%@ 回复 %@",_repaly.fromUser.displayName,_repaly.fromUser.userId.integerValue != _repaly.toUser.userId.integerValue?_repaly.toUser.displayName:@""];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:13],NSFontAttributeName,nil];
        
        NSRange rang = NSMakeRange(_repaly.fromUser.displayName.length+1, 2);
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str];
        [attstr addAttributes:attributeDict range:rang];
        _nameLabel.attributedText = attstr;
    }
    
    
    [_schoolImageView
     sd_setImageWithURL:[NSURL
                         URLWithString:UN_NIL_STR(
                                                  _repaly.fromUser.unvi.iconUrl)]
     placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]
     options:SDWebImageAllowInvalidSSLCertificates];
    if (_repaly.fromUser.unvi.name) {
        [self updateCons:_repaly.fromUser.unvi.name];
        _schoolLabel.text = _repaly.fromUser.unvi.name;
    }
    
    __weak typeof(self) weakSelf = self;
    [_headIconButton
     sd_setBackgroundImageWithURL:[NSURL URLWithString:_repaly.fromUser.picture
                                   .srcUrl]
     forState:UIControlStateNormal
     placeholderImage:[[UIImage imageNamed:@"usernone"]
                       imageWithRenderingMode:
                       UIImageRenderingModeAlwaysOriginal]
     options:SDWebImageAllowInvalidSSLCertificates
     completed:^(UIImage *image, NSError *error,
                 SDImageCacheType cacheType,
                 NSURL *imageURL) {
         if (image) {
             [weakSelf.headIconButton
              setImage:
              [image
               imageWithRenderingMode:
               UIImageRenderingModeAlwaysOriginal]
              forState:UIControlStateNormal];
         }
     }];
    
    _currentUserID = _repaly.fromUser.userId;
    
    // add Friend
    _type = (HSGH_FRIEND_MODE)([_repaly.friendStatus integerValue]);
    //加好友
    [HSGHFriendViewModel fetchAddBtnStateWithCurrentUserId:_repaly.fromUser.userId
                                               WithOtherId:nil
                                             WithQQianMode:QQIAN_HOME
                                                FriendMode:0
                                                  WithMode:_repaly.friendStatus
                                                   WithBtn:self.friendButton
                                              WithAddLabel:self.addingLab];
    //    _friendButton.hidden = [[HSGHUserInf shareManager].userId
    //    isEqualToString:UN_NIL_STR(_currentUserID)];
    
    [_contentLabel setContent:layoutModel];
    _contentLabel.height = layoutModel.layout.normalLabelHeight;
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.schoolImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self);
        make.right.equalTo(self.praiseButton);
    }];
    //  if (layoutModel.layout.cellsHeight == 0) {
    //    _replyViews.hidden = true;
    //  } else {
    //    _replyViews.hidden = false;
    //    [_replyViews updateDataArray:layoutModel];
    //    _replyViews.top = _contentLabel.bottom + 8;
    //    _replyViews.height = layoutModel.layout.cellsHeight;
    //  }
}

//yes二级回复，no一级回复
- (void)setToDetail:(BOOL)iSDetail {
    isDetail = iSDetail;
    _detailsLine.hidden = !isDetail;
    _line.hidden = YES;
    if (!isDetail) {//一级
        leftConstraint.constant = 0;
//        headImageWidth.constant = 25;
//        _headIconBackgroundView.hidden = NO;
        _headIconButton.cornerRadius = 12.5;
    }else{//二级
        leftConstraint.constant = 27;
//        headImageWidth.constant = 20;
//        _headIconBackgroundView.hidden = YES;
        _headIconButton.cornerRadius = 12.5;
    }
    
}

#pragma mark-- click
//点击cell本身
- (IBAction)clickWholeButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickWholeButton:)]) {
        [_delegate clickWholeButton:_indexPath];
    }
}
//查看更多
- (IBAction)clickMore:(id)sender {
  if ([_delegate
          respondsToSelector:@selector(clickExtended:refreshIndexPath:)]) {
    [_delegate clickExtended:_indexPath refreshIndexPath:_refreshIndexPath];
  }
}
//点赞
- (IBAction)clickParise:(id)sender {
  if (!_praiseButton.selected) {
      [self updateUPState:true];
      if ([_delegate respondsToSelector:@selector(clickUP:block:)]) {
          [_delegate clickUP:_indexPath block:^(BOOL success) {
              if (success) {
              }
          }];
      }
  } else {
      HSLog(@"---取消---取消点赞----");
//    [self updateUPState:false];
//    if ([_delegate respondsToSelector:@selector(cancelUP:block:)]) {
//      [_delegate cancelUP:_indexPath
//                    block:^(BOOL success){
//
//                    }];
//    }
  }
}

- (void)clickEnterDetail {
    if ([_delegate respondsToSelector:@selector(clickEnterDetails:)]) {
        [_delegate clickEnterDetails:_indexPath];
    }
}

//点击头像
- (IBAction)clickHead:(id)sender {
    [HSGHZoneVC enterOtherZone:_currentUserID];
}

- (void)updateUPState:(BOOL)up {
    if (up) {
        _praiseButton.selected = YES;
        _numberLabel.text = [NSString
                             stringWithFormat:@"%@", @(_numberLabel.text.integerValue + 1)];
        [self updateUpNumberState];
        _praiseButton.userInteractionEnabled = YES;
        
    } else {
        _praiseButton.selected = NO;
        _numberLabel.text = [NSString
                             stringWithFormat:@"%@", @(_numberLabel.text.integerValue - 1)];
        [self updateUpNumberState];
        _praiseButton.userInteractionEnabled = YES;
    }
}

+ (CGFloat)getLabelWidth {
    return HSGH_SCREEN_WIDTH - 50;
}

//添加好友
- (IBAction)addFriendBtn:(id)sender {
  [HSGHFriendViewModel
      fetchFriendShipWithMode:_repaly.friendStatus
                      WithBtn:(UIButton *)sender
                   WithUserID:_repaly.fromUser.userId
                  WithQqianId:self.qqianId
                 WithReplayId:_repaly.replayId
                 WithCallBack:^(BOOL success, UIImage *image) {
                   if (success) {
                     [self.friendButton setImage:image
                                        forState:UIControlStateNormal];
                     if (_block) {
                       self.block(_repaly.fromUser.userId,_indexPath);
                       if ([_repaly.friendStatus integerValue] == 0) {
                         _repaly.friendStatus = @3;
                       } else if ([_repaly.friendStatus integerValue] == 4 ||
                                  [_repaly.friendStatus integerValue] == 5) {
                         _repaly.friendStatus = @2;
                       }
                     }
                   } else {
                     [[[UIAlertView alloc]
                             initWithTitle:@""
                                   message:@"未知错误，请稍后重试"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
                   }
                 }
                 WithAddLabel:self.addingLab];
}
@end
