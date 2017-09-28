//
//  HSGHUserInf.h
//  HSGHNBC
//
//  Created by Qianqian li on 2017/2/14.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EducationStatus) {
    EducationHighSchool = 3,
    EducationBachelor = 2,
    EducationMaster = 1
};


@interface BachelorUniversity : NSObject<NSCoding>
@property(nonatomic, copy) NSString *iconUrl;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *univId;
@property(nonatomic, assign) NSInteger univStatus;
@property(nonatomic, assign) NSInteger educationalLevel;
@property(nonatomic, assign) NSInteger city;//1 中国   其他 国外
@property(nonatomic, strong) NSDate *univIn;
@property(nonatomic, strong) NSDate *univOut;
- (NSString*)convertToStartYear;
- (NSString*)convertToEndYear;
@end

@interface HeadPicInfo : NSObject<NSCoding>
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *srcHeight;
@property(nonatomic, copy) NSString *srcSize;
@property(nonatomic, copy) NSString *srcUrl;
@property(nonatomic, copy) NSString *srcWidth;
@property(nonatomic, copy) NSString *thumbHeight;
@property(nonatomic, copy) NSString *thumbSize;
@property(nonatomic, copy) NSString *thumbUrl;
@property(nonatomic, copy) NSString *thumbWidth;
@end

@interface HSGHUserInf : NSObject<NSCoding>
+ (HSGHUserInf *)shareManager;



- (BOOL)logined;



+ (void)saveFormNet:(HSGHUserInf*)inf;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *phoneCn;
@property(nonatomic, copy) NSString *phoneAbroad;
@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, strong) HeadPicInfo *backgroud;


@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *fullNameEn;

@property(nonatomic, copy) NSString *firstNameEn;
@property(nonatomic, copy) NSString *middleNameEn;
@property(nonatomic, copy) NSString *lastNameEn;

@property(nonatomic, strong) HeadPicInfo *picture;
@property(nonatomic, strong) BachelorUniversity *bachelorUniv;//本科
@property(nonatomic, strong) BachelorUniversity *masterUniv;//研究生
@property(nonatomic, strong) BachelorUniversity *highSchool;
@property(nonatomic, copy) NSString *homeCityId;
@property(nonatomic, copy) NSString *homeCity;  //Position
@property(nonatomic, assign) NSInteger sex;
@property(nonatomic, copy) NSString *signature;


@property(nonatomic, assign) NSInteger displayNameMode; //1 中文, 2 英文

@property(nonatomic, assign) BOOL showQQianStranger; //对陌生人开放新鲜事
@property(nonatomic, assign) BOOL showQQianAlumni;  //对校友隐身
@property(nonatomic, assign) BOOL showUniv;           //显示第一海外学历信息于新鲜事
@property(nonatomic, assign) BOOL searchByName;     //允许被实名搜索到

@property(nonatomic, assign) BOOL notifyReply;//评论提醒
@property(nonatomic, assign) BOOL notifyAt;//被@提醒
@property(nonatomic, assign) BOOL notifyUp;//点赞提醒
@property(nonatomic, assign) BOOL notifyApply;//被申请加好友
@property(nonatomic, assign) BOOL notifyAgree;//申请好友被通过

@property(nonatomic, assign) BOOL hasSendQianQian;//是否已经发过骞文，如果是登入进来，则为True, 如果是注册进来，则会false

@property(nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *renewal;


//For autoSend
@property(nonatomic, strong) UIImage *headIconImage;
@property(nonatomic, copy) NSString *headIconImageKey;
@property(nonatomic, copy) NSString *headBgImageKey;
@property(nonatomic, strong) UIImage *headBgImage;

+ (void)refreshSignature:(NSString*)signature;
+ (void)refreshPSD:(NSString*)password;
+ (void)emptyUserDefault;
- (void)saveUserDefault;
+ (BOOL)hasEngName;
+ (BOOL)hasCompletedInfo;
+ (void)saveUserSettings:(HSGHUserInf*)inf;

+ (void)updateDisplayMode:(BOOL)isCH;
+ (NSString*)fetchRealName;
+ (void)emptyEndYear:(BOOL)isRegular;

+ (BOOL)hasContainBoardSchool;
+ (BOOL)schoolInfosError;

@end
