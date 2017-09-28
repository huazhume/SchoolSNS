//
//  ViewController.m
//  Betterme
//
//  Created by len on 16/9/23.
//  Copyright © 2016年 len. All rights reserved.
//

#import "ViewController.h"
#import "HSGHScrollZoneVC.h"
#import "HSGHPublishView.h"
#import "HSGHUserInf.h"
#import "HSGHPhotoPickerController.h"
#import "HSGHPublishMsgVC.h"
#import "HSGHHomeViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "HSGHPublishViewModel.h"
#import "HSGHHomeMainTableViewCell.h"
#import "HSGHHomeViewModel.h"
#import "HSGHUserDefalut.h"
#import "HSGHAutoSendModel.h"
#import "HSGHMessageModel.h"
#import "HSGHAlertView.h"
#import "HSGHFriendViewModel.h"
#import "NSObject+YYModel.h"
#import "UITabBarItem+PPBadgeView.h"
#import "HSGHFriendViewController.h"
#import "HXPhotoViewController.h"
#import "HSGHMessageModel.h"
#import "DWSRecordManager.h"
#import "HSGHMessageVC.h"
#import "NSString+pinyin.h"
#import "HSGHZoneModel.h"

@interface ViewController () <UITabBarControllerDelegate, HXPhotoViewControllerDelegate> {
    HSGHPublishView* animationView;
    UINavigationController* _selectNav;
}
@property (nonatomic, strong) NSDate* fistSelectlastDate;
@property (nonatomic, assign) NSInteger lastTabSelect;

@property (strong, nonatomic) HXPhotoManager *photomanager;
@property (strong, nonatomic) HXPhotoManager *videomanager;
//tab_icon_fb_n
@end

@implementation ViewController {
    HSGHZoneModel *zoneModel;
}
#ifdef DWSRocordScreen
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ([DWSRecordManager shareInstance].isRecording) {
        [[DWSRecordManager shareInstance] stop];
    }else{
        [[DWSRecordManager shareInstance] start];
    }
}
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //     self.tabBar.frame = CGRectMake(0,HSGH_SCREEN_HEIGHT - 44 , HSGH_SCREEN_WIDTH, 49);
    
    //首次注册后，强制发布一个新鲜事
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstLaunchPublish)
                                                 name:@"firstLaunchVC_2_rootVC_publish_notifi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareData) name:HSGH_POST_2_FRIEND_ADDME_NOTIFI object:nil];
    
    //收到推送通知后处理消息tab栏提示数字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshMessageTabTips) name:@"msg_refreshData" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self prepareData];
    });
    
}
/** 首次注册后，强制发布一个新鲜事 */
- (void)firstLaunchPublish {
    UINavigationController* nav = self.viewControllers[0];
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.photomanager;
    vc.hiddenLeftBackButton = YES;
    vc.delegate = self;
    [nav pushViewController:vc animated:YES];
}

/** 提前做一次数据请求 */
- (void)prepareData {
    //请求一次好友数据
    [HSGHFriendViewModel fetchAllFriends:^(BOOL success, NSArray* array) {
        if (success) {
            if(array.count > 0){//HSGHFriendSingleModel
                _allFriendArr = array;
                _friendDataArray = [self getFriendListDataBy:array];
            }
        }
    }];
    
    //请求一次好友--加我 数据
    [HSGHFriendViewModel fetchReceivedFriends:^(BOOL success, NSArray* array) {
        if (success == YES) {
            _friendThirdArr = [NSArray arrayWithArray:array];
            if (_friendThirdArr.count==0) {
                [self.tabBar.items[1] pp_hiddenBadge];
            } else if (_friendThirdArr.count < 99 ) {
                [self.tabBar.items[1] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",_friendThirdArr.count]];
            } else {
                [self.tabBar.items[1] pp_addBadgeWithText:@"99+"];
            }
        }
    }];
    
    //请求一次消息tab栏的提示数字
    [self getMessageTabTips];
}

- (void)refleshMessageTabTips {
    [self getMessageTabTips];
}

/** 消息tab栏的提示数字 */
- (void)getMessageTabTips {
    //获取消息总数，只执行一次
    HSGHMessageVC *vc = [ViewController messageVC];
    [HSGHMessageModel fetchMessageViewModelArrWithType:0 Page:0 :^(BOOL success, NSArray *array) {
        if (success) {
            NSUInteger tipCnt = array.count;
            if (tipCnt==0) {
                [self.tabBar.items[3] pp_hiddenBadge];
            } else if (tipCnt < 99 ) {
                [self.tabBar.items[3] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",tipCnt]];
            } else {
                [self.tabBar.items[3] pp_addBadgeWithText:@"99+"];
            }
            [vc prepareData:array];
        }
    }];
}

- (void)awakeFromNib
{

    [super awakeFromNib];
    _friendMsgNumModel = [HSGHNotificationMessage new];
    _messageMsgNumModel = [HSGHNotificationMessage new];

    _isFullScreen = YES;
    self.delegate = self;
    [self configUI];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:19 / 155.0 green:19 / 155.0 blue:19 / 155.0 alpha:1] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:19 / 155.0 green:19 / 155.0 blue:19 / 155.0 alpha:1] } forState:UIControlStateSelected];
    _selectNav = self.viewControllers[0];
    
    [[HSGHAutoSendModel singleInstance] start];
    [HSGHMessageModel refreshRedCount];
    [self registNotification];
}

- (void)configUI
{
    self.tabBar.backgroundColor = HEXRGBCOLOR(0xFAFAFA);
    [self.tabBar addSubview:self.centerItemBtn];
    [self.centerItemBtn addTarget:self action:@selector(centerBtnClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self replaceLastNav];
}

// Replace the last navigation
- (void)replaceLastNav {
    if (UN_NIL_STR([HSGHUserInf shareManager].userId)) {
        zoneModel = [[HSGHZoneModel alloc]initWithUserID:[HSGHUserInf shareManager].userId];
        [zoneModel requestMine:[HSGHUserInf shareManager].userId
                    refreshAll:true
                         block:^(BOOL status) {
                             if (status) {
                                 UINavigationController *nav = self.viewControllers.lastObject;
                                ((HSGHScrollZoneVC *)nav.viewControllers.firstObject).model = zoneModel;
                             }
                         }];
        [zoneModel requestForward:[HSGHUserInf shareManager].userId
                       refreshAll:true
                            block:^(BOOL status) {
                                if (status) {
                                    UINavigationController *nav = self.viewControllers.lastObject;
                                    ((HSGHScrollZoneVC *)nav.viewControllers.firstObject).model = zoneModel;
                                }
                            }];
    }
    NSArray* navArray = self.viewControllers;
    if (navArray.count > 0) {
        HSGHScrollZoneVC* vc = [[HSGHScrollZoneVC alloc] initWithUserID:[HSGHUserInf shareManager].userId];
        if (vc) {
            [((UINavigationController*)navArray.lastObject)
                setViewControllers:@[ vc ]];
        }
    }
    [self setViewControllers:navArray.copy];
}

- (UIButton*)centerItemBtn
{
    if (!_centerItemBtn) {
        UIButton* centerItem = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //centerItem.frame = CGRectMake((HSGH_SCREEN_WIDTH - 49) / 2.0, 0, 44, 44);
        centerItem.size = CGSizeMake(44, 44);
        centerItem.center = CGPointMake(HSGH_SCREEN_WIDTH/2.0,22);
        
        
        //         centerItem.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
        [centerItem setImage:[UIImage imageNamed:HSGH_TABBAR_IMAGE] forState:UIControlStateNormal];
        [centerItem setImage:[UIImage imageNamed:HSGH_TABBAR_IMAGE] forState:UIControlStateSelected];
        _centerItemBtn = centerItem;
    }
    return _centerItemBtn;
}

- (void)setCenterEnable:(TAB_CENTER_MODE)mode
{
    if (mode == TAB_CENTER_DISENABLE) {
        self.centerItemBtn.userInteractionEnabled = NO;
        [self.centerItemBtn setImage:[UIImage imageNamed:@"tab_icon_fb_n"]
                            forState:UIControlStateNormal];
    } else {
        self.centerItemBtn.userInteractionEnabled = YES;
        [self.centerItemBtn setImage:[UIImage imageNamed:HSGH_TABBAR_IMAGE]
                            forState:UIControlStateNormal];
        [self.centerItemBtn setImage:[UIImage imageNamed:HSGH_TABBAR_IMAGE]
                            forState:UIControlStateSelected];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (void)centerBtnClicked:(UIButton*)btn
{
    
    [HSGHPublishViewModel fetchPublishAnonymtimes:^(BOOL success, HSGHPublishViewModel * reponse) {
        if(success){
            [HSGHUserDefalut saveUserAnonymtimes:reponse.qqResidueDegree];
        }
    }];
    animationView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHPublishView"
                                                   owner:self
                                                 options:nil] lastObject];
    animationView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:animationView];
    __weak ViewController* weakSelf = self;
    __weak HSGHPublishView* weakS = animationView;
    animationView.block = ^(int tag) {
        UINavigationController* nav = weakSelf.viewControllers[weakSelf.selectedIndex];
        HSLog(@"----tag----%d---nav=%@",tag,nav);//tag=1图片,tag=2视频,tag=0文字
        
        if (tag == 0) {//tag=0文字
            HSGHPublishMsgVC* vc = [HSGHPublishMsgVC new];
            vc.publishType = 0;
            [nav pushViewController:vc animated:YES];
        
        } else if (tag == 1) {//tag=1图片
            HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
            vc.manager = weakSelf.photomanager;
            vc.delegate = weakSelf;
            [nav pushViewController:vc animated:YES];
            
        } else if (tag == 2) {//tag=2视频
            HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
            vc.manager = weakSelf.videomanager;
            vc.delegate = weakSelf;
            [nav pushViewController:vc animated:YES];
        }
        
        [weakS removeFromSuperview];
        
        
        
//        UINavigationController* nav = weakSelf.viewControllers[weakSelf.selectedIndex];
//        NSLog(@"%@", nav);
//        HSGHPublishMsgVC* vc = [HSGHPublishMsgVC new];
//        vc.publishType = @(tag);
//        if (tag == 0) {
//            [nav pushViewController:vc animated:YES];
//        } else {
//            HSGHPhotoPickerController* controller = [HSGHPhotoPickerController new];
//            controller.isPush = true;
//#ifdef OPEN_VIDEO
//            controller.isContainsVideo = (tag == 2);
//            controller.isEnterVideo = (tag == 2);
//#endif
//            [nav pushViewController:controller animated:YES];
//        }
//        [weakS removeFromSuperview];
    };
    animationView.hidden = NO;
}

#pragma mark - tabbarDelegate
- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    _selectNav = (UINavigationController*)viewController;
    UINavigationController* navi = (UINavigationController*)viewController;
    NSDate* date = [NSDate date];
    if ([navi isEqual:self.viewControllers[0]]) { //第一个控制器
        //处理双击事件
        HSGHHomeViewController* homeVC = (HSGHHomeViewController*)navi.topViewController;
        if (date.timeIntervalSince1970 - _fistSelectlastDate.timeIntervalSince1970 < 0.5) {
            //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
            _fistSelectlastDate = [NSDate dateWithTimeIntervalSince1970:0];
            _fistSelectlastDate = date;
            NSLog(@"上移 和 刷新");
            [homeVC moveToTopAndIsRefresh:YES];
            _lastTabSelect = 0;
            return NO;
        } else {
            if (_lastTabSelect == 0) {
                _fistSelectlastDate = date;
                NSLog(@"上移");
                [homeVC moveToTopAndIsRefresh:NO];
            }
            _lastTabSelect = 0;
            return YES;
        }
    }
    _lastTabSelect = -1;
    return YES;
}

//隐藏 nav tab
- (void)navgationAndTabisHidden:(BOOL)isHidden
{
    CGRect rect = self.tabBar.frame;
    CGFloat tabBottom = isHidden ? HSGH_SCREEN_HEIGHT : HSGH_SCREEN_HEIGHT - 44;
    [UIView animateWithDuration:0.45
        animations:^{
            self.tabBar.frame = CGRectMake(0, tabBottom, rect.size.width, rect.size.height);
            //        [UIApplication sharedApplication].statusBarHidden = isHidden;
        }
        completion:^(BOOL finished) {
            if (finished) {
                self.isFullScreen = isHidden;
            }
        }];
    // self.isFullScreen = isHidden;
}

#pragma mark - publish
//imageData and VideoData no nil
- (void)publishQQianMsgWithVideoData:(NSData*)VideoData imageData:(NSData*)imageData WithParms:(NSDictionary*)params WithUserID:(NSString *)userId {
    [HSGHPublishViewModel uploadVideoFile:VideoData imageData:imageData block:^(BOOL success, NSString* key) {
        if (success == YES) {
            NSMutableDictionary* mud = [NSMutableDictionary dictionaryWithDictionary:params];
            [mud setObject:key forKey:@"imageKey"];
            
            [HSGHPublishViewModel fetchPublishWithParams:
                                                     mud:^(BOOL success, HSGHPublishViewModel* response) {
                                                         [[AppDelegate instanceApplication] indicatorDismiss];
                                                         if (success == YES) {
                                                             if(userId != nil && response.qqianId != nil){
                                                                 
                                                                 
                                                                 //视频成功后再上传封面
                                                                 [HSGHUploadPicNetRequest uploadAlbum:imageData key:key block:nil];
                                                                 [self searchQQianWithQQianId:response.qqianId WithErrorId:userId];
                                                             }
                                                             
                                                         } else {
                                                             NSLog(@"发布失败啦");
                                                         }
                                                         
                                                     }];
        } else {
        }
    }];
}


- (void)publishQQianMsgWithImageData:(NSData*)imageData isVideo:(BOOL)isVideo WithParms:(NSDictionary*)params WithUserID:(NSString *)userId
{

    if (imageData == nil) {
        [HSGHPublishViewModel fetchPublishWithParams:
                                              params:^(BOOL success , HSGHPublishViewModel * response) {
                                                  if (success == YES) {
                                                      //发布成功后
                                                      [self searchQQianWithQQianId:response.qqianId WithErrorId:userId];
                                                  } else {
                                                      HSLog(@"发布失败啦---");
                                                  }
                                              }];

    } else {
        [HSGHPublishViewModel uploadFile:imageData isVideo:isVideo block:^(BOOL success, NSString* key) {
                                   if (success == YES) {
                                       NSMutableDictionary* mud = [NSMutableDictionary dictionaryWithDictionary:params];
                                       [mud setObject:key forKey:@"imageKey"];

                                       [HSGHPublishViewModel fetchPublishWithParams:
                                                                                mud:^(BOOL success, HSGHPublishViewModel* response) {
                                                                                    [[AppDelegate instanceApplication] indicatorDismiss];
                                                                                    if (success == YES) {
                                                                                        if(userId != nil && response.qqianId != nil){
                                                                            
                                                                                            [self searchQQianWithQQianId:response.qqianId WithErrorId:userId];
                                                                                        }

                                                                                    } else {
                                                                                        NSLog(@"发布失败啦");
                                                                                    }

                                                                                }];
                                   } else {
                                   }
                               }];
    }
}

- (void)publishQQianMsgWithImageKey:(NSString*)imageKey WithParms:(NSDictionary*)params WithUserID:(NSString*)userId
{

    if (imageKey == nil || [imageKey isEqualToString:@""]) {
        [HSGHPublishViewModel fetchPublishWithParams:
                                              params:^(BOOL success, HSGHPublishViewModel* response) {
                                                  if (success == YES) {
                                                      [self searchQQianWithQQianId:response.qqianId WithErrorId:userId];

                                                  } else {
                                                      NSLog(@"发布失败啦");
                                                  }
                                              }];

    } else {

        NSMutableDictionary* mud = [NSMutableDictionary dictionaryWithDictionary:params];
        [mud setObject:imageKey forKey:@"imageKey"];
        [HSGHPublishViewModel fetchPublishWithParams:
                                                 mud:^(BOOL success, HSGHPublishViewModel* response) {
                                                     [[AppDelegate instanceApplication] indicatorDismiss];
                                                     if (success == YES) {
                                                         if (userId != nil && response.qqianId != nil) {

                                                             [self searchQQianWithQQianId:response.qqianId WithErrorId:userId];
                                                         }

                                                     } else {
                                                         NSLog(@"发布失败啦");
                                                     }

                                                 }];
    }
}

- (void)searchQQianWithQQianId:(NSString *)qqianId WithErrorId:(NSString *)errorId{
    
    [HSGHHomeViewModel fetchSearchQQiansModelArrWitQQiansID:qqianId :^(BOOL success, NSArray *array) {
        if(array.count > 0){
              HSGHHomeQQianModelFrame * modelF = [array firstObject];
            if(modelF != nil && errorId != nil){
                [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_PUBLISH_NOTIFICATION object:nil userInfo:@{@"errorId":errorId,@"qqian":modelF}];
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_PUBLISH_NOTIFICATION object:nil userInfo:nil];
            }
        }
    }];
}

#pragma  mark - HXPhotoViewControllerDelegate

- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:0 completion:^(NSArray<UIImage *> *images) {
        //weakSelf.imageView.image = images.firstObject;
        
        HSLog(@"选择图片完成---到达rootVC");
        
        UINavigationController* nav = weakSelf.viewControllers[weakSelf.selectedIndex];
        NSLog(@"%@", nav);
        
        HSGHPublishMsgVC *vc = [HSGHPublishMsgVC new];
        vc.publishType = @1;
        vc.isLauncher = NO;
        vc.image = images.firstObject;
        [nav pushViewController:vc animated:YES];
    }];
}

- (HXPhotoManager *)photomanager {
    if (!_photomanager) {
        _photomanager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photomanager.openCamera = YES;
        _photomanager.singleSelected = YES;
        _photomanager.saveSystemAblum = YES;
        _photomanager.cacheAlbum = NO;
        //_manager.singleSelecteClip = NO;
        _photomanager.cameraType = HXPhotoManagerCameraTypeFullScreen;
    }
    return _photomanager;
}

- (HXPhotoManager *)videomanager {
    if (!_videomanager) {
        _videomanager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
        _videomanager.openCamera = YES;
        _videomanager.singleSelected = YES;
        _videomanager.saveSystemAblum = YES;
        _photomanager.cacheAlbum = NO;
        //_manager.singleSelecteClip = NO;
        _videomanager.cameraType = HXPhotoManagerCameraTypeHalfScreen;
    }
    return _videomanager;
}

#pragma mark - umSocialShared

- (void)umSocialType:(UMSOCIAL_MODE)mode WithTitle:(NSString*)title description:(NSString*)description ImageUrl:(NSString*)imageUrl webUrl:(NSString*)webUrl image:(UIImage*)image
{
    UMSocialMessageObject* messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject* shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:image];
    shareObject.thumbImage = image;

    UMShareImageObject* shared = [UMShareImageObject shareObjectWithTitle:@"骞文" descr:@"快扫码下载安装吧" thumImage:image];
    //设置网页地址
    shared.shareImage = image;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shared;
    UMSocialPlatformType type;
    if(mode == UMSOCIAL_QQ_MODE){
        type = UMSocialPlatformType_QQ;
    }else if (mode == UMSOCIAL_QQZONE_MODE){
        type = UMSocialPlatformType_Qzone;
    }else if (mode == UMSOCIAL_WECHAT_MODE){
        type = UMSocialPlatformType_WechatSession;
    }else {
        type = UMSocialPlatformType_WechatTimeLine;
    }
    [[UMSocialManager defaultManager] shareToPlatform:type
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError* error) {
                                               if (error) {
                                                   NSLog(@"************Share fail with error %@*********", error);
                                               } else {
                                                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                       UMSocialShareResponse* resp = data;
                                                       //分享结果消息
                                                       NSLog(@"response message is %@", resp.message);
                                                       //第三方原始返回的数据
                                                       NSLog(@"response originalResponse data is %@", resp.originalResponse);
                                                   } else {
                                                       NSLog(@"response data is %@", data);
                                                   }
                                               }
                                           }];
}

#pragma mark - 生成分享图片
- (UIImage*)getCellGraphicsBeginImageWithClass:(NSString*)className WithFrame:(HSGHHomeQQianModelFrame*)modelF
{
    modelF.model.contentIsMore = @1;
    HSGHHomeQQianModelFrame *modelF2 =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [modelF2 setModel:modelF.model];
    HSGHHomeMainTableViewCell* cellView = [[[NSBundle mainBundle] loadNibNamed:@"HSGHHomeMainTableViewCell" owner:self options:nil] lastObject];
    cellView.frame = CGRectMake(0, 0, modelF2.cellWidth* 0.8, modelF2.cellHeight*0.8);

    [cellView setcellFrame:modelF2];
    
    UIGraphicsBeginImageContextWithOptions(cellView.frame.size, NO,  [UIScreen mainScreen].scale);
    [cellView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

}

- (void)registNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moreToolsDeal:) name:@"MORETOOLS_NOTIFICATION" object:nil];
    // 在init的时候监听状态栏改变的通知 UIApplicationDidChangeStatusBarFrameNotification
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (layoutControllerSubViews) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
    
}

- (void)layoutControllerSubViews {
    
}

- (void)moreToolsDeal:(NSNotification *)notification {
    BOOL is = [notification.userInfo[@"is"] boolValue];
    HSGHAlertView * alertView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHAlertView" owner:self options:nil]lastObject];
    if(!is){
        [alertView.alertBtn setTitle:@"举报失败" forState:UIControlStateNormal];
        
    }else{
        [alertView.alertBtn setTitle:@"举报成功" forState:UIControlStateNormal];

    }
    alertView.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
    [self.view addSubview:alertView];
    [UIView animateWithDuration:2 animations:^{
        alertView.alpha = 0;
    }completion:^(BOOL finished) {
        [alertView removeFromSuperview];
    }];
}

+ (HSGHMessageVC *)messageVC {
    AppDelegate* delegate = [AppDelegate instanceApplication];
    ViewController *vc = (ViewController *) (delegate.window.rootViewController);
    UINavigationController *nav = (UINavigationController *)vc.viewControllers[3];
    return (HSGHMessageVC *)nav.viewControllers.firstObject;
}


- (NSMutableArray *)getFriendListDataBy:(NSArray *)array {
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    if (array.count > 0) {//得到fullName的拼音
        for (HSGHFriendSingleModel *user in array) {
            user.fullNamePY = [user.fullName pinyinForSort:YES];
        }
    }
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(HSGHFriendSingleModel *obj1, HSGHFriendSingleModel* obj2) {// 排序
        int i;
        NSString *strA = obj1.fullNamePY;
        NSString *strB = obj2.fullNamePY;
        
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;          // 上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;         // 下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    
    NSMutableSet *mSet = [NSMutableSet set];
    for (HSGHFriendSingleModel *user in serializeArray) {
        NSString *tmpStr = user.fullNamePY;
        char c = [tmpStr characterAtIndex:0];
        [mSet addObject:[[tmpStr substringToIndex:1] uppercaseString]];
        if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    
    NSArray *searray = [mSet allObjects];
    _friendSectionIndexArray = [searray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    
    return ans;
}
@end

@implementation HSGHNotificationMessage

@end
