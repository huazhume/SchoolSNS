//
//  HSGHHomeBaseView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseView.h"
#import "HSGHHomeViewModel.h"
#import "HSGHHomeMainTableViewCell.h"
#import "UITableView+VideoPlay.h"



@interface HSGHHomeBaseView ()<UIScrollViewDelegate>

@end

@implementation HSGHHomeBaseView

- (void)awakeFromNib {
  [super awakeFromNib];

  [self addSubview:self.mainTableView];
  [self.mainTableView
     registerNib:[UINib nibWithNibName:@"HSGHHomeMainTableViewCell"
                                bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"MainCell"];
    
    [self.mainTableView
     registerNib:[UINib nibWithNibName:@"HSGHHomeTableViewCell"
                                bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"HomeTableViewCell"];
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT - 39 - 53)
                                                      style:UITableViewStylePlain];
    }
    _mainTableView.separatorColor = [UIColor colorWithRed:239 / 255.0
                                                    green:239 / 255.0
                                                     blue:239 / 255.0
                                                    alpha:1];
    _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return _mainTableView;
}

#define initData


- (void)reloadData:(NSArray *)data {
    self.dataFrameArr = data;
    [self.mainTableView reloadData];
}

- (void)reloadData:(NSArray*)data andIndex:(NSIndexPath*)indexPath
{
    self.dataFrameArr = data;
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.mainTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
//    }];
//    self.edgesForExtendedLayout = UIRectEdgeNone
    
//    HSGHHomeMainTableViewCell * cell []
//    
//    [UIView transitionWithView:self
//                      duration: 0.35f
//                       options: UIViewAnimationOptionTransitionCrossDissolve
//                    animations: ^(void)
//     {
//         
//         [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//     }
//                    completion: ^(BOOL isFinished)
//     {  
//         
//     }];
//    [UIView performSystemAnimation:nil onViews:nil options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        
//    } completion:^(BOOL finished) {
//
//    }];
//    
//    
    

    [UIView performWithoutAnimation:^{
        
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.mainTableView beginUpdates];
        [self.mainTableView endUpdates];
    }];
    
//    [UIView animateWithDuration:1 animations:^{
//        
//    }]
    
//    [UIView setAnimationsEnabled:NO];
//    [self.mainTableView beginUpdates];
//    
//    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
//                          withRowAnimation:UITableViewRowAnimationNone];
//    [self.mainTableView endUpdates];
//    [UIView setAnimationsEnabled:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   _oldOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y > _oldOffset){
        //隐藏
        [self.delegate navAndTabIsHidden:YES];
    }else{
        [self.delegate navAndTabIsHidden:NO];
    }
}

// setData
- (void)setData:(NSArray*)frameArr {
    if (self.mainTableView.playingCell) {
        self.mainTableView.playingCell = nil;
    }
    
    self.dataFrameArr = [NSArray arrayWithArray:frameArr];
    [self.mainTableView reloadData];
    
    [self.mainTableView handleScrollStop];
}

- (void)replaceData:(NSArray*)frameArr WithIndex:(NSInteger)index
{
    self.dataFrameArr = [NSArray arrayWithArray:frameArr];
//    [self.mainTableView reloadData];
    NSIndexPath * indexP = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mainTableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)keywordViewClosed {
//  [_keywordView endEditing:YES];
  
}


- (void)getCellImageWithTableView:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath WithFrame:(HSGHHomeQQianModelFrame *)modelF {
    
    
//    HSGHHomeMainTableViewCell * cellView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHHomeMainTableViewCell" owner:self options:nil]lastObject];
//    cellView.frame = CGRectMake(0, 0, modelF.cellWidth, modelF.cellHeight);
//    [cellView setcellFrame:modelF];
//    UIGraphicsBeginImageContext(CGSizeMake(cellView.frame.size.width, modelF.headerHeight));
//    [cellView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * image =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    
//    // 渲染tableView 头
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    UIGraphicsBeginImageContext(CGSizeMake(cell.frame.size.width, modelF.headerHeight));
//    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * image =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    HSGHHomeQQianModel * model = modelF.model;
//    
//    // 渲染内容
//    
//    UIImage
//    
//    if ([model.content isEqualToString:@""] || model.content == nil) { //
//        if (![model.image.srcUrl isEqualToString:@""] && model.image.srcUrl != nil) {
//            
//        }
//    } else {
//        if (![model.image.srcUrl isEqualToString:@""] && model.image.srcUrl != nil) {
//            //图文
//           
//        } else { // 文字
//           
//        }
//    }
//
//    
//    [UIViewanimateWithDuration:3.0animations:^{
//        [self.tableViewscrollToRowAtIndexPath:[NSIndexPathindexPathForRow:0inSection:1]atScrollPosition:UITableViewScrollPositionTopanimated:NO];// animated 必须为NO，否则和UIView animateWithDuration冲突
//    } completion:^(BOOL finished) {//动画完成后开始渲染
//        if (finished) {
//            for (NSInteger j =0; j < 10; j ++) {
//                NSIndexPath * indexPath = [NSIndexPathindexPathForRow:j inSection:1] ;
//                LJFallDownSectionOneCell * cell = [self.tableViewcellForRowAtIndexPath:indexPath];
//                
//                UIGraphicsBeginImageContext(cell.frame.size);
//                [cell.layerrenderInContext:UIGraphicsGetCurrentContext()];
//                UIImage * image =UIGraphicsGetImageFromCurrentImageContext();
//                if (image) {
//                    [imageArr addObject:image];
//                }
//                UIGraphicsEndImageContext();
//                LJLog(@"bbb%ld",imageArr.count);
//                
//            }
//            
//            // start
//            //将所有小图片拼成一张大图片
//            
//            // 先计算出大图片的大小
//            CGFloat totalH = 0;
//            for (UIImage * imagein imageArr) {
//                totalH += image.size.height;
//            }
//            
//            UIGraphicsBeginImageContext(CGSizeMake(LFScreenWidth, totalH));
//            CGFloat hight = 0;
//            for (NSInteger i =0; i < imageArr.count; i ++) {
//                UIImage * image = imageArr[i];
//                [image drawInRect:CGRectMake(0, hight,LFScreenWidth, image.size.height)];
//                hight += image.size.height;
//                
//            }
//            UIImage * bigImage =UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            /// 存入沙盒
//            NSData * imageData = UIImagePNGRepresentation(bigImage);
//            NSString * filePath =NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)[0];
//            NSString * imagePath = [filePathstringByAppendingString:@"/history.png"];
//            BOOL flag= [imageData writeToFile:imagePath atomically:YES];
//            if (flag) {
//                LJLog(@"存入图片成功");
//            }else{
//                LJLog(@"存入图片失败");
//            }
//            [MBProgressHUD showSuccess:@"保存成功"toView:self.view];
//            // end
//            
//        }
//        
//    }];
//    self.tableView.userInteractionEnabled =YES;
}

- (void)forwardWithQqianVO:(HSGHHomeQQianModel *)qqiansVO succBlock:(FawordSuccBlock)succBlock {
    //转发
    [HSGHHomeViewModel fetchForwardWithParams:@{
                                                @"qqianId" : qqiansVO.qqianId,
                                                @"type" : @0,
                                                @"content" : @""
                                                }:^(BOOL success,NSString * replayId) {
                                                    [[AppDelegate instanceApplication] indicatorDismiss];
                                                    if (success == YES) {
                                                        //Toast *toast = [[Toast alloc] initWithText:@"转发成功!" delay:0 duration:1.f];
                                                        //[toast show];
                                                        if (succBlock!=nil) {
                                                            succBlock();
                                                        }
                                                        
                                                    } else {
                                                        //                    [[[UIAlertView alloc]initWithTitle:@"" message:@"转发失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                                                        HSLog(@"转发失败");
                                                        Toast *toast = [[Toast alloc] initWithText:@"出了一点小问题，请稍后再试!" delay:0 duration:1.f];
                                                        [toast show];
                                                    }
                                                    
                                                }];
    
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

@end
