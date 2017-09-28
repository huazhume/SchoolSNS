//
//  HSGHHomeMainCellToolsView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMeToolView.h"
#import "HSGHTools.h"
#import "HSGHFabuCollectionViewCell.h"
#import "AppDelegate.h"
#import "HSGHHomeModel.h"
#import "HSGHUserInf.h"
#import "HSGHNetworkSession.h"
#import "HSGHZoneVC.h"
#import "HSGHTools.h"
#import "HSGHFriendViewModel.h"

@interface HSGHMeToolView () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
}

@property(strong, nonatomic) NSArray<HSGHHomeUp *> *dataList;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardWidth;
@property (strong, nonatomic)HSGHHomeQQianModel * qqianVo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentWidth;
@property (weak, nonatomic) IBOutlet UILabel *addingLab;

@end

@implementation HSGHMeToolView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"HSGHMeToolView"
                                  owner:self
                                options:nil];
    self.view.frame =
    CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.view];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:
     [UINib nibWithNibName:@"HSGHFabuCollectionViewCell"
                    bundle:nil]
          forCellWithReuseIdentifier:@"faceCell"];
    
    CGFloat space = (HSGH_SCREEN_WIDTH - 150 - 24)/4.0;
    self.firstTosecond.constant = space;
    self.secondToThird.constant = space;
    self.thirdToFourth.constant = space;
}


- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF {
    
    _qqianVo = modelF.model;
    // 设置约束
    
    // 时间
    
    self.timeLab.text = [HSGHTools getLocalDateFormateUTCDate:modelF.model.createTime];
    self.timeWidth.constant =
    [HSGHTools widthOfString:self.timeLab.text
                        font:self.timeLab.font
                      height:self.timeLab.frame.size.height]
    + 2;
    
    // 位置
    
    if (modelF.model.address.address.length == 0) {
        [self.locationLab setTitle:@""
                          forState:UIControlStateNormal];
        self.locationImage.hidden = YES;
    } else {
        self.locationImage.hidden = NO;
        //        if(modelF.model.address.address.length > 6){
        //            [self.locationLab setTitle:[modelF.model.address.address substringToIndex:5]
        //                              forState:UIControlStateNormal];
        //        }else{
        [self.locationLab setTitle:modelF.model.address.address
                          forState:UIControlStateNormal];
        
        //        }
    }
    self.locationWidth.constant =
    [HSGHTools widthOfString:self.locationLab.titleLabel.text
                        font:self.locationLab.titleLabel.font
                      height:self.locationLab.frame.size.height]
    + 2;
    
    // 转发数
    
    if ([modelF.model.forwardCount integerValue] == 0) {
        self.forwardLab.text =
        [NSString stringWithFormat:@""];
        self.forwardWidth.constant =10;
        
    } else {
        NSString* string = @"";
        if ([modelF.model.forwardCount integerValue] > 1000) {
            
            string = [NSString stringWithFormat:@"%ldk", [modelF.model.forwardCount integerValue] / 1000];
        } else {
            string = [NSString stringWithFormat:@"%@", modelF.model.forwardCount];
        }
        self.forwardLab.text = string;
        self.forwardWidth.constant = [HSGHTools widthOfLab:self.forwardLab];
    }
    
    //评论数
    if ([modelF.model.replyCount integerValue] == 0) {
        self.commentLab.text =
        [NSString stringWithFormat:@""];
        self.commentWidth.constant = 10;
        
    } else {
        NSString* string = @"";
        
        if ([modelF.model.replyCount integerValue] > 1000) {
            
            string = [NSString stringWithFormat:@"999+"];
        } else {
            string = [NSString stringWithFormat:@"%@", modelF.model.replyCount];
        }
        self.commentLab.text = string;
        self.commentWidth.constant = [HSGHTools widthOfLab:self.commentLab];
    }
    
    // 点赞头像
    [HSGHFriendViewModel fetchAddBtnStateWithCurrentUserId:modelF.model.creator.userId WithOtherId:nil WithQQianMode:QQIAN_HOME FriendMode:0 WithMode:modelF.model.friendStatus WithBtn:self.addBtn WithAddLabel:self.addingLab];
    _dataList = [NSArray arrayWithArray:modelF.model.partUp];
    
    if(_isFriend){
        CGFloat colletionWidth = HSGH_SCREEN_WIDTH - self.commentLab.frame.origin.x - self.commentLab.size.width ;
        NSInteger number = colletionWidth / (30 + 5);
        if ((number - 1) > _dataList.count) {
            self.collectionWidth.constant = (_dataList.count + 1) * (30 + 5) - 5;
    
        } else {
            self.collectionWidth.constant = number * (30 + 5) - 5;
            _dataList = [_dataList subarrayWithRange:NSMakeRange(0, number - 1)];
        }
        self.addBtn.hidden = YES;
    }else{
        _dataList = [NSArray array];
        self.collectionWidth.constant = 30;
    }
    [self.collectionView reloadData];

    if(modelF.toolHeight > 60){
        self.upLab.hidden = NO;
    }else {
        self.upLab.hidden = YES;
    }
    
    if([_qqianVo.up boolValue] == true){//自己点赞了
        [self.upBtn setImage:[UIImage imageNamed:@"icon_dz_s"]
                                 forState:UIControlStateNormal];
    }else{
        [self.upBtn setImage:[UIImage imageNamed:@"common_icon_dz_n"]
                                 forState:UIControlStateNormal];
    }
    [self.upBtn addTarget:self action:@selector(upBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ( [modelF.model.upCount integerValue] != 0) {
        self.upLab.text = [NSString stringWithFormat:@"%@人赞", modelF.model.upCount];
    } else {
        self.upLab.text = [NSString stringWithFormat:@"0人赞"];
    }
    
}
- (void)upBtnClicked:(UIButton *)btn {
    if ([_qqianVo.up integerValue] == 0) {
        //点赞
        //            [[AppDelegate instanceApplication]indicatorShow];
        [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
                       appendParams:@{
                                      @"qqianId" : _qqianVo.qqianId,
                                      }
                        returnClass:[self class]
                              block:^(id obj, NetResStatus status, NSString *errorDes) {
                                  //                                     [[AppDelegate instanceApplication]indicatorDismiss];
                                  if (status == 0) {
                                      //点赞成功
                                      //                                          self.block(3000);
                                  } else {
                                      
                                      //                                          [[[UIAlertView alloc] initWithTitle:@""
                                      //                                                                      message:@"点赞失败咯"
                                      //                                                                     delegate:nil
                                      //                                                            cancelButtonTitle:@"确定"
                                      //                                                            otherButtonTitles:nil] show];
                                  }
                              }];
        self.block(3000);
    }else{
        //进点赞列表
        self.block(4000);
    }
}




#pragma mark - delagate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataList.count + 1;
}
- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGHFabuCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"faceCell"
                                              forIndexPath:indexPath];
    [cell.userIcon addTarget:self
                      action:@selector(btnClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    cell.userIcon.tag = indexPath.row;
    if (indexPath.row == _dataList.count) {
        // 如果自己点赞啦
        if ([_qqianVo.up boolValue] == true) {
            
            cell.userIcon.hidden = NO;
            cell.userBack.hidden = YES;
            //            cell.userBack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_dz_s"]];
            [cell.userIcon setBackgroundImage:[UIImage imageNamed:@"icon_dz_s"]
                                     forState:UIControlStateNormal];
            
        } else {
            cell.userIcon.hidden = NO;
            cell.userBack.hidden = YES;
            [cell.userIcon setBackgroundImage:[UIImage imageNamed:@"common_icon_dz_n"]
                                     forState:UIControlStateNormal];
        }
    } else {
        cell.userBack.hidden = NO;
        cell.userIcon.hidden = NO;
        cell.userBack.layer.borderColor = [[UIColor colorWithRed:200 / 255.0
                                                           green:200 / 255.0
                                                            blue:200 / 255.0
                                                           alpha:1] CGColor];
        [cell.userIcon
         sd_setBackgroundImageWithURL:[NSURL
                                       URLWithString:_dataList[indexPath.row]
                                       .picture.srcUrl]
         forState:UIControlStateNormal
         placeholderImage:[[UIImage imageNamed:@"usernone"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]

         options:SDWebImageAllowInvalidSSLCertificates
         completed:^(UIImage *image, NSError *error,
                     SDImageCacheType cacheType,
                     NSURL *imageURL) {
             if (image) {
                 [cell.userIcon setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                 
             }
         }];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(29, 29);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)
collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)
collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//选中

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)btnClicked:(UIButton *)btn {
    if (btn.tag == _dataList.count) {
        if ([_qqianVo.up integerValue] == 0) {
            //点赞
            //            [[AppDelegate instanceApplication]indicatorShow];
            [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
                           appendParams:@{
                                          @"qqianId" : _qqianVo.qqianId,
                                          }
                            returnClass:[self class]
                                  block:^(id obj, NetResStatus status, NSString *errorDes) {
                                      //                                     [[AppDelegate instanceApplication]indicatorDismiss];
                                      if (status == 0) {
                                          //点赞成功
                                          //                                          self.block(3000);
                                      } else {
                                          
                                          //                                          [[[UIAlertView alloc] initWithTitle:@""
                                          //                                                                      message:@"点赞失败咯"
                                          //                                                                     delegate:nil
                                          //                                                            cancelButtonTitle:@"确定"
                                          //                                                            otherButtonTitles:nil] show];
                                      }
                                  }];
            self.block(3000);
        }else{
            //进点赞列表
            self.block(4000);
        }
    } else {
        //进空间 _dataList[indexPath.row]
        NSString* userId = _dataList[btn.tag].userId;
        [HSGHZoneVC enterOtherZone:userId];
    }
}
- (IBAction)remove:(id)sender {
    if(self.block){
        self.block(5000);
    }
}

- (IBAction)addBtn:(id)sender {
    [HSGHFriendViewModel fetchFriendShipWithMode:_qqianVo.friendStatus WithBtn:(UIButton *)sender WithUserID:_qqianVo.creator.userId WithQqianId:_qqianVo.qqianId WithReplayId:nil WithCallBack:^(BOOL success, UIImage *image) {
        if(success){
//            self.block(2000,_qqianVo.qqianId);
                        [self.addBtn setImage:image forState:UIControlStateNormal];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"" message:@"加好友失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }
    }WithAddLabel:self.addingLab];

}




- (IBAction)commtBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.block(btn.tag);
}

@end
