
//
//  HSGHHomeMainCellToolsView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFirstToolsView.h"
#import "AppDelegate.h"
#import "HSGHFabuCollectionViewCell.h"
#import "HSGHHomeModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHTools.h"
#import "HSGHTools.h"
#import "HSGHUserInf.h"
#import "HSGHZoneVC.h"

@interface HSGHFirstToolsView () <
    UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
}

@property(strong, nonatomic) NSArray<HSGHHomeUp *> *dataList;
@property(weak, nonatomic) IBOutlet UIImageView *locationImage;

@property(strong, nonatomic) HSGHHomeQQianModel *qqianVo;

@end

@implementation HSGHFirstToolsView

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
  [[NSBundle mainBundle] loadNibNamed:@"HSGHFirstToolsView"
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
}

- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF

{
  _qqianVo = modelF.model;

  if (modelF.mode == QQIAN_FRIEND &&
      (modelF.friendMode == FRIEND_CATE_THIRD ||
       modelF.friendMode == FRIEND_CATE_SECOND)) {
    //加我
    self.collectionView.hidden = YES;
    self.forwardBtn.hidden = YES;
    self.forwardLab.hidden = YES;
    self.commentBtn.hidden = YES;
    self.commentLab.hidden = YES;
    self.upLab.hidden = YES;
  } else {
    self.collectionView.hidden = NO;
    self.forwardBtn.hidden = NO;
    self.forwardLab.hidden = NO;
    self.commentBtn.hidden = NO;
    self.commentLab.hidden = NO;
    self.upLab.hidden = NO;
  }
  // 我发的 显示黑色图标
   
    
    //转发图标
    if ([modelF.model.friendStatus intValue]==1 || modelF.model.hasForward==1) {//自己发的 + hasForward
        [self.forwardBtn setImage:[UIImage imageNamed:@"common_icon_zf_ed"] forState:UIControlStateNormal];
    } else {
        [self.forwardBtn setImage:[UIImage imageNamed:@"common_icon_zf_n"] forState:UIControlStateNormal];
    }
    

  // 时间

  self.timeLab.text =
      [HSGHTools getLocalDateFormateUTCDate:modelF.model.createTime];
  self.timeWidth.constant =
      [HSGHTools widthOfString:self.timeLab.text
                          font:self.timeLab.font
                        height:self.timeLab.frame.size.height] +
      2;

  // 位置

  if (modelF.model.address.address.length == 0 ||
      [modelF.model.address.address isEqualToString:@"不显示位置"]) {
    [self.locationLab setTitle:@"" forState:UIControlStateNormal];
    self.locationImage.hidden = YES;
  } else {
    self.locationImage.hidden = NO;
    //        if(modelF.model.address.address.length > 6){
    //            [self.locationLab setTitle:[modelF.model.address.address
    //            substringToIndex:5]
    //                              forState:UIControlStateNormal];
    //        }else{
    [self.locationLab setTitle:modelF.model.address.address
                      forState:UIControlStateNormal];

    //        }
  }
  self.locationWidth.constant =
      [HSGHTools widthOfString:self.locationLab.titleLabel.text
                          font:self.locationLab.titleLabel.font
                        height:self.locationLab.frame.size.height] +
      2;

  // 转发数

  if ([modelF.model.forwardCount integerValue] == 0) {
    self.forwardLab.text = [NSString stringWithFormat:@""];
    self.forwardWidth.constant = 10;

  } else {
    NSString *string = @"";
    if ([modelF.model.forwardCount integerValue] > 1000) {

      string = [NSString
          stringWithFormat:@"%ldk",
                           [modelF.model.forwardCount integerValue] / 1000];
    } else {
      string = [NSString stringWithFormat:@"%@", modelF.model.forwardCount];
    }
    self.forwardLab.text = string;
    self.forwardWidth.constant = [HSGHTools widthOfLab:self.forwardLab];
  }

  //评论数
  if ([modelF.model.replyCount integerValue] == 0) {
    self.commentLab.text = [NSString stringWithFormat:@""];
    self.commentWidth.constant = 10;

  } else {
    NSString *string = @"";

    if ([modelF.model.replyCount integerValue] > 1000) {

      string = [NSString stringWithFormat:@"999+"];
    } else {
      string = [NSString stringWithFormat:@"%@", modelF.model.replyCount];
    }
    self.commentLab.text = string;
    self.commentWidth.constant = [HSGHTools widthOfLab:self.commentLab];
  }

  // 点赞头像

  //    if((modelF.mode == QQIAN_MSG || modelF.mode ==
  //    QQIAN_FRIEND)&&modelF.model.partUp.count > 0){ //默认点开
  //        _qqianVo.up = @1;
  //    }
      _dataList = [NSArray arrayWithArray:modelF.model.partUp];
//    if(_dataList.count > 1){
//        HSGHHomeUp * up1 = _dataList[0];
//        NSMutableArray * _dataArr = [NSMutableArray arrayWithArray:_dataList];
//        [_dataArr enumerateObjectsUsingBlock:^(HSGHHomeUp * up2, NSUInteger idx, BOOL * _Nonnull stop) {
//            if(idx > 0){
//                if([up1.userId isEqualToString:up2.userId]){
//                    [_dataArr removeObjectAtIndex:idx];
//                }
//            }
//        }];
//        _dataList = [NSArray arrayWithArray:_dataArr];
//    }
  CGFloat colletionWidth =
      HSGH_SCREEN_WIDTH - self.commentLab.frame.origin.x - 35;

  NSInteger number = colletionWidth / (30 + 5);
  if ((number - 1) > _dataList.count) {
    self.collectionWidth.constant = (_dataList.count + 1) * (30 + 5) - 5;

  } else {
    self.collectionWidth.constant = number * (30 + 5) - 5;
    _dataList = [_dataList subarrayWithRange:NSMakeRange(0, number - 1)];
  }
  [self.collectionView reloadData];
  //点赞数

  if ([modelF.model.upCount integerValue] != 0) {
    self.upLab.text =
        [NSString stringWithFormat:@"%@人赞", modelF.model.upCount];
  } else {
    self.upLab.text = [NSString stringWithFormat:@"0人赞"];
  }
  //    if(modelF.toolHeight > 60){
  //        self.upLab.hidden = NO;
  //    }else {
  //        self.upLab.hidden = YES;
  //    }
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

  UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(userBackClicked:)];
  cell.userBack.userInteractionEnabled = YES;
  [cell.userBack addGestureRecognizer:tapg];
  cell.userIcon.tag = indexPath.row;
  cell.userBack.tag = indexPath.row + 1000;

  if (indexPath.row == _dataList.count) {
    // 如果自己点赞啦
    if ([_qqianVo.up boolValue] == true) {

      cell.userIcon.hidden = YES;
      cell.userBack.hidden = NO;
      [cell.userBack
          setBackgroundColor:[UIColor colorWithPatternImage:
                                          [UIImage imageNamed:@"icon_dz_s"]]];
      cell.userBack.layer.borderColor = [[UIColor clearColor] CGColor];

    } else {
      cell.userIcon.hidden = YES;
      cell.userBack.hidden = NO;
      cell.userBack.layer.borderColor = [[UIColor clearColor] CGColor];
      [cell.userBack
          setBackgroundColor:[UIColor
                                 colorWithPatternImage:
                                     [UIImage imageNamed:@"common_icon_dz_n"]]];
    }
  } else {
    [cell.userBack setBackgroundColor:[UIColor whiteColor]];
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
                    placeholderImage:[[UIImage imageNamed:@"usernone"]
                                         imageWithRenderingMode:
                                             UIImageRenderingModeAlwaysOriginal]

                             options:SDWebImageAllowInvalidSSLCertificates
                           completed:^(UIImage *image, NSError *error,
                                       SDImageCacheType cacheType,
                                       NSURL *imageURL) {
                             if (image) {
                               cell.userIcon.imageView.image = [image
                                   imageWithRenderingMode:
                                       UIImageRenderingModeAlwaysOriginal];
                             }
                           }];
  }
  return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

  return CGSizeMake(30, 30);
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

- (void)userBackClicked:(UITapGestureRecognizer *)ges {
  UIView *userBack = ges.view;
  if ((userBack.tag - 1000) == _dataList.count) {
    if ([_qqianVo.up integerValue] == 0) {
      [self praiseAnimationWithUIView:userBack];//点赞动画
      //点赞
      [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
          appendParams:@{
            @"qqianId" : _qqianVo.qqianId,
          }
          returnClass:[self class]
          block:^(id obj, NetResStatus status, NSString *errorDes) {

            if (status == 0) {

            } else {
              HSLog(@"点赞失败啦");
            }
          }];
      self.block(3000);
    } else {
      //取消点赞列表
//      [HSGHNetworkSession postReq:HSGHUpCancel
//          appendParams:@{
//            @"qqianId" : _qqianVo.qqianId,
//          }
//          returnClass:[self class]
//          block:^(id obj, NetResStatus status, NSString *errorDes) {
//
//            if (status == 0) {
//
//            } else {
//              NSLog(@"取消点赞失败啦");
//            }
//          }];
//      self.block(4000);
    }
  }
}

- (void)btnClicked:(UIButton *)btn {
  if (btn.tag == _dataList.count) {
    if ([_qqianVo.up integerValue] == 0) {
      //点赞
//      [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
//          appendParams:@{
//            @"qqianId" : _qqianVo.qqianId,
//          }
//          returnClass:[self class]
//          block:^(id obj, NetResStatus status, NSString *errorDes) {
//            if (status == 0) {
//              //点赞成功
//            } else {
//              NSLog(@"点赞失败啦");
//            }
//          }];
      self.block(3000);
    } else {
      //进点赞列表
      self.block(4000);
    }
  } else {
      self.block(6000);
//    NSString *userId = _dataList[btn.tag].userId;
//    [HSGHZoneVC enterOtherZone:userId];
  }
}
- (IBAction)remove:(id)sender {
  if (self.block) {
    self.block(5000);
  }
}

- (void)getFrameWithView:(UIView *)sender {
}

- (IBAction)commtBtnClicked:(id)sender {
  UIButton *btn = (UIButton *)sender;
    
    if (btn.tag==2000) {//转发
        if ([_qqianVo.isSelf intValue]==1) {
            Toast *toast = [[Toast alloc] initWithText:@"不可以转发自己的新鲜事" delay:0 duration:1.f];
            [toast show];
    
        } else if (_qqianVo.hasForward==1) {
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
            
            self.block(btn.tag);
        }
        
    } else {//评论
        self.block(btn.tag);
    }
}
- (void)praiseAnimationWithUIView:(UIView *)sender {

  UIImageView *imageView = [[UIImageView alloc] init];
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  CGRect rect1 = [window convertRect:sender.frame
                            fromView:sender]; //获取button在contentView的位置
  //    CGRect rect2 = [sender convertRect:rect1 toView:self.superview];
  //    CGRect rect3 = [sender convertRect:rect2 toView:window];
  CGRect frame = rect1;
  imageView.image = [UIImage imageNamed:@"common_icon_dz_s"];
  //  初始frame，即设置了动画的起点
  imageView.frame = rect1;
  //  初始化imageView透明度为0
  imageView.alpha = 0;
  imageView.backgroundColor = [UIColor clearColor];
  imageView.clipsToBounds = YES;
  [UIView animateWithDuration:0.2
                   animations:^{
                     imageView.alpha = 1.0;
                     CGAffineTransform transfrom =
                         CGAffineTransformMakeScale(1.5, 1.5);
                     imageView.transform =
                         CGAffineTransformScale(transfrom, 1, 1);
                     [self layoutIfNeeded];
                   }];
  [[UIApplication sharedApplication].keyWindow addSubview:imageView];
  CGFloat finishX = frame.size.width - round(random() % 200);
  //  动画结束点的Y值
  CGFloat finishY = rect1.origin.y - 400;
  //  imageView在运动过程中的缩放比例
  CGFloat scale = round(random() % 2) + 0.7;
  // 生成一个作为速度参数的随机数
  CGFloat speed = 1 / round(random() % 900) + 0.6;
  //  动画执行时间
  NSTimeInterval duration = 3 * speed;
  //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
  if (duration == INFINITY)
    duration = 2.412346;
  //  开始动画
  [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
  //  设置动画时间
  [UIView setAnimationDuration:duration];
  //  拼接图片名字
  //    imageView.image = [UIImage imageNamed:[NSString
  //    stringWithFormat:@"good%d_30x30_.png",imageName]];

  //  设置imageView的结束frame
  imageView.frame = CGRectMake(finishX, finishY, 30 * scale, 30 * scale);

  //  设置渐渐消失的效果，这里的时间最好和动画时间一致
  [UIView animateWithDuration:duration
                   animations:^{
                     imageView.alpha = 0;
                     [self layoutIfNeeded];
                   }];
  //  结束动画，调用onAnimationComplete:finished:context:函数
  [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:
                                                           finished:
                                                            context:)];
  //  设置动画代理
  [UIView setAnimationDelegate:self];
  [UIView commitAnimations];
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID
                   finished:(NSNumber *)finished
                    context:(void *)context {
  UIImageView *imageView = (__bridge UIImageView *)(context);
  [imageView removeFromSuperview];
  imageView = nil;
}

- (void)contentViewPriaseAction {
    int lastVTag = (int)_dataList.count + 1000;
    UIView *lastV = [self.collectionView viewWithTag:lastVTag];
    
    if ([_qqianVo.up integerValue] == 0) {
        [self praiseAnimationWithUIView:lastV];//点赞动画
        //点赞
        [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
                       appendParams:@{
                                      @"qqianId" : _qqianVo.qqianId,
                                      }
                        returnClass:[self class]
                              block:^(id obj, NetResStatus status, NSString *errorDes) {
                                  
                                  if (status == 0) {
                                      
                                  } else {
                                      HSLog(@"点赞失败啦");
                                  }
                              }];
        self.block(3000);
    } else {
        //取消点赞列表
//        [HSGHNetworkSession postReq:HSGHUpCancel
//                       appendParams:@{
//                                      @"qqianId" : _qqianVo.qqianId,
//                                      }
//                        returnClass:[self class]
//                              block:^(id obj, NetResStatus status, NSString *errorDes) {
//                                  
//                                  if (status == 0) {
//                                      
//                                  } else {
//                                      NSLog(@"取消点赞失败啦");
//                                  }
//                              }];
//        self.block(4000);
    }
    
}
@end
