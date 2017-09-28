//
//  ViewController.h
//  Betterme
//
//  Created by len on 16/9/23.
//  Copyright © 2016年 len. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"

//#import "HSGHKeyBoardView.h"
@class HSGHKeyBoardView;
@class HSGHMessageVC;


typedef enum {
  TAB_CENTER_DISENABLE = 0,
  TAB_CENTER_ENABLE ,
}TAB_CENTER_MODE;


typedef enum {
    UMSOCIAL_QQ_MODE = 1001,
    UMSOCIAL_QQZONE_MODE,
    UMSOCIAL_WECHAT_MODE,
    UMSOCAIL_WECHAR_ZONG,
}UMSOCIAL_MODE;

@interface HSGHNotificationMessage : NSObject
@property (nonatomic ,assign)NSInteger firstMsgNum;
@property (nonatomic ,assign)NSInteger secondMsgNum;
@property (nonatomic ,assign)NSInteger thirdMsgNum;
@property (nonatomic ,assign)NSInteger forthMsgNum;
@end


@interface ViewController : UITabBarController

@property(nonatomic, strong) UIButton *centerItemBtn;
@property (nonatomic ,assign)BOOL isFullScreen;

//msg消息数
@property (nonatomic,strong) HSGHNotificationMessage *messageMsgNumModel;

@property (nonatomic,strong) HSGHNotificationMessage *friendMsgNumModel;


@property (nonatomic, strong) NSArray *allFriendArr;//当前用户的所有好友
@property (nonatomic, strong) NSArray *friendDataArray;//当前用户的所有好友(已处理过的分组数据)
@property (nonatomic, strong) NSArray *friendSectionIndexArray;// 好友拼音首字母列表
@property (nonatomic, strong) NSArray *friendThirdArr;//好友--加我
@property (nonatomic, strong) NSArray *messageArr;//消息--消息

@property (nonatomic ,strong)HSGHKeyBoardView * keyboardView;

- (void)setCenterEnable:(TAB_CENTER_MODE)mode ;
- (void)navgationAndTabisHidden:(BOOL)isHidden ;

- (void)umSocialType:(UMSOCIAL_MODE )mode WithTitle:(NSString *)title description:(NSString *)description ImageUrl:(NSString *)imageUrl webUrl:(NSString *)webUrl image:(UIImage *)image;

//Send Video
- (void)publishQQianMsgWithVideoData:(NSData*)VideoData imageData:(NSData*)imageData WithParms:(NSDictionary*)params WithUserID:(NSString *)userId;
- (void)publishQQianMsgWithImageData:(NSData *)imageData isVideo:(BOOL)isVideo WithParms:(NSDictionary *)params WithUserID:(NSString *)userId;
- (void)publishQQianMsgWithImageKey:(NSString*)imageKey WithParms:(NSDictionary*)params WithUserID:(NSString*)userId ;

- (UIImage *)getCellGraphicsBeginImageWithClass:(NSString *)className WithFrame:(HSGHHomeQQianModelFrame *)modelF;
- (void)praiseAnimation;



/**
 获取消息列表的VC

 @return 消息列表vc
 */
+ (HSGHMessageVC *)messageVC;
@end


