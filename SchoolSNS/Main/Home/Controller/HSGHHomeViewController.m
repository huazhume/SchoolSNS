//
//  HSGHMessageViewController.m
//
//
//  Created by Huaral on 2017/3/6.
//  Copyright © 2017年 . All rights reserved.
//

#import "HSGHHomeViewController.h"
#import "HSGHHomeNavTagsView.h"
#import "HSGHMoreCommentsVC.h"
#import "HSGHHomeFriendTagsView.h"
#import "ViewController.h"
#import "HSGHHomeFirstView.h"
#import "HSGHKeyBoardView.h"
#import "HSGHHomeSecondView.h"
#import "HSGHHomeThirdView.h"
#import "HSGHHomeModelFrame.h"
#import "HSGHHomeViewModel.h"
#import "HSGHUserInf.h"
#import "MJRefresh.h"
#import "HSGHFriendViewModel.h"
#import "HSGHAtViewController.h"
#import "HSGHLocationManager.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHInspectNetwork.h"
#import "HSGHFirstLaunchShowVC.h"
#import "HSGHNameMatch.h"
#import "HSGHNetworkSession.h"
#import "NSObject+YYModel.h"
#import "UITableView+VideoPlay.h"
#import "HSGHMessageModel.h"


@interface HSGHHomeViewController () <UIScrollViewDelegate, UITextViewDelegate,
    BaceViewDelegate> {
    HOME_BTN_TAGS _oldTag;
    NSInteger pageNumber;
    CGFloat keyboardHeight;
    Boolean keyBoardShow;
    HSGHHomeModel* _dataVo;

    NSInteger _firstPage;
    NSInteger _secondPage;
    NSInteger _thirdPage;
    NSString *_atString;
        
}
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) HSGHHomeNavTagsView* navTagsView;
@property (weak, nonatomic) IBOutlet HSGHHomeFirstView* firstView;
@property (weak, nonatomic) IBOutlet HSGHHomeSecondView* secondView;
@property (weak, nonatomic) IBOutlet HSGHHomeThirdView* thirdView;
@property (strong, nonatomic) HSGHHomeModel* dataVo;
@property (strong, nonatomic) HSGHKeyBoardView* keywordView;
@property (strong, nonatomic) NSArray* fistFrameArr;
@property (strong, nonatomic) NSArray* secondFrameArr;
@property (strong, nonatomic) NSArray* thirdFrameArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* scrollViewToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* navToTop;

@property(assign, nonatomic) int lastIndex;//上一次的索引

@end

@implementation HSGHHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 64dp 错位
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    ViewController* tabVC = (ViewController*)self.tabBarController;
    [tabVC setCenterEnable:TAB_CENTER_ENABLE];
    //刷新地理位置信息
    [self fetchPOIInfo];
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
//        [[[UIAlertView alloc]initWithTitle:@"" message:@"开启系统定位后\n才能搜索到附近和全网新鲜事" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }
    
    //网络不可用
    if(![HSGHInspectNetwork inspectNetwork]){
//         [[[UIAlertView alloc]initWithTitle:@"" message:@"开启数据流量或连接wifi后\n才能搜索新鲜事" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        
        Toast *toast = [[Toast alloc]
                        initWithText:@"当前网络不可用,请检查你的网络设置"
                        delay:0
                        duration:1.f];
        [toast show];
    }
    
    
    if (![HSGHNameMatch isMatchName: [HSGHUserInf shareManager].lastName]) {
        [[AppDelegate instanceApplication] enterFixesCNName];
    }
    else {
        [HSGHSettingsModel defaultFixesName];
        if (![HSGHUserInf hasContainBoardSchool]) {
            Toast *toast = [[Toast alloc]
                            initWithText:@"请至少选择一所国外大学!"
                            delay:0
                            duration:1.f];
            [toast show];
            [[AppDelegate instanceApplication] enterCompleteSchool];
        }
        else {
            if ([HSGHUserInf schoolInfosError]) {
                Toast *toast = [[Toast alloc]
                                initWithText:@"学校信息输入有误，请重新输入!"
                                delay:0
                                duration:1.f];
                [toast show];
                [[AppDelegate instanceApplication] enterCompleteSchool];
            }
        }
    }
    
    HSLog(@"---home---viewWillAppear---%d",self.lastIndex);
    
    if (self.lastIndex==0) {
        [self.firstView.mainTableView handleScrollStop];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dealwithScrollViewWillShow:0 andWillDisappear:0];
        });
        
    } else if (self.lastIndex==1) {
        [self.secondView.mainTableView handleScrollStop];
    } else {
        [self.thirdView.mainTableView handleScrollStop];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    HSLog(@"---home---viewWillDisappear---%d",self.lastIndex);
    
    if (self.lastIndex==0) {
        if (self.firstView.mainTableView.playingCell!=nil) {
            [self.firstView.mainTableView stopPlay];
        }
    } else if (self.lastIndex==1) {
        if (self.secondView.mainTableView.playingCell!=nil) {
            [self.secondView.mainTableView stopPlay];
        }
    } else {
        if (self.thirdView.mainTableView.playingCell!=nil) {
            [self.thirdView.mainTableView stopPlay];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/** 首页thirdView加载更多数据 */
- (void)thirdViewLoadMoreData {
    static BOOL isFresh ;
    if (isFresh) {
        return;
    }
    isFresh = YES;
    _thirdPage++;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
        while (YES) { //判断是否定到位了
            if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
                HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
                break;
            }
        }

        [HSGHNetworkSession postReq:HSGHHomeQQiansRecomURL
                       appendParams:@{@"from":[NSNumber numberWithInteger:_thirdPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),@"longitude": @(sharedManager.coordinate.longitude)}
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                      NSString *errorDes) {
                                  dispatch_async(dispatch_get_main_queue(), ^{

                                      if (status == NetResSuccess) {
                                          if (obj.qqians.count > 0) {
                                              NSMutableArray *mArr = [NSMutableArray arrayWithArray:_thirdFrameArr];
                                              NSInteger count = _thirdFrameArr.count;
                                              NSMutableArray *array = [NSMutableArray array];
                                              for (HSGHHomeQQianModel* tmpModel in obj.qqians) {
                                                  HSGHHomeQQianModelFrame *tmpModelFrame = [[HSGHHomeQQianModelFrame alloc] init];
                                                  [tmpModelFrame setQQModel:tmpModel];
                                                  [mArr addObject:tmpModelFrame];
                                                  [array addObject:[NSIndexPath indexPathForRow:count++ inSection:0]];
                                              }
                                              _thirdFrameArr = [mArr copy];
                                              weakSelf.thirdView.dataFrameArr = _thirdFrameArr;
                                              [weakSelf.thirdView.mainTableView reloadData];
                                          //     [weakSelf.thirdView.mainTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                                          //    [weakSelf.thirdView setData:_thirdFrameArr];
                                          } else {
                                              Toast *toast = [[Toast alloc] initWithText:@"没有更多了" delay:0 duration:1.f];
                                              [toast show];
                                          }

                                      } else {
                                          //Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
                                          //[toast show];
                                          HSLog(@"---网络请求失败---");
                                      }
                                      isFresh = NO;
                                  });
                              }];
        
    });

}

/** 首页secondView加载更多数据 */
- (void)secondViewLoadMoreData {
    static BOOL isFresh ;
    if (isFresh) {
        return;
    }
    isFresh = YES;
    _secondPage++;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
        while (YES) { //判断是否定到位了
            if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
                HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
                break;
            }
        }
        
        [HSGHNetworkSession postReq:HSGHHomeQQiansLocationURL
                       appendParams:@{@"from":[NSNumber numberWithInteger:_secondPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),
                                      @"longitude": @(sharedManager.coordinate.longitude)}
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                      NSString *errorDes) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      if (status == NetResSuccess) {
                                          if (obj.qqians.count > 0) {
                                              NSMutableArray *mArr = [NSMutableArray arrayWithArray:_secondFrameArr];
                                              NSInteger count = _secondFrameArr.count;
                                              NSMutableArray *array = [NSMutableArray array];
                                              for (HSGHHomeQQianModel* tmpModel in obj.qqians) {
                                                  HSGHHomeQQianModelFrame *tmpModelFrame = [[HSGHHomeQQianModelFrame alloc] init];
                                                  [tmpModelFrame setQQModel:tmpModel];
                                                  [mArr addObject:tmpModelFrame];
                                                  [array addObject:[NSIndexPath indexPathForRow:count++ inSection:0]];
                                              }
                                              _secondFrameArr = [mArr copy];
                                              weakSelf.secondView.dataFrameArr = _secondFrameArr;
                                              [weakSelf.secondView.mainTableView reloadData];
                                            //   [weakSelf.secondView.mainTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                                          //    [weakSelf.secondView setData:_secondFrameArr];
                                          } else {
                                              Toast *toast = [[Toast alloc] initWithText:@"没有更多了" delay:0 duration:1.f];
                                              [toast show];
                                          }
                                          
                                      } else {
                                          //Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
                                          //[toast show];
                                          HSLog(@"---网络请求失败---");
                                      }
                                      isFresh = NO;
                                  });
                                  
                              }];
        
    });
}

/** 首页first加载更多数据 */
- (void)firstViewLoadMoreData {
    static BOOL isFresh ;
    if (isFresh) {
        return;
    }
    isFresh = YES;
    _firstPage++;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HSGHNetworkSession postReq:HSGHHomeQQiansURL
                       appendParams:@{@"from": [NSNumber numberWithInteger:_firstPage * 10],@"size":@10,@"type":@3}
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                      NSString *errorDes) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      if (status == NetResSuccess) {
                                          if (obj.qqians.count > 0) {
                                              NSMutableArray *mArr = [NSMutableArray arrayWithArray:_fistFrameArr];
                                              NSInteger count = _fistFrameArr.count;
                                              NSMutableArray *array = [NSMutableArray array];
                                              for (HSGHHomeQQianModel* tmpModel in obj.qqians) {
                                                  HSGHHomeQQianModelFrame *tmpModelFrame = [[HSGHHomeQQianModelFrame alloc] init];
                                                  [tmpModelFrame setQQModel:tmpModel];
                                                  [mArr addObject:tmpModelFrame];
                                                  [array addObject:[NSIndexPath indexPathForRow:count++ inSection:0]];
                                              }
                                              _fistFrameArr = [mArr copy];
                                              weakSelf.firstView.dataFrameArr = _fistFrameArr;
//                                              [weakSelf.firstView.mainTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                                              [weakSelf.firstView.mainTableView reloadData];
                                         //     [weakSelf.firstView setData:_fistFrameArr];
                                              
                                          } else {
                                              Toast *toast = [[Toast alloc] initWithText:@"没有更多了" delay:0 duration:1.f];
                                              [toast show];
                                          }

                                      } else {
                                          //Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
                                          //[toast show];
                                          HSLog(@"---网络请求失败---");
                                      }
                                      isFresh = NO;
                                  });
                              }];
        
    });
}

- (void)addRefresh {
    __weak typeof(self) weakSelf = self;
    //firstView   mj_header
    self.firstView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _firstPage = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HSGHNetworkSession postReq:HSGHHomeQQiansURL
                           appendParams:@{@"from": [NSNumber numberWithInteger:_firstPage * 10],@"size":@10,@"type":@3}
                            returnClass:NSClassFromString(@"HSGHHomeViewModel")
                                  block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                          NSString *errorDes) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf.firstView.mainTableView.mj_header endRefreshing];
                                          
                                          if (status == NetResSuccess) {
                                              if (obj.qqians.count > 0) {//obj.qqians  请求成功
                                                  NSMutableArray *mArr = [NSMutableArray array];
                                                  for (HSGHHomeQQianModel *model in obj.qqians) {
                                                      HSGHHomeQQianModelFrame *modelF = [[HSGHHomeQQianModelFrame alloc] init];
                                                      [modelF setQQModel:model];
                                                      [mArr addObject:modelF];
                                                  }
                                                  _fistFrameArr = [mArr mutableCopy];
                                                  [weakSelf.firstView setData:_fistFrameArr];
                                              }
                                          } else {
                                              Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
                                              [toast show];
                                              HSLog(@"---网络请求失败---");
                                          }
                                      });
                                  }];
            
        });
    }];
    
    //firstView   mj_footer
//    self.firstView.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _firstPage++;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [HSGHNetworkSession postReq:HSGHHomeQQiansURL
//                           appendParams:@{@"from": [NSNumber numberWithInteger:_firstPage * 10],@"size":@10,@"type":@3}
//                            returnClass:NSClassFromString(@"HSGHHomeViewModel")
//                                  block:^(HSGHHomeViewModel *obj, NetResStatus status,
//                                          NSString *errorDes) {
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                          [weakSelf.firstView.mainTableView.mj_footer endRefreshing];
//                                          
//                                          if (status == NetResSuccess) {
//                                              NSMutableArray *mArr = [NSMutableArray arrayWithArray:_fistFrameArr];
//                                              for (HSGHHomeQQianModel* tmpModel in obj.qqians) {
//                                                  HSGHHomeQQianModelFrame *tmpModelFrame = [[HSGHHomeQQianModelFrame alloc] init];
//                                                  [tmpModelFrame setQQModel:tmpModel];
//                                                  [mArr addObject:tmpModelFrame];
//                                              }
//                                              _fistFrameArr = [mArr copy];
//                                              [weakSelf.firstView setData:_fistFrameArr];
//                                              
//                                          } else {
//                                              Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
//                                              [toast show];
//                                              HSLog(@"---网络请求失败---");
//                                          }
//                                          
//                                      });
//                                  }];
//            
//        });
//    }];
    
    
    //secondView   mj_header
    self.secondView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _secondPage = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
            while (YES) { //判断是否定到位了
                if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
                    HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
                    break;
                }
            }
            
            [HSGHNetworkSession postReq:HSGHHomeQQiansLocationURL
                           appendParams:@{@"from":[NSNumber numberWithInteger:_secondPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),
                                          @"longitude": @(sharedManager.coordinate.longitude)}
                            returnClass:NSClassFromString(@"HSGHHomeViewModel")
                                  block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                          NSString *errorDes) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf.secondView.mainTableView.mj_header endRefreshing];
                                          
                                          if (status == NetResSuccess) {
                                              if (obj.qqians.count > 0) {//obj.qqians  请求成功
                                                  NSMutableArray *mArr = [NSMutableArray array];
                                                  for (HSGHHomeQQianModel *model in obj.qqians) {
                                                      HSGHHomeQQianModelFrame *modelF = [[HSGHHomeQQianModelFrame alloc] init];
                                                      [modelF setQQModel:model];
                                                      [mArr addObject:modelF];
                                                  }
                                                  _secondFrameArr = [mArr copy];
                                                  [weakSelf.secondView setData:_secondFrameArr];
                                              }
                                              
                                          } else {
                                              Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
                                              [toast show];
                                              HSLog(@"---网络请求失败---");
                                          }
                                          
                                      });
                                  }];
        });
    }];
    
    //secondView   mj_footer
//    self.secondView.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _secondPage++;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
//            
//            while (YES) { //判断是否定到位了
//                if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
//                    HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
//                    break;
//                }
//            }
//            
//            [HSGHNetworkSession postReq:HSGHHomeQQiansLocationURL
//                           appendParams:@{@"from":[NSNumber numberWithInteger:_secondPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),
//                                          @"longitude": @(sharedManager.coordinate.longitude)}
//                            returnClass:NSClassFromString(@"HSGHHomeViewModel")
//                                  block:^(HSGHHomeViewModel *obj, NetResStatus status,
//                                          NSString *errorDes) {
//                                      
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                          [weakSelf.secondView.mainTableView.mj_footer endRefreshing];
//                                          
//                                          if (status == NetResSuccess) {
//                                              if (obj.qqians.count > 0) {
//                                                  NSMutableArray *mArr = [NSMutableArray arrayWithArray:_secondFrameArr];
//                                                  for (HSGHHomeQQianModel* tmpModel in obj.qqians) {
//                                                      HSGHHomeQQianModelFrame *tmpModelFrame = [[HSGHHomeQQianModelFrame alloc] init];
//                                                      [tmpModelFrame setQQModel:tmpModel];
//                                                      [mArr addObject:tmpModelFrame];
//                                                  }
//                                                  _secondFrameArr = [mArr copy];
//                                                  [weakSelf.secondView setData:_secondFrameArr];
//                                              }
//                                              
//                                          } else {
//                                              Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
//                                              [toast show];
//                                              HSLog(@"---网络请求失败---");
//                                          }
//                                      });
//                                      
//                                  }];
//            
//        });
//    }];
    
    
    //thirdView   mj_header
    self.thirdView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _thirdPage = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
            while (YES) { //判断是否定到位了
                if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
                    HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
                    break;
                }
            }

            
            [HSGHNetworkSession postReq:HSGHHomeQQiansRecomURL
                           appendParams:@{@"from":[NSNumber numberWithInteger:_thirdPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),@"longitude": @(sharedManager.coordinate.longitude)}
                            returnClass:NSClassFromString(@"HSGHHomeViewModel")
                                  block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                          NSString *errorDes) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf.thirdView.mainTableView.mj_header endRefreshing];
                                          
                                          if (status == NetResSuccess) {
                                              if (obj.qqians.count > 0) {//obj.qqians  请求成功
                                                  NSMutableArray *mArr = [NSMutableArray array];
                                                  for (HSGHHomeQQianModel *model in obj.qqians) {
                                                      HSGHHomeQQianModelFrame *modelF = [[HSGHHomeQQianModelFrame alloc] init];
                                                      [modelF setQQModel:model];
                                                      [mArr addObject:modelF];
                                                  }
                                                  _thirdFrameArr = [mArr copy];
                                                  [weakSelf.thirdView setData:_thirdFrameArr];
                                              }
                                          } else {
                                              Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
                                              [toast show];
                                              HSLog(@"---网络请求失败---");
                                          }
                                      });
                                  }];
            
        });
    }];
    
    //thirdView   mj_footer
//    self.thirdView.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _thirdPage++;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
//            while (YES) { //判断是否定到位了
//                if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
//                    HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
//                    break;
//                }
//            }
//            
//            [HSGHNetworkSession postReq:HSGHHomeQQiansRecomURL
//                           appendParams:@{@"from":[NSNumber numberWithInteger:_thirdPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),@"longitude": @(sharedManager.coordinate.longitude)}
//                            returnClass:NSClassFromString(@"HSGHHomeViewModel")
//                                  block:^(HSGHHomeViewModel *obj, NetResStatus status,
//                                          NSString *errorDes) {
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                          [weakSelf.thirdView.mainTableView.mj_footer endRefreshing];
//                                          
//                                          if (status == NetResSuccess) {
//                                              if (obj.qqians.count > 0) {
//                                                  NSMutableArray *mArr = [NSMutableArray arrayWithArray:_thirdFrameArr];
//                                                  for (HSGHHomeQQianModel* tmpModel in obj.qqians) {
//                                                      HSGHHomeQQianModelFrame *tmpModelFrame = [[HSGHHomeQQianModelFrame alloc] init];
//                                                      [tmpModelFrame setQQModel:tmpModel];
//                                                      [mArr addObject:tmpModelFrame];
//                                                  }
//                                                  _thirdFrameArr = [mArr copy];
//                                                  [weakSelf.thirdView setData:_thirdFrameArr];
//                                              }
//                                              
//                                          } else {
//                                              Toast *toast = [[Toast alloc] initWithText:@"网络请求失败!" delay:0 duration:1.f];
//                                              [toast show];
//                                              HSLog(@"---网络请求失败---");
//                                          }
//                                      });
//                                  }];
//            
//        });
//    }];
    
    //    [self.firstView.mainTableView.mj_header beginRefreshing];
    //    [self.secondView.mainTableView.mj_header beginRefreshing];
    //    [self.thirdView.mainTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _oldTag = HOME_Friend_BTN;
    [self addNavigationTagView];
    [self addNotificattionCenter];

    __weak typeof(self) weakSelf = self;
    _firstView.delegate = self;
    _firstView.loadMoreDataBlock = ^{
        [weakSelf firstViewLoadMoreData];
    };
    _secondView.delegate = self;
    _secondView.loadMoreDataBlock = ^{
        [weakSelf secondViewLoadMoreData];
    };
    _thirdView.delegate = self;
    _thirdView.loadMoreDataBlock = ^{
        [weakSelf thirdViewLoadMoreData];
    };
    
//    [self loadDBD00ata];
    [self addRefresh];
    
    
    [self enterFirstAddQianQian];
    
    [self loadFirstViewData];
    [self loadScondViewData];
    [self loadThirdViewData];
}

- (void)loadDBData {
    _fistFrameArr = [NSArray arrayWithArray:[HSGHHomeViewModel fetchDataWithType:HOME_FIRST_MODE]];
    _secondFrameArr = [NSArray arrayWithArray:[HSGHHomeViewModel fetchDataWithType:HOME_SECOND_MODE]];
    _thirdFrameArr = [NSArray arrayWithArray:[HSGHHomeViewModel fetchDataWithType:HOME_THIRD_MODE]];
    
    [_firstView setData:_fistFrameArr];
    [_secondView setData:_secondFrameArr];
    [_thirdView setData:_thirdFrameArr];
}

- (void)addNotificattionCenter
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(replaceDataWithUserInfo:)
               name:HSGH_PUBLISH_NOTIFICATION
             object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(addModelData:)
     name:HSGH_PUBLISH_MESSAGE
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadFirstViewData)
     name:HSGH_POST_2_HOME_FIRST_NOTIFI
     object:nil];
}


- (void)replaceDataWithUserInfo:(NSNotification *)notification {//
    
    NSString * qqianId = notification.userInfo[@"errorId"];
    HSGHHomeQQianModelFrame * modelF = notification.userInfo[@"qqian"];
    __block NSInteger index = -1;
    [_fistFrameArr enumerateObjectsUsingBlock:^(HSGHHomeQQianModelFrame * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj.model.qqianId isEqualToString:qqianId]){
            index = idx;
        }
    }];
    
    
    if(index != -1){
        //替换数据
        NSMutableArray * muArr = [NSMutableArray arrayWithArray:_fistFrameArr];
        modelF.model.image.srcUrl = ((HSGHHomeQQianModelFrame *)_fistFrameArr[index]).model.image.srcUrl;
        [muArr replaceObjectAtIndex:index withObject:modelF];
        _fistFrameArr = [NSArray arrayWithArray:muArr];
        [_firstView replaceData:_fistFrameArr WithIndex:index];
        HSLog(@"替换数据成功");
    }
    else {
         HSLog(@"没有替换数据成功");
    }
    
}


- (void)addModelData:(NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    if(userInfo[@"model"] != nil){
        if([userInfo[@"type"] integerValue] == HOME_FIRST_MODE){
            NSMutableArray * mu = [NSMutableArray arrayWithArray:_fistFrameArr];
            [mu insertObject: [HSGHHomeViewModel transToHomeViewFrameWithHomeModel:@[userInfo[@"model"]]][0] atIndex:0];
            _fistFrameArr = [NSArray arrayWithArray:mu];
            [_firstView setData:_fistFrameArr];
        }
    }
}
- (void)homeViewsReloadData
{

    [self.firstView.mainTableView.mj_header beginRefreshing];
    [self.secondView.mainTableView.mj_header beginRefreshing];
    [self.thirdView.mainTableView.mj_header beginRefreshing];
}

#pragma mark - init

- (void)addKeyBoardView
{
    _keywordView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHKeyBoardView"
                                                  owner:self
                                                options:nil] lastObject];
    _keywordView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    __weak HSGHHomeViewController* weakSelf = self;
    __weak HSGHKeyBoardView* weakkey = _keywordView;
    _keywordView.block = ^(NSIndexPath* indexPath, NSInteger homeMode,
        NSIndexPath* commentIndex, NSInteger editMode) {
        //处理发布
        [[AppDelegate instanceApplication] indicatorShow];
        NSArray* datalist = [NSArray array];
        if (homeMode == HOME_FIRST_MODE) {
            datalist = _fistFrameArr;
        } else if (homeMode == HOME_SECOND_MODE) {
            datalist = _secondFrameArr;
        } else if (homeMode == HOME_THIRD_MODE) {
            datalist = _thirdFrameArr;
        }
        HSGHHomeQQianModel* qqiansVO = ((HSGHHomeQQianModelFrame*)datalist[indexPath.row])
                                           .model;
        __block HOME_MODE _homeMode = (HOME_MODE)homeMode;
        __block EDIT_MODE _editMode = (EDIT_MODE)editMode;
        if (editMode == HOME_COMMENT_MODE) {
            //评论
            [HSGHHomeViewModel fetchCommentWithParams:@{
                @"qqianId" : qqiansVO.qqianId,
                @"content" : weakkey.textView.text
            }:^(BOOL success ,NSString * replayId) {
                [[AppDelegate instanceApplication] indicatorDismiss];
                if (success == YES) {
                    [weakSelf qqianUpWithHomeType:_homeMode andEditType:_editMode andIndex:indexPath];

                } else {
                    HSLog(@"评论失败");
                }
                weakSelf.keywordView.textView.text = @"";

            }];

        } else if (editMode == EDIT_FORWARD_MODE) {
            //转发
            [HSGHHomeViewModel fetchForwardWithParams:@{
                @"qqianId" : qqiansVO.qqianId,
                @"type" : @0,
                @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:weakkey.textView]
            }:^(BOOL success,NSString * replayId) {
                [[AppDelegate instanceApplication] indicatorDismiss];
                if (success == YES) {
                    Toast *toast = [[Toast alloc] initWithText:@"转发成功!" delay:0 duration:1.f];
                    [toast show];
                    [weakSelf qqianUpWithHomeType:_homeMode andEditType:_editMode andIndex:indexPath];
                } else {
//                    [[[UIAlertView alloc]initWithTitle:@"" message:@"转发失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                    HSLog(@"转发失败");
                    Toast *toast = [[Toast alloc] initWithText:@"出了一点小问题，请稍后再试!" delay:0 duration:1.f];
                    [toast show];
                }
                weakSelf.keywordView.textView.text = @"";

            }];

        } else if (HOME_REPLAY_MODE == editMode) {
            //长按评论
        }
        [weakSelf.keywordView removeFromSuperview];
        
    };
    
    _keywordView.atBlock = ^{
        HSGHAtViewController* atViewController = [HSGHAtViewController new];
        atViewController.block = ^(BOOL isSuccess, HSGHFriendSingleModel* model) {
            //Todo  must change when friends is ok.
            if(isSuccess){
                 [HSGHCommentsCallFriendViewModel addOneFriend:model.displayName userId:model.userId location:weakkey.textView.selectedRange.location yyTextView:weakkey.textView];
            }else{
                weakkey.textView.text = [NSString stringWithFormat:@"%@@",weakkey.textView.text];
            }
        };
        [weakSelf.navigationController pushViewController:atViewController animated:YES];
    };
    [self.view addSubview:_keywordView];
    [_keywordView startInputText];
}

/**
 添加navgationView
 */
- (void)addNavigationTagView
{
    self.navTagsView.frame = CGRectMake(0, 0, self.navBgView.frame.size.width, self.navBgView.frame.size.height);
    [self.navBgView addSubview:self.navTagsView];
    __weak HSGHHomeViewController* weakSelf = self;

    _navTagsView.tagBlock = ^(HOME_BTN_TAGS tag) {
        [weakSelf changeContentOffsetWithType:tag];
        _oldTag = tag;
    };
}

- (HSGHHomeNavTagsView*)navTagsView
{
    if (!_navTagsView) {
        _navTagsView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHHomeNavTagsView"
                                                      owner:self
                                                    options:nil] lastObject];
        _navTagsView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 44);
    }
    return _navTagsView;
}

/**
 改变scrollViewContentOfSet

 @param tags BtnTag
 */
- (void)changeContentOffsetWithType:(HOME_BTN_TAGS)tags
{
    int page = 0;
    switch (tags) {
    case HOME_Friend_BTN:
        page = 0;
        break;
    case HOME_FriendRequest_BTN:
        page = 1;
        break;
    case HOME_FriendINTRO_BTN:
        page = 2;
        break;
    }
    self.scrollView.contentOffset = CGPointMake((HSGH_SCREEN_WIDTH)*page, 0);
    pageNumber = page;
    
    
    if (self.lastIndex != page) {
        HSLog(@"---changeContentOffsetWithType---%d消失  ,%d显示",self.lastIndex,page);
        [self dealwithScrollViewWillShow:page andWillDisappear:self.lastIndex];
    } else {
        HSLog(@"---changeContentOffsetWithType---还是当前页---%d",self.lastIndex);
    }
}

/**
 scrollView停止滑动时

 @param scrollView 画布
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    int page = 0;
    if (scrollView.contentOffset.x <= 0) {
        page = 0;
    } else if (scrollView.contentOffset.x <= HSGH_SCREEN_WIDTH) {
        page = 1;
    } else {
        page = 2;
    }
    [_navTagsView moveRedLineFrame:page + 1001];
    pageNumber = page;
}

- (void)dealwithScrollViewWillShow:(int)willShowIndex andWillDisappear:(int)willDisappIndex {
        HSLog(@"---home---%d消失  ,%d显示",willDisappIndex,willShowIndex);
        
        if (willDisappIndex==0) {
            if (self.firstView.mainTableView.playingCell != nil) {
                [self.firstView.mainTableView stopPlay];
            }
        } else if (willDisappIndex==1) {
            if (self.secondView.mainTableView.playingCell != nil) {
                [self.secondView.mainTableView stopPlay];
            }
        } else {
            if (self.thirdView.mainTableView.playingCell != nil) {
                [self.thirdView.mainTableView stopPlay];
            }
        }
        
        
        if (willShowIndex==0) {
            [self.firstView.mainTableView handleScrollStop];
        } else if (willShowIndex==1) {
            [self.secondView.mainTableView handleScrollStop];
        } else {
            [self.thirdView.mainTableView handleScrollStop];
        }
        
        self.lastIndex = willShowIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = (int)scrollView.contentOffset.x / HSGH_SCREEN_WIDTH;
    if (self.lastIndex != index) {
        [self dealwithScrollViewWillShow:index andWillDisappear:self.lastIndex];
    } else {
        HSLog(@"---home---还是当前页---%d",self.lastIndex);//
    }
}

#pragma mark - baseView Delegate

- (void)pushViewVC:(UIViewController*)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

// keyBorddelegate
- (void)qqianCommentAndForwardWithHomeType:(HOME_MODE)mode andEdit:(EDIT_MODE)editMode andMainIndex:(NSIndexPath*)mainIndexPath andNomalIndex:(NSIndexPath*)nomalIndex
{

    [self addKeyBoardView];
    HSGHHomeBaseView* baseView = [HSGHHomeBaseView new];
    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        baseView = _firstView;
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
        baseView = _secondView;
    } else if (mode == HOME_THIRD_MODE) {
        baseView = _thirdView;
        datalist = _thirdFrameArr;
    }
    CGFloat commentHeight = ((HSGHHomeQQianModelFrame*)datalist[mainIndexPath.row]).commentHeight;
    [self adjustTableViewToFitKeyboardWithTableView:baseView.mainTableView andIndexPath:mainIndexPath WithCommentHeight:commentHeight];

    _keywordView.editMode = editMode;
    _keywordView.indexPath = mainIndexPath;
    _keywordView.commentIndex = nomalIndex;
    _keywordView.HomeMode = mode;

    if (editMode == HOME_REPLAY_MODE) {
        //回复
        _keywordView.textView.placeholderText = [NSString stringWithFormat:@"回复%@", ((HSGHHomeQQianModelFrame*)datalist[nomalIndex.row]).model.partReplay[nomalIndex.row].fromUser.displayName];
    } else if (editMode == EDIT_FORWARD_MODE) {
        //转发
        NSString * userName = ((HSGHHomeQQianModelFrame*)datalist[mainIndexPath.row]).model.creator.displayName;
        if([userName isEqualToString:@""]||userName == nil ){
            _keywordView.textView.placeholderText = [NSString stringWithFormat:@"转发此条匿名新鲜事"];
        }else{
            _keywordView.textView.placeholderText = [NSString stringWithFormat:@"转发%@的新鲜事", ((HSGHHomeQQianModelFrame*)datalist[mainIndexPath.row]).model.creator.displayName];
        }
        //计算tableView 中comment的高度
    } else if (editMode == HOME_COMMENT_MODE) {
        //评论
        _keywordView.textView.placeholderText = [NSString stringWithFormat:@"评论%@的新鲜事", ((HSGHHomeQQianModelFrame*)datalist[mainIndexPath.row]).model.creator.displayName];
    }
}

- (void)adjustTableViewToFitKeyboardWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath WithCommentHeight:(CGFloat)commentHeight
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    rect.origin.y = rect.origin.y - commentHeight + 64;
    [self adjustTableViewToFitKeyboardWithRect:rect WithTableView:tableView];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect WithTableView:(UITableView*)tableView
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _keywordView.keyboardHeight);

    CGPoint offset = tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }

    [tableView setContentOffset:offset animated:YES];
}

- (void)qqianAddFrinedWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath*)indexPath
{
    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
    } else if (mode == HOME_THIRD_MODE) {
        datalist = _thirdFrameArr;
    }
    HSGHHomeQQianModelFrame* Frame = (HSGHHomeQQianModelFrame*)datalist[indexPath.row];
    HSGHHomeQQianModel* qqiansVO = Frame.model;
    NSString* imageFileName = @"";
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
    default:
        break;
    }
    HSGHHomeQQianModelFrame* voFrame = [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [voFrame setModel:qqiansVO];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    if (mode == HOME_FIRST_MODE) {
        _fistFrameArr = [NSArray arrayWithArray:arr];
        [_firstView reloadData:_fistFrameArr andIndex:indexPath];

    } else if (mode == HOME_SECOND_MODE) {
        _secondFrameArr = [NSArray arrayWithArray:arr];
        [_secondView reloadData:_secondFrameArr andIndex:indexPath];

    } else if (mode == HOME_THIRD_MODE) {
        _thirdFrameArr = [NSArray arrayWithArray:arr];
        [_thirdView reloadData:_thirdFrameArr andIndex:indexPath];
    }
}
// 查看更多
- (void)qqianMoreWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath*)indexPath
{
    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
    } else if (mode == HOME_THIRD_MODE) {
        datalist = _thirdFrameArr;
    }
    HSGHHomeQQianModelFrame* Frame = (HSGHHomeQQianModelFrame*)datalist[indexPath.row];
    HSGHHomeQQianModel* qqiansVO = Frame.model;
    qqiansVO.contentIsMore = @(![qqiansVO.contentIsMore integerValue]);
    HSGHHomeQQianModelFrame* voFrame = [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [voFrame setModel:qqiansVO];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    if (mode == HOME_FIRST_MODE) {
        _fistFrameArr = [NSArray arrayWithArray:arr];
        [_firstView reloadData:_fistFrameArr andIndex:indexPath];

    } else if (mode == HOME_SECOND_MODE) {
        _secondFrameArr = [NSArray arrayWithArray:arr];
        [_secondView reloadData:_secondFrameArr andIndex:indexPath];

    } else if (mode == HOME_THIRD_MODE) {
        _thirdFrameArr = [NSArray arrayWithArray:arr];
        [_thirdView reloadData:_thirdFrameArr andIndex:indexPath];
    }
}
// 点赞
- (void)qqianUpWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath*)indexPath
{

    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
    } else if (mode == HOME_THIRD_MODE) {
        datalist = _thirdFrameArr;
    }
    HSGHHomeQQianModelFrame* frame = [HSGHHomeViewModel upQQianModel:((HSGHHomeQQianModelFrame*)datalist[indexPath.row]).model];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:frame];
    if (mode == HOME_FIRST_MODE) {
        _fistFrameArr = [NSArray arrayWithArray:arr];
        [_firstView reloadData:_fistFrameArr andIndex:indexPath];

    } else if (mode == HOME_SECOND_MODE) {
        _secondFrameArr = [NSArray arrayWithArray:arr];
        [_secondView reloadData:_secondFrameArr andIndex:indexPath];

    } else if (mode == HOME_THIRD_MODE) {
        _thirdFrameArr = [NSArray arrayWithArray:arr];
        [_thirdView reloadData:_thirdFrameArr andIndex:indexPath];
    }
}

// 评论 转发
- (void)qqianUpWithHomeType:(HOME_MODE)mode andEditType:(EDIT_MODE)editMode andIndex:(NSIndexPath*)indexPath
{

    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
    } else if (mode == HOME_THIRD_MODE) {
        datalist = _thirdFrameArr;
    }
    HSGHHomeQQianModelFrame * originFrame = datalist[indexPath.row];
    if([originFrame.model.forward integerValue] == NO){
        HSGHHomeQQianModelFrame* voFrame = [HSGHHomeViewModel commentQQianModel:((HSGHHomeQQianModelFrame*)datalist[indexPath.row]).model WithText:_keywordView.textView.text Mode:editMode];
        
        NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
        [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
        if (mode == HOME_FIRST_MODE) {
            _fistFrameArr = [NSArray arrayWithArray:arr];
            [_firstView reloadData:_fistFrameArr andIndex:indexPath];
            
        } else if (mode == HOME_SECOND_MODE) {
            _secondFrameArr = [NSArray arrayWithArray:arr];
            [_secondView reloadData:_secondFrameArr andIndex:indexPath];
            
        } else if (mode == HOME_THIRD_MODE) {
            _thirdFrameArr = [NSArray arrayWithArray:arr];
            [_thirdView reloadData:_thirdFrameArr andIndex:indexPath];
        }
    }
}


// 删除
- (void)qqianRemoveHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath {
    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
    } else if (mode == HOME_THIRD_MODE) {
        datalist = _thirdFrameArr;
    }
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
    [arr removeObjectAtIndex:indexPath.row];
    
    if (mode == HOME_FIRST_MODE) {
        _fistFrameArr = [NSArray arrayWithArray:arr];
        [_firstView reloadData:_fistFrameArr];
        
    } else if (mode == HOME_SECOND_MODE) {
        _secondFrameArr = [NSArray arrayWithArray:arr];
        [_secondView reloadData:_secondFrameArr ];
        
    } else if (mode == HOME_THIRD_MODE) {
        _thirdFrameArr = [NSArray arrayWithArray:arr];
        [_thirdView reloadData:_thirdFrameArr];
    }

}

//取消点赞
- (void)cancelQqianUpWithHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath {
    NSArray* datalist = [NSArray array];
    if (mode == HOME_FIRST_MODE) {
        datalist = _fistFrameArr;
    } else if (mode == HOME_SECOND_MODE) {
        datalist = _secondFrameArr;
    } else if (mode == HOME_THIRD_MODE) {
        datalist = _thirdFrameArr;
    }
    HSGHHomeQQianModelFrame * modelF = datalist[indexPath.row];
    HSGHHomeQQianModel * model = modelF.model;
    model.up = @(0);
    model.upCount =[NSNumber numberWithUnsignedInteger:[model.upCount integerValue] - 1];
    //便利数组
    NSMutableArray * upModelArr = [NSMutableArray arrayWithArray:model.partUp];
    __block NSUInteger index = 999999;
    [model.partUp enumerateObjectsUsingBlock:^(HSGHHomeUp * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[HSGHUserInf shareManager].userId  isEqualToString:obj.userId]){
            index = idx;
        }
    }];
    if(index != 999999){
        [upModelArr removeObjectAtIndex:index];
    }
    model.partUp = [NSArray arrayWithArray:upModelArr];
    HSGHHomeQQianModelFrame * modelF2 = [[HSGHHomeQQianModelFrame alloc]initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [modelF2 setModel:model];
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:modelF2];
    
    if (mode == HOME_FIRST_MODE) {
        _fistFrameArr = [NSArray arrayWithArray:arr];
        [_firstView reloadData:_fistFrameArr andIndex:indexPath];
        
    } else if (mode == HOME_SECOND_MODE) {
        _secondFrameArr = [NSArray arrayWithArray:arr];
        [_secondView reloadData:_secondFrameArr andIndex:indexPath ];
        
    } else if (mode == HOME_THIRD_MODE) {
        _thirdFrameArr = [NSArray arrayWithArray:arr];
        [_thirdView reloadData:_thirdFrameArr andIndex:indexPath];
    }

}

#pragma mark - 上移和刷新
- (void)moveToTopAndIsRefresh:(BOOL)isRefresh
{
    HSGHHomeBaseView* baseView = [HSGHHomeBaseView new];
    NSArray* datalist = [NSArray new];
    switch (pageNumber) {
    case 0:
        baseView = _firstView;
        datalist = _fistFrameArr;
        break;
    case 1:
        baseView = _secondView;
        datalist = _secondFrameArr;

        break;
    case 2:
        baseView = _thirdView;
        datalist = _thirdFrameArr;

        break;
    default:
        break;
    }
    if (datalist.count > 0) {
        [baseView.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        if (baseView.mainTableView.contentOffset.y == 0) {
            [baseView.mainTableView.mj_header beginRefreshing];
            isRefresh = NO;
        }
    }
    if (isRefresh) {
        [baseView.mainTableView.mj_header beginRefreshing];
    }
}

#pragma mark - textVIew delegate

//- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//
//    if ([text isEqualToString:@"@"]) { //判断输入的字是否是回车，即按下return
//        HSGHAtViewController* atViewController = [HSGHAtViewController new];
//        atViewController.block = ^(HSGHFriendSingleModel* model) {
//            textView.text = [NSString stringWithFormat:@"%@%@ ", textView.text, model.nickName];
//            _atString = [NSString stringWithFormat:@"@%@ ", model.nickName];
//        };
//        [self.navigationController pushViewController:atViewController animated:YES];
//    } else if ([text length] == 0) //点击了删除键
//    {
//        if ((textView.text.length >= _atString.length) && [[textView.text substringWithRange:NSMakeRange(textView.text.length - _atString.length, _atString.length)] isEqualToString:_atString]) {
//            textView.text = [textView.text substringToIndex:textView.text.length - _atString.length];
//            return NO;
//        }
//    }
//    return YES;
//}



- (void)navAndTabIsHidden:(BOOL)isHidden
{
    ViewController* tabVC = (ViewController*)self.tabBarController;
    if (isHidden != tabVC.isFullScreen) {
//        if (isHidden) {
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 //                self.tableViewToNavHeight.constant = 0;
//                                 self.navToTop.constant = -24;
//                                 [self.view layoutIfNeeded];
//                             }];
//        } else {
//            [_navTagsView moveLineWithTag:pageNumber];
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 //                self.tableViewToNavHeight.constant = 64;
//                                 self.navToTop.constant = 20;
//                                 [self.view layoutIfNeeded];
//                             }
//                             completion:^(BOOL finished){
//                             }];
//        }
//        [tabVC navgationAndTabisHidden:isHidden];
    }
}
// 刷新下位置信息
- (void)fetchPOIInfo {
    HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
    [sharedManager fetchCoordinate:^(CLLocationCoordinate2D coordinate) {
        
    }];
}


#pragma mark- addFirst loading
- (void)enterFirstAddQianQian {
    if (![HSGHUserInf shareManager].hasSendQianQian) {
        HSGHFirstLaunchShowVC* vc = [[HSGHFirstLaunchShowVC alloc]initWithNibName:@"HSGHFirstLaunchShowVC" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav setNavigationBarHidden:YES animated:NO];
        [self presentViewController:nav animated:YES completion:nil];
        
//        HSGHPhotoPickerController *vc = [HSGHPhotoPickerController new];
//        vc.isLauncher = true;
//        vc.isPush = true;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [nav setNavigationBarHidden:YES animated:YES];
//        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 请求页面数据
/** 加载FirstView数据 */
- (void)loadFirstViewData {
    __weak typeof(self) weakSelf = self;
    _firstPage = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HSGHNetworkSession postReq:HSGHHomeQQiansURL
                       appendParams:@{@"from": [NSNumber numberWithInteger:_firstPage * 10],@"size":@10,@"type":@3}
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                      NSString *errorDes) {
                                  if (status == NetResSuccess) {
                                      if (obj.qqians.count > 0) {//obj.qqians  请求成功
                                          NSMutableArray *mArr = [NSMutableArray array];
                                          for (HSGHHomeQQianModel *model in obj.qqians) {
                                              HSGHHomeQQianModelFrame *modelF = [[HSGHHomeQQianModelFrame alloc] init];
                                              [modelF setQQModel:model];
                                              [mArr addObject:modelF];
                                          }
                                          _fistFrameArr = [mArr copy];
                                          [weakSelf.firstView setData:_fistFrameArr];
                                          [weakSelf.firstView.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                      }
                                  } else {
                                      HSLog(@"---网络请求失败---");
                                  }
                              }];
    });
}

/** 加载ScondView数据 */
- (void)loadScondViewData {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _secondPage = 0;
        HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
        while (YES) { //判断是否定到位了
            if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
                HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
                break;
            }
        }
        
        [HSGHNetworkSession postReq:HSGHHomeQQiansLocationURL
                       appendParams:@{@"from":[NSNumber numberWithInteger:_secondPage * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),
                                      @"longitude": @(sharedManager.coordinate.longitude)}
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                      NSString *errorDes) {
                                  
                                  if (status == NetResSuccess) {
                                      if (obj.qqians.count > 0) {//obj.qqians  请求成功
//                                          [weakSelf dealWithsecondViewData:obj.qqians];//处理数据
//                                          [weakSelf.secondView setData:weakSelf.secondQQianModelFrameArr];
                                          
                                          NSMutableArray *mArr = [NSMutableArray array];
                                          for (HSGHHomeQQianModel *model in obj.qqians) {
                                              HSGHHomeQQianModelFrame *modelF = [[HSGHHomeQQianModelFrame alloc] init];
                                              [modelF setQQModel:model];
                                              [mArr addObject:modelF];
                                          }
                                          _secondFrameArr = [mArr copy];
                                          [weakSelf.secondView setData:_secondFrameArr];
                                      }
                                      
                                  } else {
                                      HSLog(@"---网络请求失败---");
                                  }
                              }];
        
        
    });
}

/** 加载ThirdView数据 */
- (void)loadThirdViewData {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _thirdPage = 0;
        
        [HSGHNetworkSession postReq:HSGHHomeQQiansRecomURL
                       appendParams:@{@"from":[NSNumber numberWithInteger:_thirdPage * 10],@"size":@10}
                        returnClass:NSClassFromString(@"HSGHHomeViewModel")
                              block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                      NSString *errorDes) {
                                  
                                  if (status == NetResSuccess) {
                                      if (obj.qqians.count > 0) {//obj.qqians  请求成功
                                          NSMutableArray *mArr = [NSMutableArray array];
                                          for (HSGHHomeQQianModel *model in obj.qqians) {
                                              HSGHHomeQQianModelFrame *modelF = [[HSGHHomeQQianModelFrame alloc] init];
                                              [modelF setQQModel:model];
                                              [mArr addObject:modelF];
                                          }
                                          _thirdFrameArr = [mArr copy];
                                          [weakSelf.thirdView setData:_thirdFrameArr];
                                      }
                                  } else {
                                      HSLog(@"网络请求失败");
                                  }
                              }];
        
    });
}

#pragma mark - 缓存数组相关


@end
