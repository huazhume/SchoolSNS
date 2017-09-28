//
//  HSGHMyProfileViewController.m
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/6.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHFriendViewController.h"
#import "HSGHHomeNavTagsView.h"
#import "HSGHFriendNavTagsView.h"
#import "HSGHFriendFirstView.h"
#import "HSGHFriendSecondView.h"
#import "HSGHFriendThirdView.h"
#import "HSGHFriendFourthView.h"
#import "ViewController.h"
#import "HSGHFriendViewModel.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "PPBadgeView.h"
#import "ViewController.h"
#import "HSGHUserInf.h"
#import "NSObject+YYModel.h"
#import "PPBadgeView.h"

@interface HSGHFriendViewController () <UIScrollViewDelegate, BaseViewDelegate> {
    NSArray * _firstArr;
    NSArray * _secondArr;
    NSArray * _thirdArr;
    NSInteger _pageIndex;
    NSArray * _forthArr;
    BOOL isVisable;
}

@property (weak, nonatomic) IBOutlet HSGHFriendNavTagsView* navigationTagsView;

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet HSGHFriendFirstView* firstView;

@property (weak, nonatomic) IBOutlet HSGHFriendSecondView* secondView;
@property (weak, nonatomic) IBOutlet HSGHFriendThirdView* thirdView;
//@property (weak, nonatomic) IBOutlet HSGHFriendFourthView* fourthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navToTop;
@property (weak, nonatomic) IBOutlet UIView *navBgView;

@property(assign, nonatomic) int lastIndex;//上一次的索引

@end

@implementation HSGHFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    HSLog(@"HSGHFriendViewController---viewDidLoad");
    
    _firstArr = [NSArray array];
    _secondArr = [NSArray array];
    _thirdArr = [NSArray array];
    //    _forthArr = [NSArray array];
    
    self.navigationController.navigationBarHidden = YES;
    [self addNavigationTagView];
    self.firstView.delegate = self;
    self.thirdView.delegate = self;
    self.secondView.delegate = self;
    //    self.fourthView.delegate = self;
    [self addHeadRefresh];
    [self addNotifacationCenter];
    
    [self setupModel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 64dp 错位
    isVisable = YES;
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    ViewController* tabVC = (ViewController*)self.tabBarController;
    [tabVC setCenterEnable:TAB_CENTER_ENABLE];
    [HSGHFriendViewModel refreshRedCountWithIsHidden:NO];
}

/** 刷新好友数据 */
- (void)refreshSecondData {
    [HSGHFriendViewModel fetchAllFriends:^(BOOL success, NSArray* array) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _secondArr = array;
                [self.secondView setFriendArray:_secondArr];
            });
        }
    }];
}
/** 刷新加我数据 */
- (void)refreshThirdData {
    __weak typeof(self) weakSelf = self;
    [HSGHFriendViewModel fetchReceivedFriends:^(BOOL success, NSArray* array) {
        if (success == YES) {
            _thirdArr = [NSArray arrayWithArray:array];
            [weakSelf.thirdView setDataArray:_thirdArr];
            [self dealwithAddMeTip];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    ViewController* tabVC = (ViewController*)self.tabBarController;
//    HSGHNotificationMessage *notiFriendMsgNumModel = tabVC.friendMsgNumModel;
//    
//    if (notiFriendMsgNumModel.secondMsgNum > 0) {
//        [self.scrollView setContentOffset:CGPointMake(HSGH_SCREEN_WIDTH, 0) animated:NO];
//        CGFloat tmpX = -_navigationTagsView.secondBtn.frame.size.width/2+30;
//        [_navigationTagsView.secondBtn pp_addDotWithColor:nil];
//        [_navigationTagsView.secondBtn pp_moveBadgeWithX:tmpX Y:5];
//        [self.navigationTagsView moveRedLineFrame:1002 animated:NO];
//        self.lastIndex = 1;
//        
//    }
//    else if (notiFriendMsgNumModel.firstMsgNum > 0) {
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//        [_navigationTagsView.firstBtn pp_addDotWithColor:nil];
//        [_navigationTagsView.firstBtn pp_moveBadgeWithX:0 Y:5];
//        [self.navigationTagsView moveRedLineFrame:1001 animated:NO];
//        self.lastIndex = 0;
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isVisable = NO;
}


//- (void)refleshData {
//    [self.firstView.mainTableView.mj_header beginRefreshing];
//    //[self.secondView.mainTableView.mj_header beginRefreshing];
//    [self.thirdView.mainTableView.mj_header beginRefreshing];
//    //[self.fourthView.mainTableView.mj_header beginRefreshing];
//    if(isVisable){
//       [self changeRedItemsSign];
//    }
//}

- (void)refleshNotificationData:(NSNotification *)nofi{
    [self refreshThirdData];
    [self refreshSecondData];
    
//    NSDictionary * user = nofi.userInfo;
//    NSNumber * number = user[@"sign"];
//    switch ([number integerValue]) {
//         case 5:
//            //[self.thirdView.mainTableView.mj_header beginRefreshing];
//            [self refreshThirdData];
//            break;
//        case 4:
//             //[self.secondView.mainTableView.mj_header beginRefreshing];
//            [self refreshSecondData];
//            break;
//            
//        default:
//            break;
//    }
}

- (void)changeRedItemsSign {
//    [self.view endEditing:YES];
//    //改变数据源
//    ViewController* tabVC = (ViewController*)self.tabBarController;
//    HSGHNotificationMessage * numModel = tabVC.friendMsgNumModel;
//    if(_pageIndex == 0){
//        numModel.firstMsgNum = 0;
//    }else if (_pageIndex == 1){
//        numModel.secondMsgNum = 0;
//    }else{
//        numModel.thirdMsgNum = 0;
//    }
//    tabVC.friendMsgNumModel = numModel;
//    if(numModel.firstMsgNum + numModel.secondMsgNum + numModel.thirdMsgNum > 0){ //有消息则变红
//        [tabVC.tabBar.items[1] pp_addDotWithColor:nil];
//        [tabVC.tabBar.items[1] pp_moveBadgeWithX:0 Y:5];
//        [self refreshRedCountWithIndex:0 WithHaveNewMessage:!!numModel.firstMsgNum];
//        [self refreshRedCountWithIndex:1 WithHaveNewMessage:!!numModel.secondMsgNum];
//        [self refreshRedCountWithIndex:2 WithHaveNewMessage:!!numModel.thirdMsgNum];
//        
//    }else{
//        [tabVC.tabBar.items[1] pp_hiddenBadge];
//    }
//    [self refreshRedCountWithIndex:_pageIndex WithHaveNewMessage:NO];
    
}
- (void)refreshRedCountWithIndex:(NSInteger )index WithHaveNewMessage:(BOOL)has {
//    UIButton * btn ;
//    if(index == 0){
//        btn = _navigationTagsView.firstBtn;//好友按钮
//        return ;
//    }else if (index == 1){
//        btn = _navigationTagsView.secondBtn;//加我按钮
//    }else if (index == 2){
//        btn = _navigationTagsView.thirdBtn;//搜索按钮
//        return ;
//    }else{
//        //第四个
//    }
//    if(has){
//        //有新消息
//        [btn pp_addDotWithColor:nil];
//        [btn pp_moveBadgeWithX:-btn.width/4.0 Y:7];
//        
//    }else{
//        //没有
//        [btn pp_hiddenBadge];
//    }
}

- (void)setupModel
{
    //获取推荐好友
    __weak typeof(self) weakSelf = self;
    [HSGHFriendViewModel fetchRecommendedFriends:^(BOOL success, NSArray* array) {
        if (success == YES) {
            _firstArr = [NSArray arrayWithArray:array];
            [weakSelf.firstView setRecommentArray:array];
        }
    }];

    
    ViewController* tabVC = (ViewController*)self.tabBarController;
    if (tabVC.allFriendArr!=nil && tabVC.allFriendArr.count>0) {//提前的请求成功了
        dispatch_async(dispatch_get_main_queue(), ^{
            _secondArr = tabVC.allFriendArr;
            [weakSelf.secondView setPreparedFriendArray:tabVC.allFriendArr andDataArray:tabVC.friendDataArray andSectionIndexArray:tabVC.friendSectionIndexArray];
            
            UIButton *btn = [_navigationTagsView viewWithTag:1002];
            if (_thirdArr.count > 0) {
                [btn setTitle:[NSString stringWithFormat:@"加我(%zd)",_thirdArr.count] forState:UIControlStateNormal];
            } else {
                [btn setTitle:@"加我" forState:UIControlStateNormal];
            }
        });
    }
    
    //再次请求数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HSGHFriendViewModel fetchAllFriends:^(BOOL success, NSArray* array) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _secondArr = array;
                    [weakSelf.secondView setFriendArray:_secondArr];
                });
            }
        }];
    });
    
    
//    [HSGHFriendViewModel fetchAllFriends:^(BOOL success, NSArray* array) {
//        if (success== YES ) {
////            if(_secondArr.count > 0){
//            
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _secondArr = [NSArray arrayWithArray:array];
//                    [weakSelf.secondView setFriendArray:array];
//                });
//            
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    if (_secondArr.count > 0) {//HSGHFriendSingleModel
//                        NSMutableArray *userFRNDArr = [NSMutableArray array];
//                        for (int i=0; i<_secondArr.count; i++) {
//                            id jsonData = [_secondArr[i] yy_modelToJSONData];
//                            [userFRNDArr addObject:jsonData];
//                        }
//                        
//                        NSArray *tmpArr = [userFRNDArr copy];
//                        NSString *tmpStr = [NSString stringWithFormat:@"%@_FRND_DEFT",[HSGHUserInf shareManager].userId];
//                        [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:tmpStr];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                    }
//                });
//            
////            }
//            
//        }
//    }];
    
    if (tabVC.friendThirdArr!=nil && tabVC.friendThirdArr.count>0) {//提前的请求成功了
        dispatch_async(dispatch_get_main_queue(), ^{
            _thirdArr = tabVC.friendThirdArr;
            [weakSelf.thirdView setDataArray:_thirdArr];
            
            [self dealwithAddMeTip];
        });
    } else {//再次请求数据
        [HSGHFriendViewModel fetchReceivedFriends:^(BOOL success, NSArray* array) {
            if (success == YES) {
                _thirdArr = [NSArray arrayWithArray:array];
                [weakSelf.thirdView setDataArray:_thirdArr];
                
                [self dealwithAddMeTip];
            }
        }];
    }
    

//    [HSGHFriendViewModel fetchSendedFriends:^(BOOL success, NSArray* array) {
//        if (success  == YES) {
//             _forthArr = [NSArray arrayWithArray:array];
//            [weakSelf.fourthView setDataArray:array];
//        }
//    }];

    //    _firstView.headerView.block = ^(NSString *text) {
    //
    //    };
}

/** 处理数字提醒 */
- (void)dealwithAddMeTip {
    HSLog(@"---frndVC---dealwithAddMeTip---");
    
    UIButton * btn = _navigationTagsView.secondBtn;//加我按钮
    
    if (_thirdArr.count > 0) {
        //[btn pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",_thirdArr.count]];
        //[btn pp_addDotWithColor:nil];
        //[btn pp_moveBadgeWithX:-32 Y:6];
        
        [self.scrollView setContentOffset:CGPointMake(HSGH_SCREEN_WIDTH, 0) animated:NO];
        [self.navigationTagsView moveRedLineFrame:1002 animated:NO];
        
        UIButton *btn = [_navigationTagsView viewWithTag:1002];
        [btn setTitle:[NSString stringWithFormat:@"加我(%zd)",_thirdArr.count] forState:UIControlStateNormal];
        
        
    } else {
        [btn pp_hiddenBadge];
        UIButton *btn = [_navigationTagsView viewWithTag:1002];
        [btn setTitle:@"加我" forState:UIControlStateNormal];
    }
    
    
    ViewController* tabVC = (ViewController*)self.tabBarController;
    if (_thirdArr.count==0) {
        [tabVC.tabBar.items[1] pp_hiddenBadge];
    } else if (_thirdArr.count < 99 ) {
        [tabVC.tabBar.items[1] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",_thirdArr.count]];
    } else {
        [tabVC.tabBar.items[1] pp_addBadgeWithText:@"99+"];
    }
}

- (void)searchDetailWithText:(NSString*)searchKey
{
    __weak typeof(self) weakSelf = self;
    [[AppDelegate instanceApplication]indicatorShow];
    [HSGHFriendViewModel SearchFriendsWithKeyWord:
                                        searchKey:^(BOOL success, NSArray* array) {
                                            [[AppDelegate instanceApplication]indicatorDismiss];
                                                [weakSelf.firstView setSearchArray:array isSuccess:success];
                                        }];
}


- (void)loadDBData {
    [self.secondView setFriendArray:[HSGHFriendViewModel fetchDataWithType:FRIEND_CATE_SCHOLL]];
}

- (void)addHeadRefresh
{
    __weak typeof(self) weakSelf = self;
    _firstView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [HSGHFriendViewModel fetchRecommendedFriends:^(BOOL success, NSArray* array) {
            [weakSelf.firstView.mainTableView.mj_header endRefreshing];
            if (success ) {
                 _firstArr = [NSArray arrayWithArray:array];
                [weakSelf.firstView setRecommentArray:array];
            }
        }];
    }];

    //取消好友-好友页下拉刷新
//    _secondView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [HSGHFriendViewModel fetchAllFriends:^(BOOL success, NSArray* array) {
//            [weakSelf.secondView.mainTableView.mj_header endRefreshing];
//            if (success) {
//                 _secondArr = [NSArray arrayWithArray:array];
//                [HSGHFriendViewModel deleteDataWithType:FRIEND_CATE_SCHOLL];
//                [HSGHFriendViewModel saveData:_secondArr WithType:FRIEND_CATE_SCHOLL ];
//                [weakSelf.secondView setFriendArray:array];
//            }
//        }];
//    }];

    _thirdView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [HSGHFriendViewModel fetchReceivedFriends:^(BOOL success, NSArray* array) {
            [weakSelf.thirdView.mainTableView.mj_header endRefreshing];
            if (success ) {
                 _thirdArr = [NSArray arrayWithArray:array];
                [weakSelf.thirdView setDataArray:array];
            }
        }];
    }];

//    _fourthView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [HSGHFriendViewModel fetchSendedFriends:^(BOOL success, NSArray* array) {
//            [weakSelf.fourthView.mainTableView.mj_header endRefreshing];
//            if (success) {
//                _forthArr = [NSArray arrayWithArray:array];
//                [weakSelf.fourthView setDataArray:array];
//            }
//        }];
//    }];
//    [self changeRedItemsSign];
}


/**
 添加navgationView
 */
- (void)addNavigationTagView
{

    __weak HSGHFriendViewController* weakSelf = self;
    _navigationTagsView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHFriendNavTagsView"
                                                         owner:self
                                                       options:nil] lastObject];
    _navigationTagsView.frame = CGRectMake(0, 0, self.navBgView.frame.size.width, self.navBgView.frame.size.height);
    [self.navBgView addSubview:_navigationTagsView];
    _navigationTagsView.tagBlock = ^(FRINED_BTN_TAGS tag) {
        [weakSelf changeContentOffsetWithType:tag];
    };
}

/**
 改变scrollViewContentOfSet

 @param tags BtnTag
 */
- (void)changeContentOffsetWithType:(FRINED_BTN_TAGS)tags
{
    int page = 0;
    switch (tags) {
    case FRIEND_Friend_BTN:
        page = 0;
        break;
    case FRIEND_FriendRequest_BTN:
        page = 1;
        break;
    case FRIEND_FriendINTRO_BTN:
        page = 2;
        break;
    case FRIEND_FiendFORTH_BTN:
        page = 3;
        break;
    }
    self.scrollView.contentOffset = CGPointMake((HSGH_SCREEN_WIDTH)*page, 0);
}

/**
 scrollView停止滑动时
 @param scrollView 画布
 */
//- (void)scrollViewDidScroll:(UIScrollView*)scrollView
//{
//    int page = 0;
//    if (scrollView.contentOffset.x <= 0) {
//        page = 0;
//    } else if (scrollView.contentOffset.x <= HSGH_SCREEN_WIDTH) {
//        page = 1;
//    } else if (scrollView.contentOffset.x <= 2 * HSGH_SCREEN_WIDTH) {
//        page = 2;
//    } else {
//        page = 3;
//    }
//    [_navigationTagsView moveRedLineFrame:page + 1001];
//    _pageIndex = page;
//    [self changeRedItemsSign];
//}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    //int index = (int)scrollView.contentOffset.x / HSGH_SCREEN_WIDTH;
    //NSLog(@"---scrollViewWillBeginDragging----index=%d",self.lastIndex);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = (int)scrollView.contentOffset.x / HSGH_SCREEN_WIDTH;
    [_navigationTagsView moveRedLineFrame:index + 1001];
    
    [self.secondView frndSecondViewEndEdit];
    [self.firstView frndFirstViewEndEdit];
    
    //int index = (int)scrollView.contentOffset.x / HSGH_SCREEN_WIDTH;
//    if (self.lastIndex != index) {
//        HSLog(@"---%d消失  ,%d显示",self.lastIndex,index);
//        [self deleteTipWithIndex:self.lastIndex];
//        self.lastIndex = index;
//        [_navigationTagsView moveRedLineFrame:self.lastIndex + 1001];
//    } else {
//        HSLog(@"---还是当前页---");
//    }
}

- (void)deleteTipWithIndex:(int)index {
//    ViewController* tabVC = (ViewController*)self.tabBarController;
//    HSGHNotificationMessage *notiFriendMsgNumModel = tabVC.friendMsgNumModel;
//    
//    UIButton *btn;
//    if (index==0) {
//        btn = _navigationTagsView.firstBtn;
//        [btn pp_hiddenBadge];
//        notiFriendMsgNumModel.firstMsgNum = 0;
//    } else if (index==1) {
//        btn = _navigationTagsView.secondBtn;
//        [btn pp_hiddenBadge];
//        notiFriendMsgNumModel.secondMsgNum = 0;
//    } else if (index==2) {
//        btn = _navigationTagsView.thirdBtn;
//        [btn pp_hiddenBadge];
//        notiFriendMsgNumModel.thirdMsgNum = 0;
//    }
//    
//    if (notiFriendMsgNumModel.firstMsgNum +notiFriendMsgNumModel.secondMsgNum + notiFriendMsgNumModel.thirdMsgNum <1) {
//        [tabVC.tabBar.items[1] pp_hiddenBadge];
//    }
}


- (void)pushViewVC:(UIViewController*)vc WithType:(FRINED_CATE_MODE)mode
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navAndTabIsHidden:(BOOL)isHidden
{
//    ViewController* tabVC = (ViewController*)self.tabBarController;
//    if (isHidden != tabVC.isFullScreen) {
//        if (isHidden) {
//            [UIView animateWithDuration:0.45
//                             animations:^{
//                                 //                self.tableViewToNavHeight.constant = 0;
//                                 self.navToTop.constant = -24;
//                                 [self.view layoutIfNeeded];
//                             }];
//        } else {
//            
//            [UIView animateWithDuration:0.45
//                             animations:^{
//                                 //                self.tableViewToNavHeight.constant = 64;
//                                 self.navToTop.constant = 20;
//                                 [self.view layoutIfNeeded];
//                             }
//                             completion:^(BOOL finished){
//                             }];
//        }
//        [tabVC navgationAndTabisHidden:isHidden];
//    }

}


- (void)addNotifacationCenter {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refleshNotificationData:) name:@"msg_refreshData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteOtherToMe:) name:@"friendShipDaoNotication" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSecondAndThirdView:) name:@"newFriendNotication" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSecondAndThirdView:) name:@"FriendDetailVC_2_FriendVC" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewEndEditNotifi:) name:@"FriendNav_2_FriendVC_EndEdit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSecondAndThirdView:) name:HSGH_POST_2_FRIEND_ADDME_NOTIFI object:nil];
    
}

- (void)refreshSecondAndThirdView:(NSNotification *)notifi {
    HSLog(@"------refreshSecondAndThirdView--------");
    //刷新加我数据
    [self refreshThirdData];
    
    //刷新好友数据
    [self refreshSecondData];
}


- (void)viewEndEditNotifi:(NSNotificationCenter *)notifi {
    [self.secondView frndSecondViewEndEdit];
    [self.firstView frndFirstViewEndEdit];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)deleteOtherToMe:(NSNotification *)notification { // 删除成功了的好友
    [self loadDBData];
    NSDictionary * userinfo = notification.userInfo;
    if([userinfo[@"mode"] integerValue] == 0){ //search
        
    }else if ([userinfo[@"mode"] integerValue] == 1){ //好友
        
    }else if ([userinfo[@"mode"] integerValue] == 2){ //加我
        HSGHFriendSingleModel * model = userinfo[@"model"];
        //是否存在
        __block BOOL isExist = NO;
        __block NSInteger index = 0;
        [_thirdArr enumerateObjectsUsingBlock:^(HSGHFriendSingleModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(model.userId == obj.userId){
                isExist = YES;
                index = idx;
            }
        }];
        if(isExist){
            NSMutableArray * muArr = [NSMutableArray arrayWithArray:_thirdArr];
            [muArr removeObjectAtIndex:index];
            _thirdArr = [NSArray arrayWithArray:muArr];
            [_thirdView setDataArray:_thirdArr];
        }
        
    }else if ([userinfo[@"mode"] integerValue] == 3){ //加他
        
    }
}



@end
