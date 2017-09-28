//
//  HSGHPublishMsgVC.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHPublishMsgVC.h"
#import "AppDelegate.h"
#import "HSGHBaseNavigationViewController.h"
#import "HSGHHomeBaseView.h"
#import "HSGHHomeModel.h"
#import "HSGHHomeModelFrame.h"
#import "HSGHLaunchHideView.h"
#import "HSGHMediaFileManager.h"
#import "HSGHNetworkSession.h"
#import "HSGHPhotoPickerController.h"
#import "HSGHPublishViewModel.h"
#import "HSGHUploadPicNetRequest.h"
#import "HSGHUserDefalut.h"
#import "HSGHUserInf.h"
#import "SchoolSNS-Swift.h"
#import "ViewController.h"
#import "HSGHAutoSendModel.h"
#import "HSGHAtViewController.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "UIView+WebVideoCache.h"
//#import <GooglePlaces/GooglePlaces.h>

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <GooglePlaces/GooglePlaces.h>

#define MAX_LIMIT_NUMS 800

#define INIT_CONTENT_HEIGHT 200
#define ANONYBTN_TO_CONTENT_SPACE 20
#define SPACE 20
#define CELL_HEIGHT 50
#define Max_Image_height (kFit(500))

@interface HSGHPublishMsgVC () <YYTextViewDelegate, UIScrollViewDelegate> {
    
    NSString *imageKey;
    HSGHPOIInfo *poi;
    BOOL isAnonymous;
    HSGHHomeQQianModel *_qqianModel;
    NSData *_imageData;
    CGFloat _textViewHeight;
    CGFloat _keyboardHeight;
    HSGHLaunchHideView *hideView;
    NSArray *locationArray;
    NSTimer *timer;
}



@property (weak, nonatomic) IBOutlet UIView *textViewBgView;


@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *anonyButton;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeight;
@property(weak, nonatomic) IBOutlet UIButton *locationBtn;
@property(weak, nonatomic) IBOutlet UIView *anonymousView;
@property(weak, nonatomic) IBOutlet UIButton *anonyBtn;
@property (weak, nonatomic) IBOutlet UILabel *anonyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *anonyImg;
@property(assign, nonatomic) BOOL isChinese;
@property (weak, nonatomic) IBOutlet UIButton *atBtn;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *locationToBottom;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeight;

@property(strong, nonatomic) UIButton *choiceBtn;
@property(strong, nonatomic) UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *sumTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (nonatomic, assign) int currMaxTextLength;

// new
@end

@implementation HSGHPublishMsgVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_qqianModel.mediaType == 2 && self.contentImageView) {
        [self.contentImageView jp_playVideoHiddenStatusViewWithURL:[NSURL URLWithString:_qqianModel.image.srcUrl]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentImageView jp_stopPlay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView = [[YYTextView alloc]init];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = HEXRGBCOLOR(0x272727);
    //self.textView.textParser = [YYTextMatchBindingParser new];
    [self.textViewBgView addSubview:self.textView];
    self.textView.delegate = self;
    [self.textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_textViewBgView);
        make.top.mas_equalTo(_textViewBgView);
        make.bottom.mas_equalTo(_textViewBgView);
        make.right.mas_equalTo(_textViewBgView);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = RGBCOLOR(245, 245, 245);
    [self.atBtn addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.atBtn).offset(-1);
        make.left.equalTo(self.atBtn);
        make.right.equalTo(self.atBtn);
        make.height.equalTo(@1);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = line1.backgroundColor;
    [self.atBtn addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.atBtn);
        make.left.equalTo(self.atBtn);
        make.right.equalTo(self.atBtn);
        make.height.equalTo(@1);
    }];
    //默认中文
    if (_isLauncher) {
        _isChinese = YES;
        [HSGHUserInf updateDisplayMode:_isChinese];
        self.anonymSign.constant = 0;
        self.anonymousView.hidden = YES;
        [self loadBaseViews];
        
        if ([HSGHUserInf hasEngName]) {
            [self addChoiceiSChineseName];
        }
    } else {
        if ([[HSGHUserDefalut getAnonymtimes]integerValue] > 0){
            //可以发布
            self.anonymSign.constant = 50;
            self.anonymousView.hidden = NO;
            
            UIView *line3 = [UIView new];
            line3.backgroundColor = line1.backgroundColor;;
            [self.atBtn addSubview:line3];
            [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.atBtn).offset(45);
                make.left.equalTo(self.atBtn);
                make.right.equalTo(self.atBtn);
                make.height.equalTo(@1);
            }];
            
        }else{
            //不可以匿名
            self.anonymSign.constant = 0;
            self.anonymousView.hidden = YES;
            self.anonyLabel.hidden = YES;
            self.anonyImg.hidden = YES;
            self.anonyBtn.hidden = YES;
        }
        [self loadBaseViews];
    }
    
    if ([self.publishType intValue]==0) {
        self.currMaxTextLength = 250;
    } else {
        self.currMaxTextLength = 125;
    }
    self.sumTextLbl.text = [NSString stringWithFormat:@"/ %d",self.currMaxTextLength];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGaoDE:) name:kAMapSearchAPIPOISuccess object:nil];
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:120 target:self selector:@selector(locationPrepare) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer invalidate];
}

- (void)loadBaseViews {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self addNotificattionCenter];
    [self configBaseViews];
    [self loadData];
    [self setFrames];
    isAnonymous = YES;
}

- (void)addChoiceiSChineseName {
    [self.headerView addSubview:self.choiceBtn];
    if ([HSGHUserInf shareManager].displayNameMode == 1) {
        //中文
        _isChinese = YES;
        [_choiceBtn setTitle:@"显示英文名" forState:UIControlStateNormal];
        
    } else {
        //英文
        _isChinese = NO;
        [_choiceBtn setTitle:@"显示中文名" forState:UIControlStateNormal];
    }
    [_choiceBtn addTarget:self
                   action:@selector(choiceBtnClicked:)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)choiceBtnClicked:(UIButton *)btn {
    if (_isChinese) {
        _headerView.usernameLab.text = [HSGHUserInf shareManager].fullNameEn;
        [btn setTitle:@"显示中文名" forState:UIControlStateNormal];
    } else {
        _headerView.usernameLab.text = [HSGHUserInf shareManager].fullName;
        [btn setTitle:@"显示英文名" forState:UIControlStateNormal];
    }
    _isChinese = !_isChinese;
    [HSGHUserInf updateDisplayMode:_isChinese];
}

#pragma mark 提前定位
- (void)locationPrepare {
    if (![HSGHLocationManager sharedManager].isChina) {//国内高德
        [[HSGHLocationManager sharedManager] fetchPOIInfo:^(NSArray *array) {
            
        }];
    }else{//国外谷歌
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            NSMutableArray *array = [NSMutableArray array];
            for (GMSPlaceLikelihood *obj in likelihoodList.likelihoods) {
                GMSPlace *place = obj.place;
                HSGHPOIInfo *poi = [HSGHPOIInfo new];
                
                poi.name = place.name;
                poi.subName = place.formattedAddress;
                poi.subName = [poi.subName componentsSeparatedByString:@" "].firstObject;
                poi.latitude = place.coordinate.latitude;
                poi.longitude = place.coordinate.longitude;
                [array addObject:poi];
            }
            locationArray = [NSArray arrayWithArray:array];
        }];
    }
}

- (void)receiveGaoDE:(NSNotification *)not {
    NSDictionary *userInfo = not.userInfo;
    NSArray *array = userInfo[@"poiArr"];
    locationArray = array;
}

- (IBAction)Anonymouspublication:(id)sender {
    [((UIButton *)sender)
     setImage:[UIImage imageNamed:isAnonymous ? @"fb_icon_s" : @"fb_icon_gx_n"]
     forState:UIControlStateNormal];
    isAnonymous = !isAnonymous;
}

- (UIButton *)choiceBtn {
    if (!_choiceBtn) {
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _choiceBtn.frame =
        CGRectMake(HSGH_SCREEN_WIDTH / 2.0 + 19 + 5, 10 + 19, 72, 25);
        [_choiceBtn setBackgroundImage:[UIImage imageNamed:@"tshmk"]
                              forState:UIControlStateNormal];
        [_choiceBtn setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        _choiceBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _choiceBtn;
}

- (void)addNotificattionCenter {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillShowNotification
     object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(publishMsgNotifi)
     name:HSGH_PUBLISH_MSG_NOTIFI
     object:nil];
    
}

- (void)publishMsgNotifi {
    HSLog(@"---publishMsgNotifi---");
    
    if (!(_image != nil ||
          ([self removeSpaceAndNewline:_textView.text] != nil && ![[self removeSpaceAndNewline:_textView.text] isEqualToString:@""]))) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"内容为空"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return;
    }
    
    //字数长度检查
    int maxTextLength = 250;
    if (_image != nil) {
        maxTextLength = 125;
    }
    if (_textView.text.length > maxTextLength) {
        //Toast *toast = [[Toast alloc] initWithText:@"文字长度超过限制!" delay:0 duration:1.f];
        //[toast show];
        
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:[NSString stringWithFormat:@"文字长度超过限制(%zd字)",maxTextLength]
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return ;
    }
    
    //修改
    if (_isLauncher) {
        //            [HSGHUserInf updateDisplayMode:_isChinese];
    }
    
    
    //[[AppDelegate instanceApplication] indicatorShow];
    
    HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
    NSDictionary * locationDic = [NSDictionary dictionary];
    if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
        HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
        locationDic = @{@"longitude" : [NSNumber numberWithFloat:sharedManager.coordinate.longitude],@"latitude":[NSNumber numberWithFloat:sharedManager.coordinate.latitude]};
        
    }
    
    if (![HSGHUserInf shareManager].hasSendQianQian) {
        [HSGHUserInf shareManager].hasSendQianQian = YES;
        [[HSGHUserInf shareManager] saveUserDefault];
    }
    
    HSGHHomeQQianModel *publishModel = [self publishQQianModel];
    //发布 publishType=0 文字
    //    mediaType=2 视频    mediaType=1 图片
    NSString *content = [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView];
    //去除首尾空格和换行
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //三次换行屏蔽
    while ([content containsString:@"\n\n\n"]) {
        content = [content stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
    }
    if (!content) {
        content = @"";
    }
    
    if ([self.publishType integerValue] == 0) {
        if (content.length <= 0) {
            Toast *toast = [[Toast alloc] initWithText:@"无效文本，请重新输入" delay:0 duration:1.f];
            [toast show];
            return;
        }
        NSDictionary *params;
        
        if (poi == nil) {
            if(locationDic == nil){
                params = @{
                           @"content" : content,
                           @"type" : @0,
                           @"anonym" : @(!isAnonymous)
                           };
            }else{
                params = @{
                           @"content" : content,
                           @"type" : @0,
                           @"anonym" : @(!isAnonymous),
                           @"latLon" : locationDic
                           };
            }
            
        } else {
            params = @{
                       @"content" : content,
                       @"type" : @0,
                       @"latLon" : @{
                               @"address" : poi.name,
                               @"latitude" : [NSNumber numberWithDouble:poi.latitude],
                               @"longitude" : [NSNumber numberWithDouble:poi.longitude]
                               },
                       @"anonym" : @(!isAnonymous)
                       };
        }
        //纯文字
        HSLog(@"---发布---纯文字---");
//        [tabVC publishQQianMsgWithImageData:nil
//                                    isVideo: false
//                                  WithParms:params
//                                 WithUserID:publishModel.qqianId];
        
        
        [SVProgressHUD showWithStatus:@"上传中,请稍等"];
        [HSGHPublishViewModel fetchPublishWithParams: params:^(BOOL success , HSGHPublishViewModel * response) {
            [SVProgressHUD dismiss];
            if (success == YES) {
                //通知首页取数据
                [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_POST_2_HOME_FIRST_NOTIFI object:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self leftBarItemBtnClicked:nil];
                });
                
            } else {
                [SVProgressHUD showInfoWithStatus:@"上传失败"];
                HSLog(@"---发布失败文字---");
            }
        }];
        
        
    } else {
        NSDictionary *dic;
        if (poi == nil) {
            if(locationDic == nil){
                dic = @{
                        @"content" : content,
                        @"type" : @0,
                        @"mediaType" : _localVideoPath.length > 0 ? @"2" : @"1",
                        @"anonym" : @(!isAnonymous)
                        };
            }else{
                dic = @{
                        @"content" : content,
                        @"type" : @0,
                        @"mediaType" : _localVideoPath.length > 0 ? @"2" : @"1",
                        @"anonym" : @(!isAnonymous),
                        @"latLon" : locationDic
                        };
            }
            
            
        } else {
            
            dic = @{
                    @"content" : content,
                    @"type" : @0,
                    @"mediaType" : _localVideoPath.length > 0 ? @"2" : @"1",
                    @"latLon" : @{
                            @"address" : poi.name,
                            @"latitude" : [NSNumber numberWithDouble:poi.latitude],
                            @"longitude" : [NSNumber numberWithDouble:poi.longitude]
                            },
                    @"anonym" : @(!isAnonymous)
                    };
        }
        NSData* uploadData = _imageData;
        
        if (_localVideoPath.length > 0) {
            HSLog(@"---发布---视频---_localVideoPath=%@",_localVideoPath);
            uploadData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_localVideoPath]];
//            [tabVC publishQQianMsgWithVideoData:uploadData
//                                      imageData:_imageData
//                                      WithParms:dic
//                                     WithUserID:publishModel.qqianId];
            
            [SVProgressHUD showInfoWithStatus:@"后台上传中"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [HSGHPublishViewModel uploadVideoFile:uploadData imageData:_imageData block:^(BOOL success, NSString* key) {
                    if (success == YES) {
                        NSMutableDictionary* mud = [NSMutableDictionary dictionaryWithDictionary:dic];
                        [mud setObject:key forKey:@"imageKey"];
                        HSLog(@"----mud===%@",mud);
                        [HSGHPublishViewModel fetchPublishWithParams:mud:^(BOOL success, HSGHPublishViewModel* response) {
                            if (success == YES) {
                                [HSGHUploadPicNetRequest uploadAlbum:_imageData key:key block:nil];
                                
                                //通知首页取数据
                                [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_POST_2_HOME_FIRST_NOTIFI object:nil];
                                
                                Toast *toast = [[Toast alloc] initWithText:@"上传成功" delay:0 duration:1.f];
                                [toast show];
                                
                                //手动存SDImageCache
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    if (key.length > 0) {
                                        NSString *pubImageUrl = [NSString stringWithFormat:@"https://s3-ap-northeast-1.amazonaws.com/image.qiantest.com/qqian_thumb/%@.jpg",key];
                                        UIImage *pubImage = [UIImage imageWithData:_imageData];
                                        [[SDImageCache sharedImageCache] storeImage:pubImage forKey:pubImageUrl toDisk:YES];
                                    }
                                });
                                
                            } else {
                                HSLog(@"发布失败啦");
                                [SVProgressHUD showInfoWithStatus:@"上传失败"];
                            }
                            
                        }];
                        
                    } else {
                        [SVProgressHUD showInfoWithStatus:@"上传失败"];
                        HSLog(@"---发布---上传视频或图片失败---");
                    }
                }];//发布视频
            });
            
            [self leftBarItemBtnClicked:nil];
            
            
        } else {
            HSLog(@"---发布---图片---");
            
//            [tabVC publishQQianMsgWithImageData:uploadData
//                                        isVideo: false
//                                      WithParms:dic
//                                     WithUserID:publishModel.qqianId];
            
            
            [SVProgressHUD showWithStatus:@"上传中,请稍等"];
            [HSGHPublishViewModel uploadFile:uploadData isVideo:NO block:^(BOOL success, NSString* key) {
                if (success == YES) {
                    NSMutableDictionary* mud = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [mud setObject:key forKey:@"imageKey"];
                    
                    //手动存SDImageCache
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        if (key.length > 0) {
                            NSString *pubImageUrl = [NSString stringWithFormat:@"https://s3-ap-northeast-1.amazonaws.com/image.qiantest.com/qqian/%@.jpg",key];
                            UIImage *pubImage = [UIImage imageWithData:uploadData];
                            [[SDImageCache sharedImageCache] storeImage:pubImage forKey:pubImageUrl toDisk:YES];
                        }
                    });
                    
                    
                    [HSGHPublishViewModel fetchPublishWithParams:mud:^(BOOL success, HSGHPublishViewModel* response) {
                        [SVProgressHUD dismiss];
                        if (success == YES) {
                            //通知首页取数据
                            [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_POST_2_HOME_FIRST_NOTIFI object:nil];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self leftBarItemBtnClicked:nil];
                            });
                            
                        } else {
                            [SVProgressHUD showInfoWithStatus:@"上传失败"];
                            HSLog(@"---发布失败图片---");
                        }
                    }];
                    
                } else {
                    [SVProgressHUD showInfoWithStatus:@"上传失败"];
                    HSLog(@"---发布---上传图片失败---");
                }
            }];//发布图片
            
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_PUBLISH_MESSAGE
//                                                        object:nil userInfo:@{
//                                                                              @"model" : publishModel,
//                                                                              @"type" : @(HOME_FIRST_MODE)
//                                                                              }];
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random_uniform(8) + 2) * 10000000)),
//                   dispatch_get_main_queue(), ^{
//                       [[AppDelegate instanceApplication] indicatorDismiss];
//                       if (_isLauncher) {
//                           [HSGHUserInf shareManager].hasSendQianQian = true;
//                           [[HSGHUserInf shareManager] saveUserDefault];
//                           
//                           [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                           [[NSNotificationCenter defaultCenter] postNotificationName:HSGHAutoSendHeadIconNotification object:nil];
//                       } else {
//                           [self.navigationController popToRootViewControllerAnimated:YES];
//                       }
//                   });
}


//监听键盘 高度变化
- (void)keyboardChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    if (notification.name == UIKeyboardWillShowNotification) { //打开键盘
        _keyboardHeight = keyboardEndFrame.size.height;
        CGFloat contentHeight =
        HSGH_SCREEN_HEIGHT - 64 -
        keyboardEndFrame.size.height; //屏幕最大能给展示的文字输入框
        self.scrollContentHeight.constant =
        self.headerHeight.constant + self.contentHeight.constant +
        keyboardEndFrame.size.height + contentHeight;
//        self.contentTextViewHeight.constant = contentHeight;
        
        CGFloat offY = 0;
//        if (self.headerHeight.constant + self.contentHeight.constant > 150) {
            offY = self.headerHeight.constant + self.contentHeight.constant - 50;
//
//        }
        
        [UIView animateWithDuration:0.29
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(0, offY); //移动在最顶头
                             [self.view layoutIfNeeded];
                         }];
        
    } else {
        CGFloat contentHeight =
        [HSGHTools getTextViewHeightString:self.textView.text
                                      font:[UIFont systemFontOfSize:15]
                                     width:(HSGH_SCREEN_WIDTH)];
        CGFloat oldContentHeight =
        (HSGH_SCREEN_HEIGHT - 64 - CELL_HEIGHT - self.anonymSign.constant -
         2 * SPACE - self.headerHeight.constant);
        HSLog(@"%lf___%lf", contentHeight, oldContentHeight);
        if (contentHeight <
            ([self.publishType integerValue] != 0
             ? INIT_CONTENT_HEIGHT
             : oldContentHeight)) { // 如果输入内容小于初始的高度
                
                contentHeight = ([self.publishType integerValue] != 0)
                ? INIT_CONTENT_HEIGHT
                : oldContentHeight;
            } else {
                //加个20
            }
        self.scrollContentHeight.constant =
        self.headerHeight.constant + self.contentHeight.constant +
        contentHeight + 2 * SPACE + CELL_HEIGHT + self.anonymSign.constant + 70;
//        self.contentTextViewHeight.constant = contentHeight;
        [UIView animateWithDuration:0.29
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(0, 0);
                             [self.view layoutIfNeeded];
                         }];
    }
}

- (void)loadData {
    _qqianModel = [HSGHHomeQQianModel new];
    
    HSGHHomeImage *contentImage = [HSGHHomeImage new];
    if (_image != nil) {
        HSLog(@"---pub---image");
        contentImage.srcWidth = [NSNumber numberWithFloat:_image.size.width];
        contentImage.srcHeight = [NSNumber numberWithFloat:_image.size.height];
        
        HSGHMediaFileManager *manager = [HSGHMediaFileManager sharedManager];
        _imageData = UIImagePNGRepresentation(_image);
        NSString *file = [
                          [manager getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
                                                        AndMediaType:FILE_IMAGE_TYPE]
                          stringByAppendingPathComponent:[NSString
                                                          stringWithFormat:@"%dpub.png",
                                                          arc4random_uniform(
                                                                             1000) +
                                                          100]];
        [_imageData writeToFile:file atomically:YES];
        contentImage.srcUrl = file;
        contentImage.thumbUrl = file;
        
        
        self.contentImageView = [[UIImageView alloc] initWithImage:self.image];
        [self.contentView addSubview:self.contentImageView];
        
        CGFloat w = self.image.size.width;
        CGFloat h = self.image.size.height;
        CGFloat srwh = HSGH_SCREEN_WIDTH/Max_Image_height;
        CGFloat wh = w/h;
        
        if (wh > srwh) {//宽图
            h = 1.0 * MIN(w, HSGH_SCREEN_WIDTH) * h / w;
            self.contentHeight.constant = h;
            w = MIN(w, HSGH_SCREEN_WIDTH);
            [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.width.mas_equalTo(w);
                make.top.equalTo(self.contentView);
            }];
        }else{//长图
            w = 1.0 * MIN(h, Max_Image_height) * w / h;
            h = MIN(h, Max_Image_height);
            self.contentHeight.constant = h;
            [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.top.equalTo(self.contentView);
                make.width.mas_equalTo(w);
            }];
        }
        contentImage.srcWidth = [NSNumber numberWithFloat:w];
        contentImage.srcHeight = [NSNumber numberWithFloat:h];
    }
    
#ifdef OPEN_VIDEO
    if (UN_NIL_STR(_localVideoPath).length > 0) {
        HSLog(@"---pub---video");
        contentImage.srcUrl = _localVideoPath;
        _qqianModel.mediaType = 2; //video
//        [_contentView.image hiddenMute];
        
        NSURL *url = [NSURL URLWithString:_localVideoPath];
        [self.contentImageView jp_playVideoMutedHiddenStatusViewWithURL:url];
    }
#endif
    
    _qqianModel.creator = [self getMe];
    _qqianModel.image = contentImage;
    _qqianModel.isSelf = @1;
    
}

//点击匿名发布按钮
- (IBAction)anonyButtonClick:(UIButton*)btn {
    HSLog(@"---anonyButtonClick---");
    
    btn.selected = !btn.selected;
    
    isAnonymous = !isAnonymous;
    
    CGFloat contentHeight;
    if (isAnonymous) {
        _qqianModel.creator = [self getMe];
        //匿名的话
        contentHeight = self.scrollContentHeight.constant + 40;
        self.anonyImg.image = [UIImage imageNamed:@"fb_icon_gx_n"];
        self.anonyLabel.textColor = [UIColor lightGrayColor];
    } else {
        contentHeight = self.scrollContentHeight.constant - 40;
        _qqianModel.creator = [self getAninoUser];
        self.anonyImg.image = [UIImage imageNamed:@"fb_icon_s"];
        self.anonyLabel.textColor = [UIColor blackColor];
    }
    if (contentHeight < HSGH_SCREEN_HEIGHT - 64) {
        //        self.contentTextViewHeight.constant = HSGH_SCREEN_HEIGHT- 64 -
        //        contentHeight +
        //        self.contentTextViewHeight.constant;
        contentHeight = HSGH_SCREEN_HEIGHT - 64;
    }
    HSGHHomeQQianModelFrame *modelFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_HOME];
    [modelFrame setModel:_qqianModel];
    [self.headerView setModelFrame:modelFrame];
    self.headerHeight.constant = modelFrame.headerHeight;
    self.headerView.addFriendButton.hidden = YES;
    self.headerView.leftBtn.hidden = YES;
    self.scrollContentHeight.constant = contentHeight;
    
    self.scrollView.contentOffset = CGPointZero;
}


- (void)setFrames {
    HSGHHomeQQianModelFrame *modelFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_HOME];
    [modelFrame setModel:_qqianModel];
    [self.headerView setModelFrame:modelFrame];
    
    //匿名按钮显示与隐藏
    [self.headerView bringSubviewToFront:self.anonyButton];
    if ([[HSGHUserDefalut getAnonymtimes] intValue]>0) {
        self.anonyButton.hidden = NO;
    } else {
        self.anonyButton.hidden = YES;
    }
    
    
  //  [self.contentView setModelFrame:modelFrame];
    
    self.headerView.leftBtn.hidden = YES;
    self.headerView.addFriendButton.hidden = YES;
    self.headerHeight.constant = modelFrame.headerHeight;
    modelFrame.contentHeight = self.contentHeight.constant;
    if([self.publishType integerValue] == 0){
        self.textView.placeholderText = @"说点什么吧...";
    }else{
        self.textView.placeholderText = @"请添加描述文字吧";
    }
    self.textView.scrollEnabled = YES;
    self.textView.returnKeyType = UIReturnKeyDefault;
    
    
    //设置右上角
    [self setRightButtonClickable:(modelFrame.contentHeight>0)? YES:NO];
    //图片和文字
    CGFloat contentHeight = modelFrame.headerHeight + modelFrame.contentHeight +
    INIT_CONTENT_HEIGHT + SPACE * 2 + self.anonymSign.constant + CELL_HEIGHT;
    if (contentHeight < HSGH_SCREEN_HEIGHT - 64) { //如果选择了一张小图 或者没有图片
        self.scrollContentHeight.constant = HSGH_SCREEN_HEIGHT - 64;
        //        self.contentTextViewHeight.constant =
        //        HSGH_SCREEN_HEIGHT - 64 - (self.anonymSign.constant + CELL_HEIGHT) -
        //        SPACE * 2 - self.headerHeight.constant - self.contentHeight.constant;
    } else { //选择了一张合适的图
        self.scrollContentHeight.constant = modelFrame.headerHeight +
        modelFrame.contentHeight +
        INIT_CONTENT_HEIGHT + SPACE * 2 +
        self.anonymSign.constant + CELL_HEIGHT + 70;
        //设置contentText的
        //        self.contentTextViewHeight.constant = INIT_CONTENT_HEIGHT;
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
#ifdef OPEN_VIDEO
//    if (UN_NIL_STR(_localVideoPath).length > 0 && _contentView.image.height > 0) {
//        //[_contentView.image.videoContainerView jp_playVideoHiddenStatusViewWithURL:[NSURL URLWithString:_localVideoPath]];
//    }
#endif
}

- (void)configBaseViews {
    [self addLeftNavigationBarBtnWithString:@"取消"];
    //[self addRightNavigationBarBtnWithString:@"发布"];
    [self addRightNavigationBarBtnWithString:@"下一步"];
    [self setRightButtonClickable:NO];
    [self.navigationItem.leftBarButtonItem
     setTintColor:[UIColor colorWithRed:39 / 255.0
                                  green:39 / 255.0
                                   blue:39 / 255.0
                                  alpha:1]];
    
    [self.navigationItem.rightBarButtonItem
     setTintColor:[UIColor colorWithRed:69 / 255.0
                                  green:130 / 255.0
                                   blue:216 / 255.0
                                  alpha:1]];
    self.textView.delegate = self;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(locationCellClicked)];
    [self.locationView addGestureRecognizer:ges];
    self.locationView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
//    UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc]
//                                    initWithTarget:self
//                                    action:@selector(anonymousCellClicked)];
//    [self.anonymousView addGestureRecognizer:ges2];
//    self.anonymousView.userInteractionEnabled = YES;
    self.title = @"发布新鲜事";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //        [self.textView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)anonymousCellClicked {
//    [self.anonyBtn
//     setImage:[UIImage imageNamed:isAnonymous ? @"fb_icon_s" : @"fb_icon_gx_n"]
//     forState:UIControlStateNormal];
//    isAnonymous = !isAnonymous;
//    
//    CGFloat contentHeight;
//    if (isAnonymous) {
//        _qqianModel.creator = [self getMe];
//        //匿名的话
//        contentHeight = self.scrollContentHeight.constant + 40;
//    } else {
//        contentHeight = self.scrollContentHeight.constant - 40;
//        _qqianModel.creator = [self getAninoUser];
//    }
//    if (contentHeight < HSGH_SCREEN_HEIGHT - 64) {
//        self.contentTextViewHeight.constant = HSGH_SCREEN_HEIGHT - 64 -
//        contentHeight +
//        self.contentTextViewHeight.constant;
//        contentHeight = HSGH_SCREEN_HEIGHT - 64;
//    }
//    HSGHHomeQQianModelFrame *modelFrame =
//    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
//                                              WithMode:QQIAN_HOME];
//    [modelFrame setModel:_qqianModel];
//    [self.headerView setModelFrame:modelFrame];
//    self.headerHeight.constant = modelFrame.headerHeight;
//    self.headerView.addFriendButton.hidden = YES;
//    self.headerView.leftBtn.hidden = YES;
//    self.scrollContentHeight.constant = contentHeight;
//}

- (void)locationCellClicked {
//    BOOL ischa = [HSGHLocationManager sharedManager].isChina;
//    if (!ischa) {//中国 用高德
//        HSGHLocationSelectionVC *vc = [HSGHLocationSelectionVC new];
//        __weak HSGHPublishMsgVC *weakSelf = self;
//        vc.selectedData = ^(HSGHPOIInfo *_Nullable poi2, BOOL isAllowed) {
//            
//            if (poi2==nil) {
//                poi.name = @"";
//                weakSelf.locationLab.text = @"所在位置";
//                
//            } else {
//                weakSelf.locationLab.text = poi2.name;
//                poi = poi2;
//                [weakSelf.locationBtn
//                 setImage:[[UIImage imageNamed:@"fb_wz_s2"]
//                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                 forState:UIControlStateNormal];
//            }
//            
//            HSLog(@"---weakSelf.locationLab.text=%@",weakSelf.locationLab.text);
//            
//            //内容为空
////            if (!(_image != nil ||
////                  ([self removeSpaceAndNewline:_textView.text] != nil && ![[self removeSpaceAndNewline:_textView.text] isEqualToString:@""]))) {
////                
////            } else {//内容不为空
////                [self rightBarItemBtnClicked:[[UIButton alloc] init]];
////            }
//        };
//        vc.setPosition = @"";
//        HSGHBaseNavigationViewController *nav =
//        [[HSGHBaseNavigationViewController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//        
//    } else {//外国用google
//        [[HSGHLocationManager sharedManager] postGooglePOIVC];
//        
//        __weak typeof(self) weakSelf = self;
//        [HSGHLocationManager sharedManager].googlePickPlaceCompleteBlock = ^(HSGHPOIInfo* poiInfo){
//            weakSelf.locationLab.text = poiInfo.name;
//            poi = poiInfo;
//            [weakSelf.locationBtn
//             setImage:[[UIImage imageNamed:@"fb_wz_s2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//             forState:UIControlStateNormal];
//        };
//    }
}


- (void)leftBarItemBtnClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [timer invalidate];
}

- (void)rightBarItemBtnClicked:(UIButton *)btn {
    if (self.textView.text.length > self.currMaxTextLength) {
        Toast *toast = [[Toast alloc] initWithText:@"输入字数长度超过限定字数" delay:0 duration:1.f];
        [toast show];
        return ;
    }
    
    
    HSLog(@"---rightBarItemBtnClicked---");
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    
    BOOL ischa = [HSGHLocationManager sharedManager].isChina;
    
    if (!ischa) {//中国 用高德
        HSGHLocationSelectionVC *vc = [HSGHLocationSelectionVC new];
        __weak HSGHPublishMsgVC *weakSelf = self;
        vc._dataArray = [NSMutableArray arrayWithArray:locationArray];
        vc._isChina = true;
        vc.selectedData = ^(HSGHPOIInfo *_Nullable poi2, BOOL isAllowed) {
            if (poi2==nil) {
                poi.name = @"";
                weakSelf.locationLab.text = @"所在位置";
                
            } else {
                weakSelf.locationLab.text = poi2.name;
                poi = poi2;
                [weakSelf.locationBtn
                 setImage:[[UIImage imageNamed:@"fb_wz_s2"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                 forState:UIControlStateNormal];
            }
        };
        vc.setPosition = @"";
        HSGHBaseNavigationViewController *nav =
        [[HSGHBaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else {//外国用google
    
        HSGHLocationSelectionVC *vc = [HSGHLocationSelectionVC new];
        //__weak HSGHPublishMsgVC *weakSelf = self;
        vc._dataArray = [NSMutableArray arrayWithArray:locationArray];
        vc._isChina = false;
        vc.setPosition = @"";
        vc.selectedData = ^(HSGHPOIInfo *_Nullable poi2, BOOL isAllowed) {
            if (poi2==nil) {
                poi.name = @"";
                weakSelf.locationLab.text = @"所在位置";
            } else {
                weakSelf.locationLab.text = poi2.name;
                poi = poi2;
                [weakSelf.locationBtn setImage:[[UIImage imageNamed:@"fb_wz_s2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
        };
        HSGHBaseNavigationViewController *nav = [[HSGHBaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)BF_rightBarItemBtnClicked_BF:(UIButton *)btn {
    
    if (!(_image != nil ||
          ([self removeSpaceAndNewline:_textView.text] != nil && ![[self removeSpaceAndNewline:_textView.text] isEqualToString:@""]))) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"内容为空"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return;
    }
    
    //字数长度检查
    int maxTextLength = 250;
    if (_image != nil) {
        maxTextLength = 125;
    }
    if (_textView.text.length > maxTextLength) {
        //Toast *toast = [[Toast alloc] initWithText:@"文字长度超过限制!" delay:0 duration:1.f];
        //[toast show];
        
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:[NSString stringWithFormat:@"文字长度超过限制(%zd字)",maxTextLength]
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return ;
    }
    
    //修改
    if (_isLauncher) {
        //            [HSGHUserInf updateDisplayMode:_isChinese];
    }
    
    HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
    NSDictionary * locationDic = [NSDictionary dictionary];
    if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
        HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
        locationDic = @{@"longitude" : [NSNumber numberWithFloat:sharedManager.coordinate.longitude],@"latitude":[NSNumber numberWithFloat:sharedManager.coordinate.latitude]};
        
    }
    HSGHHomeQQianModel *publishModel = [self publishQQianModel];
    ViewController *tabVC = (ViewController *)[AppDelegate instanceApplication]
    .window.rootViewController;
    btn.enabled = NO;
    if ([self.publishType integerValue] == 0) {
        NSDictionary *params;
        
        if (poi == nil) {
            if(locationDic == nil){
                params = @{
                           @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView],
                           @"type" : @0,
                           @"anonym" : @(!isAnonymous)
                           };
            }else{
                params = @{
                           @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView],
                           @"type" : @0,
                           @"anonym" : @(!isAnonymous),
                           @"latLon" : locationDic
                           };
            }
            
        } else {
            params = @{
                       @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView],
                       @"type" : @0,
                       @"latLon" : @{
                               @"address" : poi.name,
                               @"latitude" : [NSNumber numberWithDouble:poi.latitude],
                               @"longitude" : [NSNumber numberWithDouble:poi.longitude]
                               },
                       @"anonym" : @(!isAnonymous)
                       };
        }
        [tabVC publishQQianMsgWithImageData:nil
                                  isVideo: false
                                  WithParms:params
                                 WithUserID:publishModel.qqianId];
    } else {
        NSDictionary *dic;
        if (poi == nil) {
            if(locationDic == nil){
                dic = @{
                        @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView],
                        @"type" : @0,
                        @"mediaType" : _localVideoPath.length > 0 ? @"2" : @"1",
                        @"anonym" : @(!isAnonymous)
                        };
            }else{
                dic = @{
                           @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView],
                           @"type" : @0,
                           @"mediaType" : _localVideoPath.length > 0 ? @"2" : @"1",
                           @"anonym" : @(!isAnonymous),
                           @"latLon" : locationDic
                           };
            }

            
        } else {
            
            dic = @{
                    @"content" : [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView],
                    @"type" : @0,
                    @"mediaType" : _localVideoPath.length > 0 ? @"2" : @"1",
                    @"latLon" : @{
                            @"address" : poi.name,
                            @"latitude" : [NSNumber numberWithDouble:poi.latitude],
                            @"longitude" : [NSNumber numberWithDouble:poi.longitude]
                            },
                    @"anonym" : @(!isAnonymous)
                    };
        }
        NSData* uploadData = _imageData;
        if (_localVideoPath.length > 0) {
            uploadData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_localVideoPath]];
            [tabVC publishQQianMsgWithVideoData:uploadData
                                        imageData:_imageData
                                      WithParms:dic
                                     WithUserID:publishModel.qqianId];
        }
        else {
            [tabVC publishQQianMsgWithImageData:uploadData
                                        isVideo: false
                                      WithParms:dic
                                     WithUserID:publishModel.qqianId];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HSGH_PUBLISH_MESSAGE
     object:nil userInfo:@{
                @"model" : publishModel,
                @"type" : @(HOME_FIRST_MODE)
                }];
    [[AppDelegate instanceApplication] indicatorShow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random_uniform(8) + 2) * 10000000)),
       dispatch_get_main_queue(), ^{
           [[AppDelegate instanceApplication] indicatorDismiss];
           if (_isLauncher) {
               [HSGHUserInf shareManager].hasSendQianQian = true;
               [[HSGHUserInf shareManager] saveUserDefault];
               
               [self.navigationController dismissViewControllerAnimated:YES completion:nil];
               [[NSNotificationCenter defaultCenter] postNotificationName:HSGHAutoSendHeadIconNotification object:nil];
           } else {
               [self.navigationController popToRootViewControllerAnimated:YES];
           }
       });
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
//        [textView endEditing:YES];
//        return NO;
    }
    
    //取消输入框中的@监听
//    else if ([text isEqualToString:@"@"]){
//        HSGHAtViewController* atViewController = [HSGHAtViewController new];
//        atViewController.block = ^(BOOL isSuccess, HSGHFriendSingleModel* model) {
//            //Todo  must change when friends is ok.
//            if(isSuccess){
//                     [HSGHCommentsCallFriendViewModel addOneFriend:model.displayName userId:model.userId location:self.textView.selectedRange.location yyTextView:self.textView];
//            }else{
//                self.textView.text = [NSString stringWithFormat:@"%@@",self.textView.text];
//                
//            }
//        };
//        [self.navigationController pushViewController:atViewController animated:YES];
//        return NO;
//        
//    }
    
    else {
        NSString *comcatstr =
        [textView.text stringByReplacingCharactersInRange:range
                                               withString:text];
        
        NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
        
        if (caninputlen >= 0) {
            return YES;
        } else {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen <
            //0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0, MAX(len, 0)};
            
            if (rg.length > 0) {
                NSString *s = [text substringWithRange:rg];
                
                [textView
                 setText:[textView.text stringByReplacingCharactersInRange:range
                                                                withString:s]];
            }
            return NO;
        }
    }
    return YES;
    
}

- (void)textViewDidChange:(YYTextView *)textView{

    self.textLbl.text = [NSString stringWithFormat:@"%zd",textView.text.length];
    
    if (textView.text.length > self.currMaxTextLength) {
        self.textLbl.textColor = [UIColor redColor];
    } else {
        self.textLbl.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    }
    
    
    if ([_publishType intValue]==0) {
        if (textView.text.length>0) {
            [self setRightButtonClickable:YES];
        } else {
            [self setRightButtonClickable:NO];
        }
    }
    
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS) {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    
}

- (HSGHHomeUserInfo *)getAninoUser {
    HSGHHomeUserInfo *creator = [HSGHHomeUserInfo new];
    HSGHHomeImage *creatorPicture = [HSGHHomeImage new];
    creatorPicture.srcUrl = @"anoicon";
    creator.picture = creatorPicture;
    return creator;
}

- (HSGHHomeUserInfo *)getMe {
    HSGHHomeUserInfo *creator = [HSGHHomeUserInfo new];
    //    creator.userId = [HSGHUserInf shareManager].userId;
    creator.displayName = [[HSGHUserInf shareManager] nickName];
    creator.userId = [HSGHUserInf shareManager].userId;
    HSGHHomeImage *creatorPicture = [HSGHHomeImage new];
    creatorPicture.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    creatorPicture.thumbUrl = [HSGHUserInf shareManager].picture.thumbUrl;
    creator.picture = creatorPicture;
    HSGHHomeUniversity *uni = [HSGHHomeUniversity new];
    if([HSGHUserInf shareManager].bachelorUniv.city != 1 && (![[HSGHUserInf shareManager].bachelorUniv.name isEqualToString:@""] && [HSGHUserInf shareManager].bachelorUniv.name != nil)){
        uni.iconUrl = [HSGHUserInf shareManager].bachelorUniv.iconUrl;
        uni.name = [HSGHUserInf shareManager].bachelorUniv.name;
    }
    ////修改bug 发布新鲜事 获取不到 校名////
//    else if(([HSGHUserInf shareManager].masterUniv.name != nil && ![[HSGHUserInf shareManager].masterUniv.name isEqualToString:@""])
//            &&[HSGHUserInf shareManager].bachelorUniv.city != 1 ){
    else if(([HSGHUserInf shareManager].masterUniv.name != nil && ![[HSGHUserInf shareManager].masterUniv.name isEqualToString:@""])){
        //研究生
        uni.iconUrl = [HSGHUserInf shareManager].masterUniv.iconUrl;
        uni.name = [HSGHUserInf shareManager].masterUniv.name;
        
    }else if ([HSGHUserInf shareManager].highSchool.name !=nil && ![[HSGHUserInf shareManager].highSchool.name isEqualToString:@""]){
        uni.iconUrl = [HSGHUserInf shareManager].highSchool.iconUrl;
        uni.name = [HSGHUserInf shareManager].highSchool.name;
    }
    
    creator.unvi = uni;
    return creator;
}

- (HSGHHomeQQianModel *)publishQQianModel {
    // time
    if(isAnonymous){
        _qqianModel.creator.displayName = [[HSGHUserInf shareManager] nickName];
        _qqianModel.creator.userId = [HSGHUserInf shareManager].userId;
    }else{
        _qqianModel.creator.displayName = @"";
        _qqianModel.creator.userId = @"";
        
    }
    _qqianModel.createTime = [HSGHTools getUTCFormateLocalDate];
    _qqianModel.qqianId = [NSString
                           stringWithFormat:@"%@%d", @"qqianTest",
                           arc4random_uniform(100) * arc4random_uniform(100)];
    _qqianModel.content = [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_textView];
    HSGHHomeAddress *address = [HSGHHomeAddress new];
    address.address = poi.name;
    _qqianModel.address = address;
    _qqianModel.friendStatus = @1;
    return _qqianModel;
}

//默认发送一个东西
+ (void)sendSomethingNewWithImageData:(UIImage *)image WithImageKey:(NSString *)imageKey WithText:(NSString *)text {
    HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
    NSDictionary * poiParams = @{};
    //    if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1 && sharedManager.name != nil && ![sharedManager.name isEqualToString:@""]){
    //        poiParams =  @{
    //                       @"address" : sharedManager.name,
    //                       @"latitude" : [NSNumber numberWithDouble:sharedManager.coordinate.latitude],
    //                       @"longitude" : [NSNumber numberWithDouble:sharedManager.coordinate.longitude]
    //                       };
    //        NSLog(@"_____%lf____%lf____%@",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude,sharedManager.name);
    //    }
    NSDictionary * params = @{
                              @"content" : text,
                              @"type" : @0,
                              @"latLon" : poiParams,
                              @"anonym" : @(0)
                              };
    NSData * imageData;
    
    HSGHHomeQQianModel * qqianModel = [HSGHHomeQQianModel new];
    HSGHHomeUserInfo * creator = [HSGHHomeUserInfo new];
    creator.displayName = [[HSGHUserInf shareManager ]nickName];
    creator.userId = [HSGHUserInf shareManager].userId;
    qqianModel.creator = creator;
    qqianModel.createTime = [HSGHTools getUTCFormateLocalDate];
    qqianModel.qqianId = [NSString stringWithFormat:@"%@%d",@"qqianTest",arc4random_uniform(100)*arc4random_uniform(100)];
    qqianModel.content = text;
    HSGHHomeAddress * address = [HSGHHomeAddress new];
    address.address = sharedManager.name;
    //    qqianModel.address = address;
    qqianModel.friendStatus = @1;
    
    HSGHHomeImage* contentImage = [HSGHHomeImage new];
    //图片
    if (image != nil) {
        contentImage.srcWidth = [NSNumber numberWithFloat:image.size.width];
        contentImage.srcHeight = [NSNumber numberWithFloat:image.size.height];
        
        HSGHMediaFileManager* manager = [HSGHMediaFileManager sharedManager];
        imageData = UIImageJPEGRepresentation(image, 0.7);
        NSString* file = [[manager
                           getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
                           AndMediaType:FILE_IMAGE_TYPE] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dpub.png", arc4random_uniform(1000) + 100]];
        [imageData writeToFile:file atomically:YES];
        contentImage.srcUrl = file;
    }
    qqianModel.image = contentImage;
    ViewController* tabVC = (ViewController*)[AppDelegate instanceApplication].window.rootViewController;
    [tabVC publishQQianMsgWithImageKey:imageKey WithParms:params WithUserID:qqianModel.qqianId];
    [[NSNotificationCenter defaultCenter]
     
     postNotificationName:HSGH_PUBLISH_MESSAGE
     object:nil
     userInfo:@{ @"model" : qqianModel,
                 @"type" : @(HOME_FIRST_MODE) }];
}


- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

// @ 按钮点击
- (IBAction)ATButtonClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    HSGHAtViewController* atViewController = [HSGHAtViewController new];
    //AT 数组
    atViewController.blockArr = ^(BOOL isAt,NSArray *modelArr) {
        HSLog(@"---publish---AT---array---count=%zd",modelArr.count);
        //[weakSelf.textView updateATInfo:modelArr];
        if (!modelArr || !modelArr.count) {
            return ;
        }
        
        for (int i=0; i<modelArr.count; i++) {
            HSGHFriendSingleModel* model = modelArr[i];
            [HSGHCommentsCallFriendViewModel addOneFriend:model.displayName userId:model.userId location:_textView.selectedRange.location yyTextView:_textView];
        }
    };
    [weakSelf.navigationController pushViewController:atViewController animated:YES];
}


@end
