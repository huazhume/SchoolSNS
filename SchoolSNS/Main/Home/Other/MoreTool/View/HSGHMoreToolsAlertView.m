//
//  HSGHMoreToolsAlertView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMoreToolsAlertView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "AppDelegate.h"
#import "HSGHSharedCollectionViewCell.h"
#import "HSGHSharedModel.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "HSGHUserInf.h"
#import "HSGHHomeViewModel.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "UMSocialQQHandler.h"
#import "HSGHHomeMainTableViewCell.h"
#import "UIView+YYAdd.h"
#import "HSGHShareImageView.h"
#import "NSAttributedString+YYText.h"
#import <CoreText/CoreText.h>
#import "HSGHHomeTableViewCell.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface HSGHMoreToolsAlertView ()<UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray * _dataList;
    HSGHHomeQQianModelFrame * _modelF;
    UIImage * image;
    
}
@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation HSGHMoreToolsAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat space = (HSGH_SCREEN_WIDTH - 2* 27 - 4 * 54)/3.0;
    self.firstToSecond.constant = space;
    self.secondToThird.constant = space;
    self.thirdToFourth.constant = space;
    _viewHeight.constant = 0;
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.27 animations:^{
        self.bgView.alpha = 0.5;
        self.viewHeight.constant = 250;
        [self.toolView layoutIfNeeded];
        self.toolView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 250);
        
    }completion:^(BOOL finished) {
        
    }];
    UITapGestureRecognizer * gesturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel:)];;
    [self.bgView addGestureRecognizer:gesturer];
    self.bgView.userInteractionEnabled = YES;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:
     [UINib nibWithNibName:@"HSGHSharedCollectionViewCell"
                    bundle:nil]
          forCellWithReuseIdentifier:@"faceCell"];
    
}
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image1.size.width , image2.size.height + image1.size.height), self.opaque, 0);
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    // Draw image2
    [image2 drawInRect:CGRectMake(0, image1.size.height, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
- (NSMutableAttributedString *)generateAttributedStringWithString:
(NSString *)content {
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc] initWithString:content];
    attString.yy_color = HEXRGBCOLOR(0x272727);
    attString.yy_font = [UIFont systemFontOfSize:14];
    attString.yy_lineSpacing = 2;
    return attString;
}

//备份原来
- (void)BF__loadDataWithModel__BF:(HSGHHomeQQianModelFrame *)modelF WithCellView:(UITableViewCell *)cellView  {
//    HSGHHomeMainTableViewCell * mainCell = (HSGHHomeMainTableViewCell *)[cellView mutableCopy];

    _modelF = modelF;
    UIImage *  cellImage;
    if(modelF.contentTextMaxH > modelF.contentTextH){//如果这个比较大的话
        UIImage * cellImage1 =   [cellView snapshotImageWithSize:CGSizeMake(HSGH_SCREEN_WIDTH, modelF.contentImageH + modelF.headerHeight)];
        YYLabel * yylabel = [[YYLabel alloc]initWithFrame:CGRectMake(12,modelF.contentImageH + modelF.headerHeight + 8, HSGH_SCREEN_WIDTH - 24, modelF.contentTextMaxH)];
        yylabel.userInteractionEnabled = YES;
        yylabel.textColor = HEXRGBCOLOR(0x272727);
        yylabel.numberOfLines = 0;
        yylabel.textAlignment = NSTextAlignmentLeft;
        yylabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        yylabel.attributedText = [self generateAttributedStringWithString:modelF.model.content];
        yylabel.backgroundColor = [UIColor whiteColor];
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, modelF.contentImageH + modelF.headerHeight + modelF.contentTextMaxH + 8)];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, modelF.contentImageH + modelF.headerHeight)];
        imageView.image = cellImage1;
        [backView addSubview:imageView];
        [backView addSubview:yylabel];
        backView.backgroundColor = [UIColor whiteColor];
        cellImage =  backView.snapshotImage;
        
    }else{
      cellImage =   [cellView snapshotImageWithSize:CGSizeMake(HSGH_SCREEN_WIDTH, modelF.contentHeight + modelF.headerHeight)];
    }
    CGFloat fistHeight = ((HSGH_SCREEN_WIDTH, HSGH_SCREEN_WIDTH/375.0)) * 95;
    CGFloat thirdHeight = ((HSGH_SCREEN_WIDTH, HSGH_SCREEN_WIDTH/375.0)) * 255;
    CGFloat secondHeight = modelF.contentTextMaxH +16 + modelF.contentImageH + modelF.headerHeight;
    UIView * shareView = [UIView new];
    shareView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH,fistHeight + thirdHeight + secondHeight);
    UIImageView * fistView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, fistHeight)];
    fistView.image = [UIImage imageNamed:@"fxs"];
    
    UIImageView * secondView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fistHeight, HSGH_SCREEN_WIDTH, secondHeight)];
    secondView.image = cellImage;
    
    UIImageView * thirdView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fistHeight + secondHeight+6, HSGH_SCREEN_WIDTH, thirdHeight)];
    thirdView.image = [UIImage imageNamed:@"fxx"];
    [shareView addSubview:fistView];
    [shareView addSubview:secondView];
    [shareView addSubview:thirdView];
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 80, 55)];
    leftView.backgroundColor = [UIColor whiteColor];
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(HSGH_SCREEN_WIDTH - 120,5, 120, 55)];
    rightView.backgroundColor = [UIColor whiteColor];
    [secondView addSubview:leftView];
    [secondView addSubview:rightView];
    shareView.backgroundColor = [UIColor whiteColor];
    image = shareView.snapshotImage;
    HSGHHomeQQianModel * model = modelF.model;
    _dataList = [NSMutableArray array];
    
    HSGHSharedModel * wechat = [HSGHSharedModel new];
    wechat.title = @"微信";
    wechat.imageName = @"wx";
    wechat.type = SHARED_WECHAT_MODE;
    
    HSGHSharedModel * wechatF = [HSGHSharedModel new];
    wechatF.title = @"朋友圈";
    wechatF.imageName = @"wxf";
    wechatF.type = SHARED_WECHATFRIEND_MODE;
    
    HSGHSharedModel * qq = [HSGHSharedModel new];
    qq.title = @"QQ";
    qq.imageName = @"qq";
    qq.type = SHARED_QQ_MODE;
    
    HSGHSharedModel * qqF = [HSGHSharedModel new];
    qqF.title = @"空间";
    qqF.imageName = @"qqf";
    qqF.type = SHARED_QQFRIEND_MODE;
    
    HSGHSharedModel * report = [HSGHSharedModel new];
    report.title = @"举报";
    report.imageName = @"report";
    report.type = SHARED_REPORT_MODE;
    
    HSGHSharedModel * delete = [HSGHSharedModel new];
    delete.type = SHARED_DELETE_MODE;
    delete.title = @"删除";
    delete.imageName = @"delete";
    
    HSGHSharedModel * hei = [HSGHSharedModel new];
    hei.title = @"屏蔽";
    hei.imageName = @"alert_pb";
    hei.type = SHARED_HEI_MODE;
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]){
        HSLog(@"已经安装微信");
        [_dataList addObject:wechat];
        [_dataList addObject:wechatF];
    }else{
        HSLog(@"没有安装WX");
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
        HSLog(@"已经安装QQ");
        [_dataList addObject:qq];
        [_dataList addObject:qqF];
    }else{
        HSLog(@"没有安装QQ");
    }
    
    [_dataList addObject:report];
    //删除
    if(model.isSelf.boolValue == 1){
         [_dataList addObject:delete];
    }else{
        [_dataList addObject:hei];
    }
    
    
//    if(![[HSGHUserInf shareManager].userId isEqualToString:model.creator.userId]){
//        
//    }
    [self.collectionView reloadData];
    
}


- (void)loadDataWithModel:(HSGHHomeQQianModelFrame *)modelF WithCellView:(UITableViewCell *)cellView  {
    
    _modelF = modelF;
    UIImage *  cellImage;
    
    CGFloat tmpHeadHeight = 65 + _modelF.headNameLabelHeight + _modelF.headUnivLabelHeight;
    //cellImage =   [cellView snapshotImageWithSize:CGSizeMake(HSGH_SCREEN_WIDTH, modelF.contntViewImageVHeight + tmpHeadHeight + modelF.contntViewTextVHeight + 5)];
    cellImage =   [cellView snapshotImageWithSize:CGSizeMake(HSGH_SCREEN_WIDTH, modelF.cellAllHeight-12)];
    
    CGFloat fistHeight = ((HSGH_SCREEN_WIDTH, HSGH_SCREEN_WIDTH/375.0)) * 105;
    CGFloat thirdHeight = ((HSGH_SCREEN_WIDTH, HSGH_SCREEN_WIDTH/375.0)) * 120;
    //CGFloat secondHeight = modelF.contntViewTextVHeightAll +16 + modelF.contntViewImageVHeight + tmpHeadHeight;
    CGFloat secondHeight = modelF.cellAllHeight;
    UIView * shareView = [UIView new];
    shareView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH,fistHeight + thirdHeight + secondHeight);
    UIImageView * fistView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, fistHeight)];
    fistView.image = [UIImage imageNamed:@"fxss"];
    
    UIImageView * secondView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fistHeight, HSGH_SCREEN_WIDTH, secondHeight)];
    secondView.image = cellImage;
    
    UIImageView * thirdView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fistHeight + secondHeight+6, HSGH_SCREEN_WIDTH, thirdHeight)];
    thirdView.image = [UIImage imageNamed:@"fxxx"];
    [shareView addSubview:fistView];
    [shareView addSubview:secondView];
    [shareView addSubview:thirdView];
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 80, 55)];
    leftView.backgroundColor = [UIColor whiteColor];
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(HSGH_SCREEN_WIDTH - 120,5, 120, 55)];
    rightView.backgroundColor = [UIColor whiteColor];
    [secondView addSubview:leftView];
    [secondView addSubview:rightView];
    shareView.backgroundColor = [UIColor whiteColor];
    image = shareView.snapshotImage;
    
    
    HSGHHomeQQianModel * model = modelF.model;
    _dataList = [NSMutableArray array];
    HSGHSharedModel * wechat = [HSGHSharedModel new];
    wechat.title = @"微信";
    wechat.imageName = @"wx";
    wechat.type = SHARED_WECHAT_MODE;
    
    
    HSGHSharedModel * wechatF = [HSGHSharedModel new];
    wechatF.title = @"朋友圈";
    wechatF.imageName = @"wxf";
    wechatF.type = SHARED_WECHATFRIEND_MODE;
    
    
    HSGHSharedModel * qq = [HSGHSharedModel new];
    qq.title = @"QQ";
    qq.imageName = @"qq";
    qq.type = SHARED_QQ_MODE;
    
    
    HSGHSharedModel * qqF = [HSGHSharedModel new];
    qqF.title = @"空间";
    qqF.imageName = @"qqf";
    qqF.type = SHARED_QQFRIEND_MODE;
    
    
    HSGHSharedModel * report = [HSGHSharedModel new];
    report.title = @"举报";
    report.imageName = @"report";
    report.type = SHARED_REPORT_MODE;
    
    HSGHSharedModel * delete = [HSGHSharedModel new];
    delete.type = SHARED_DELETE_MODE;
    delete.title = @"删除";
    delete.imageName = @"delete";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]){
        HSLog(@"已经安装微信");
        [_dataList addObject:wechat];
        [_dataList addObject:wechatF];
    }else{
        HSLog(@"没有安装WX");
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
        HSLog(@"已经安装QQ");
        [_dataList addObject:qq];
        [_dataList addObject:qqF];
    }else{
        HSLog(@"没有安装QQ");
    }
    
    [_dataList addObject:report];
    
    HSGHSharedModel * hei = [HSGHSharedModel new];
    hei.title = @"屏蔽";
    hei.imageName = @"alert_pb";
    hei.type = SHARED_HEI_MODE;
    //删除
    if([model.isSelf boolValue]){
        NSLog(@"是自己的");
        [_dataList addObject:delete];
    }else{
        NSLog(@"不是自己的");
        [_dataList addObject:hei];
    }
   
    
    [self.collectionView reloadData];
}


- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)shared:(id)sender {
    
}

#pragma mark - delegate 
#pragma mark - delagate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataList.count ;
}
- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGHSharedCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"faceCell"
                                              forIndexPath:indexPath];
    HSGHSharedModel *model = _dataList[indexPath.row];
    cell.sharedImage.image = [UIImage imageNamed:model.imageName];
    cell.sharedTitle.text = model.title;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(HSGH_SCREEN_WIDTH/4.0, 79);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)
collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)
collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HSGHSharedModel * model = _dataList[indexPath.row];
    if(model.type == SHARED_REPORT_MODE){
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"政治敏感",@"版权问题",@"语言粗鲁下流",@"色情",@"儿童色情",@"垃圾广告" ,nil];
        [sheet showInView:self];
        [self.toolView removeFromSuperview];
    }else if (model.type == SHARED_DELETE_MODE){
        //删除
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"删除此条新鲜事!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
        [self.toolView removeFromSuperview];
        self.bgView.alpha = 0;
    }else if(model.type == SHARED_QQ_MODE){
        [[AppDelegate instanceApplication] umSocialType:UMSOCIAL_QQ_MODE WithTitle:@"HSGH" description:@"测试" ImageUrl:nil webUrl:@"http://www.huaral.tech" image:image];
         [self removeFromSuperview];
        [self saveToLocalALAssetsLibrary:image];
        
    }else if (model.type == SHARED_QQFRIEND_MODE){
         [[AppDelegate instanceApplication] umSocialType:UMSOCIAL_QQZONE_MODE WithTitle:@"分享" description:@"测试" ImageUrl:@"http://www.huaral.tech" webUrl:@"http://www.huaral.tech" image:image];
         [self removeFromSuperview];
        [self saveToLocalALAssetsLibrary:image];
        
    }else if(model.type == SHARED_WECHAT_MODE){
      [[AppDelegate instanceApplication] umSocialType:UMSOCIAL_WECHAT_MODE WithTitle:@"分享" description:@"测试" ImageUrl:@"http://www.huaral.tech" webUrl:@"http://www.huaral.tech" image:image];
         [self removeFromSuperview];
        [self saveToLocalALAssetsLibrary:image];
        
    }else if (model.type == SHARED_WECHATFRIEND_MODE){
        [[AppDelegate instanceApplication] umSocialType:UMSOCAIL_WECHAR_ZONG WithTitle:@"分享" description:@"测试" ImageUrl:@"http://www.huaral.tech" webUrl:@"http://www.huaral.tech" image:image];
        [self removeFromSuperview];
        [self saveToLocalALAssetsLibrary:image];
        
        
    }else if (model.type == SHARED_HEI_MODE){
        //拉黑
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"屏蔽后将不再接收到该用户的新鲜事，确认要拉黑么？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 99999;
        [alert show];
    }
}

//image 存本地相册
- (void)saveToLocalALAssetsLibrary:(UIImage*)image {
    ALAssetsLibrary * library = [ALAssetsLibrary new];
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 99999 && buttonIndex == 1) {
        [[AppDelegate instanceApplication]indicatorShow];
        [HSGHSharedModel reportAndDeleteWithParams:@{@"qqianId":UN_NIL_STR(_model.qqianId),@"type":@(6)} :^(BOOL success) {
            [[AppDelegate instanceApplication]indicatorDismiss];
            if (success){
                Toast* toast = [[Toast alloc]initWithText:@"屏蔽成功" delay:0 duration:1.f];
                [toast show];
            }
            else {
                Toast* toast = [[Toast alloc]initWithText:@"屏蔽失败，请稍后再试" delay:0 duration:1.f];
                [toast show];
            }
            [self removeFromSuperview];
        }];
    }
    else {
        if(alertView.tag == 1000 && buttonIndex == 1){
            [[AppDelegate instanceApplication]indicatorShow];
            
            if ([_model.forward intValue]==1) {//取消转发
                [HSGHHomeViewModel forwardCancelWithParams:@{@"qqianId":_model.qqianId} :^(BOOL success, NSString *replayId) {
                    [[AppDelegate instanceApplication]indicatorDismiss];
                    if(success == YES){
                        if(_block){
                            self.block(1001);//取消转发
                        }
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                    }
                    [self removeFromSuperview];
                }];
                
            } else {//删除
                [HSGHHomeViewModel fetchRemoveWithParams:@{@"qqianId":_model.qqianId} :^(BOOL success) {
                    [[AppDelegate instanceApplication]indicatorDismiss];
                    if(success == YES){
                        //删除成功
                        if(_block){
                            self.block(1000);//
                        }
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                    }
                    [self removeFromSuperview];
                }];
            }
        }
        [self removeFromSuperview];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger type = 0;
    if(buttonIndex == 0){
        type = 1;//政治名感
    }else if (buttonIndex == 1){
        type = 2;//侵权
    }else if (buttonIndex == 2){
        type = 3;//语言低俗下流
    }else if (buttonIndex == 3){
        type = 4;//色情
    }else if (buttonIndex == 4){
        type = 5;//儿童色情
    }else if (buttonIndex == 5){
        type = 6;//垃圾广告
    }
    if(buttonIndex < 6){
        [[AppDelegate instanceApplication]indicatorShow];
        [HSGHSharedModel fetchReportWithParams:@{@"qqianId":_model.qqianId,@"type":@(type)} :^(BOOL success) {
            [[AppDelegate instanceApplication]indicatorDismiss];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MORETOOLS_NOTIFICATION" object:nil userInfo:@{@"is":@(!!success)}];
//            if(success == YES){
//                [[[UIAlertView alloc]initWithTitle:nil message:@"举报成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//            }else{
//                [[[UIAlertView alloc]initWithTitle:nil message:@"举报成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//            }
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}
- (UIImage*)getCellGraphicsBeginImageWithClass:(NSString*)className WithFrame:(HSGHHomeQQianModelFrame*)modelF
{
    modelF.model.contentIsMore = @1;
    HSGHHomeQQianModelFrame *modelF2 =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [modelF2 setModel:modelF.model];
    HSGHHomeMainTableViewCell* cellView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHHomeMainTableViewCell" owner:self options:nil] lastObject];
    cellView.frame = CGRectMake(0, 0, modelF2.cellWidth, modelF2.cellHeight);
    
    [cellView setcellFrame:modelF2];
    UIGraphicsBeginImageContextWithOptions(cellView.frame.size, NO,  [UIScreen mainScreen].scale);
    [cellView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _image;
    
}



@end
