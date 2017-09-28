//
//  HSGHZoneAreaBCellVC.m
//  SchoolSNS
//
//  Created by Murloc on 16/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHZoneAreaBCellVC.h"
#import "HSGHHomeMainTableViewCell.h"
#import "HSGHScrollZoneVC.h"
#import "HSGHMoreToolsAlertView.h"
#import "HSGHUpViewController.h"
#import "HSGHMoreCommentsVC.h"
#import "HSGHHomeViewModel.h"
#import "HSGHHomeTableViewCell.h"
#import "UITableView+VideoPlay.h"
#import "HSGHNetworkSession.h"
#import "HSGHMoreToolsAlertView.h"

@interface HSGHZoneAreaBCellVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL fingerIsTouch;

@property (nonatomic, strong) NSArray *dataList;//数据源

@property(nonatomic, assign)CGFloat offsetY_last;
@end

@implementation HSGHZoneAreaBCellVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
//    [self setupRefresh];
    if (!self.model || !self.model.user) {
        [self firstLoad];
    }else{
        __weak UITableView *weakTable = _tableView;
        _model.block = ^(NSIndexPath *indexPath) {
            if(indexPath != nil){
                [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [weakTable reloadData];
            }
        };
        if ([self.delegate respondsToSelector:@selector(refreshPersonalInfo)]) {
            [self.delegate refreshPersonalInfo];
        }
        if (_isMine) {
            self.dataList = [_model fetchData];
        }else{
            self.dataList = [_model fetchForwardData];
        }
        
        [self.tableView reloadData];
    }
}


- (void)setupSubViews {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    [_tableView registerNib:[UINib nibWithNibName:@"HSGHZoneVCTableViewCell"
//                                           bundle:[NSBundle mainBundle]]
//     forCellReuseIdentifier:@"mainCell2"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HSGHHomeTableViewCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"mainCell2"];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews {
    _tableView.height = self.view.height;
}

- (void)resetBlock {
    __weak typeof(self) weakSelf = self;
    _model.block = ^(NSIndexPath *indexPath) {
        if(indexPath != nil){
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [weakSelf.tableView reloadData];
        }
    };
}

- (void)firstLoad {
    __weak UITableView *weakTable = _tableView;

    //up , reply update
    _model.block = ^(NSIndexPath *indexPath) {
        if(indexPath != nil){
            [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [weakTable reloadData];
        }
    };

    __weak typeof(self) weakSelf = self;
    if (_isMine) {
        [_model requestMine:_userID
             refreshAll:true
                  block:^(BOOL status) {
                      if (status) {
                          if ([weakSelf.delegate respondsToSelector:@selector(refreshPersonalInfo)]) {
                              [weakSelf.delegate refreshPersonalInfo];
                          }
                          weakSelf.dataList = [_model fetchData];
                          [weakSelf.tableView reloadData];
                      }
                  }];
    }
    else {
        [_model requestForward:_userID
             refreshAll:true
                  block:^(BOOL status) {
                      if (status) {
                          if ([weakSelf.delegate respondsToSelector:@selector(refreshPersonalInfo)]) {
                              [weakSelf.delegate refreshPersonalInfo];
                          }
                          weakSelf.dataList = [_model fetchForwardData];
                          [weakSelf.tableView reloadData];
                      }
                  }];
    }
}

/** loadMoreData */
- (void)loadMoreData {
    NSInteger count = self.dataList.count;
    if (self.isMine) {
        [self.model requestMine:self.userID refreshAll:false block:^(BOOL status) {
              if (status) {
                  if (self.dataList.count > count) {
                      NSMutableArray *array = [NSMutableArray array];
                      for (NSInteger i = count; i < self.dataList.count; ++i) {
                          [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                      }
                      [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                  }else{
                      [self.tableView.mj_footer endRefreshingWithNoMoreData];
                  }
              }
          }];
    } else {
        [self.model requestForward:self.userID refreshAll:false block:^(BOOL status) {
             if (status) {
                 if (self.dataList.count > count) {
                     NSMutableArray *array = [NSMutableArray array];
                     for (NSInteger i = count; i < self.dataList.count; ++i) {
                         [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                     }
                     [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                 }else{
                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                 }
             }
         }];
    }
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isMine) {
            [weakSelf.model requestMine:weakSelf.userID
                         refreshAll:false
                              block:^(BOOL status) {
                                  [weakSelf.tableView.mj_footer endRefreshing];
                                  if (status) {
                                      [weakSelf.tableView reloadData];
                                  }else{
                                      [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                  }
                              }];
        }
        else {
            [weakSelf.model requestForward:weakSelf.userID
                         refreshAll:false
                              block:^(BOOL status) {
                                  [weakSelf.tableView.mj_footer endRefreshing];
                                  if (status) {
                                      [weakSelf.tableView reloadData];
                                  }else{
                                      [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                  }
                              }];
        }
    }];
}

//- (NSArray*)currentData {
//    self.dataList = _isMine ? [_model fetchData] : [_model fetchForwardData];
//    return self.dataList;
//}




#pragma mark- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"all count is %@, current is %@", @([self currentData].count), @(indexPath.row));
    return [self.dataList[(NSUInteger) indexPath.row] cellAllHeight];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataList[(NSUInteger) indexPath.row] cellAllHeight];
}

//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHHomeQQianModelFrame * modelF = (HSGHHomeQQianModelFrame *)self.dataList[indexPath.row];
    //[cell setModelF:modelF];
    if (_isMine) {
        [(HSGHHomeTableViewCell *)cell setModelF:modelF showDistance:NO];
    }else{
        [(HSGHHomeTableViewCell *)cell setModelF:modelF showDistance:YES];
    }
    if (indexPath.row == self.dataList.count-3) {//最后一个cell willDisplay
        [self loadMoreData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//    __kindof UITableViewCell *reuseCell;
//    reuseCell = [tableView dequeueReusableCellWithIdentifier:@"mainCell2"
//                                                forIndexPath:indexPath];
//    HSGHHomeMainTableViewCell *cell = reuseCell;
    
    __weak typeof(self) weakSelf = self;
    HSGHHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSGHHomeTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HSGHHomeTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row <= 0) { // 上不可及
        cell.cellStyle = JPPlayUnreachCellStyleUp;
    } else if (indexPath.row >= self.dataList.count-1){ // 下不可及
        cell.cellStyle = JPPlayUnreachCellStyleDown;
    } else {
        cell.cellStyle = JPPlayUnreachCellStyleNone;
    }
    
    HSGHHomeQQianModelFrame * modelF = (HSGHHomeQQianModelFrame *)self.dataList[indexPath.row];
    
    cell.moreBtnClickedBlock = ^(){
        [weakSelf expandCellAtIndexPath:indexPath];
    };

    cell.commonBtnClickBlock = ^{
        HSGHHomeQQianModel* model = modelF.model;
        [HSGHMoreCommentsVC show:model.qqianId userID:model.owner.userId name:model.owner.displayName block:^(BOOL isChanged, NSArray *array) {
        }];
    };

    cell.forwardBtnClickBlock = ^{
        [HSGHHomeViewModel fetchForwardWithParams:@{
                                                    @"qqianId" : modelF.model.qqianId,
                                                    @"type" : @0,
                                                    @"content" : @""
                                                    }:^(BOOL success,NSString * replayId) {
                                                        [[AppDelegate instanceApplication] indicatorDismiss];
                                                        if (success == YES) {
                                                            Toast *toast = [[Toast alloc] initWithText:@"转发成功!" delay:0 duration:1.f];
                                                            [toast show];
                                                            //成功后刷新当前cell
                                                            [weakSelf forwardSuccRefreshCurrCell:indexPath];
                                                            
                                                        } else {
                                                            //                    [[[UIAlertView alloc]initWithTitle:@"" message:@"转发失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                                                            HSLog(@"转发失败");
                                                            Toast *toast = [[Toast alloc] initWithText:@"出了一点小问题，请稍后再试!" delay:0 duration:1.f];
                                                            [toast show];
                                                        }
                                                        
                                                    }];
        
        
        
    };

    cell.upBtnClickBlock = ^ (CGRect frame){
        [weakSelf praiseAnimationWithUIView:frame];//点赞动画
        [weakSelf updateCurrModeFAndRefreshCell:indexPath];
        
        //点赞 self.dataFrameArr[indexPath.row].model.qqianId
        [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
                       appendParams:@{@"qqianId" : modelF.model.qqianId }
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(id obj, NetResStatus status, NSString *errorDes) {
                                  if (status == 0) {
                                      HSLog(@"点赞成功啦");
                                  } else {
                                      HSLog(@"点赞失败啦---errorDes=%@",errorDes);
                                  }
                              }];
        
    };

    cell.toolIconsViewClickBlock = ^{
        //进点赞列表
        HSGHUpViewController* upVC = [HSGHUpViewController new];
        upVC.qqianVo = modelF.model;
        //[self.delegate pushViewVC:upVC];
        [weakSelf.navigationController pushViewController:upVC animated:YES];
    };
    
    
    __weak typeof(cell) weakCell = cell;
    cell.headShareBtnClickBlock = ^{
        HSLog(@"---个人主页---share---");
        HSGHMoreToolsAlertView * view = [[[NSBundle mainBundle]loadNibNamed:@"HSGHMoreToolsAlertView" owner:weakSelf options:nil]lastObject];
        view.model = modelF.model;
        view.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
        view.block = ^(NSInteger type){
            //[weakSelf.delegate qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
            [weakSelf deleteItemByQQid:modelF.model.qqianId andType:type];
            
        };
        [[AppDelegate instanceApplication].window.rootViewController.view addSubview:view];
        [view loadDataWithModel:modelF WithCellView:weakCell];
    };
    
    
    return cell;
}

/** 删除一行后 */
- (void)deleteItemByQQid:(NSString *)qqianId andType:(NSInteger)type {
    NSPredicate *pred;
    if (type==1000) {//删除我的原创
        pred = [NSPredicate predicateWithFormat:@" model.qqianId == %@ and model.forward == %@",qqianId,@0];
    } else {//1001 取消转发
        pred = [NSPredicate predicateWithFormat:@" model.qqianId == %@ and model.forward == %@",qqianId,@1];
    }
    NSArray *preArr = [self.dataList filteredArrayUsingPredicate:pred];
    
    if (preArr.count > 0) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataList];
        [mArr removeObject:[preArr lastObject]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.dataList = [mArr copy];
            //[self.tableView reloadData]
            
            if (self.tableView.playingCell) {
                self.tableView.playingCell = nil;
            }
            
            self.dataList = [mArr copy];
            [self.tableView reloadData];
            
            [self.tableView handleScrollStop];
        });
    }
}

#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.fingerIsTouch = YES;
    
    self.offsetY_last = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.fingerIsTouch = NO;
}

- (void)forwardWithQqianVO:(HSGHHomeQQianModel *)qqiansVO {
    //转发
    [HSGHHomeViewModel fetchForwardWithParams:@{
                                                @"qqianId" : qqiansVO.qqianId,
                                                @"type" : @0,
                                                @"content" : @""
                                                }:^(BOOL success,NSString * replayId) {
                                                    [[AppDelegate instanceApplication] indicatorDismiss];
                                                    if (success == YES) {
                                                        Toast *toast = [[Toast alloc] initWithText:@"转发成功!" delay:0 duration:1.f];
                                                        [toast show];
                                                        
                                                    } else {
                                                        //                    [[[UIAlertView alloc]initWithTitle:@"" message:@"转发失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                                                        HSLog(@"转发失败");
                                                        Toast *toast = [[Toast alloc] initWithText:@"出了一点小问题，请稍后再试!" delay:0 duration:1.f];
                                                        [toast show];
                                                    }
                                                    
                                                }];
}

- (void)refreshData {
    [_tableView reloadData];
}

//查看更多    展开某一行cell  indexPath
- (void)expandCellAtIndexPath:(NSIndexPath*)indexPath {
    HSGHHomeQQianModelFrame *objF = self.dataList[indexPath.row];
    CGFloat tmpH = objF.contentTextHAll - objF.contentTextH;
    objF.contentTextH = objF.contentTextHAll;
    objF.contentHeight += tmpH;
    objF.cellHeight += tmpH;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)updateCurrModeFAndRefreshCell:(NSIndexPath*)indexPath {
    HSGHHomeTableViewCell *cell = (HSGHHomeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    HSGHHomeQQianModelFrame* currModelframe = cell.modelF;
    HSGHHomeQQianModel* currModel = currModelframe.model;
    currModel.upCount = [NSNumber numberWithInteger:[currModel.upCount integerValue] + 1];
    currModel.up = @1;
    
    NSMutableArray* mutableArr = [NSMutableArray arrayWithArray:currModel.partUp];
    //点赞成功 修改model
    HSGHHomeUp* modelup = [HSGHHomeUp new];
    HSGHHomeImage* image = [HSGHHomeImage new];
    image.thumbUrl = [HSGHUserInf shareManager].picture.thumbUrl;
    
    modelup.picture = image;
    modelup.unvi.name = [HSGHUserInf shareManager].bachelorUniv.name;
    modelup.fullName = [NSString stringWithFormat:@"%@%@", [HSGHUserInf shareManager].firstName,
                        [HSGHUserInf shareManager].lastName];
    modelup.userId = [HSGHUserInf shareManager].userId;
    [mutableArr insertObject:modelup atIndex:0];
    
    currModel.partUp = [NSArray arrayWithArray:mutableArr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell refreshDianzan];
      //  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}


- (void)praiseAnimationWithUIView:(CGRect)frame {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"common_icon_dz_s"];
    //  初始frame，即设置了动画的起点
    imageView.frame = frame;
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
                         //[self layoutIfNeeded];
                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    CGFloat finishX = frame.size.width - round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = frame.origin.y - 400;
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
                         //[self layoutIfNeeded];
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


- (void)forwardSuccRefreshCurrCell:(NSIndexPath*)indexPath {
    HSGHHomeQQianModelFrame* currModelframe = self.dataList[indexPath.row];
    HSGHHomeQQianModel* currModel = currModelframe.model;
    currModel.hasForward = 1;
    int num = [currModel.forwardCount intValue] + 1;
    NSNumber *rstNum = [NSNumber numberWithInt:num];
    currModel.forwardCount = rstNum;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}



#pragma mark - 播放小视频

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO)
        [self.tableView handleScrollStop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.tableView handleScrollStop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
    
    [self handleScrollDerectionWithOffset:scrollView.contentOffset.y];
    
    [self.tableView handleQuickScroll];
}

- (void)handleScrollDerectionWithOffset:(CGFloat)offsetY{
    self.tableView.currentDerection = (offsetY-self.offsetY_last>0) ? JPVideoPlayerDemoScrollDerectionUp : JPVideoPlayerDemoScrollDerectionDown;
    self.offsetY_last = offsetY;
}

@end
