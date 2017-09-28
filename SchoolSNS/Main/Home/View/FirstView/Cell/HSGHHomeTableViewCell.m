//
//  HSGHHomeTableViewCell.m
//  SchoolSNS
//
//  Created by 陈位 on 2017/8/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeTableViewCell.h"
#import "HSGHHomeModelFrame.h"
#import "UIImageView+WebCache.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "HSGHTools.h"
#import "HSGHFriendViewModel.h"
#import "SchoolSNS-Swift.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHZoneVC.h"
#import "JPVideoPlayerManager.h"

#define MAX_UP_COUNT 5 //显示的最大点赞人数

@interface HSGHHomeTableViewCell ()

//head
@property (weak, nonatomic) IBOutlet UIImageView *headHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headSchoolIcon;
@property (weak, nonatomic) IBOutlet UILabel *headSchoolLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *friendApplyingButton;
@property (weak, nonatomic) IBOutlet UILabel *friendApplyingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headNameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headUnivLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
@property (weak, nonatomic) IBOutlet UIView *BgHeadView;

//firstCreator
@property (weak, nonatomic) IBOutlet UIImageView *fstCreatorImg;
@property (weak, nonatomic) IBOutlet UILabel *fstCreatorName;
@property (weak, nonatomic) IBOutlet UIImageView *fstCreatorUnImg;
@property (weak, nonatomic) IBOutlet UILabel *fstCreatorUnName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fstCreatorViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fstCreatorViewH;
@property (weak, nonatomic) IBOutlet UIView *fstCreatorView;
@property (weak, nonatomic) IBOutlet UILabel *fstCreatorApplyingLabel;
@property (weak, nonatomic) IBOutlet UIButton *fstCreatorApplingButton;
@property (weak, nonatomic) IBOutlet UIButton *fstCreatorAddButton;


//secondCreator
@property (weak, nonatomic) IBOutlet UIImageView *secCreatorImg;
@property (weak, nonatomic) IBOutlet UIImageView *secCreatorUnImg;
@property (weak, nonatomic) IBOutlet UILabel *secCreatorName;
@property (weak, nonatomic) IBOutlet UILabel *secCreatorUnName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secCreatorViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secCreatorViewH;
@property (weak, nonatomic) IBOutlet UIView *secCreatorView;
@property (weak, nonatomic) IBOutlet UIButton *secCreatorAddButton;
@property (weak, nonatomic) IBOutlet UIButton *secCreatorApplyingButton;
@property (weak, nonatomic) IBOutlet UILabel *secCreatorApplyingLabel;


//content
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contntViewImageV;//内容图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contntViewImageVX;//内容图片 左边 留白

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contntViewTextV;
@property (weak, nonatomic) IBOutlet YYLabel *yyLabel;


//time 时间 距离
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
@property (weak, nonatomic) IBOutlet UIView *leftDistanceView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


//tool 转发 点赞
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UILabel *forwordL;
@property (weak, nonatomic) IBOutlet UILabel *replyL;
@property (weak, nonatomic) IBOutlet UILabel *upL;
@property (weak, nonatomic) IBOutlet UIImageView *dianzanIcon;//心形图片切换
@property (weak, nonatomic) IBOutlet UIView *dianzanIconsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dianzanIconsViewWidth;


//comment评论区
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewH;



@property (nonatomic, strong) NSMutableArray<YYLabel *> *replayLabelArr;


@property (nonatomic, assign) BOOL showDistance;//显示距离我 km

@end

@implementation HSGHHomeTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    //[self mutePlay];
    
    self.cntImageView.image = nil;
    //self.cntImageView.videoPlayURL = nil;
    //self.cntImageView.image = [UIImage imageNamed:@"contentHoldImage"];
    self.contntViewImageV.constant = .0f;
    _muteButton.selected = YES;
    //_muteButton.hidden = YES;
    
    _videoPath = @"";
    
    self.headHeadIcon.image = nil;
    self.headSchoolIcon.image = nil;
    
    NSAttributedString *nullstr = [[NSAttributedString alloc] initWithString:@""];
    self.replayLabelArr[0].attributedText = nullstr;
    self.replayLabelArr[1].attributedText = nullstr;
    self.replayLabelArr[2].attributedText = nullstr;
    
}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if(self) {
//
//    }
//    return self;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置头像圆角
    self.headHeadIcon.layer.cornerRadius = 17.0;
    self.headHeadIcon.clipsToBounds = YES;
    UIColor *tmpColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.BgHeadView.layer.cornerRadius = 19.0;
    self.BgHeadView.clipsToBounds = YES;
    self.BgHeadView.layer.borderColor = [tmpColor CGColor];
    self.BgHeadView.layer.borderWidth = 1;
    
    
    self.fstCreatorImg.layer.cornerRadius = 8.5;
    self.fstCreatorImg.clipsToBounds = YES;
    self.secCreatorImg.layer.cornerRadius = 8.5;
    self.secCreatorImg.clipsToBounds = YES;
    
    
    [self addTruncationToken];
    
    for (int i=0; i< 3; i++) {//创建三个评论label
        YYLabel *replayL = [[YYLabel alloc] init];
        replayL.numberOfLines = 0;
        replayL.textAlignment = NSTextAlignmentLeft;
        [self.commentView addSubview:replayL];
        replayL.textParser = [YYTextMatchBindingParser new];
        [self.replayLabelArr addObject:replayL];
    }
    
    
    
    for (int i=0; i<MAX_UP_COUNT; i++) {
        UIView* containView = [UIView new];
        containView.backgroundColor = [UIColor whiteColor];
        containView.frame = CGRectMake(34*i, 2, 30, 30);
        containView.layer.cornerRadius = 15.f;
        containView.layer.borderColor = HEXRGBCOLOR(0xbcbcbc).CGColor;
        containView.layer.borderWidth = 0.5f;

        [self.dianzanIconsView addSubview:containView];

        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(2, 2, 26, 26);
        imgV.layer.cornerRadius = 13.0;
        imgV.layer.masksToBounds = YES;

//        NSString *urlStr = [NSString stringWithFormat:@"%@",_modelF.model.partUp[i].picture.thumbUrl];
//        [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
        [containView addSubview:imgV];
    }
    
    
//    self.cntImageView
    self.cntImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ImageViewDoubleTapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [ImageViewDoubleTapGester setNumberOfTapsRequired:2];
    [self.cntImageView addGestureRecognizer:ImageViewDoubleTapGester];//图片双击点赞
    
    
    UITapGestureRecognizer *ImageViewTapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    [self.cntImageView addGestureRecognizer:ImageViewTapGester];//图片点击
    
    //fstCreatorView tap
    UITapGestureRecognizer *fstViewTapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatorViewTap:)];
    [self.fstCreatorView addGestureRecognizer:fstViewTapGester];
    //secCreatorView tap
    UITapGestureRecognizer *secViewTapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatorViewTap:)];
    [self.secCreatorView addGestureRecognizer:secViewTapGester];
    
    UITapGestureRecognizer *yyLabelDoubleTapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [yyLabelDoubleTapGester setNumberOfTapsRequired:2];
    [_yyLabel addGestureRecognizer:yyLabelDoubleTapGester];
    
    
    [self.cntImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    //内容图片长按事件  加好友
    UILongPressGestureRecognizer * longPressGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressIMGGestAction:)];
    longPressGest.minimumPressDuration = 0.5;
    [self.cntImageView addGestureRecognizer:longPressGest];
    
    //内容文字长按事件  加好友
    UILongPressGestureRecognizer * longPressLabelGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestAction:)];
    longPressLabelGest.minimumPressDuration = 0.5;
    [_yyLabel addGestureRecognizer:longPressLabelGest];
    
    
    UITapGestureRecognizer *tapGster = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGsterAction:)];
    [self.commentView addGestureRecognizer:tapGster];
    
    //跳转点赞人员列表
    UITapGestureRecognizer *tapIconsViewGster = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconsViewGsterAction:)];
    [self.dianzanIconsView addGestureRecognizer:tapIconsViewGster];
    
}

/** 设置内容label的truncationToken */
- (void)addTruncationToken {//
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...查看更多"];
//    YYTextHighlight *hi = [YYTextHighlight new];
//    [hi setColor:HEXRGBCOLOR(0xa5a5a5)];
//    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        //NSLog(@"-------查看更多-------");
//        if (_moreBtnClickedBlock) {
//            self.moreBtnClickedBlock();
//        }
//    };
//    [text yy_setFont:[UIFont systemFontOfSize:12] range:[text.string rangeOfString:@"查看更多"]];
//    [text yy_setColor:HEXRGBCOLOR(0xa5a5a5) range:[text.string rangeOfString:@"查看更多"]];
//    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"查看更多"]];
//    
//    YYLabel *seeMore = [YYLabel new];
//    seeMore.attributedText = text;
//    [seeMore sizeToFit];
//    NSAttributedString *truncationToken = [NSAttributedString
//                                           yy_attachmentStringWithContent:seeMore
//                                           contentMode:UIViewContentModeBottomRight
//                                           attachmentSize:seeMore.size
//                                           alignToFont:[UIFont systemFontOfSize:11]
//                                           alignment:YYTextVerticalAlignmentBottom];
//    _yyLabel.truncationToken = truncationToken;
    
    _yyLabel.userInteractionEnabled = YES;
    _yyLabel.numberOfLines = 0;
    _yyLabel.textContainerInset = UIEdgeInsetsMake(1, 0, 0, 0);
    _yyLabel.textAlignment = NSTextAlignmentLeft;
    _yyLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _yyLabel.textParser = [YYTextMatchBindingParser new];
}

- (void)layoutSubviews {//
    [super layoutSubviews];
    
    self.headNameLabelHeight.constant = _modelF.headNameLabelHeight;
    self.headUnivLabelHeight.constant = _modelF.headUnivLabelHeight;
    self.contntViewImageV.constant = _modelF.contntViewImageVHeight;
    self.contntViewImageVX.constant = _modelF.contntViewImageVX;
    
    self.fstCreatorViewW.constant = _modelF.fstCreatorViewW;
    self.fstCreatorViewH.constant = _modelF.fstCreatorViewH;
    self.secCreatorViewW.constant = _modelF.secCreatorViewW;
    self.secCreatorViewH.constant = _modelF.secCreatorViewH;
    
    self.contntViewTextV.constant = _modelF.contntViewTextVHeight;
    self.yyLabel.attributedText = _modelF.model.contentAtt;
    self.commentViewH.constant = _modelF.commentViewVHeight;
    self.addressViewHeight.constant = _modelF.addressViewHeight;
    
    if (_modelF.model.mediaType==2) {
        _muteButton.frame = CGRectMake(4, _modelF.contntViewImageVHeight - 30, 26, 26);
        self.muteButton.hidden = NO;
    } else {
        self.muteButton.hidden = YES;
    }
    
    
    [self setCreatorContent];
    
    
    //具体评论内容
    if (_modelF.mReplayAtt.count > 0) {
        int tmpY = 0;
        for (int i=0; i< _modelF.mReplayAtt.count; i++) {
            self.replayLabelArr[i].attributedText = _modelF.mReplayAtt[i];
            int rowH = HSGH_REPLAY_LINEHEIGHT*[_modelF.mReplayAttRow[i] intValue];
            self.replayLabelArr[i].frame = CGRectMake(10, tmpY, HSGH_SCREEN_WIDTH-20, rowH);
            tmpY += rowH;
            tmpY += HSGH_REPLAY_LINESPACE;//多条评论之间的距离
        }
    }
    
}
//- (void)setModelF:(HSGHHomeQQianModelFrame *)modelF showDistance:(BOOL)show;//
- (void)setModelF:(HSGHHomeQQianModelFrame *)modelF showDistance:(BOOL)showDistance {
    
    _modelF = modelF;
    _showDistance = showDistance;
    
    //设置具体内容
    [self setHeadContent];//设置head具体内容
    
    self.videoPath = @"";
    _muteButton.hidden = YES;
    //modelF.model.image
    if (_modelF.model.image != nil) {
        UIImage *holdImage = [UIImage imageNamed:@"contentHoldImage"];
        if (_modelF.model.mediaType == 2 ) {//视频
            self.videoPath = _modelF.model.image.srcUrl;
            self.muteButton.hidden = NO;
            
            self.cntImageView.userInteractionEnabled = YES;
            
            NSString *thumbStr = _modelF.model.image.thumbUrl;
            UIImage *thumbImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbStr];
            if (thumbImage) {
                self.cntImageView.image = thumbImage;
            } else {
                NSURL *thumbUrl = [NSURL URLWithString:thumbStr];
                [self.cntImageView sd_setImageWithURL:thumbUrl placeholderImage:holdImage
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                self.cntImageView.alpha = 0.0f;
//                                                [UIView transitionWithView:self.cntImageView
//                                                                  duration:0.5
//                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                                                                animations:^{
//                                                                    [self.cntImageView setImage:image];
//                                                                    self.cntImageView.alpha = 1.0;
//                                                                } completion:nil];
//
                                            }];
            }
            
        } else {//图片
            //cntImageViewself.cntImageView.videoPlayURL = nil; //For video //
            NSString *srcStr = _modelF.model.image.srcUrl;
            //NSURL *thumbUrl = [NSURL URLWithString:_modelF.model.image.thumbUrl];
            
            UIImage *srcImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:srcStr];
            if (srcImage) {
                self.cntImageView.image = srcImage;
            } else {
                NSURL *srcUrl = [NSURL URLWithString:srcStr];
                [self.cntImageView sd_setImageWithURL:srcUrl placeholderImage:holdImage
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                self.cntImageView.alpha = 0.0f;
//                                                [UIView transitionWithView:self.cntImageView
//                                                                  duration:0.5
//                                                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                                                                animations:^{
//                                                                    [self.cntImageView setImage:image];
//                                                                    self.cntImageView.alpha = 1.0;
//                                                                } completion:nil];
                    
                }];
            }
            
        }
    }
    
    [self setToolContent];//设置tool具体内容
    //[self clearCommentContent];//comment
        
    [self layoutIfNeeded];
  
}

//转发时 设置原创作者视图
- (void)setCreatorContent {
    if ([_modelF.model.forward intValue]==1 ) {
        UIImage *defaultSchoolIcon = [UIImage imageNamed:@"defaultSchoolIcon"];
        
        NSString *cName = _modelF.model.creator.displayName;
        NSString *unName = _modelF.model.creator.unvi.name;
        NSString *cImgurl = _modelF.model.creator.picture.thumbUrl;
        NSString *unImgurl = _modelF.model.creator.unvi.iconUrl;
        BOOL anony = (_modelF.model.creator.userId == nil) || [_modelF.model.creator.userId isEqualToString:@""];
        
        if (_modelF.fstCreatorViewH > 0) {
            
            //匿名
            if (anony) {
                self.fstCreatorImg.image = [UIImage imageNamed:@"anoicon"];
                self.fstCreatorUnImg.image = defaultSchoolIcon;
            } else {
                [self.fstCreatorImg sd_setImageWithURL:[NSURL URLWithString:cImgurl] placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
                [self.fstCreatorUnImg sd_setImageWithURL:[NSURL URLWithString:unImgurl] placeholderImage:defaultSchoolIcon];
            }
            //[self.fstCreatorImg sd_setImageWithURL:[NSURL URLWithString:cImgurl] placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
            //[self.fstCreatorUnImg sd_setImageWithURL:[NSURL URLWithString:unImgurl] placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]];
            self.fstCreatorName.text = cName;
            self.fstCreatorUnName.text = unName;
            
            //转发 加好友按钮
            self.fstCreatorAddButton.hidden = YES;
            self.fstCreatorApplingButton.hidden = YES;
            self.fstCreatorApplyingLabel.hidden = YES;
            if ([_modelF.model.friendStatus intValue]==0) {//显示加好友
                self.fstCreatorAddButton.hidden = NO;
            } else if ([_modelF.model.friendStatus intValue]==3) {//申请中
                self.fstCreatorAddButton.hidden = YES;
                self.fstCreatorApplingButton.hidden = NO;
                self.fstCreatorApplyingLabel.hidden = NO;
            }
            
            self.fstCreatorView.alpha = 0.8;//重新移动到视野内的cell 不隐藏
            
        } else {
            //匿名
            if (anony) {
                self.secCreatorImg.image = [UIImage imageNamed:@"anoicon"];
                self.secCreatorUnImg.image = defaultSchoolIcon;
            } else {
                [self.secCreatorImg sd_setImageWithURL:[NSURL URLWithString:cImgurl] placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
                [self.secCreatorUnImg sd_setImageWithURL:[NSURL URLWithString:unImgurl] placeholderImage:defaultSchoolIcon];
            }
            self.secCreatorName.text = cName;
            self.secCreatorUnName.text = unName;
            
            //转发 加好友按钮
            self.secCreatorAddButton.hidden = YES;
            self.secCreatorApplyingButton.hidden = YES;
            self.secCreatorApplyingLabel.hidden = YES;
            if ([_modelF.model.friendStatus intValue]==0) {//显示加好友
                self.secCreatorAddButton.hidden = NO;
            } else if ([_modelF.model.friendStatus intValue]==3) {//申请中
                self.secCreatorAddButton.hidden = YES;
                self.secCreatorApplyingButton.hidden = NO;
                self.secCreatorApplyingLabel.hidden = NO;
            }
        }
        
    }
}

- (void)setHeadContent {
    //匿名标识
    BOOL anony = (_modelF.model.creator.userId == nil) || [_modelF.model.creator.userId isEqualToString:@""];
    BOOL isme = [_modelF.model.friendStatus intValue]==1 ? YES : NO;
    //[[HSGHUserInf shareManager].userId isEqualToString:_modelF.model.creator.userId];
    
    if(anony){
        
        if ([_modelF.model.forward intValue]==1) {//我转发
            self.headSchoolIcon.hidden = NO;
            self.headNameLabel.text = _modelF.model.owner.displayName;
            self.headSchoolLabel.text = _modelF.model.owner.unvi.name;
            NSURL *headurl = [NSURL URLWithString:_modelF.model.owner.picture.thumbUrl];
            [self.headHeadIcon sd_setImageWithURL:headurl placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
            NSURL *unviurl = [NSURL URLWithString:_modelF.model.owner.unvi.iconUrl];
            [self.headSchoolIcon sd_setImageWithURL:unviurl placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]];
            
        } else {
            //匿名
            self.headNameLabel.text = @"";
            self.headSchoolLabel.text = @"";
            self.headHeadIcon.image = [UIImage imageNamed:@"anoicon"];
            self.headSchoolIcon.hidden = YES;
        }
        
        
    } else {
        
        if ([_modelF.model.forward intValue]==1) {//转发的 头部用owner
            self.headSchoolIcon.hidden = NO;
            self.headNameLabel.text = _modelF.model.owner.displayName;
            self.headSchoolLabel.text = _modelF.model.owner.unvi.name;
            NSURL *headurl = [NSURL URLWithString:_modelF.model.owner.picture.thumbUrl];
            [self.headHeadIcon sd_setImageWithURL:headurl placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
            NSURL *unviurl = [NSURL URLWithString:_modelF.model.owner.unvi.iconUrl];
            [self.headSchoolIcon sd_setImageWithURL:unviurl placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]];
            
        } else {
            self.headSchoolIcon.hidden = NO;
            self.headNameLabel.text = _modelF.model.creator.displayName;
            self.headSchoolLabel.text = _modelF.model.creator.unvi.name;
            NSURL *headurl = [NSURL URLWithString:_modelF.model.creator.picture.thumbUrl];
            [self.headHeadIcon sd_setImageWithURL:headurl placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
            NSURL *unviurl = [NSURL URLWithString:_modelF.model.creator.unvi.iconUrl];
            [self.headSchoolIcon sd_setImageWithURL:unviurl placeholderImage:[UIImage imageNamed:@"defaultSchoolIcon"]];
            
        }
    }
    
//    {
//        FRIEND_NONE = 0,//不是好友
//        FRIEND_SELF = 1,//自己发的新鲜事
//        FRIEND_TO = 3, // 我发过申请
//        FRIEND_FROM = 4, //对方向你发送了好友请求 ？？？
//        FRIEND_ALL = 2,//已经是好友
//        FRIEND_UKNOW = 5,//给我发送过
//        FRIEND_MODE_ONE = 11,//通过当前新鲜事成为好友
//        FRIEND_MODE_TWO = 12,//不是通过当前新鲜事成为好友
//    } HSGH_FRIEND_MODE;
    
    
    int friendStatus = [_modelF.model.friendStatus intValue];
    if (friendStatus==FRIEND_NONE || friendStatus==FRIEND_UKNOW) {
        //显示加好友按钮
        self.addFriendButton.hidden = NO;
        self.friendApplyingLabel.hidden = YES;
        self.friendApplyingButton.hidden = YES;
        
    } else if (friendStatus==FRIEND_TO) {
        //申请中
        self.addFriendButton.hidden = YES;
        self.friendApplyingLabel.hidden = NO;
        self.friendApplyingButton.hidden = NO;
        
    }
//    else if (friendStatus==FRIEND_FROM || friendStatus==FRIEND_UKNOW) {
//        //待同意
//        self.addFriendButton.hidden = YES;
//        self.friendApplyingLabel.hidden = YES;
//        self.friendApplyingButton.hidden = YES;
//        
//    }
    else {
        //已是好友
        self.addFriendButton.hidden = YES;
        self.friendApplyingLabel.hidden = YES;
        self.friendApplyingButton.hidden = YES;
    }
    
    //自己发的
    if (isme || anony || [_modelF.model.forward intValue]==1) {//自己发的 + 匿名 + 转发的
        self.addFriendButton.hidden = YES;
        self.friendApplyingLabel.hidden = YES;
        self.friendApplyingButton.hidden = YES;
    }

}

/** 设置tool具体内容 */
- (void)setToolContent {
    //时间
    self.timeLabel.text = [HSGHTools getLocalDateFormateUTCDate:_modelF.model.createTime];
    
    BOOL isme = [self.modelF.model.isSelf intValue] == 1 ? YES : NO;//我自己发的
    //距离我5km
    if (!self.showDistance || isme || _modelF.model.address==nil
        || _modelF.model.address.type==0 ) {//不显示距离我 + 我发的 + model.address为空 + type为0
        self.distanceLabel.hidden = YES;
        self.leftDistanceView.hidden = YES;
    
    } else {
        NSString *distanceStr = [self getDistanceStr:_modelF.model.address.distance andType:_modelF.model.address.type];
        self.distanceLabel.text = distanceStr;
        self.leftDistanceView.hidden = NO;
        self.distanceLabel.hidden = NO;
    }
    
    //地点address
    if (_modelF.model.address != nil && _modelF.model.address.address!= nil) {
        self.addressLabel.text = _modelF.model.address.address;
        self.addressIcon.hidden = NO;
        //self.rightDistanceView.hidden = NO;
        self.addressViewHeight.constant = _modelF.addressViewHeight;//14;
    } else {
        self.addressLabel.text = @"";
        self.addressIcon.hidden = YES;
        //self.rightDistanceView.hidden = YES;
        self.addressViewHeight.constant = 0;
    }
    
    //转发图标
    if ([self.modelF.model.friendStatus intValue]==1 || self.modelF.model.hasForward==1) {//自己发的 + hasForward
        [self.forwardButton setImage:[UIImage imageNamed:@"common_icon_zf_ed"] forState:UIControlStateNormal];
    } else {
        [self.forwardButton setImage:[UIImage imageNamed:@"common_icon_zf_n"] forState:UIControlStateNormal];
    }
    NSString *forwordLText = @"";
    if ([_modelF.model.forwardCount intValue]!=0) {
        forwordLText = [NSString stringWithFormat:@"%@",_modelF.model.forwardCount];
    }
    self.forwordL.text = forwordLText;
    
    //评论
    NSString *freplyLText = @"";
    if ([_modelF.model.replyCount intValue]!=0) {
        freplyLText = [NSString stringWithFormat:@"%@",_modelF.model.replyCount];
    }
    self.replyL.text = freplyLText;
    
    //点赞
    [self setDianzanImageIcon];
}

//点赞
- (void)setDianzanImageIcon {
    self.upL.text = [NSString stringWithFormat:@"%zd人赞",[_modelF.model.upCount intValue]];
    if ([_modelF.model.up intValue]==0) {
        self.dianzanIcon.image = [UIImage imageNamed:@"common_icon_dz_n"];
    } else {
        self.dianzanIcon.image = [UIImage imageNamed:@"common_icon_dz_s"];
    }
    int upcnt = [_modelF.model.upCount intValue];
    if (upcnt > MAX_UP_COUNT) {
        upcnt = MAX_UP_COUNT;
    }
    if (upcnt<1) {
        self.dianzanIconsViewWidth.constant = 0;
    } else {
        self.dianzanIconsViewWidth.constant = 30*upcnt + 4*(upcnt-1);
        
        for (int i=0; i<upcnt; i++) {
            NSString *urlStr = [NSString stringWithFormat:@"%@",_modelF.model.partUp[i].picture.thumbUrl];
            UIImageView *imgV = (UIImageView *)self.dianzanIconsView.subviews[i].subviews[0];
            [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon-news-xttz"]];
        }
    }
}

#pragma mark - cell 点击事件

/** 点击head分享按钮 */
- (IBAction)headShareBtnClick:(id)sender {
    HSLog(@"点击head分享按钮");
    if (_headShareBtnClickBlock) {
        self.headShareBtnClickBlock();
    }
}

/** 点击头像 */
- (IBAction)headHeadIconClick:(id)sender {
    HSLog(@"---headHeadIconClick---");
    
    NSString *currUserId = self.modelF.model.owner.userId;
    if([currUserId isEqualToString:@""]||currUserId == nil || [currUserId isEqualToString:[HSGHUserInf shareManager].userId]){//匿名 我
        return ;
    } else {
        [HSGHZoneVC enterOtherZone:currUserId];
    }
}
//
/** 点击加好友 */
- (IBAction)addFriendButtonClick:(id)sender {
    HSLog(@"---addFriendButtonClick---");
    
    int friendStatus = [_modelF.model.friendStatus intValue];
    if (friendStatus==FRIEND_UKNOW) {//5 加过我  直接成为好友
        self.addFriendButton.hidden = YES;
        self.friendApplyingLabel.hidden = YES;
        self.friendApplyingButton.hidden = YES;
    } else {
        self.addFriendButton.hidden = YES;
        self.friendApplyingLabel.hidden = NO;
        self.friendApplyingButton.hidden = NO;
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HSGHFriendViewModel addFriend:self.modelF.model.qqianId replyID:nil block:^(BOOL success) {
            if (success) {
                if (friendStatus==FRIEND_UKNOW) {
                    self.modelF.model.friendStatus = @2;
                } else {
                    self.modelF.model.friendStatus = @3;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_POST_2_FRIEND_ADDME_NOTIFI object:nil];
                
                
                HSLog(@"发送ok");
                //Toast *toast = [[Toast alloc] initWithText:@"好友请求发送成功!" delay:0 duration:1.f];
                //[toast show];
                
            } else {
                HSLog(@"发送失败");
                //Toast *toast = [[Toast alloc] initWithText:@"好友请求发送失败!" delay:0 duration:1.f];
                //[toast show];
            }
        }];
    });
}

/** fstCreator加好友 */
- (IBAction)fstCreatorAddBtnClick:(id)sender {
    HSLog(@"---fstCreatorAddBtnClick---");
    self.fstCreatorAddButton.hidden = YES;
    self.fstCreatorApplingButton.hidden = NO;
    self.fstCreatorApplyingLabel.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HSGHFriendViewModel addFriend:self.modelF.model.qqianId replyID:nil block:^(BOOL success) {
            if (success) {
                self.modelF.model.friendStatus = @3;
                HSLog(@"发送ok");
            } else {
                HSLog(@"发送失败");
            }
        }];
    });
}
/** secCreator加好友 */
- (IBAction)secCreatorAddBtnClick:(id)sender {
    HSLog(@"---secCreatorAddBtnClick---");
    self.secCreatorAddButton.hidden = YES;
    self.secCreatorApplyingButton.hidden = NO;
    self.secCreatorApplyingLabel.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HSGHFriendViewModel addFriend:self.modelF.model.qqianId replyID:nil block:^(BOOL success) {
            if (success) {
                self.modelF.model.friendStatus = @3;
                HSLog(@"发送ok");
            } else {
                HSLog(@"发送失败");
            }
        }];
    });
}

/** 点击creator跳转到creator主页 */
- (void)creatorViewTap:(UITapGestureRecognizer *)g {
    NSString *currUserId = _modelF.model.creator.userId;
    HSLog(@"---------creatorViewTap-----------%@,wo:%@",currUserId,[HSGHUserInf shareManager].userId);
    if([currUserId isEqualToString:@""]||currUserId == nil || [[HSGHUserInf shareManager].userId isEqualToString:currUserId]){//匿名 我
        return ;
    } else {
        [HSGHZoneVC enterOtherZone:currUserId];
    }
}


/** 长按内容图片加好友 */
- (void)longPressIMGGestAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
//        [UIView animateWithDuration:0.5f animations:^{
//            UIView.animationRepeatCount  = 3;
//            self.cntImageView.alpha = 0.3;
//            [self layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            self.cntImageView.alpha = 1.0;
//        }];
        
        if (self.addFriendButton.hidden == NO) {//需要处理
            [self addFriendButtonClick:nil];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
//        self.cntImageView.alpha = 1.0f;
//        [self.cntImageView.layer removeAllAnimations];
    }
}

- (void)longPressGestAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
//        [UIView animateWithDuration:0.5f animations:^{
//            UIView.animationRepeatCount  = 3;
//            self.yyLabel.alpha = 0.3;
//            [self layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            self.yyLabel.alpha = 1.0;
//        }];
        
        if (self.addFriendButton.hidden == NO) {//需要处理
            [self addFriendButtonClick:nil];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
//        self.yyLabel.alpha = 1.0f;
//        [self.yyLabel.layer removeAllAnimations];
    }
}


/** 点击转发 */
- (IBAction)forwardBtnClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    if ([self.modelF.model.isSelf intValue]==1) {
        Toast *toast = [[Toast alloc] initWithText:@"不可以转发自己的新鲜事" delay:0 duration:1.f];
        [toast show];
        
    } else if (self.modelF.model.hasForward==1) {
        Toast *toast = [[Toast alloc] initWithText:@"每件新鲜事只可转发一次" delay:0 duration:1.f];
        [toast show];
        
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *keyStr = [NSString stringWithFormat:@"%@_forward_tipnum",[HSGHUserInf shareManager].userId];
        int tipnum = [[defaults valueForKey:keyStr] intValue];
        if (tipnum < 3) {
            Toast *toast = [[Toast alloc] initWithText:@"仅你的好友中还未与源作者成为好友的人可见" delay:0 duration:3.f];
            [toast show];
            tipnum++;
            [defaults setValue:@(tipnum) forKey:keyStr];
            [defaults synchronize];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(_forwardBtnClickBlock){
                self.forwardBtnClickBlock();
            }
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });

}

/** 点击评论按钮 */
- (IBAction)commonBtnClick:(id)sender {
    if(_commonBtnClickBlock){
        self.commonBtnClickBlock();
    }
}


/** 点赞 */
- (IBAction)dianzanClick:(UIButton *)sender {
    int up = [self.modelF.model.up intValue];
    if (up==0) {//还没有点赞
        sender.userInteractionEnabled = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.cntImageView.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
        });
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect frame = [window convertRect:sender.frame fromView:sender.superview];
        if (_upBtnClickBlock) {
            self.upBtnClickBlock(frame);
        }
    }
}

/** 双击图片 或者双击内容文字点赞 */
- (void)doubleTap:(UIGestureRecognizer *)gestureRecognizer {
    int up = [self.modelF.model.up intValue];
    if (up==0) {//还没有点赞
        self.cntImageView.userInteractionEnabled = NO;
        _yyLabel.userInteractionEnabled = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.cntImageView.userInteractionEnabled = YES;
            _yyLabel.userInteractionEnabled = YES;
        });
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect frame = [window convertRect:self.dianzanIcon.frame fromView:self.dianzanIcon.superview];
        if (_upBtnClickBlock) {
            self.upBtnClickBlock(frame);
        }
    }
}
    
- (void)imgTap:(UITapGestureRecognizer *)g {
    //self.fstCreatorView.hidden = !self.fstCreatorView.hidden;
    
    [UIView animateWithDuration:0.8 animations:^{
        if (self.fstCreatorView.alpha == 0) {
            self.fstCreatorView.alpha = 0.8;
        } else {
            self.fstCreatorView.alpha = 0;
        }
    }];
}
    

/** 单击评论去头像列表跳转 */
- (void)tapIconsViewGsterAction:(UIGestureRecognizer *)gestureRecognizer {
    if (_toolIconsViewClickBlock) {
        self.toolIconsViewClickBlock();
    }
}

/** 单击评论区跳转 */
- (void)tapGsterAction:(UIGestureRecognizer *)gestureRecognizer {
    if(_commonBtnClickBlock){
        self.commonBtnClickBlock();
    }
}

/** 清空comment内容 */
- (void)clearCommentContent {
    if (_modelF.mReplayAtt.count < 1) {
        for (YYLabel *replayL in self.replayLabelArr) {//清空3个评论label
            replayL.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}

#pragma mark - getter and setter
    
- (UIButton*)muteButton {
    if (!_muteButton) {
        _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteButton setBackgroundImage:[UIImage imageNamed:@"videoMicroOpen"] forState:UIControlStateNormal];
        [_muteButton setBackgroundImage:[UIImage imageNamed:@"videoMicroClose"] forState:UIControlStateSelected];
        
        [_muteButton addTarget:self action:@selector(clickMute:) forControlEvents:UIControlEventTouchUpInside];
        _muteButton.selected = YES;
        [self.cntImageView addSubview:_muteButton];
        //_muteButton.hidden = YES;
    }
    return _muteButton;
}
    
- (void)clickMute:(UIButton*)sender {
    _muteButton.selected = !_muteButton.selected;
    [[JPVideoPlayerManager sharedManager] setPlayerMute:_muteButton.selected];
}

- (NSMutableArray *)replayLabelArr {
    if (_replayLabelArr == nil) {
        _replayLabelArr = [NSMutableArray array];
    }
    return _replayLabelArr;
}
    
- (NSString*)getDistanceStr:(float)distance andType:(int)type {
//    if (0==distance) {
//        return @"";
//    }
    //1.表示新鲜事  此刻距你5km以内 ，2表示人   TA距你200km以内    type=0 不显示
    if (1==type) {
        //return [NSString stringWithFormat:@"此刻距你%@以内",disStr];
        if (distance <= 5) {
            return [NSString stringWithFormat:@"此刻距你5km以内"];
        } else if (distance <= 10) {
            return [NSString stringWithFormat:@"此刻距你10km以内"];
        } else if (distance <= 20) {
            return [NSString stringWithFormat:@"此刻距你20km以内"];
        } else if (distance <= 50) {
            return [NSString stringWithFormat:@"此刻距你50km以内"];
        } else if (distance <= 100) {
            return [NSString stringWithFormat:@"此刻距你100km以内"];
        } else if (distance <= 1000) {
            //return [NSString stringWithFormat:@"此刻距你100km以内"];
            int tmpV = distance / 100;
            return [NSString stringWithFormat:@"此刻距你%zd00km以内",tmpV];
        } else if (distance <= 10000) {
            //return [NSString stringWithFormat:@"此刻距你100km以内"];
            int tmpV = distance / 1000;
            return [NSString stringWithFormat:@"此刻距你%zd000km以内",tmpV];
        } else {
            return [NSString stringWithFormat:@"很远"];
        }
        
    } else {
        //return [NSString stringWithFormat:@"TA距您%@以内",disStr];
        if (distance <= 5) {
            return [NSString stringWithFormat:@"TA距你5km以内"];
        } else if (distance <= 10) {
            return [NSString stringWithFormat:@"TA距你10km以内"];
        } else if (distance <= 20) {
            return [NSString stringWithFormat:@"TA距你20km以内"];
        } else if (distance <= 50) {
            return [NSString stringWithFormat:@"TA距你50km以内"];
        } else if (distance <= 100) {
            return [NSString stringWithFormat:@"TA距你100km以内"];
        } else if (distance <= 1000) {
            //return [NSString stringWithFormat:@"TA距你100km以内"];
            int tmpV = distance / 100;
            return [NSString stringWithFormat:@"TA距你%zd00km以内",tmpV];
        } else if (distance <= 10000) {
            //return [NSString stringWithFormat:@"TA距你100km以内"];
            int tmpV = distance / 1000;
            return [NSString stringWithFormat:@"TA距你%zd000km以内",tmpV];
        } else {
            return [NSString stringWithFormat:@"很远"];
        }
    }
}

- (void)refreshDianzan {
    [self setDianzanImageIcon];
}
@end
