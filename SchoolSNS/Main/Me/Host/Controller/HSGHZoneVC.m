//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
// My homepage and other people homepage.

#import "HSGHZoneVC.h"
#import "HSGHUserInf.h"
#import "HSGHHeadView.h"
#import "HSGHSchoolView.h"
#import "HSGHFriendView.h"
#import "HSGHPhotoPickerController.h"
#import "SchoolSNS-Swift.h"
#import "HSGHZoneModel.h"
#import "HSGHHomeMainTableViewCell.h"
#import "HSGHZoneCell.h"
#import "HSGHUpViewController.h"
#import "HSGHHomeViewModel.h"
#import "YYPhotoBrowseView.h"
#import "SchoolSNS-Swift.h"
#import "HSGHAtViewController.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHMoreToolsAlertView.h"
#import "HSGHFriendViewModel.h"
#import "HSGHMoreCommentsVC.h"
#import "HSGHScrollZoneVC.h"

@interface HSGHZoneVC () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, strong) HSGHZoneModel *model;
@property(nonatomic, strong) HSGHKeyBoardView *keywordView;
@property(nonatomic, strong) HSGHHeadView *headBgView;   // rate : 750 : 456 ;

@property(nonatomic, strong) UIView *editSignatureBGView;
@property(nonatomic, assign) BOOL isEditSignature;

@property(nonatomic, strong) UIView *topStatusBgView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BOOL isMine;
@property(nonatomic, strong) HSGHFriendView *friendView; // 100
@end

@implementation HSGHZoneVC {
    UIView *_headView;
    HSGHSchoolView *_schoolView; // 103
    UIView *_wholeSelectionView;  // 25
    UIButton *_selectionButton1; //Height 25
    UIImageView *_selectionButton1ImageView; //22

    UIButton *_selectionButton2;
    UIImageView *_selectionButton2ImageView;
    UIView *selectedView;
    BOOL isSecondSelection;
}

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _userID = userID;
        _isMine = [_userID isEqualToString:[HSGHUserInf shareManager].userId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupModel];
    [self addNotificationCenter];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = !_isMine;
    if (_isMine) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    ViewController *tabVC = (ViewController *) self.tabBarController;
    [tabVC setCenterEnable:TAB_CENTER_ENABLE];
    _keywordView.hidden = NO;
    
    [self refreshMine];
    
    [self addKVO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (_isMine) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [super viewWillDisappear:animated];
    
    [self removeKVO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - KVO

- (void)creatStatusBgView {
    if (_isMine) {
        _topStatusBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        _topStatusBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topStatusBgView];
    }
}

- (void)dealloc {
    if (_isMine) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

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

#pragma mark - build views

- (void)setupViews {
    if (_isMine) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    [self setupNavViews];
    [self setupBodyView];
    [self creatStatusBgView];
}

- (void)setupNavViews {
    if (!_isMine) {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]
                initWithImage:[UIImage imageNamed:@"zone_rightBar"]
                        style:UIBarButtonItemStyleDone
                       target:self
                       action:@selector(rightBarAction:)];
        rightBar.tintColor = [UIColor blackColor];
        rightBar.imageInsets = UIEdgeInsetsMake(5, -5, -5, 5);
        self.navigationItem.rightBarButtonItem = rightBar;
    }
}

- (void)setupBodyView {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 39)
                                              style:UITableViewStylePlain];
    
    if (!_isMine) {
        _tableView.height -= HSGH_NAVGATION_HEIGHT;
        _tableView.top = HSGH_NAVGATION_HEIGHT;
        _tableView.height = self.view.height - HSGH_NAVGATION_HEIGHT;
    } else {
        _tableView.height -= 20;
        _tableView.top = 20;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"HSGHZoneCell" bundle:nil]
     forCellReuseIdentifier:@"mainCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HSGHZoneVCTableViewCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"mainCell2"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];//HEXRGBCOLOR(0xcdcdcd);

    [self setupHeadView];
    _tableView.sectionHeaderHeight = _headView.height;
    _tableView.tableHeaderView = _headView;
    __weak typeof(self) weakSelf = self;

    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.model requestMine:weakSelf.userID
                     refreshAll:false
                          block:^(BOOL status) {
                              [weakSelf endRefresh];
                              if (status) {
                                  [weakSelf.tableView reloadData];
                              }
                          }];
    }];

    [self buildSignatureView];
}

- (void)endRefresh {
    [_tableView.mj_footer endRefreshing];
}


- (void)setupHeadView {
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = self.view.backgroundColor;
        _headView.frame = CGRectMake(0, 0, self.view.width, 0);
        // First
        CGFloat tempHeight = _headView.width / 750 * 456;
        _headBgView = [[HSGHHeadView alloc]
                initWithFrame:CGRectMake(0, 0, _headView.width, tempHeight)
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

        [_headView addSubview:_headBgView];

        // Second
        tempHeight = 103.f;
        _schoolView = [[HSGHSchoolView alloc]
                initWithFrame:CGRectMake(0, _headBgView.height, _headView.width,
                        tempHeight)];
        [_schoolView updateIsMineInfo:_isMine];
        [_headView addSubview:_schoolView];

        // Third
        tempHeight = 0.f;
        _friendView = [[HSGHFriendView alloc]
                initWithFrame:CGRectMake(0, _headBgView.height + _schoolView.height,
                        _headView.width, tempHeight)];
        [_headView addSubview:_friendView];

        // set height
        _headView.height += _headBgView.height;
        _headView.height += _schoolView.height;
        if (!_isMine) {
            _headView.height += _friendView.height;
        }

        // Four
        [self setupSelectionButton];
        _wholeSelectionView.y = _headView.height;
        [_headView addSubview:_wholeSelectionView];
        _headView.height += _wholeSelectionView.height;
    }
}


//_headView ==> _headBgView  _schoolView  _friendView _wholeSelectionView
- (void)updateFrame {
    _headBgView.height = _headView.width / 750 * 456;
    if (_isMine) {
        _schoolView.height = [HSGHSchoolView calcWholeHeight:[HSGHUserInf shareManager].bachelorUniv masterUnvi:[HSGHUserInf shareManager].masterUniv highSchool:[HSGHUserInf shareManager].highSchool];
    }
    else {
        _schoolView.height = [HSGHSchoolView calcWholeHeight:[_model fetchCurrentUser].bachelorUniv masterUnvi:[_model fetchCurrentUser].masterUniv highSchool:[_model fetchCurrentUser].highSchool];
    }
    _friendView.height =  _isMine ? 0 : ([_model fetchFriendData].count > 0 ? 145 : 0);
    _wholeSelectionView.height = 35.f;
    _headView.height = _headBgView.height + _schoolView.height + _friendView.height + _wholeSelectionView.height;
    
    _schoolView.top = _headBgView.bottom;
    _friendView.top = _schoolView.bottom;
    _wholeSelectionView.top = _friendView.bottom;
}


- (void)setupSelectionButton {
    _wholeSelectionView = [UIView new];
    _wholeSelectionView.backgroundColor = [UIColor whiteColor];
    _wholeSelectionView.frame = CGRectMake(0, 0, self.view.width, 35.f);

    UIView *lineView = [UIView new];
    lineView.backgroundColor = HEXRGBCOLOR(0xefefef);
    lineView.frame = CGRectMake(0, 0, _wholeSelectionView.width, .5f);
    [_wholeSelectionView addSubview:lineView];

    _selectionButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectionButton1.backgroundColor = [UIColor clearColor];

    _selectionButton1.frame = CGRectMake(0, 0, _wholeSelectionView.width / 2, 35);
    _selectionButton1.tag = 1;
    [_selectionButton1 addTarget:self
                          action:@selector(selectSelection:)
                forControlEvents:UIControlEventTouchUpInside];

    _selectionButton1ImageView = [UIImageView new];
    [_selectionButton1ImageView setImage:[UIImage imageNamed:@"zone_selection1_n"]];
    _selectionButton1ImageView.highlightedImage = [UIImage imageNamed:@"zone_selection1_s"];
    _selectionButton1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectionButton1ImageView.frame = CGRectMake(0, 0, 30, 30);
    _selectionButton1ImageView.left = (_selectionButton1.width - _selectionButton1ImageView.width) / 2.f;
    _selectionButton1ImageView.top = (_selectionButton1.height - _selectionButton1ImageView.height) / 2.f;
    [_selectionButton1 addSubview:_selectionButton1ImageView];

    _selectionButton1.selected = YES;
    _selectionButton1ImageView.highlighted = YES;

    _selectionButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectionButton2.backgroundColor = [UIColor clearColor];

    _selectionButton2.frame = CGRectMake(_wholeSelectionView.width / 2, 0, _wholeSelectionView.width / 2, 35);
    _selectionButton2.tag = 2;
    [_selectionButton2 addTarget:self
                          action:@selector(selectSelection:)
                forControlEvents:UIControlEventTouchUpInside];
    _selectionButton2ImageView = [UIImageView new];
    [_selectionButton2ImageView setImage:[UIImage imageNamed:@"zone_selection2_n"]];
    _selectionButton2ImageView.highlightedImage = [UIImage imageNamed:@"zone_selection2_s"];
    _selectionButton2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectionButton2ImageView.frame = CGRectMake(0, 0, 30, 30);
    _selectionButton2ImageView.left = (_selectionButton2.width - _selectionButton2ImageView.width) / 2.f;
    _selectionButton2ImageView.top = (_selectionButton2.height - _selectionButton2ImageView.height) / 2.f;
    [_selectionButton2 addSubview:_selectionButton2ImageView];


    [_wholeSelectionView addSubview:_selectionButton2];
    [_wholeSelectionView addSubview:_selectionButton1];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _wholeSelectionView.height - (CGFloat) 0.75,
            _wholeSelectionView.width, 0.75)];
    lineView2.backgroundColor = HEXRGBCOLOR(0xefefef);
    [_wholeSelectionView addSubview:lineView2];

    selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, _wholeSelectionView.height - (CGFloat) 0.75,
            _wholeSelectionView.width / 2, 0.75)];
    selectedView.backgroundColor = HEXRGBCOLOR(0x888888);
    [_wholeSelectionView addSubview:selectedView];

    _selectionButton2.selected = NO;
}

- (void)selectSelection:(UIButton *)button {
    BOOL isSelectedTwo = (button.tag == 2);
    if (isSecondSelection != isSelectedTwo) {
        isSecondSelection = isSelectedTwo;
        _selectionButton1.selected = !isSecondSelection;
        _selectionButton2.selected = isSecondSelection;
        _selectionButton1ImageView.highlighted = _selectionButton1.selected;
        _selectionButton2ImageView.highlighted = _selectionButton2.selected;

        if (_selectionButton2.selected) {
            [UIView animateWithDuration:0.2 animations:^{
                selectedView.left = _wholeSelectionView.width / 2;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                selectedView.left = 0;
            }];
        }
        [_tableView reloadData];
    }
}


#pragma mark - views actions

- (void)rightBarAction:(UIBarButtonItem *)sender {
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
                                                          [ HSGHFriendViewModel fetchRemoveWithUrl:HSGHServerFriendRemoveURL Params:@{@"userId": UN_NIL_STR( _userID)} :^(BOOL success) {
                                                              [[AppDelegate instanceApplication]indicatorDismiss];
                                                              if(success == YES){
                                                                  Toast *toast = [[Toast alloc] initWithText:@"解除关系成功!" delay:0 duration:1.f];
                                                                  [toast show];
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

- (void)goSettings {
    HSGHSettingsSwiftVC *vc = [[HSGHSettingsSwiftVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - build model
- (void)refreshMine {
    if (_isMine) {
        //Refresh From Local
        [self updateFrame];
        [self updateInfoFromDB];

        __weak typeof(self) weakSelf = self;
        [_model requestMine:_userID
             refreshAll:true
                  block:^(BOOL status) {
                      if (status) {
                          [weakSelf updateFrame];
                          [weakSelf updateInfoFromDB];
                          [weakSelf.tableView reloadData];
                      }
        }];
    }
}

- (void)setupModel {
    if (_userID) {
        _isMine = [_userID isEqualToString:[HSGHUserInf shareManager].userId];
    }

    _model = [[HSGHZoneModel alloc] initWithUserID:_userID];
    __weak UITableView *weakTable = _tableView;
    __weak HSGHZoneVC *weakSelf = self;
    //Refresh more
    _model.block = ^(NSIndexPath *indexPath) {
        if(indexPath != nil){
            [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [weakTable reloadData];
        }
    };
    
    
    if (!_isMine) {
        [self updateFrame];
        [[AppDelegate instanceApplication]indicatorShow];
        [_model requestMine:_userID
             refreshAll:true
                  block:^(BOOL status) {
                      if (status) {
//                          [weakSelf.model requestPublicFriend:weakSelf.userID block:^(BOOL status) {
                              [[AppDelegate instanceApplication]indicatorDismiss];
                              [weakSelf updateFrame];
                              [weakSelf updateInfoFromDB];
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
}

#pragma mark - updateInfo
- (void)updateInfoFromDB {
    if (_isMine) {
        _headBgView.headPath = [HSGHUserInf shareManager].picture.thumbUrl;
        _headBgView.bgPath = [HSGHUserInf shareManager].backgroud.srcUrl;
        
        _headBgView.name =  UN_NIL_STR([HSGHUserInf fetchRealName]);
        
        _headBgView.signature = [HSGHUserInf shareManager].signature;
        _headBgView.sexType =  [NSString stringWithFormat:@"%@", @([HSGHUserInf shareManager].sex)] ;
        
        
        [_schoolView updateContainsView:[HSGHUserInf shareManager].bachelorUniv masterUnvi:[HSGHUserInf shareManager].masterUniv highSchool:[HSGHUserInf shareManager].highSchool];
        
        _schoolView.city = UN_NIL_STR([HSGHUserInf shareManager].homeCity);
    } else {
        self.title = [_model fetchCurrentUser].displayName;
        _headBgView.headPath = [_model fetchCurrentUser].picture.thumbUrl;
        _headBgView.bgPath = [_model fetchCurrentUser].backgroud.srcUrl;
        _headBgView.name = [_model fetchCurrentUser].displayName;
        _headBgView.signature = [_model fetchCurrentUser].signature;
        //_headBgView.sexType = [_model fetchCurrentUser].sex;
        
        [_schoolView updateContainsView:[_model fetchCurrentUser].bachelorUniv masterUnvi:[_model fetchCurrentUser].masterUniv highSchool:[_model fetchCurrentUser].highSchool];
        
        _schoolView.city =  [_model fetchCurrentUser].homeCityAddress ? [_model fetchCurrentUser].homeCityAddress : UN_NIL_STR([_model fetchCurrentUser].homeCity);
    }
}

#pragma mark - edit signature mode

- (void)buildSignatureView {
    if (_isMine) {
        _editSignatureBGView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_editSignatureBGView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSignatureBG)];
        [_editSignatureBGView addGestureRecognizer:ges];
        _editSignatureBGView.alpha = 0.0;
    }
}

- (void)clickSignatureBG {
    NSString* compareText = _isEditSignature ? [HSGHUserInf shareManager].signature : [HSGHUserInf shareManager].nickName;
    if (![[_headBgView fetchEditedText] isEqualToString:compareText]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"还未保存，是否退出？"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf enterEditMode:NO isSignature:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self enterEditMode:NO isSignature:_isEditSignature];
    }
}

- (void)enterEditMode:(BOOL)isEdit isSignature:(BOOL)isSignature{
    [_headBgView enterEditMode:isEdit isSingle:isSignature];
    _editSignatureBGView.alpha = isEdit ? 1 : 0;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSecondSelection) {
        return [_model fetchForwardData].count;
    }
    return [_model fetchData].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell *reuseCell;
//    if (!isSecondSelection) {
//        reuseCell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"
//                                                    forIndexPath:indexPath];
//        HSGHZoneCell *cell = reuseCell;
//        BOOL isFriend;
//        if(_isMine){
//            isFriend = YES;
//        }else{
//            isFriend = [_model isFriend];
//        }
//        [cell setContentFrame:[_model fetchData][(NSUInteger) indexPath.row] isFriend:isFriend];
//        HSGHHomeQQianModelFrame * modelF = [_model fetchData][indexPath.row];
//        if(![modelF.model.image.srcUrl isEqualToString:@""] && modelF.model.image.srcUrl != nil){
//            //图片
//            cell.publicCellView.marginTop.constant = 0;
//        }else{
//            cell.publicCellView.marginTop.constant = 16;
//        }
//        cell.publicCellView.ContentView.block = ^() {
//            //查看更多
//            [_model qqianMoreWithHomeType:HOME_FIRST_MODE andIndex:indexPath andIsSecond:isSecondSelection];
//        };
//        cell.publicCellView.ToolView.block = ^(NSInteger tag) {
//            if (tag == 3000) {
//                //点赞
//                [_model qqianUpWithHomeType:HOME_FIRST_MODE andIndex:indexPath andIsSecond:isSecondSelection];
//            } else if (tag == 1000) {
//                //评论
//                if( [_model fetchData].count > 0){
//                    HSGHHomeQQianModel *model = ((HSGHHomeQQianModelFrame *) [_model fetchData][(NSUInteger) indexPath.row]).model;
//                    [HSGHCommentsVC show:model.qqianId userID:model.owner.userId name:model.owner.displayName
//                                   block:^(BOOL isChanged, NSArray *array) {
//                                       
//                                   }];
//                }
//            } else if (tag == 2000) {
//                //转发
//                [self keyBoardShow:indexPath];
//                [self adjustTableViewToFitKeyboardWithTableView:tableView andIndexPath:indexPath WithCommentHeight:[((HSGHHomeQQianModelFrame *)[_model fetchData][indexPath.row]) commentHeight]];
//
//            } else if (tag == 4000) {
//                //进点赞列表
//                HSGHUpViewController *upVC = [HSGHUpViewController new];
//                NSArray *datalist = isSecondSelection ? [_model fetchForwardData] : [_model fetchData];
//                upVC.qqianVo = ((HSGHHomeQQianModelFrame *) datalist[(NSUInteger) indexPath.row]).model;
//                [self.navigationController pushViewController:upVC animated:YES];
//            }else if (tag == 6000){
//                //举报
//                HSGHMoreToolsAlertView * view = [[[NSBundle mainBundle]loadNibNamed:@"HSGHMoreToolsAlertView" owner:self options:nil]lastObject];
//                view.model = ((HSGHHomeQQianModelFrame*)[_model fetchData]
//                              [(NSUInteger)indexPath.row]).model;
//                view.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
//                view.block = ^(NSInteger type){
//                    //                    [self.delegate qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
//                    [_model qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath andIsSecond:isSecondSelection];
//                };
//                [[UIApplication sharedApplication].keyWindow addSubview:view];
//                [view loadDataWithModel:((HSGHHomeQQianModelFrame*)[_model fetchData][(NSUInteger)indexPath.row]) WithCellView:cell];
//            }
//        };
//        cell.publicCellView.CommentView.oprationBlock = ^(NSInteger type, NSIndexPath *nomalIndexPath) {
//            if (type == 1000) {
//                //查看更多评论
//                NSArray *datalist = isSecondSelection ? [_model fetchForwardData] : [_model fetchData];
//                if(datalist.count > 0){
//                    HSGHHomeQQianModel *model = ((HSGHHomeQQianModelFrame *) datalist[(NSUInteger) indexPath.row]).model;
//                    [HSGHCommentsVC show:model.qqianId userID:model.owner.userId name:model.owner.displayName
//                                   block:^(BOOL isChanged, NSArray *array) {
//                                   }];
//                }
//            } else if (type == 2000) {
//                //回复
//            }
//        };
//
//    } else {
    
        reuseCell = [tableView dequeueReusableCellWithIdentifier:@"mainCell2"
                                                    forIndexPath:indexPath];
        HSGHHomeMainTableViewCell *cell = reuseCell;
    
    
        if (!isSecondSelection) {
            [cell setcellFrame:[_model fetchData][(NSUInteger) indexPath.row]];
             cell.HeaderView.otherVisiableLabel.hidden = YES;
            HSGHHomeQQianModelFrame * modelF = [_model fetchData][indexPath.row];
            if(_isMine){
                if([modelF.model.creator.userId isEqualToString:@""]||modelF.model.creator.userId == nil){
                    //匿名
                    cell.HeaderView.otherVisiableLabel.hidden = NO;
                }
            }
        }else{
            [cell setcellFrame:[_model fetchForwardData][(NSUInteger) indexPath.row]];
             cell.HeaderView.otherVisiableLabel.hidden = YES;
        }
        cell.ContentView.block = ^() {
            //查看更多
            [_model qqianMoreWithHomeType:HOME_FIRST_MODE andIndex:indexPath andIsSecond:isSecondSelection];
        };
        cell.HeaderView.block = ^(NSInteger type, NSString *key) {
            if (type == 1000) {
                //进入空间
                if (!_isMine) {
                    if (![_userID isEqualToString: key]) {
                        [HSGHZoneVC enterOtherZone:key];
                    }
                }
                else {
                    [HSGHZoneVC enterOtherZone:key];
                }
                
            } else if (type == 2000) {
                //加好友  置换数据源
                [_model modifyAddFriendMeDataWithIndexPath:indexPath andIsSecond:isSecondSelection];

            } else if (type == 3000) {
                //举报
                HSGHMoreToolsAlertView * view = [[[NSBundle mainBundle]loadNibNamed:@"HSGHMoreToolsAlertView" owner:self options:nil]lastObject];
                NSArray * datalist = [NSArray array];
                if (!isSecondSelection) {
                    datalist = [NSArray arrayWithArray:[_model fetchData]];
                }else{
                    datalist = [NSArray arrayWithArray:[_model fetchForwardData]];;
                }
                view.model = ((HSGHHomeQQianModelFrame*)datalist[(NSUInteger)indexPath.row]).model;
                view.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
                view.block = ^(NSInteger type){
//                    [self.delegate qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath];
                    [_model qqianRemoveHomeType:HOME_FIRST_MODE andIndexPath:indexPath andIsSecond:isSecondSelection];
                };
                 [[AppDelegate instanceApplication].window.rootViewController.view addSubview:view];
                [view loadDataWithModel:((HSGHHomeQQianModelFrame*)datalist[(NSUInteger)indexPath.row]) WithCellView:cell];

            }
        };
        cell.ToolView.block = ^(NSInteger tag) {
            if (tag == 3000) {
                //点赞
                [_model qqianUpWithHomeType:HOME_FIRST_MODE andIndex:indexPath andIsSecond:isSecondSelection];

            } else if (tag == 1000) {
                //评论
                NSArray * datalist = [NSArray array];
                if (!isSecondSelection) {
                    datalist = [NSArray arrayWithArray:[_model fetchData]];
                }else{
                    datalist = [NSArray arrayWithArray:[_model fetchForwardData]];;
                }
                if( datalist.count > 0){
                    HSGHHomeQQianModel *model = ((HSGHHomeQQianModelFrame *) datalist[(NSUInteger) indexPath.row]).model;
                    //HSGHMoreCommentsVC
                    [HSGHMoreCommentsVC show:model.qqianId userID:model.owner.userId name:model.owner.displayName
                                   block:^(BOOL isChanged, NSArray *array) {
                                   }];
                }
            } else if (tag == 2000) {
                //转发
                [self keyBoardShow:indexPath];
                NSArray * datalist = [NSArray array];
                if (!isSecondSelection) {
                    datalist = [NSArray arrayWithArray:[_model fetchData]];
                }else{
                    datalist = [NSArray arrayWithArray:[_model fetchForwardData]];;
                }
                [self adjustTableViewToFitKeyboardWithTableView:tableView andIndexPath:indexPath WithCommentHeight:[((HSGHHomeQQianModelFrame *) datalist[indexPath.row]) commentHeight]];
            } else if (tag == 4000) {
                //进点赞列表
                
                HSGHUpViewController *upVC = [HSGHUpViewController new];
                NSArray *datalist = isSecondSelection ? [_model fetchForwardData] : [_model fetchData];
                upVC.qqianVo = ((HSGHHomeQQianModelFrame *) datalist[(NSUInteger) indexPath.row]).model;
                [self.navigationController pushViewController:upVC animated:YES];

            } else if (tag == 5000) {
                HSLog(@"删除");
            }
        };

        cell.CommentView.oprationBlock = ^(NSInteger type, NSIndexPath *nomalIndexPath) {
            if (type == 1000) {
                //查看更多评论
                NSArray * datalist = [NSArray array];
                if (!isSecondSelection) {
                    datalist = [NSArray arrayWithArray:[_model fetchData]];
                }else{
                    datalist = [NSArray arrayWithArray:[_model fetchForwardData]];;
                }
                if(datalist.count > 0){
                    HSGHHomeQQianModel *model = ((HSGHHomeQQianModelFrame *) datalist[(NSUInteger) indexPath.row]).model;
                    //HSGHMoreCommentsVC
                    [HSGHMoreCommentsVC show:model.qqianId userID:model.owner.userId name:model.owner.displayName
                                   block:^(BOOL isChanged, NSArray *array) {
                                   }];
                }
            } else if (type == 2000) {
                //回复

            }
        };
    reuseCell.clipsToBounds = YES;
    return reuseCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSecondSelection) {
        return [[_model fetchForwardData][(NSUInteger) indexPath.row] cellHeight];
    }

//    HSGHHomeQQianModelFrame * modelF = [_model fetchData][0];
//    if(![modelF.model.image.srcUrl isEqualToString:@""]&&modelF.model.image.srcUrl != nil){
//        //图片
//        return [[_model fetchData][(NSUInteger) indexPath.row] cellHeight] - 98 + 1  + 16;
//    }
//    HSGHHomeQQianModel * model = ((HSGHHomeQQianModelFrame *)[_model fetchData][(NSUInteger) indexPath.row]).model;
//    if(model.creator.userId == nil || [model.creator.userId isEqualToString:@""]){
//        return [[_model fetchData][(NSUInteger) indexPath.row] cellHeight] - 58 + 16;
//    }
    return [[_model fetchData][(NSUInteger) indexPath.row] cellHeight];
    
}

//点击头像
+ (void)enterOtherZone:(NSString *)userID {
    return [HSGHScrollZoneVC enterOtherZone:userID];
    
//    if ([userID isEqualToString:[HSGHUserInf shareManager].userId]) {
//        return;
//    }
//    
//    if (UN_NIL_STR(userID).length == 0) {
//        return;
//    }
//    
//    HSGHZoneVC *vc = [[HSGHZoneVC alloc] initWithUserID:userID];
//    UINavigationController *nav =
//            [AppDelegate instanceApplication].fetchCurrentNav;
//    [nav pushViewController:vc animated:YES];
}


- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMine)
                                                 name:HSGH_PUBLISH_NOTIFICATION
                                               object:nil];
}


#pragma mark - keyboardView

- (void)addKeyBoardView {
    _keywordView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHKeyBoardView"
                                                  owner:self
                                                options:nil] lastObject];
    _keywordView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    __weak HSGHKeyBoardView *weakkey = _keywordView;
    __weak HSGHZoneVC *weakSelf = self;
    _Bool isSecond = isSecondSelection;
    __weak HSGHZoneModel *weakModel = _model;
    _keywordView.block = ^(NSIndexPath *indexPath, NSInteger homeMode,
            NSIndexPath *commentIndex, NSInteger editMode) {
        //处理发布
        [[AppDelegate instanceApplication] indicatorShow];
        NSArray *datalist = isSecond ? [weakModel fetchForwardData] : [weakModel fetchData];
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
                                                      andIsSecond:isSecond];
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
                                                      andIsSecond:isSecond];
                } else {
                    HSLog(@"转发失败");
                }
                weakSelf.keywordView.textView.text = @"";

            }];

        } else if (HOME_REPLAY_MODE == editMode) {

        } else if (ZONE_EDIT_SIGNATURE == editMode) {
            [HSGHSettingsModel ModifyUserSignature:weakkey.textView.text block:^(BOOL status, NSString* errDes) {
                [[AppDelegate instanceApplication] indicatorDismiss];
                if (status) {
                    weakSelf.headBgView.signature = weakkey.textView.text;
                    Toast *toast = [[Toast alloc] initWithText:@"更新签名成功" delay:0 duration:1.f];
                    [toast show];
                }
            }];
        }
        [weakSelf.keywordView removeFromSuperview];
    };

    _keywordView.atBlock = ^{
        HSGHAtViewController* atViewController = [HSGHAtViewController new];
        atViewController.block = ^(BOOL isSuccess,HSGHFriendSingleModel* model) {
            //Todo  must change when friends is ok.
            [HSGHCommentsCallFriendViewModel addOneFriend:model.displayName userId:model.userId location:weakkey.textView.selectedRange.location yyTextView:weakkey.textView];
        };
        [weakSelf.navigationController pushViewController:atViewController animated:YES];
    };
    [self.view addSubview:_keywordView];
    [_keywordView startInputText];
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


- (void)keyBoardShow:(NSIndexPath *)indexPath {

    [self addKeyBoardView];
    [_keywordView.textView becomeFirstResponder];
    _keywordView.editMode = HOME_COMMENT_MODE;
    _keywordView.indexPath = indexPath;
    _keywordView.commentIndex = nil;
    _keywordView.HomeMode = HOME_FIRST_MODE;
    [_keywordView.textView becomeFirstResponder];
}
@end
