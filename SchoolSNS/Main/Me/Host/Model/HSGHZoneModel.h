//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//




#import "HSGHUserInf.h"
#import "HSGHHomeBaseView.h"


typedef void(^ReloadDataBlock)(NSIndexPath * indexpath);

@class HSGHHomeVoFrame;

@interface HSGHFriendModel : NSObject

@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, copy) NSString* fullName;
@property (nonatomic, copy) NSString* fullNameEn;
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, strong) HeadPicInfo *picture;
@property (nonatomic, strong) BachelorUniversity* unvi;
@property (nonatomic, copy) NSString* userId;

@end


@interface HSGHOtherUser : NSObject
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *fullNameEn;

@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *signature;

@property(nonatomic, strong) BachelorUniversity *unvi;
@property(nonatomic, strong) BachelorUniversity *bachelorUniv;
@property(nonatomic, strong) BachelorUniversity *masterUniv;
@property(nonatomic, strong) BachelorUniversity *highSchool;

@property(nonatomic, strong) HeadPicInfo *picture;
@property(nonatomic, strong) HeadPicInfo *backgroud;

@property(nonatomic, strong) NSString *homeCity;

@property(nonatomic, strong) NSString *homeCityAddress;

@property(nonatomic, strong) NSArray *friends;
@end

@interface HSGHZoneModel : NSObject

- (instancetype)initWithUserID:(NSString *)anUserID;
//All
//- (void)request:(NSString *)userID refreshAll: (BOOL)refreshAll block:(void (^)(BOOL status))fetchBlock;
- (void)requestForward:(NSString*)userID refreshAll: (BOOL)refreshAll block:(void (^)(BOOL status))fetchBlock;
- (void)requestMine:(NSString*)userID refreshAll: (BOOL)refreshAll block:(void (^)(BOOL status))fetchBlock;
- (void)requestPublicFriend:(NSString*)anotherUserID block:(void (^)(BOOL status))fetchBlock;
- (NSArray *)fetchData;

- (NSArray *)fetchForwardData;

- (NSArray *)fetchFriendData;

- (HSGHOtherUser*)fetchCurrentUser;
@property(nonatomic, strong) NSNumber *first;
@property(nonatomic, strong) NSNumber *last;
@property(nonatomic, strong) NSMutableArray *qqians;
@property(nonatomic, strong) NSMutableArray *qqiansForward;
@property(nonatomic, strong) NSMutableArray *friendUser;
@property(nonatomic, strong) HSGHOtherUser *user;
@property(nonatomic, assign) NSDate *friendAddTime;
@property(nonatomic, assign) NSUInteger from;

@property(nonatomic, assign) NSUInteger mineFrom;
@property(nonatomic, assign) NSUInteger forwardFrom;
@property(nonatomic, copy) ReloadDataBlock block;
@property(nonatomic, strong) NSArray<HSGHHomeVoFrame *> * datalist;

//more
- (void)qqianMoreWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath *)indexPath andIsSecond:(BOOL)isSecond ;
// up
- (void)qqianUpWithHomeType:(HOME_MODE)mode andIndex:(NSIndexPath *)indexPath andIsSecond:(BOOL)isSecond;

// comment forword
- (void)qqianCommentAndForwardWithHomeType:(HOME_MODE)mode andEdit:(EDIT_MODE)editMode andMainIndex:(NSIndexPath *)mainIndexPath andNomalIndex:(NSIndexPath *)nomalIndex andText:(NSString *)text andIsSecond:(BOOL)isSecond;
- (void)qqianRemoveHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath andIsSecond:(BOOL)isSecond;

+ (void)changeSingnature:(NSString *)sign block:(void (^)(BOOL status))fetchBlock;
+ (void)changeNickName:(NSString *)nickName block:(void (^)(BOOL status))fetchBlock;
- (BOOL) isFriend;
- (void)modifyAddFriendMeDataWithIndexPath:(NSIndexPath *)indexPath andIsSecond:(BOOL)isSecond;
//取消点赞
- (void)cancelQqianUpWithHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath andIsSecond:(BOOL)isSecond;

@end
