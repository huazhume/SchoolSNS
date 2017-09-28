/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "HSGHSanboxFile.h"
#import "HSGHTools.h"
#import "HSGHUserInf.h"

#import "HSGHNetworkTest.h"
#import "JPUSHService.h"
#import "SchoolSNS-Swift.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

#import "HSGHAutoSendModel.h"
#import "HSGHFriendViewModel.h"
#import "HSGHIndicatorView.h"
#import "HSGHMessageModel.h"
#import "HSGHMessageViewController.h"
#import "HSGHNetworkSession.h"
#import "HSGHPublishViewModel.h"
#import "HSGHRealmManager.h"
#import "HSGHUserInf.h"
#import "JDStatusBarNotification.h"
#import "NSObject+LBLaunchImage.h"
#import "SVProgressHUD.h"
#import "UMMobClick/MobClick.h"
#import <UMSocialCore/UMSocialCore.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DWSRecordManager.h"

@interface AppDelegate () <JPUSHRegisterDelegate> {
  HSGHIndicatorView *_activityIndicator;
  ViewController *_tabViewController;
    UIView * _launchScreenView;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self doSomethingBeforeShow:launchOptions];
  [self showWindow];
  [self doSomethingAfterShow:launchOptions];
  [self initData];
  [self indicatorLoading];
    
#ifdef DWSRocordScreen
    [[DWSRecordManager shareInstance] start];
#endif
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  //去掉badge
//   UINavigationController* currentNav = [self fetchCurrentNav];
//    if (currentNav) {
//        currentNav.navigationBar.frame = CGRectMake(0,9, HSGH_SCREEN_WIDTH, 44);
//    }
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    UINavigationController* currentNav = [self fetchCurrentNav];
    if (currentNav) {
        currentNav.navigationBar.frame = CGRectMake(0,9, HSGH_SCREEN_WIDTH, 44);
    }
    
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  //将jpush的count清0

  [JPUSHService setBadge:0];
  // Message Count
  //    [HSGHMessageModel refreshRedCount];
  // Save school info
  [HSGHFetchUniv fetch:@"" isAll:YES isHighSchool:NO block:nil];
  // Refresh userinfos settings
  [HSGHLoginNetRequest getUserSettings:nil];
  [HSGHLoginNetRequest getUserInfo:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - Register DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  [self dealNotificationData:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - didFinshedLaunching

- (void)doSomethingBeforeShow:(NSDictionary *)launchOptions {
  // LoadingImage
//  [self addLauncherImage];
  // No backup to iCloud
  NSString *documentPath = [HSGHSanboxFile getDocumentPath];
  documentPath =
      [documentPath stringByAddingPercentEncodingWithAllowedCharacters:
                        [NSCharacterSet URLQueryAllowedCharacterSet]];
  [HSGHTools
      addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:documentPath]];

  // Statistics

  // Share

  // Toast style
    ToastView.appearance.font = [UIFont systemFontOfSize:16.f];
    ToastView.appearance.bottomOffsetPortrait = 100;
}

- (void)doSomethingAfterShow:(NSDictionary *)launchOptions {
// JPush
#if TARGET_OS_IPHONE
  [self setupJPush:launchOptions];
#endif
  // UMeng
  [self UMengConfig];
  [self UMengSocail];
    
  //google map
  [self googleMapConfig];
    
  // SVProgressHUD
  [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //检测app版本更新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self checkAppStoreVersion];
    });
}

#pragma mark - 检测app版本更新

- (void)checkAppStoreVersion {
    NSString *appStoreVersion;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1253823998"];
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    if (jsonResponseString!=nil) {
        //HSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
        NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = json[@"results"];
        for (NSDictionary *dic in array) {
            appStoreVersion = [dic valueForKey:@"version"];
        }
        
        NSString *key = @"CFBundleShortVersionString";
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
        //HSLog(@"---版本检测---appStoreVersion=%@, currentVersion=%@",appStoreVersion,currentVersion);
        
        if ([appStoreVersion compare:currentVersion] > 0) {//要去更新
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *msg = [NSString stringWithFormat:@"发现新版本v%@，请前往更新",appStoreVersion];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:nil  otherButtonTitles:@"前往更新",nil];
                [alertView show];
            });
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        NSString *url =@"https://itunes.apple.com/cn/app/%E9%AA%9E%E9%AA%9E/id1253823998?mt=8&uo=4";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark  检测app版本更新

- (void)initData {
}

#pragma mark - loading image
- (void)addLauncherImage {
  [NSObject makeLBLaunchImageAdView:^(LBLaunchImageAdView *imgAdView) {
    imgAdView.getLBlaunchImageAdViewType(LogoAdType);
    imgAdView.imgUrl = @"http://www.uisheji.com/wp-content/uploads/2013/04/19/"
                       @"app-design-uisheji-ui-icon20121_55.jpg";
    imgAdView.skipBtn.backgroundColor = [UIColor blackColor];
    imgAdView.clickBlock = ^(clickType type) {
      switch (type) {
      case clickAdType: {
      } break;
      case skipAdType:

        break;
      case overtimeAdType:

        break;
      default:
        break;
      }
    };

  }];
}

#pragma mark - change login status

- (void)showWindow {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  if (![HSGHUserInf shareManager].logined) {
    [self enterLogin];
  } else {
    if ([HSGHUserInf hasCompletedInfo]) {
        
      [self enterMainUI2];
    } else {
        
      [self enterCompleteInfo];
    }
  }
}
//未登录
- (void)enterMainUI {
  UIStoryboard *storyBoard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ViewController *viewController =
      [storyBoard instantiateViewControllerWithIdentifier:@"MainVC"];
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
  _tabViewController = viewController;
  [self jPushResetAlias];
  [self createDB];
}
//已登陆
- (void)enterMainUI2 {
    UIStoryboard *storyBoard =
    [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    self.window.rootViewController = viewController;
    [self makeLanunchScreen];
    _tabViewController = viewController;
    [self jPushResetAlias];
    [self createDB];
}

- (void)makeLanunchScreen {
    _launchScreenView =  [[[NSBundle mainBundle]loadNibNamed:@"LaunchScreen" owner:self options:nil]lastObject];
    _launchScreenView.frame = CGRectMake(0, 0,HSGH_SCREEN_WIDTH , HSGH_SCREEN_HEIGHT );
    UIButton * judgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [judgeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [judgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    judgeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    judgeBtn.frame = CGRectMake(HSGH_SCREEN_WIDTH - 60, 20, 40, 20);
    [judgeBtn addTarget:self action:@selector(judgeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    judgeBtn.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:0.5];
    
    [self.window addSubview:_launchScreenView];
    UIImageView * view = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_launchScreenView addSubview:view];
    [_launchScreenView addSubview:judgeBtn];
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"launchScreen_%d",arc4random_uniform(20)]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window bringSubviewToFront:_launchScreenView];
    [UIView animateWithDuration:3 animations:^{
        view.bounds = CGRectMake(0,0,HSGH_SCREEN_WIDTH*1.001 , HSGH_SCREEN_HEIGHT*1.001) ;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_launchScreenView removeFromSuperview];
    }];
}
- (void)judgeBtnClicked:(UIButton *)button {
    if (_launchScreenView) {
        [_launchScreenView removeFromSuperview];
    }
}


- (void)enterLogin {
    
  UIStoryboard *storyBoard =
      [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
  ViewController *viewController =
      [storyBoard instantiateViewControllerWithIdentifier:@"LoginNav"];
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
}

- (void)enterCompleteInfo {

  UIStoryboard *storyBoard =
      [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
  ViewController *viewController =
      [storyBoard instantiateViewControllerWithIdentifier:@"completeInfo"];
  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:viewController];
  self.window.rootViewController = nav;
  [self.window makeKeyAndVisible];
}


- (void)enterCompleteSchool {
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    HSGHRegSchoolInfosVC *vc = (HSGHRegSchoolInfosVC *)[profileStoryBoard instantiateViewControllerWithIdentifier:@"RegSchoolInfo2"];
    vc.isEditingModel = true;
    vc.isFixesSchoolModel = true;
    UINavigationController* pushVC = [[UINavigationController alloc]initWithRootViewController:vc];
    UINavigationController* nav = [self fetchCurrentNav];
    [nav presentViewController:pushVC animated:YES completion:nil];
}


- (void)enterFixesCNName {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    HSGHRegNameVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"CompletedLast"];
    UINavigationController* nav = [self fetchCurrentNav];
    vc.isFixesCNName = true;
    UINavigationController* pushVC = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav presentViewController:pushVC animated:YES completion:nil];
}

#pragma mark - createDB

- (void)createDB {
  HSGHRealmManager *manager = [HSGHRealmManager sharedManager];
  [manager createRealmDB:[HSGHUserInf shareManager].userId];
}

#pragma mark - JPUSHRegisterDelegate

- (void)setupJPush:(NSDictionary *)launchOptions {
  JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
  entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge |
                 JPAuthorizationOptionSound;
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    // 可以添加自定义categories
    // NSSet<UNNotificationCategory *> *categories for iOS10 or later
    // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    [JPUSHService
        registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                            UIUserNotificationTypeSound |
                                            UIUserNotificationTypeAlert)
                                categories:nil];
  }
  [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
  [JPUSHService setupWithOption:launchOptions
                         appKey:@"b0d524b07fe452e3b845b426"
                        channel:@"AppStore"
#ifndef __OPTIMIZE__
               apsForProduction:false
#else
               apsForProduction:true
#endif
          advertisingIdentifier:nil];
}

- (void)jPushResetAlias {
  // JPush 如果用户切换，则会重设此alias
  if ([HSGHUserInf shareManager].userId &&
      [HSGHUserInf shareManager].userId.length > 0) {
    [JPUSHService setAlias:[HSGHUserInf shareManager].userId
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
  }
  // 注册通知
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(networkDidReceiveMessage:)
             name:kJPFNetworkDidReceiveMessageNotification
           object:nil];
}

// Public
- (void)clearPushAlias {
  [JPUSHService setAlias:@""
        callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                  object:self];
}

// Clear and do notification data
- (void)dealNotificationData:(NSDictionary *)userInfo {
  [JPUSHService handleRemoteNotification:userInfo];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  //    [UIApplication sharedApplication].applicationIconBadgeNumber ++;
}

// 接收到通知事件
- (void)networkDidReceiveMessage:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];

  [self dealNotificationData:userInfo];
  [self changeNoticationMsgWithUserInfo:userInfo];
  HSLog(@"__________%@", userInfo[@"content"]);
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
  HSLog(@"=== JPush rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags,
        alias);
}

// iOS 10 Support 在应用内收到消息,但不点击
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  //    NSDictionary* userInfo = notification.request.content.userInfo;
  //    if ([notification.request.trigger
  //    isKindOfClass:[UNPushNotificationTrigger class]]) {
  //        [self dealNotificationData:userInfo];
  //    }
  //    completionHandler(UNNotificationPresentationOptionBadge); //
  //    需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
  //    [self changeNoticationMsgWithUserInfo:userInfo];
}

- (void)changeNoticationMsgWithUserInfo:(NSDictionary *)info {
  NSDictionary *userInfo = info[@"extras"];
  NSString *content = info[@"content"]; //内容
  NSString *alertString = @"";
  NSInteger messageIndex = 0;
  HSLog(@"____%@", userInfo[@"category"]);
  ViewController *tabVc = (ViewController *)self.window.rootViewController;
  HSGHNotificationMessage *notifacationMsgModel = tabVc.messageMsgNumModel;
  HSGHNotificationMessage *notifacationFriendModel = tabVc.friendMsgNumModel;
  if (![userInfo[@"userId"]
          isEqualToString:[HSGHUserInf shareManager].userId]) {
    NSInteger sign = 0;
    if ([userInfo[@"category"] isEqualToString:@"qqian.up.qqian"]) {
      alertString = @"有人赞了你的新鲜事";
      notifacationMsgModel.thirdMsgNum++;
      [HSGHMessageModel newMessageRed];
        sign = 3;

    } else if ([userInfo[@"category"] isEqualToString:@"qqian.up.reply"]) {
      alertString = @"有人赞了你的评论";
      notifacationMsgModel.thirdMsgNum++;
      [HSGHMessageModel newMessageRed];
         sign = 3;

    } else if ([userInfo[@"category"] isEqualToString:@"qqian.reply.qqian"]) {
      alertString = @"有人在新鲜事中回复了你";
      notifacationMsgModel.firstMsgNum++;
      [HSGHMessageModel newMessageRed];
        sign = 1;

    } else if ([userInfo[@"category"] isEqualToString:@"qqian.reply.reply"]) {
      messageIndex = 0;
      alertString = @"有人在评论中回复了你";
         sign = 1;
      notifacationMsgModel.firstMsgNum++;
      [HSGHMessageModel newMessageRed];
    } else if ([userInfo[@"category"] isEqualToString:@"qqian.at.reply"]) {
      messageIndex = 1;
      alertString = @"有人在评论中@了你";
         sign = 2;

      [HSGHMessageModel newMessageRed];
      notifacationMsgModel.secondMsgNum++;
    } else if ([userInfo[@"category"] isEqualToString:@"qqian.at.qqian"]) {
      messageIndex = 1;
      alertString = @"有人在新鲜事中@了你";
         sign = 2;
      notifacationMsgModel.secondMsgNum++;
      [HSGHMessageModel newMessageRed];
    } else if ([userInfo[@"category"] isEqualToString:@"friend.apply.send"]) {
      alertString = @"有人向你发送了好友申请";
      notifacationFriendModel.secondMsgNum++;
      [HSGHFriendViewModel newMessageRed];
         sign = 5;

    } else if ([userInfo[@"category"] isEqualToString:@"friend.apply.agree"]) {
      alertString = @"有人同意了你的好友申请";
      notifacationFriendModel.firstMsgNum++;
      [HSGHFriendViewModel newMessageRed];
         sign = 4;

    } else {
      alertString = [NSString stringWithFormat:@"收"
                                               @"到一条新动态新动态"];
    }
    tabVc.friendMsgNumModel = notifacationFriendModel;
    tabVc.messageMsgNumModel = notifacationMsgModel;
    [JDStatusBarNotification showWithStatus:content
                               dismissAfter:1.5f
                                  styleName:JDStatusBarStyleDark];

    //改变消息数
      NSDictionary * userDic;
      userDic = @{@"sign":@(sign)};
      if(userDic != nil){
          [[NSNotificationCenter defaultCenter]
           postNotificationName:@"msg_refreshData"
           object:nil userInfo:userDic];
      }
  }
}
#pragma mark iOS 10 Support  在应用内或者应用外点击消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)())completionHandler {
  // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self dealNotificationData:userInfo];
    }
    completionHandler(); // 系统要求执行这个方法
    ViewController *tabVc = (ViewController *)self.window.rootViewController;
    NSString *category = userInfo[@"category"];
    if([category containsString:@"friend"]){//好友类
        [tabVc setSelectedIndex:1];
    }else if ([category containsString:@"qqian"]){//消息类
        [tabVc setSelectedIndex:3];
    }else{
        
    }
}

#pragma mark-- UMeng

- (void)UMengConfig {
  UMConfigInstance.appKey = @"591a4f5607fe65714e002142";
  UMConfigInstance.channelId = @"App Store";
  [MobClick startWithConfigure:
                UMConfigInstance]; //配置以上参数后调用此方法初始化SDK！
#ifndef __OPTIMIZE__
  [MobClick setLogEnabled:true];
#endif
}

/* 设置谷歌appkey */
- (void)googleMapConfig {
    [GMSPlacesClient provideAPIKey:@"AIzaSyAqzPZJaLhO0_0XNilSbzNiFuOiX4hsq84"];
    [GMSServices provideAPIKey:@"AIzaSyAqzPZJaLhO0_0XNilSbzNiFuOiX4hsq84"];
}

#pragma mark - UMengSocial
- (void)UMengSocail {
  /* 设置友盟appkey */
  [[UMSocialManager defaultManager]
      setUmSocialAppkey:@"591a4f5607fe65714e002142"];
  [self configUSharePlatforms];
}

- (void)configUSharePlatforms {
  /* 设置微信的appKey和appSecret */
  [[UMSocialManager defaultManager]
       setPlaform:UMSocialPlatformType_WechatSession
           appKey:@"wxe04c0d69127bea1a"
        appSecret:@"d40424bd30fbb9642e83b62f7fb4f516"
      redirectURL:@"http://mobile.umeng.com/social"];

  [[UMSocialManager defaultManager]
       setPlaform:UMSocialPlatformType_QQ
           appKey:@"1106230320" /*设置QQ平台的appID*/
        appSecret:@"GgVreSOEBciOtt62"
      redirectURL:@"http://mobile.umeng.com/social"];
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
  BOOL result =
      [[UMSocialManager defaultManager] handleOpenURL:url
                                    sourceApplication:sourceApplication
                                           annotation:annotation];
  if (!result) {
    // 其他如支付等SDK的回调
  }
  return result;
}

#pragma mark-- public actions

- (UINavigationController *)fetchCurrentNav {
  ViewController *vc = (ViewController *)(self.window.rootViewController);
    if ([vc isKindOfClass:[ViewController class]]) {
        return vc.selectedViewController;
    }
    else if([vc isKindOfClass:[UINavigationController class]]){
        return (UINavigationController *)vc;
    }
    else {
        return vc.navigationController;
    }
}

- (UIViewController *)fetchCurrentVC {
  return [self fetchCurrentNav].viewControllers.lastObject;
}

#pragma mark - indicator

- (void)indicatorLoading {
  _activityIndicator = [[[NSBundle mainBundle] loadNibNamed:@"HSGHIndicatorView"
                                                      owner:self
                                                    options:nil] lastObject];
  _activityIndicator.frame =
      CGRectMake(0, HSGH_NAVGATION_HEIGHT, HSGH_SCREEN_WIDTH,
                 HSGH_SCREEN_HEIGHT - HSGH_NAVGATION_HEIGHT); //只能设置中心，不能设置大小
  [self.window addSubview:_activityIndicator];
  [_activityIndicator.indicatorView stopAnimating];           // 结束旋转
  [_activityIndicator.indicatorView setHidesWhenStopped:YES]; //当旋转结束时隐藏
  _activityIndicator.hidden = YES;
}

- (void)indicatorShow {
  [self.window bringSubviewToFront:_activityIndicator];
  _activityIndicator.hidden = NO;
  [_activityIndicator.indicatorView startAnimating]; // 开始旋转
}

- (void)indicatorShowWithFull {
  [self.window bringSubviewToFront:_activityIndicator];
  _activityIndicator.top = 0;
  _activityIndicator.height = HSGH_SCREEN_HEIGHT;
  [self indicatorShow];
}

- (void)indicatorDismiss {
  _activityIndicator.hidden = YES;
  [_activityIndicator.indicatorView stopAnimating]; // 结束旋转

  // Restore
  _activityIndicator.top = HSGH_NAVGATION_HEIGHT;
  _activityIndicator.height = HSGH_SCREEN_HEIGHT - HSGH_NAVGATION_HEIGHT;
}

+ (AppDelegate *)instanceApplication {
  return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - UMSocial Shared

- (void)umSocialType:(UMSOCIAL_MODE)mode
           WithTitle:(NSString *)title
         description:(NSString *)description
            ImageUrl:(NSString *)imageUrl
              webUrl:(NSString *)webUrl
               image:(UIImage *)image {
  [_tabViewController umSocialType:mode
                         WithTitle:title
                       description:description
                          ImageUrl:imageUrl
                            webUrl:webUrl
                             image:image];
}

#pragma mark 测试 sanbox download
//
//  HSGHMediaFileManager * manager = [HSGHMediaFileManager sharedManager];
//
//
//  ///download
//  __block HSGHDownloadModel * downloadModel = [[HSGHDownloadModel alloc]init];
//  downloadModel.url = @"http://www.huaral.tech/images/long768x2469.jpeg";
//  downloadModel.targetPath = [[manager
//  getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
//  AndMediaType:FILE_IMAGE_TYPE] stringByAppendingPathComponent:@"video.m4v"];
//  NSLog(@"__downloadPath:__%@",downloadModel.targetPath);
//
//  HSGHDownloadManager * downloadManager = [HSGHDownloadManager
//  defaultDBManager];
//  [downloadManager downloadWithModel:downloadModel];
//
//  HSGHResumeManager * resumeManager = [downloadManager.resumeTasksArray
//  lastObject];
//  resumeManager.progressBlock = ^(){
//
////    NSLog(@"接收到数据：_____%lld",downloadModel.totalContentLength);
//  };
//#pragma mark 测试 realm
// HSGHStudentModel *model = [[HSGHStudentModel alloc] initWithValue:@{
//                                                                    @"name" :
//                                                                    @"huaral",
//                                                                    @"age" :
//                                                                    @"dasd"
//                                                                    }];
// HSGHRealmManager *manager =
//[HSGHRealmManager sharedManagerWithRealmDBName:@"huaral"];
//[manager insertRealmModel:@[ model ]];
//
////      //查询
// RLMResults *results = [HSGHStudentModel allObjectsInRealm:manager.realm];
// HSGHStudentModel *student = results[0];
// NSLog(@"____________________");
// NSLog(@"%@___%@", student.name, student.age);

@end
