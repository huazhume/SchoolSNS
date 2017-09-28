//
//  HSGHFriendViewModel.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 27/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModel.h"
#import "HSGHFriendBaseView.h"
#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"



typedef enum {
    FRIEND_CATE_SEARCH = 1001,
    FRIEND_CATE_SCHOLL,
    FRIEND_CATE_MEDAO,
    FRIEND_CATE_OTHERDAO,
     FRIEND_CATE_OTHER,
} FRINED_CATE_TYPE;



typedef enum {
    FRIEND_NONE = 0,
    FRIEND_SELF = 1,
    FRIEND_TO = 3, // 你想
    FRIEND_FROM = 4, //对方向你发送了好友请求
    FRIEND_ALL = 2,
    FRIEND_UKNOW = 5,//通过这个给你发送过
    FRIEND_MODE_ONE = 11,
    FRIEND_MODE_TWO = 12,
} HSGH_FRIEND_MODE;


@interface HSGHFriendSingleModel : NSObject

@property(nonatomic, strong) NSString *fullName;
@property(nonatomic, strong) NSString *fullNameEn;
@property(nonatomic, strong) NSString *nickName;
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, strong) NSString *fullNamePY;//对应的fullName的拼音，用于排序

@property(nonatomic, strong) HSGHHomeImage *picture;
@property(nonatomic, strong) HSGHHomeUniversity *unvi;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSNumber * status;
@property(nonatomic, strong) NSString *applyTime;
@property(nonatomic, assign) BOOL selected;//AT 被选中

@end

@interface HSGHFriendViewModel : NSObject

@property(nonatomic, strong) NSArray *users;

+ (void)fetchSendedFriends:(void (^)(BOOL success, NSArray *array))fetchBlock;
+ (void)fetchReceivedFriends:(void (^)(BOOL success, NSArray *array))fetchBlock;
+ (void)fetchRecommendedFriends:(void (^)(BOOL success, NSArray *array))fetchBlock;
+ (void)fetchAllFriends:(void (^)(BOOL success, NSArray *array))fetchBlock;
+ (void)SearchFriendsWithKeyWord:(NSString *)keyword :(void (^)(BOOL success, NSArray *array))fetchBlock;

+ (NSArray *)fetchDataWithType:(FRINED_CATE_TYPE)mode ;
//添加好友
//通过新鲜事，只需要qqianID, 通过评论，同时需要qqianID 和 replyID
+ (void)addFriend:(NSString*)qqianID replyID:(NSString*)replyID block:(void(^)(BOOL success))fetchBlock;
+ (NSString *)getFriendStateImageWithMode:(HSGH_FRIEND_MODE)mode ;
+ (void)fetchRemoveWithUrl:(NSString *)url Params:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock ;

+ (void)agreeFriend:(NSString *)userID :(NSString*)qqianID replyID:(NSString*)replyID block:(void(^)(BOOL success))fetchBlock;
+ (void)saveData:(NSArray<HSGHFriendSingleModel *> *)datas WithType:(FRINED_CATE_TYPE)mode;


//+ (void)fetchAddBtnIsUserInteractionEnabledWithUserId:(NSString *)userId WithMode:(NSNumber *)friendState WithBtn:(UIButton *)addBtn ;
+ (void)fetchAddBtnStateWithCurrentUserId:(NSString *)headerUserID WithOtherId:(NSString *)otherId WithQQianMode:(QQIAN_MODE)qqianMode FriendMode:(FRINED_CATE_MODE)friendMode WithMode:(NSNumber *)friendState WithBtn:(UIButton *)addBtn WithAddLabel:(UILabel *)label;

+ (void)fetchFriendShipWithMode:(NSNumber *)friendState WithBtn:(UIButton *)addBtn WithUserID:(NSString *)userId WithQqianId:(NSString *)qqianId WithReplayId:(NSString *)replayId WithCallBack:(void(^)(BOOL success, UIImage *image))block WithAddLabel:(UILabel *)label;

+ (void)refreshRedCountWithIsHidden:(BOOL )isHidden ;
+ (void)deleteDataWithType:(FRINED_CATE_TYPE)mode;
+ (void)newMessageRed;
@end
