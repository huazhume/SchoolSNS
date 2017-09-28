//
//  HSGHScrollZoneVC.m
//  SchoolSNS
//
//  Created by Murloc on 15/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

//View
#import "HSGHScrollZoneVC.h"
#import "FSBaseTableView.h"
#import "HSGHZoneAreaBCell.h"
#import "HSGHZoneAreaBHeadView.h"

//AreaA
#import "HSGHHeadView.h"
#import "HSGHSchoolView.h"
#import "HSGHFriendView.h"
#import "HSGHAddressChooseView.h"


//Other Views
#import "HSGHKeyBoardView.h"
#import "HSGHAtViewController.h"
#import "YYPhotoBrowseView.h"
#import "HSGHZoneAreaBCellVC.h"

//Model
#import "HSGHZoneModel.h"
#import "HSGHUserInf.h"
#import "HSGHFriendViewModel.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHHomeViewModel.h"
#import "SchoolSNS-Swift.h"
#import "UITableView+VideoPlay.h"


@interface HSGHScrollZoneVC ()<UITableViewDelegate,UITableViewDataSource, FSPageContentViewDelegate, AreaBDelegate>

@property (nonatomic, assign) BOOL isMine;

@property (nonatomic, strong) FSBaseTableView  *tableView;
@property (nonatomic, strong) UIView    *areaAView;
@property (nonatomic, strong) HSGHZoneAreaBCell *contentCell;
@property (nonatomic, strong) HSGHZoneAreaBHeadView *areaBHeadView;
@property (nonatomic, assign) BOOL canScroll;

//AreaAView
@property(nonatomic, strong) HSGHHeadView *headBgView;   // rate : 750 : 456 ;
@property(nonatomic, strong) HSGHSchoolView *schoolView; // 103
@property(nonatomic, strong) HSGHFriendView *friendView; // 100
@property(nonatomic, strong) HSGHAddressChooseView *addressChooseView;


//Other Views
@property(nonatomic, strong) HSGHKeyBoardView *keywordView;
@property(nonatomic, strong) UIView *editSignatureBGView;
@property(nonatomic, assign) BOOL isEditSignature;


@property(nonatomic, strong) HSGHZoneAreaBCellVC* mineVC;
@property(nonatomic, strong) HSGHZoneAreaBCellVC* forwardVC;

@property(assign, nonatomic) int lastIndex;//上一次的索引
@property(assign, nonatomic) BOOL friendFlag;//好友标识 控制是否 显示英文名

@end

@implementation HSGHScrollZoneVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeSureFriendFlag];//确定 好友标识
    
    [self setupViews];
    [self addRefresh];//下拉刷新
    
    if (self.model == nil) {
        [self setupModel];
    }else{
        [self refreshFromLocal];
//        [self.mineVC refreshData];
//        [self.forwardVC refreshData];
        [self.tableView reloadData];
    }
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)makeSureFriendFlag {
    //HSGHFriendSingleModel * model
    ViewController* tabVC = (ViewController*)[AppDelegate instanceApplication].window.rootViewController;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@" userId == %@ ",_userID];
    NSArray *preArr = [tabVC.allFriendArr filteredArrayUsingPredicate:pred];
    HSLog(@"---preArr.count=%zd,%zd",preArr.count,[[HSGHUserInf shareManager].userId isEqualToString:_userID]);
    
    if (preArr.count>0 || [[HSGHUserInf shareManager].userId isEqualToString:_userID]) {
        _friendFlag = YES;
    } else {
        _friendFlag = NO;
    }
}

//wo下拉刷新
- (void)addRefresh {
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!weakSelf.isMine) {
            [weakSelf updateAreaAFrame];
            [weakSelf.model requestMine:weakSelf.userID
                     refreshAll:true
                          block:^(BOOL status) {
                              if (status) {
                                  [weakSelf updateAreaAFrame];
                                  [weakSelf refreshFromLocal];
                                  [weakSelf.tableView reloadData];
                              }
                              else {
                                  [[AppDelegate instanceApplication]indicatorDismiss];
                                  Toast *toast = [[Toast alloc] initWithText:@"出了一点小问题，请稍后再试" delay:0 duration:1.f];
                                  [toast show];
                              }
                              [weakSelf.tableView.mj_header endRefreshing];
                          }];
        }
        else {
            [weakSelf.model requestMine:weakSelf.userID
                     refreshAll:true
                          block:^(BOOL status) {
                              if (status) {
                                  [weakSelf.mineVC refreshData];
                              }
                              [weakSelf.tableView.mj_header endRefreshing];
                          }];
            [weakSelf.model requestForward:weakSelf.userID
                        refreshAll:true
                             block:^(BOOL status) {
                                 if (status) {
                                     [weakSelf.forwardVC refreshData];
                                 }
                             }];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = !_isMine;
    self.navigationController.navigationBarHidden = YES;
    [self setNavigationBarIsHidden:!!_isMine];
    ViewController *tabVC = (ViewController *) self.tabBarController;
    [tabVC setCenterEnable:TAB_CENTER_ENABLE];
    _keywordView.hidden = NO;
    
//    [self addKVO];
    
//    if (_isMine) {
//        [self refreshFromLocal];
//        [self updateAreaAFrame];
//        [self.tableView reloadData];
//        if (!self.model) {
//            [self refreshFromNet];
//        }
//    }
//    [self setNavigationBarIsHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isMine) {
          [self setNavigationBarIsHidden:NO];
    }
    
//    [self removeKVO];
    
    if (_isMine) {
        [self enterEditMode:NO isSignature:NO];
    }
    
    //暂停播放小视频
    HSLog(@"---HSGHScrollZoneVC---viewWillDisappear---isMine=%zd",_isMine);
    
    if (_mineVC.tableView.playingCell!=nil) {
        [_mineVC.tableView stopPlay];
    }
    if (_forwardVC.tableView.playingCell!=nil) {
        [_forwardVC.tableView stopPlay];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark- Init
- (instancetype)initWithUserID:(NSString*)userID {
    self = [super init];
    
    if (self) {
        _userID = userID;
        _isMine = [_userID isEqualToString:[HSGHUserInf shareManager].userId];
    }
    
    return self;
}

- (instancetype)initWithUserID:(NSString *)userID model:(HSGHZoneModel *)model {
    if (self = [self initWithUserID:userID]) {
        self.model = model;
    }
    return self;
}

- (HSGHAddressChooseView *)addressChooseView {
    __weak __typeof(self)weakSelf = self;
    if (!_addressChooseView) {
        _addressChooseView = [[HSGHAddressChooseView alloc] init];
        _addressChooseView.chooseClick = ^(NSString *cityID,NSString *cityName) {
            weakSelf.schoolView.city = cityName;
            
            [HSGHSettingsModel modifyCityID:cityID block:^(BOOL success, NSString *errDes) {
                if (success) {
                    [HSGHUserInf shareManager].homeCity = cityName;
                    [HSGHUserInf shareManager].homeCityId = cityID;
                    [[HSGHUserInf shareManager] saveUserDefault];
                }else{
                    weakSelf.schoolView.city = [HSGHUserInf shareManager].homeCity;
                }
            }];
        };
    }
    return _addressChooseView;
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];

    [self setupNav];
    [self setupAreaA];
    [self setupTableView];
    [self setupSignatureView];
}

- (void)setupModel {
    _model = [[HSGHZoneModel alloc] initWithUserID:_userID];
    [self refreshFromLocal];
    [self refreshFromNet];
    
}

- (void)changeScrollStatus {
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

- (void)refreshFromLocal {
    if (_isMine) {
        _headBgView.headPath = [HSGHUserInf shareManager].picture.thumbUrl;
        _headBgView.bgPath = [HSGHUserInf shareManager].backgroud.srcUrl;
        
        _headBgView.name =  UN_NIL_STR([HSGHUserInf fetchRealName]);
        
        if (_friendFlag) {
            NSString *fullNameEn = [HSGHUserInf shareManager].fullNameEn;
            if (fullNameEn!=nil && fullNameEn.length>0) {
                _headBgView.name = [NSString stringWithFormat:@"%@(%@)", [HSGHUserInf shareManager].fullName,fullNameEn];
            } else {
                _headBgView.name = [NSString stringWithFormat:@"%@", [HSGHUserInf shareManager].fullName];
            }
        }
        
        _headBgView.signature = [HSGHUserInf shareManager].signature;
        _headBgView.sexType =  [NSString stringWithFormat:@"%@", @([HSGHUserInf shareManager].sex)] ;
        
        
        [_schoolView updateContainsView:[HSGHUserInf shareManager].bachelorUniv masterUnvi:[HSGHUserInf shareManager].masterUniv highSchool:[HSGHUserInf shareManager].highSchool];
        
        _schoolView.city = UN_NIL_STR([HSGHUserInf shareManager].homeCity);
        
        __weak __typeof(self)weakSelf = self;
        _schoolView.modifyAddress = ^{
            [weakSelf.view addSubview:weakSelf.addressChooseView];
            [weakSelf.addressChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.view);
                make.size.equalTo(weakSelf.view);
            }];
        };
    } else {
        self.title = [_model fetchCurrentUser].displayName;
        _headBgView.headPath = [_model fetchCurrentUser].picture.thumbUrl;
        _headBgView.bgPath = [_model fetchCurrentUser].backgroud.srcUrl;
        _headBgView.name = [_model fetchCurrentUser].displayName;
        if (_friendFlag) {
            NSString *fullNameEn = [_model fetchCurrentUser].fullNameEn;
            if (fullNameEn!=nil && fullNameEn.length>0) {
                _headBgView.name = [NSString stringWithFormat:@"%@(%@)", [_model fetchCurrentUser].fullName,fullNameEn];
            } else {
                _headBgView.name = [NSString stringWithFormat:@"%@", [_model fetchCurrentUser].fullName];
            }
        }
        
        
        _headBgView.signature = [_model fetchCurrentUser].signature;
        //_headBgView.sexType = [_model fetchCurrentUser].sex;
        
        [_schoolView updateContainsView:[_model fetchCurrentUser].bachelorUniv masterUnvi:[_model fetchCurrentUser].masterUniv highSchool:[_model fetchCurrentUser].highSchool];
        
        _schoolView.city =  [_model fetchCurrentUser].homeCityAddress ? [_model fetchCurrentUser].homeCityAddress : UN_NIL_STR([_model fetchCurrentUser].homeCity);
    }

}

- (void)refreshFromNet {
//    __weak UITableView *weakTable = _tableView;
    __weak HSGHScrollZoneVC *weakSelf = self;
    //Refresh more
//    _model.block = ^(NSIndexPath *indexPath) {
//        if(indexPath != nil){
//            [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }else{
//            [weakTable reloadData];
//        }
//    };
    
    if (!_isMine) {
        [self updateAreaAFrame];
        [[AppDelegate instanceApplication]indicatorShow];
        [_model requestMine:_userID
             refreshAll:true
                  block:^(BOOL status) {
                      if (status) {
                          //                          [weakSelf.model requestPublicFriend:weakSelf.userID block:^(BOOL status) {
                          [[AppDelegate instanceApplication]indicatorDismiss];
                          [weakSelf updateAreaAFrame];
                          [weakSelf refreshFromLocal];
                          [weakSelf.tableView reloadData];
                          
                          //                              if (status) {
                          //                                  [weakSelf.friendView updateData:[weakSelf.model fetchFriendData]];
                          //                              }
                          //                          }];
                      }
                      else {
                          [[AppDelegate instanceApplication]indicatorDismiss];
                          Toast *toast = [[Toast alloc] initWithText:@"出了一点小问题，请稍后再试" delay:0 duration:1.f];
                          [toast show];
                      }
                  }];
    }
    else {
        [_model requestMine:_userID
                 refreshAll:true
                      block:^(BOOL status) {
                          if (status) {
                              [weakSelf.mineVC refreshData];
                          }
                      }];
        [_model requestForward:_userID
                 refreshAll:true
                      block:^(BOOL status) {
                          if (status) {
                              [weakSelf.forwardVC refreshData];
                          }
                      }];
    }
}


#pragma mark- Nav
- (void)setupNav {
    if (_isMine) {
        UIView* topStatusBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        topStatusBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:topStatusBgView];
        
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    else {
//        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]
//                                     initWithImage:[UIImage imageNamed:@"zone_rightBar"]
//                                     style:UIBarButtonItemStylePlain
//                                     target:self
//                                     action:@selector(rightBarAction:)];
//        rightBar.tintColor = [UIColor blackColor];
//        rightBar.imageInsets = UIEdgeInsetsMake(5, -5, -5, 5);
//        self.navigationItem.rightBarButtonItem = rightBar;
        
        [self addRightNavigationBarImage:@"zone_rightBar"];
        
        
    }
}
- (void)rightBarItemBtnClicked:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"举报学历造假" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         [HSGHSettingsModel report:@"" type:1 userId:weakSelf.userID block:^(BOOL success) {
                                                             if (success) {
                                                                 Toast *toast = [[Toast alloc] initWithText:@"举报成功!" delay:0 duration:1.f];
                                                                 [toast show];
                                                             } else {
                                                                 Toast *toast = [[Toast alloc] initWithText:@"出了点小问题，稍后再举报吧！" delay:0 duration:1.f];
                                                                 [toast show];
                                                             }
                                                         }];
                                                     }];
    [sheet addAction:cancelAction];
    [sheet addAction:okAction];
    
    if ([_model isFriend]) {
        UIAlertAction *ok2Action = [UIAlertAction actionWithTitle:@"解除关系" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [[AppDelegate instanceApplication]indicatorShow];
                                                              [HSGHFriendViewModel fetchRemoveWithUrl:HSGHServerFriendRemoveURL Params:@{@"userId": UN_NIL_STR( _userID)} :^(BOOL success) {
                                                                  [[AppDelegate instanceApplication]indicatorDismiss];
                                                                  if(success == YES){
                                                                      Toast *toast = [[Toast alloc] initWithText:@"解除关系成功!" delay:0 duration:1.f];
                                                                      [toast show];
                                                                      
                                                                      //发通知
                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendDetailVC_2_FriendVC" object:nil];
                                                                      
                                                                  }else{
                                                                      Toast *toast = [[Toast alloc] initWithText:@"出了点小问题，稍后再举报吧！" delay:0 duration:1.f];
                                                                      [toast show];
                                                                  }
                                                              }];
                                                              
                                                          }];
        [sheet addAction:ok2Action];
    }
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)rightBarAction:(UIBarButtonItem *)sender {

}

#pragma mark- TableView
- (void)setupTableView {
    _tableView = [[FSBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 39)
                                              style:UITableViewStylePlain];
    if (!_isMine) {
        _tableView.height = self.view.bounds.size.height - HSGH_NAVGATION_HEIGHT;
        _tableView.top = HSGH_NAVGATION_HEIGHT;
    } else {
        _tableView.height -= 20;
        _tableView.top = 20;
    }
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HSGHZoneAreaBHeadView class] forHeaderFooterViewReuseIdentifier:@"areaBHead"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _areaAView.height;
    }
    return CGRectGetHeight(tableView.bounds) - [HSGHZoneAreaBHeadView shouldSize].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return [HSGHZoneAreaBHeadView shouldSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _areaBHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"areaBHead"];
    __weak typeof(self) weakSelf = self;
    _areaBHeadView.sectionBlock = ^(BOOL isFirstSection) {
        int currIndex = isFirstSection ? 0 : 1;
        weakSelf.contentCell.pageContentView.contentViewCurrentIndex = currIndex;//切换事件
        
        
        
//        lastIndex
        if (weakSelf.lastIndex != currIndex) {
            HSLog(@"---HSGHScrollZoneVC---self.lastIndex=%zd---currIndex=%zd",weakSelf.lastIndex,currIndex);
            //weakSelf.lastIndex = currIndex;
            
            [weakSelf dealwithScrollViewWillShow:currIndex andWillDisappear:weakSelf.lastIndex];
            
        } else {
            HSLog(@"---HSGHScrollZoneVC---nothing");
        }
    };
    return _areaBHeadView;
}

- (void)dealwithScrollViewWillShow:(int)willShowIndex andWillDisappear:(int)willDisappIndex {
    HSLog(@"---home---%d消失  ,%d显示",willDisappIndex,willShowIndex);
    if (willDisappIndex==0) {
        if (self.mineVC.tableView.playingCell != nil) {
            [self.mineVC.tableView stopPlay];
        }
    } else {
        if (self.forwardVC.tableView.playingCell != nil) {
            [self.forwardVC.tableView stopPlay];
        }
    }
    
    if (willShowIndex==0) {
        [self.mineVC.tableView handleScrollStop];
    } else {
        [self.forwardVC.tableView handleScrollStop];
    }
    self.lastIndex = willShowIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell* cell0 = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell0) {
            cell0 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            [cell0 addSubview:_areaAView];
        }
        cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell0;
    }
    else {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!_contentCell) {
            _contentCell = [[HSGHZoneAreaBCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            _contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *titles = @[@"Mine",@"Forward"];
            NSMutableArray *contentVCs = [NSMutableArray array];
            for (NSString *title in titles) {
                HSGHZoneAreaBCellVC *vc = [[HSGHZoneAreaBCellVC alloc]init];
                vc.title = title;
                vc.isMine = [title isEqualToString:@"Mine"];
                vc.model = _model;
                vc.userID = _userID;
                vc.delegate = self;
                if (vc.isMine) {
                    _mineVC = vc;
                }
                else {
                    _forwardVC = vc;
                }
                [contentVCs addObject:vc];
            }
            _contentCell.viewControllers = contentVCs;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.tableView.height - [HSGHZoneAreaBHeadView shouldSize].height) childVCs:contentVCs parentVC:self delegate:self];
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y - 0;
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}

#pragma mark- pageContentDelegate
- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress {
    [_areaBHeadView clickSelection: endIndex == 0];
}

#pragma mark- AreaACell
- (void)setupAreaA {
    if (!_areaAView) {
        _areaAView = [UIView new];
        _areaAView.backgroundColor = self.view.backgroundColor;
        _areaAView.frame = CGRectMake(0, 0, self.view.width, 0);
        // First
        CGFloat tempHeight = _areaAView.width / 750 * 456;
        _headBgView = [[HSGHHeadView alloc]
                       initWithFrame:CGRectMake(0, 0, _areaAView.width, tempHeight)
                       isMine:_isMine];
        __weak typeof(self) weakSelf = self;
        _headBgView.didClickSettingsBlock = ^{
            [weakSelf goSettings];
        };
        
        _headBgView.doUpdateSignaturBlock = ^(BOOL status) {
            if (status) {
                [weakSelf enterEditMode:NO isSignature:YES];
            }
        };
        
        _headBgView.doUpdateNickNameBlock = ^(BOOL status) {
            if (status) {
                [weakSelf enterEditMode:NO isSignature:NO];
            }
        };
        
        _headBgView.doUpdateEngNameBlock = ^(BOOL status) {
            if (status) {
                [weakSelf enterEditMode:NO isSignature:NO];
            }
        };
        
        _headBgView.didClickChangeBGPhotoBlock = ^{
            HSGHPhotoPickerController *vc = [HSGHPhotoPickerController new];
            vc.isChangeRate = true;
            vc.cropBlock = ^(UIImage *image) {
                if (image) {
                    [weakSelf.headBgView updateBGImage:image];
                    [HSGHSettingsModel modifyUserImage:image isBgImage:YES block:^(BOOL success, NSString *errDes) {
                        if (success) {
                            Toast *toast = [[Toast alloc] initWithText:@"更新背景成功!" delay:0 duration:1.f];
                            [toast show];
                        } else {
                            Toast *toast = [[Toast alloc] initWithText:@"更新失败，请稍后再试" delay:0 duration:1.f];
                            [toast show];
                        }
                    }];
                }
            };
            UINavigationController *nav = [[UINavigationController
                                            alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES animated:YES];
            [weakSelf presentViewController:nav animated:YES
                                 completion:nil];
        };
        
        _headBgView.didClickChangeHeadPhotoBlock = ^{
            HSGHPhotoPickerController *vc = [HSGHPhotoPickerController new];
            vc.isPersonalMode = true;
            vc.cropBlock = ^(UIImage *image) {
                if (image) {
                    [weakSelf.headBgView updateHeadIconImage:image];
                    [HSGHSettingsModel modifyUserImage:image isBgImage:NO block:^(BOOL success, NSString *errDes) {
                        if (success) {
                            Toast *toast = [[Toast alloc] initWithText:@"更新头像成功!" delay:0 duration:1.f];
                            [toast show];
                        } else {
                            Toast *toast = [[Toast alloc] initWithText:@"更新失败，请稍后再试" delay:0 duration:1.f];
                            [toast show];
                        }
                    }];
                }
            };
            UINavigationController *nav = [[UINavigationController
                                            alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES animated:YES];
            [weakSelf presentViewController:nav animated:YES
                                 completion:nil];
        };
        
        _headBgView.didClickOtherZoneHeadPhotoBlock = ^{
            if ([weakSelf.headBgView fetchCurrentHeadImage]) {
                NSMutableArray *items = [NSMutableArray array];
                UIView *fromView = nil;
                
                YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                item.thumbView = [[UIImageView alloc]initWithFrame: weakSelf.headBgView.frame];
                [(UIImageView*)item.thumbView sd_setImageWithURL:[NSURL URLWithString: UN_NIL_STR([weakSelf.model fetchCurrentUser].picture.thumbUrl)] placeholderImage:nil
                                                         options:SDWebImageAllowInvalidSSLCertificates];
                NSString* path = [weakSelf.model fetchCurrentUser].picture.srcUrl;
                NSURL *url = [NSURL URLWithString:path];
                item.largeImageURL = url;
                [items addObject:item];
                fromView = item.thumbView;
                
                YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:items];
                [groupView presentFromImageView:fromView toContainer:weakSelf.navigationController.view animated:YES completion:nil];
            }
        };
        
        _headBgView.didClickEditSignatureBlock = ^{
            weakSelf.isEditSignature = YES;
            [weakSelf enterEditMode:YES isSignature:YES];
        };
        
        _headBgView.didClickEditNickNameBlock = ^{
            if ([HSGHUserInf shareManager].displayNameMode == 2) {
                weakSelf.isEditSignature = NO;
                [weakSelf enterEditMode:YES isSignature:NO];
            }
        };
        
        [_areaAView addSubview:_headBgView];
        
        // Second
        tempHeight = 103.f;
        _schoolView = [[HSGHSchoolView alloc]
                       initWithFrame:CGRectMake(0, _headBgView.height, _areaAView.width,
                                                tempHeight)];
        [_schoolView updateIsMineInfo:_isMine];
        [_areaAView addSubview:_schoolView];
        if ([[HSGHUserInf shareManager].userId isEqualToString:_userID]) {
            _schoolView.changeCityBtn.hidden = NO;
        } else {
            _schoolView.changeCityBtn.hidden = YES;
        }
        
        // Third
        tempHeight = 0.f;
        _friendView = [[HSGHFriendView alloc]
                       initWithFrame:CGRectMake(0, _headBgView.height + _schoolView.height,
                                                _areaAView.width, tempHeight)];
        [_areaAView addSubview:_friendView];
        
        // set height
        _areaAView.height += _headBgView.height;
        _areaAView.height += _schoolView.height;
        if (!_isMine) {
            _areaAView.height += _friendView.height;
        }
        
    }
}

- (void)updateAreaAFrame {
    _headBgView.height = self.view.width / 750 * 456;
    if (_isMine) {
        _schoolView.height = [HSGHSchoolView calcWholeHeight:[HSGHUserInf shareManager].bachelorUniv masterUnvi:[HSGHUserInf shareManager].masterUniv highSchool:[HSGHUserInf shareManager].highSchool];
    }
    else {
        _schoolView.height = [HSGHSchoolView calcWholeHeight:[_model fetchCurrentUser].bachelorUniv masterUnvi:[_model fetchCurrentUser].masterUniv highSchool:[_model fetchCurrentUser].highSchool];
    }
    _friendView.height =  _isMine ? 0 : ([_model fetchFriendData].count > 0 ? 145 : 0);
    _areaAView.height = _headBgView.height + _schoolView.height + _friendView.height;
    
    _schoolView.top = _headBgView.bottom;
    _friendView.top = _schoolView.bottom;
}


- (void)goSettings {
    HSGHSettingsSwiftVC *vc = [[HSGHSettingsSwiftVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- other Views
- (void)setupSignatureView {
    if (_isMine) {
        _editSignatureBGView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_editSignatureBGView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSignatureBG)];
        [_editSignatureBGView addGestureRecognizer:ges];
        _editSignatureBGView.alpha = 0.0;
    }
}

- (void)clickSignatureBG {
//    NSString* compareText = _isEditSignature ? [HSGHUserInf shareManager].signature : [HSGHUserInf shareManager].nickName;
//    if (![[_headBgView fetchEditedText] isEqualToString:compareText]) {
//        __weak typeof(self) weakSelf = self;
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"还未保存，是否退出？"
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [weakSelf enterEditMode:NO isSignature:YES];
//        }];
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    } else {
        [self enterEditMode:NO isSignature:_isEditSignature];
//    }
}

- (void)enterEditMode:(BOOL)isEdit isSignature:(BOOL)isSignature{
    [_headBgView enterEditMode:isEdit isSingle:isSignature];
    _editSignatureBGView.alpha = isEdit ? 1 : 0;
}

#pragma mark- KVO
- (void)addKVO {
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO {
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    if (object == _tableView && _tableView.contentOffset.y < 0) {
        _tableView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark- keyboardView
- (void)addKeyBoardView {
    _keywordView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHKeyBoardView"
                                                  owner:self
                                                options:nil] lastObject];
    _keywordView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    __weak HSGHKeyBoardView *weakkey = _keywordView;
    __weak HSGHScrollZoneVC *weakSelf = self;
    __weak HSGHZoneModel *weakModel = _model;
    _keywordView.block = ^(NSIndexPath *indexPath, NSInteger homeMode,
                           NSIndexPath *commentIndex, NSInteger editMode) {
        //处理发布
        [[AppDelegate instanceApplication] indicatorShow];
        NSArray *datalist = [weakSelf.areaBHeadView isSecond] ? [weakModel fetchForwardData] : [weakModel fetchData];
        HSGHHomeQQianModel *qqiansVO = ((HSGHHomeQQianModelFrame *) datalist[(NSUInteger) indexPath.row]).model;
        
        if (editMode == HOME_COMMENT_MODE) {
            //评论
            [HSGHHomeViewModel fetchCommentWithParams:@{
                                                        @"qqianId": qqiansVO.qqianId,
                                                        @"content": weakkey.textView.text
                                                        } :^(BOOL success ,NSString * relayId) {
                                                            [[AppDelegate instanceApplication] indicatorDismiss];
                                                            if (success) {
                                                                [weakModel qqianCommentAndForwardWithHomeType:HOME_FIRST_MODE andEdit:HOME_COMMENT_MODE
                                                                                                 andMainIndex:indexPath andNomalIndex:nil
                                                                                                      andText:weakSelf.keywordView.textView.text
                                                                                                  andIsSecond:[weakSelf.areaBHeadView isSecond]];
                                                            } else {
                                                                HSLog(@"评论失败");
                                                            }
                                                            weakSelf.keywordView.textView.text = @"";
                                                            
                                                        }];
            
        } else if (editMode == EDIT_FORWARD_MODE) {
            //转发
            [HSGHHomeViewModel fetchForwardWithParams:@{
                                                        @"qqianId": qqiansVO.qqianId,
                                                        @"type": @0,
                                                        @"content": [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:weakkey.textView]
                                                        } :^(BOOL success ,NSString * relayId) {
                                                            [[AppDelegate instanceApplication] indicatorDismiss];
                                                            if (success) {
                                                                [weakModel qqianCommentAndForwardWithHomeType:HOME_FIRST_MODE andEdit:EDIT_FORWARD_MODE
                                                                                                 andMainIndex:indexPath andNomalIndex:nil
                                                                                                      andText:weakSelf.keywordView.textView.text
                                                                                                  andIsSecond:[weakSelf.areaBHeadView isSecond]];
                                                            } else {
                                                                HSLog(@"转发失败");
                                                            }
                                                            weakSelf.keywordView.textView.text = @"";
                                                            
                                                        }];
            
        } else if (HOME_REPLAY_MODE == editMode) {
            
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


- (void)adjustTableViewToFitKeyboardWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath WithCommentHeight:(CGFloat)commentHeight{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    rect.origin.y = rect.origin.y - commentHeight + 64;
    [self adjustTableViewToFitKeyboardWithRect:rect WithTableView:tableView];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect WithTableView:(UITableView*)tableView{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _keywordView.keyboardHeight);
    
    CGPoint offset = tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [tableView setContentOffset:offset animated:YES];
}


- (void)keyBoardShow:(NSIndexPath *)indexPath {
    [self addKeyBoardView];
    [_keywordView.textView becomeFirstResponder];
    _keywordView.editMode = HOME_COMMENT_MODE;
    _keywordView.indexPath = indexPath;
    _keywordView.commentIndex = nil;
    _keywordView.HomeMode = HOME_FIRST_MODE;
    [_keywordView.textView becomeFirstResponder];
}

- (void)refreshPersonalInfo {
    [self updateAreaAFrame];
    [self refreshFromLocal];
}


#pragma mark- public actions
+ (void)enterOtherZone:(NSString *)userID {
    if ([userID isEqualToString:[HSGHUserInf shareManager].userId]) {
        return;
    }
    
    if (UN_NIL_STR(userID).length == 0) {
        return;
    }

    UIViewController* currentVC = [[AppDelegate instanceApplication] fetchCurrentVC];
    if ([currentVC isKindOfClass:[HSGHScrollZoneVC class]] && [((HSGHScrollZoneVC*)currentVC).userID isEqualToString:userID] ) {
        return;
    }
    
    HSGHScrollZoneVC *vc = [[HSGHScrollZoneVC alloc] initWithUserID:userID];
    UINavigationController *nav = [AppDelegate instanceApplication].fetchCurrentNav;
    [nav pushViewController:vc animated:YES];
}

@end
