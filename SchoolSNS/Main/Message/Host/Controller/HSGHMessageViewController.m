//
//  HSGHMessageViewController.m
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/6.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHMessageViewController.h"
#import "HSGHMessageModel.h"
#import "HSGHMsgDetailViewController.h"
#import "HSGHMsgFirstView.h"
#import "HSGHMsgNavTagsView.h"
#import "HSGHMsgSecondView.h"
#import "HSGHMsgTableViewCell.h"
#import "HSGHMsgThirdView.h"
#import "PPBadgeView.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface HSGHMessageViewController () <UIScrollViewDelegate,
                                         BaseViewDelegate> {
  NSInteger _firstPager;
  NSInteger _secondPager;
  NSInteger _thirdPager;
  NSArray *_firstArr;
  NSArray *_secondArr;
  NSArray *_thirdArr;
  NSInteger _pageIndex;

  BOOL isVisiable;
}
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) HSGHMsgNavTagsView *navTagsView;
@property(weak, nonatomic) IBOutlet HSGHMsgFirstView *firstView;
@property(weak, nonatomic) IBOutlet HSGHMsgSecondView *secondView;
@property(weak, nonatomic) IBOutlet HSGHMsgThirdView *thirdView;
@property(assign, nonatomic) BOOL firstReload;
@property(assign, nonatomic) BOOL secondReload;
@property(assign, nonatomic) BOOL thirdReload;

@property(nonatomic, strong) HSGHMessageModel *firstMessgeModel;
@property(nonatomic, strong) HSGHMessageModel *secondMessgeModel;
@property(nonatomic, strong) HSGHMessageModel *thirdMessgeModel;

@property(assign, nonatomic) int lastIndex;//上一次的索引

@end

@implementation HSGHMessageViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // 64dp 错位
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.tabBarController.tabBar.hidden = NO;
  self.navigationController.navigationBarHidden = YES;
  //重置消息数
//  [HSGHMessageModel fetchResetMessageNumber:^(BOOL success){
//
//  }];
//  [self refleshData];
    [self refreshNoHeaderData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self changeRedItemsSignAndScrollView];
    isVisiable = YES;
}

/** 改变红点位置并设置scrollview */
- (void)changeRedItemsSignAndScrollView {
    ViewController *tabVC = (ViewController *)self.tabBarController;
    HSGHNotificationMessage *notifacationMsgModel = tabVC.messageMsgNumModel;
    
    if (notifacationMsgModel.firstMsgNum > 0) {
        [_navTagsView.firstBtn pp_addDotWithColor:nil];
        CGFloat tmpX = -_navTagsView.firstBtn.frame.size.width/2+30;
        [_navTagsView.firstBtn pp_moveBadgeWithX:tmpX Y:5];
    }
    if (notifacationMsgModel.secondMsgNum > 0) {
        [_navTagsView.secondBtn pp_addDotWithColor:nil];
        CGFloat tmpX = -_navTagsView.secondBtn.frame.size.width/2+30;
        [_navTagsView.secondBtn pp_moveBadgeWithX:tmpX Y:5];
    }
    if (notifacationMsgModel.thirdMsgNum > 0) {
        [_navTagsView.thirdBtn pp_addDotWithColor:nil];
        CGFloat tmpX = -_navTagsView.thirdBtn.frame.size.width/2+30;
        [_navTagsView.thirdBtn pp_moveBadgeWithX:tmpX Y:5];
    }
    
    if (!isVisiable) {
        if (notifacationMsgModel.firstMsgNum > 0) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            [_navTagsView moveRedLineFrame:1001 animated:NO];
            self.lastIndex = 0;
        } else if (notifacationMsgModel.secondMsgNum > 0) {
            [self.scrollView setContentOffset:CGPointMake(HSGH_SCREEN_WIDTH, 0) animated:NO];
            [_navTagsView moveRedLineFrame:1002 animated:NO];
            self.lastIndex = 1;
        }else if (notifacationMsgModel.thirdMsgNum > 0) {
            [self.scrollView setContentOffset:CGPointMake(HSGH_SCREEN_WIDTH*2, 0) animated:NO];
            [_navTagsView moveRedLineFrame:1003 animated:NO];
            self.lastIndex = 2;
        }
    }
    
    if (notifacationMsgModel.firstMsgNum +notifacationMsgModel.secondMsgNum + notifacationMsgModel.thirdMsgNum <1) {
        [tabVC.tabBar.items[3] pp_hiddenBadge];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  isVisiable = NO;
}

- (void)changeRedItemsSign {
  //改变数据源
//  ViewController *tabVC = (ViewController *)self.tabBarController;
//  HSGHNotificationMessage *numModel = tabVC.messageMsgNumModel;
//  NSInteger type;
//  if (_pageIndex == 0) {
//    type = 3;
//    numModel.firstMsgNum = 0;
//  } else if (_pageIndex == 1) {
//    type = 1;
//    numModel.secondMsgNum = 0;
//  } else {
//    type = 2;
//    numModel.thirdMsgNum = 0;
//  }
//  //改变为零
//  [HSGHMessageModel fetchResetMessageNumberWithType:@(type):^(BOOL success){
//                                                        //重置为零
//                                                    }];
//  if (numModel.firstMsgNum + numModel.secondMsgNum + numModel.thirdMsgNum >
//      0) { //有消息则变红
//    [tabVC.tabBar.items[3] pp_addDotWithColor:nil];
//    [tabVC.tabBar.items[3] pp_moveBadgeWithX:0 Y:5];
//    [self refreshRedCountWithIndex:0 WithHaveNewMessage:numModel.firstMsgNum];
//    [self refreshRedCountWithIndex:1 WithHaveNewMessage:numModel.secondMsgNum];
//    [self refreshRedCountWithIndex:2 WithHaveNewMessage:numModel.thirdMsgNum];
//
//  } else {
//    [tabVC.tabBar.items[3] pp_hiddenBadge];
//  }
//  [self refreshRedCountWithIndex:_pageIndex WithHaveNewMessage:NO];
}

- (void)refreshRedCountWithIndex:(NSInteger)index WithHaveNewMessage:(NSInteger )hasNum {
//  UIButton *btn;
//  if (index == 0) {
//    btn = _navTagsView.firstBtn;
//  } else if (index == 1) {
//    btn = _navTagsView.secondBtn;
//  } else if (index == 2) {
//    btn = _navTagsView.thirdBtn;
//  }
//  if (hasNum > 0) {
//    //有新消息
//    [btn pp_addDotWithColor:nil];
////      [btn pp_addBadgeWithNumber:hasNum];
//      
//    [btn pp_moveBadgeWithX:-btn.width / 4.0 Y:7];
//
//  } else {
//    //没有
//    [btn pp_hiddenBadge];
//  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _firstView.delegate = self;
  _secondView.delegate = self;
  _thirdView.delegate = self;

  [self addNavigationTagView];
  [self setupModel];
  [self addRefrsh];
  if (!_firstReload) {
    //[_firstView.mainTableView.mj_header beginRefreshing];
    _firstReload = true;
  }
    
    //加载数据
    [self loadMsgFirstViewData];
    [self loadMsgSecondViewData];
    [self loadMsgThirdViewData];
    

  [self addNotifacationCenter];
    [self refleshData];
}

- (void)refreshNoHeaderData {
  __weak typeof(self) weakSelf = self;

//  _firstPager = 0;
//  [HSGHMessageModel
//      fetchMessageViewModelArrWithType:3
//                                  Page:
//                           _firstPager:^(BOOL success, NSArray *array) {
//                             [weakSelf.firstView.mainTableView
//                                     .mj_header endRefreshing];
//                             if (success) {
//                               _firstArr = [NSArray arrayWithArray:array];
//                               [weakSelf.firstView setDataArray:_firstArr];
//                             }
//
//                           }];

  _secondPager = 0;
  [HSGHMessageModel
      fetchMessageViewModelArrWithType:1
                                  Page:
                          _secondPager:^(BOOL success, NSArray *array) {
                            [weakSelf.secondView.mainTableView
                                    .mj_header endRefreshing];
                            if (success) {
                              _secondArr = [NSArray arrayWithArray:array];
                              [weakSelf.secondView setDataArray:_secondArr];
                            }

                          }];

  _thirdArr = 0;
  [HSGHMessageModel
      fetchMessageViewModelArrWithType:2
                                  Page:
                           _thirdPager:^(BOOL success, NSArray *array) {
                             [weakSelf.thirdView.mainTableView
                                     .mj_header endRefreshing];
                             if (success) {
                               _thirdArr = [NSArray arrayWithArray:array];
                               [weakSelf.thirdView setDataArray:_thirdArr];
                             }

                           }];
    if (isVisiable) {
//        [HSGHMessageModel getMessageCount:^(BOOL success, HSGHMessageModel * obj) {
//            if (success) {
//                AppDelegate* delegate = [AppDelegate instanceApplication];
//                ViewController *vc = (ViewController *) (delegate.window.rootViewController);
//                if ([vc isKindOfClass:[UITabBarController class]]) {
//                    if (obj.count > 0) {
//                        [vc.tabBar.items[3] pp_addDotWithColor:nil];
//                        [vc.tabBar.items[3] pp_moveBadgeWithX:0 Y:5];
//                    }
//                    else {
//                        [vc.tabBar.items[3] pp_hiddenBadge];
//                    }
//                    //消息数
//                    HSGHNotificationMessage * messageModel = vc.messageMsgNumModel;
//                    messageModel.firstMsgNum = obj.replyCount;
//                    messageModel.secondMsgNum = obj.atCount;
//                    messageModel.thirdMsgNum = obj.upCount;
//                    vc.messageMsgNumModel = messageModel;
//                    [self changeRedItemsSign];
//                }
//            }
//        }];
        
    }

}
- (void)refleshNotificationData:(NSNotification *)nofi{
    NSDictionary * user = nofi.userInfo;
    NSNumber * number = user[@"sign"];
    switch ([number integerValue]) {
        case 1:
            [self loadMsgFirstViewData];
            //[self.firstView.mainTableView.mj_header beginRefreshing];
            break;
        case 2:
            [self loadMsgSecondViewData];
            //[self.secondView.mainTableView.mj_header beginRefreshing];
            break;
        case 3:
            [self loadMsgThirdViewData];
            //[self.thirdView.mainTableView.mj_header beginRefreshing];
            break;
            
        default:
            break;
    }
    
    [self changeRedItemsSignAndScrollView];
}

- (void)refleshData {
//    [self.firstView.mainTableView.mj_header endRefreshing];
//    [self.secondView.mainTableView.mj_header endRefreshing];
//    [self.thirdView.mainTableView.mj_header endRefreshing];
    
//  [self.firstView.mainTableView.mj_header beginRefreshing];
//  [self.secondView.mainTableView.mj_header beginRefreshing];
//  [self.thirdView.mainTableView.mj_header beginRefreshing];
//
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),
//                 dispatch_get_main_queue(), ^{
//                   [self.firstView.mainTableView.mj_header endRefreshing];
//                   [self.secondView.mainTableView.mj_header endRefreshing];
//                   [self.thirdView.mainTableView.mj_header endRefreshing];
//                 });

  if (isVisiable) {
//      [HSGHMessageModel getMessageCount:^(BOOL success, HSGHMessageModel * obj) {
//          if (success) {
//              AppDelegate* delegate = [AppDelegate instanceApplication];
//              ViewController *vc = (ViewController *) (delegate.window.rootViewController);
//              if ([vc isKindOfClass:[UITabBarController class]]) {
//                  if (obj.count > 0) {
//                      [vc.tabBar.items[3] pp_addDotWithColor:nil];
//                      [vc.tabBar.items[3] pp_moveBadgeWithX:0 Y:5];
//                  }
//                  else {
//                      [vc.tabBar.items[3] pp_hiddenBadge];
//                  }
//                  //消息数
//                  HSGHNotificationMessage * messageModel = vc.messageMsgNumModel;
//                  messageModel.firstMsgNum = obj.replyCount;
//                  messageModel.secondMsgNum = obj.atCount;
//                  messageModel.thirdMsgNum = obj.upCount;
//                  vc.messageMsgNumModel = messageModel;
//                  [self changeRedItemsSign];
//              }
//          }
//      }];

  }
}
/**
 添加navgationView
 */
- (void)addNavigationTagView {
  _navTagsView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHMsgNavTagsView"
                                                owner:self
                                              options:nil] lastObject];
  _navTagsView.frame = CGRectMake(0, 0, self.navTagBgView.frame.size.width,  self.navTagBgView.frame.size.height);
  [self.navTagBgView addSubview:_navTagsView];
  
  __weak HSGHMessageViewController *weakSelf = self;
  _navTagsView.tagBlock = ^(MSG_BTN_TAGS tag) {
    [weakSelf changeContentOffsetWithType:tag];
    [weakSelf.view endEditing:YES];
  };
  _navTagsView.backgroundColor = HEXRGBCOLOR(0xFAFAFA);
}

#pragma mark - network request
- (void)setupModel {
  _firstArr = [NSArray new];
  _secondArr = [NSArray new];
  _thirdArr = [NSArray new];
}




/** 加载消息第一个tab页的数据 */
- (void)loadMsgFirstViewData {
    __weak typeof(self) weakSelf = self;
    _firstPager = 0;
    [HSGHMessageModel fetchMessageViewModelArrWithType:3 Page: _firstPager:^(BOOL success, NSArray *array) {
         if (success ) {
             _firstArr = [NSArray arrayWithArray:array];
             [weakSelf.firstView setDataArray:_firstArr];
         }
     }];
}

/** 加载消息第二个tab页的数据 */
- (void)loadMsgSecondViewData {
    __weak typeof(self) weakSelf = self;
    _secondPager = 0;
    [HSGHMessageModel fetchMessageViewModelArrWithType:1 Page: _secondPager:^(BOOL success, NSArray *array) {
         if (success ) {
             _secondArr = [NSArray arrayWithArray:array];
             [weakSelf.secondView setDataArray:_secondArr];
         }
     }];
}

/** 加载消息第三个tab页的数据 */
- (void)loadMsgThirdViewData {
    __weak typeof(self) weakSelf = self;
    _thirdPager = 0;
    [HSGHMessageModel fetchMessageViewModelArrWithType:2 Page: _thirdPager:^(BOOL success, NSArray *array) {
         if (success ) {
             _thirdArr = [NSArray arrayWithArray:array];
             [weakSelf.thirdView setDataArray:_thirdArr];
         }
     }];
}

- (void)addRefrsh {
  __weak typeof(self) weakSelf = self;
  _firstView.mainTableView.mj_header =
      [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _firstPager = 0;
        [HSGHMessageModel
            fetchMessageViewModelArrWithType:3
                                        Page:
                                 _firstPager:^(BOOL success, NSArray *array) {
                                   [weakSelf.firstView.mainTableView
                                           .mj_header endRefreshing];
                                   if (success ) {
                                     _firstArr = [NSArray arrayWithArray:array];
                                     [weakSelf.firstView
                                         setDataArray:_firstArr];
                                   }

                                 }];

      }];
  _firstView.mainTableView.mj_footer =
      [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _firstPager++;
        [HSGHMessageModel
            fetchMessageViewModelArrWithType:3
                                        Page:
                                 _firstPager:^(BOOL success, NSArray *array) {
                                   [weakSelf.firstView.mainTableView
                                           .mj_footer endRefreshing];
                                   if (success ) {
                                     NSMutableArray *muArr = [NSMutableArray
                                         arrayWithArray:_firstArr];
                                     [muArr addObjectsFromArray:array];
                                     _firstArr = [NSArray arrayWithArray:muArr];
                                     [weakSelf.firstView
                                         setDataArray:_firstArr];
                                   }

                                 }];
      }];

  _secondView.mainTableView.mj_header =
      [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _secondPager = 0;
        [HSGHMessageModel
            fetchMessageViewModelArrWithType:1
                                        Page:
                                 _secondPager:^(BOOL success, NSArray *array) {
                                   [weakSelf.secondView.mainTableView
                                           .mj_header endRefreshing];
                                   if (success ) {
                                     _secondArr =
                                         [NSArray arrayWithArray:array];
                                     [weakSelf.secondView
                                         setDataArray:_secondArr];
                                   }

                                 }];

      }];

  _secondView.mainTableView.mj_footer =
      [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _secondPager++;
        [HSGHMessageModel
            fetchMessageViewModelArrWithType:1
                                        Page:
                                 _secondPager:^(BOOL success, NSArray *array) {
                                   [weakSelf.secondView.mainTableView
                                           .mj_footer endRefreshing];
                                   if (success ) {
                                     NSMutableArray *muArr = [NSMutableArray
                                         arrayWithArray:_secondArr];
                                     [muArr addObjectsFromArray:array];
                                     _secondArr =
                                         [NSArray arrayWithArray:muArr];
                                     [weakSelf.secondView
                                         setDataArray:_secondArr];
                                   }

                                 }];
      }];

  _thirdView.mainTableView.mj_header =
      [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _thirdPager = 0;
        [HSGHMessageModel
            fetchMessageViewModelArrWithType:2
                                        Page:
                                 _thirdPager:^(BOOL success, NSArray *array) {
                                   [weakSelf.thirdView.mainTableView
                                           .mj_header endRefreshing];
                                   if (success ) {
                                     _thirdArr = [NSArray arrayWithArray:array];
                                     [weakSelf.thirdView
                                         setDataArray:_thirdArr];
                                   }

                                 }];
      }];

  _thirdView.mainTableView.mj_footer =
      [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _thirdPager++;
        [HSGHMessageModel
            fetchMessageViewModelArrWithType:2
                                        Page:
                                 _thirdPager:^(BOOL success, NSArray *array) {
                                   [weakSelf.thirdView.mainTableView
                                           .mj_footer endRefreshing];
                                   if (success ) {
                                     NSMutableArray *muArr = [NSMutableArray
                                         arrayWithArray:_thirdArr];
                                     [muArr addObjectsFromArray:array];
                                     _thirdArr = [NSArray arrayWithArray:muArr];
                                     [weakSelf.thirdView
                                         setDataArray:_thirdArr];
                                   }

                                 }];
      }];
}

/**
 改变scrollViewContentOfSet

 @param tags BtnTag
 */
- (void)changeContentOffsetWithType:(MSG_BTN_TAGS)tags {
//  int page = 0;
//  switch (tags) {
//  case MSG_Comment_BTN:
//    if (!_firstReload) {
//      [_firstView.mainTableView.mj_header beginRefreshing];
//      _firstReload = true;
//    }
//    page = 0;
//    break;
//  case MSG_ANTA_BTN:
//    if (!_secondReload) {
//      [_secondView.mainTableView.mj_header beginRefreshing];
//      _secondReload = true;
//    }
//    page = 1;
//    break;
//  case MSG_UP_BTN:
//    if (!_thirdReload) {
//      [_thirdView.mainTableView.mj_header beginRefreshing];
//      _thirdReload = true;
//    }
//    page = 2;
//    break;
//  }
//  self.scrollView.contentOffset = CGPointMake((HSGH_SCREEN_WIDTH)*page, 0);
}

/**
 scrollView停止滑动时

 @param scrollView 画布
 */
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  [self.view endEditing:YES];
//  int page = 0;
//  if (scrollView.contentOffset.x <= 0) {
//    page = 0;
//  } else if (scrollView.contentOffset.x <= HSGH_SCREEN_WIDTH) {
//    page = 1;
//  } else {
//    page = 2;
//  }
//  [_navTagsView moveRedLineFrame:page + 1001];
//  _pageIndex = page;
//
//  [self changeRedItemsSign];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    //int index = (int)scrollView.contentOffset.x / HSGH_SCREEN_WIDTH;
    //NSLog(@"---scrollViewWillBeginDragging----index=%d",self.lastIndex);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = (int)scrollView.contentOffset.x / HSGH_SCREEN_WIDTH;
    if (self.lastIndex != index) {
        HSLog(@"---msg---%d消失  ,%d显示",self.lastIndex,index);
        [self deleteTipWithIndex:self.lastIndex];
        self.lastIndex = index;
        [_navTagsView moveRedLineFrame:self.lastIndex + 1001];
    } else {
        HSLog(@"---msg---还是当前页---%d",self.lastIndex);
    }
}

- (void)deleteTipWithIndex:(int)index {
    ViewController* tabVC = (ViewController*)self.tabBarController;
    HSGHNotificationMessage *notifacationMsgModel = tabVC.messageMsgNumModel;
    
    UIButton *btn;
    if (index==0) {
        btn = _navTagsView.firstBtn;
        [btn pp_hiddenBadge];
        notifacationMsgModel.firstMsgNum = 0;
        //重置为零
        [HSGHMessageModel fetchResetMessageNumberWithType:@(3):^(BOOL success){}];

    } else if (index==1) {
        btn = _navTagsView.secondBtn;
        [btn pp_hiddenBadge];
        notifacationMsgModel.secondMsgNum = 0;
        //重置为零
        [HSGHMessageModel fetchResetMessageNumberWithType:@(1):^(BOOL success){}];
        
    } else if (index==2) {
        btn = _navTagsView.thirdBtn;
        [btn pp_hiddenBadge];
        notifacationMsgModel.thirdMsgNum = 0;
        //重置为零
        [HSGHMessageModel fetchResetMessageNumberWithType:@(2):^(BOOL success){}];
    }
    
    if (notifacationMsgModel.firstMsgNum +notifacationMsgModel.secondMsgNum + notifacationMsgModel.thirdMsgNum <1) {
        [tabVC.tabBar.items[3] pp_hiddenBadge];
    }
}




- (void)pushViewVC:(UIViewController *)vc {
//    if([vc isKindOfClass:[HSGHMsgDetailViewController class]]){
//        HSGHMsgDetailViewController * detailVC = (HSGHMsgDetailViewController *)vc;
//        detailVC.popCallBackBlock = ^{
//            [self refleshData];
//        };
//        
//    }
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNotifacationCenter {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refleshNotificationData:)
                                               name:@"msg_refreshData"
                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deleteData:)
//                                                 name:@"msg_delete"
//                                               object:nil];
}


//- (void)deleteData:(NSNotification *)notification {
//    NSNumber * mode = notification.userInfo[@"mode"];
//    NSString * messageId = notification.userInfo[@"messageId"];
//    NSMutableArray * datalist;
//    
//    if([mode integerValue] == 0){
//        datalist = [NSMutableArray arrayWithArray:_firstArr];
//        
//    }else if ([mode integerValue] == 1){
//        datalist = [NSMutableArray arrayWithArray:_secondArr];
//    
//    }else if ([mode integerValue] == 2){
//        datalist = [NSMutableArray arrayWithArray:_thirdArr];
//    }
//    for(int i = 0; i < datalist.count ;i ++){
//        HSGHSingleMsg* data = datalist[i];
//        if(data.messageId)
//    }
//    
//}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pushViewVC:(UIViewController *)vc WithType:(FRINED_CATE_MODE)mode {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
