//
//  HSGHHomeFirstView.m
//  SchoolSNS
//
//  Created by Huaral on 2018/5/5.
//  Copyright © 2019年 Facebook. All rights reserved.
//
#import "HSGHHomeSecondView.h"
#import "HSGHHomeMainTableViewCell.h"
#import "HSGHHomeModelFrame.h"
#import "HSGHZoneVC.h"
#import "HSGHMoreCommentsVC.h"
#import "HSGHUpViewController.h"
#import "HSGHMoreToolsAlertView.h"
#import "HSGHHomeViewModel.h"
#import "HSGHHomeTableViewCell.h"
#import "HSGHNetworkSession.h"
#import "UITableView+VideoPlay.h"

@interface HSGHHomeSecondView () <UITableViewDelegate, UITableViewDataSource,
    UIScrollViewDelegate, UITextViewDelegate> {
}
@property(nonatomic, assign)CGFloat offsetY_last;
@end
@implementation HSGHHomeSecondView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataFrameArr = [NSArray array];
    [self setTableViewBaces];
}

- (void)setTableViewBaces
{
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.userInteractionEnabled = YES;
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataFrameArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHHomeQQianModelFrame *tmpModelF = self.dataFrameArr[indexPath.row];
    //[cell setModelF:tmpModelF];
    [(HSGHHomeTableViewCell *)cell setModelF:tmpModelF showDistance:NO];
    [cell layoutIfNeeded];
    if (indexPath.row == self.dataFrameArr.count-4) {//最后一个cell willDisplay
        if (self.loadMoreDataBlock) {
            self.loadMoreDataBlock();
        }
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HSGHHomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HSGHHomeTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row <= 0) { // 上不可及
        cell.cellStyle = JPPlayUnreachCellStyleUp;
    } else if (indexPath.row >= self.dataFrameArr.count-1){ // 下不可及
        cell.cellStyle = JPPlayUnreachCellStyleDown;
    } else {
        cell.cellStyle = JPPlayUnreachCellStyleNone;
    }
    
    //[cell setModelF:self.dataFrameArr[indexPath.row]];
    
    __weak typeof(self) weakSelf = self;
    cell.moreBtnClickedBlock = ^(){
        [weakSelf expandCellAtIndexPath:indexPath];
    };
    
    cell.commonBtnClickBlock = ^{
        HSGHHomeQQianModel* model = weakSelf.dataFrameArr[indexPath.row].model;
        [HSGHMoreCommentsVC show:model.qqianId userID:model.owner.userId name:model.owner.displayName
                           block:^(BOOL isChanged, NSArray *array) {
        }];
    };
    
    cell.forwardBtnClickBlock = ^{
        [weakSelf forwardWithQqianVO:weakSelf.dataFrameArr[indexPath.row].model succBlock:^{
            Toast *toast = [[Toast alloc] initWithText:@"转发成功" delay:0 duration:1.f];
            [toast show];
            //成功后刷新当前cell
            [weakSelf forwardSuccRefreshCurrCell:indexPath];
        }];
    };
    
    cell.upBtnClickBlock = ^ (CGRect frame){
        [weakSelf praiseAnimationWithUIView:frame];//点赞动画
        [weakSelf updateCurrModeFAndRefreshCell:indexPath];
        
        //点赞 self.dataFrameArr[indexPath.row].model.qqianId
        [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
                       appendParams:@{@"qqianId" : self.dataFrameArr[indexPath.row].model.qqianId }
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
        upVC.qqianVo = ((HSGHHomeQQianModelFrame*)weakSelf.dataFrameArr[(NSUInteger)indexPath.row]).model;
        [weakSelf.delegate pushViewVC:upVC];
    };
    
    __weak typeof(cell) weakCell = cell;
    cell.headShareBtnClickBlock = ^{
        HSGHMoreToolsAlertView * view = [[[NSBundle mainBundle]loadNibNamed:@"HSGHMoreToolsAlertView" owner:weakSelf options:nil]lastObject];
        HSGHHomeQQianModelFrame *modelF = (HSGHHomeQQianModelFrame*)weakSelf.dataFrameArr[(NSUInteger)indexPath.row];
        view.model = modelF.model;
        view.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
        view.block = ^(NSInteger type){
            //[weakSelf.delegate qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
            HSLog(@"---homeSecondView---share---删除成功后");
            [weakSelf deleteItemByQQid:modelF.model.qqianId andType:type];
        };
        [[AppDelegate instanceApplication].window.rootViewController.view addSubview:view];
        [view loadDataWithModel:((HSGHHomeQQianModelFrame*)weakSelf.dataFrameArr[(NSUInteger)indexPath.row]) WithCellView:weakCell];
    };
    
    //[cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return self.dataFrameArr[indexPath.row].cellAllHeight;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataFrameArr[indexPath.row].cellAllHeight;
}

#pragma mark - private method

/** 后台删除一行后的前台逻辑 */
- (void)deleteItemByQQid:(NSString *)qqianId andType:(NSInteger)type {
    NSPredicate *pred;
    if (type==1000) {//删除我的原创
        pred = [NSPredicate predicateWithFormat:@" model.qqianId == %@ and model.forward == %@",qqianId,@0];
    } else {//1001 取消转发
        pred = [NSPredicate predicateWithFormat:@" model.qqianId == %@ and model.forward == %@",qqianId,@1];
    }
    NSArray *preArr = [self.dataFrameArr filteredArrayUsingPredicate:pred];
    
    if (preArr.count > 0) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.dataFrameArr];
        [mArr removeObject:[preArr lastObject]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.dataFrameArr = [mArr copy];
            //[self.mainTableView reloadData];
            [self setData:[mArr copy]];
        });
    }
}

/** 查看更多,展开某一行cell,indexPath */
- (void)expandCellAtIndexPath:(NSIndexPath*)indexPath {
    HSGHHomeQQianModelFrame *objF = self.dataFrameArr[indexPath.row];
    
    CGFloat tmpH = objF.contntViewTextVHeightAll - objF.contntViewTextVHeight;
    objF.contntViewTextVHeight = objF.contntViewTextVHeightAll;
    //objF.cellHeightUPCmt += tmpH;
    objF.cellAllHeight += tmpH;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}

#pragma mark - 点赞动画

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
                         [self layoutIfNeeded];
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

- (void)updateCurrModeFAndRefreshCell:(NSIndexPath*)indexPath {
    HSGHHomeTableViewCell *cell = (HSGHHomeTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
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
        //[self setData:self.dataFrameArr];
        //[self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)forwardSuccRefreshCurrCell:(NSIndexPath*)indexPath {
    HSGHHomeQQianModelFrame* currModelframe = self.dataFrameArr[indexPath.row];
    HSGHHomeQQianModel* currModel = currModelframe.model;
    currModel.hasForward = 1;
    int num = [currModel.forwardCount intValue] + 1;
    NSNumber *rstNum = [NSNumber numberWithInt:num];
    currModel.forwardCount = rstNum;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setData:self.dataFrameArr];
        //[self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    });
}


#pragma mark - 播放小视频

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO)
        [self.mainTableView handleScrollStop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.mainTableView handleScrollStop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self handleScrollDerectionWithOffset:scrollView.contentOffset.y];
    [self.mainTableView handleQuickScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.offsetY_last = scrollView.contentOffset.y;
}

- (void)handleScrollDerectionWithOffset:(CGFloat)offsetY{
    self.mainTableView.currentDerection = (offsetY-self.offsetY_last>0) ? JPVideoPlayerDemoScrollDerectionUp : JPVideoPlayerDemoScrollDerectionDown;
    self.offsetY_last = offsetY;
}

@end
