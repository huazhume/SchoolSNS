//
//  HSGHFriendViewModel.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 27/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHFriendViewModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHRealmManager.h"
#import "HSGHFriendPoToVo.h"
#import "HSGHFriendVoToPo.h"
#import "PPBadgeView.h"
#import "HSGHUserInf.h"


@implementation HSGHFriendSingleModel

@end

@implementation HSGHFriendViewModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{ @"users" : [HSGHFriendSingleModel class] };
}
+ (void)fetchRemoveWithUrl:(NSString *)url Params:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock {
    [HSGHNetworkSession postReq:url
                   appendParams:params
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO);
                                  }
                              }
                          }];
}
//待他通过
+ (void)fetchSendedFriends:(void (^)(BOOL success, NSArray *array))fetchBlock {
  [HSGHNetworkSession postReq:HSGHHadSendedUsersURL
                 appendParams:nil
                  returnClass:[self class]
                        block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                NSString *errorDes) {
                          if (status == NetResSuccess) {
                            if (fetchBlock) {
                              fetchBlock(YES, obj.users);
                            }
                          } else {
                            if (fetchBlock) {
                              fetchBlock(NO, nil);
                            }
                          }

                        }];
}
//待我通过
+ (void)fetchReceivedFriends:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHadReceivedUsersURL
                   appendParams:nil
                    returnClass:[self class]
                          block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES, obj.users);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}
//推荐好友
+ (void)fetchRecommendedFriends:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHFriendGetRecommendUsersURL
                   appendParams:nil
                    returnClass:[self class]
                          block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES, obj.users);
                                      if(obj.users.count > 0){
                                          [self deleteDataWithType:FRIEND_CATE_SEARCH];
                                          [self saveData:obj.users WithType:FRIEND_CATE_SEARCH];
                                      }
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}

//全部好友
+ (void)fetchAllFriends:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHFriendGetFriendsURL
                   appendParams:nil
                    returnClass:[self class]
                          block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES, obj.users);
                                  }
                                  if(obj.users.count > 0){
                                      [self deleteDataWithType:FRIEND_CATE_SCHOLL];
                                      [self saveData:obj.users WithType:FRIEND_CATE_SCHOLL];
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}

//搜索好友
+ (void)SearchFriendsWithKeyWord:(NSString *)keyword :(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHSearchFriendsURL
                   appendParams:@{@"key":keyword}
                    returnClass:[self class]
                          block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES, obj.users);
                                     
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}

//添加好友
//通过新鲜事，只需要qqianID, 通过评论，同时需要qqianID 和 replyID
+ (void)addFriend:(NSString*)qqianID replyID:(NSString*)replyID block:(void(^)(BOOL success))fetchBlock {
     NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (qqianID && qqianID.length > 0) {
         dic[@"qqianId"] = qqianID;
    }
    if (replyID && replyID.length > 0) {
        dic[@"replyId"] = replyID;
    }
    [HSGHNetworkSession postReq:HSGHServerFriendApplyURL
                   appendParams:dic
                    returnClass:nil
                          block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO);
                                  }
                              }
                          }];
}

+ (NSString *)getFriendStateImageWithMode:(HSGH_FRIEND_MODE)mode {
    NSString * imageFileName = @"";
        switch (mode) {
            case FRIEND_NONE:
                imageFileName = FRIEND_NONE_IMAGE;
                break;
            case FRIEND_TO:
                imageFileName = FRIEND_TO_IMAGE;
                break;
            case FRIEND_FROM:
               imageFileName = FRIEND_FROM_IMAGE;
                break;
            case FRIEND_ALL:
                imageFileName = FRIEND_ALL_IMAGE;
                break;
            case FRIEND_UKNOW:
                imageFileName = FRIEND_NONE_IMAGE;
                break;
            case FRIEND_MODE_ONE:
                imageFileName = FRIEND_ALL_IMAGE;
                break;
            default:
                break;
        }
    return imageFileName;
}


+ (void)saveData:(NSArray<HSGHFriendSingleModel *> *)datas WithType:(FRINED_CATE_TYPE)mode {
    HSGHRealmManager *manager =  [HSGHRealmManager sharedManager];
    NSMutableArray * poArr = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(HSGHFriendSingleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HSGHFriendPo * po = [HSGHFriendVoToPo friendVoToPo:obj WithType:mode];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@ && userId = %@",@(mode),po.userId];
        RLMResults * re = [manager searchResultsWithClass:[HSGHFriendPo class] WithPredicate:pred];
        if(re.count == 0){
             [poArr addObject:[HSGHFriendVoToPo friendVoToPo:obj WithType:mode]];
        }
    }];
    [manager insertRealmModel:poArr];
}

+ (NSArray *)fetchDataWithType:(FRINED_CATE_TYPE)mode {
    HSGHRealmManager * manager = [HSGHRealmManager sharedManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@",@(mode)];
    RLMResults * results = [manager searchResultsWithClass:[HSGHFriendPo class] WithPredicate:pred];
    NSMutableArray * voArr = [NSMutableArray array];
    for(int i =0 ; i< results.count ; i ++){
        [voArr addObject:[HSGHFriendPoToVo friendPoToVo:results[i]]];
    }
    return voArr;
}


+ (void)deleteDataWithType:(FRINED_CATE_TYPE)mode {
    HSGHRealmManager * manager = [HSGHRealmManager sharedManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@",@(mode)];
    [manager deleteDataWithClass:[HSGHFriendPo class] WithPredicate:pred];
}

+ (void)deleteDataWithType:(FRINED_CATE_TYPE)mode WithModel:(HSGHFriendSingleModel *)model {
    HSGHRealmManager * manager = [HSGHRealmManager sharedManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@ && userId = %@",@(mode),model.userId];
    [manager deleteDataWithClass:[HSGHFriendPo class] WithPredicate:pred];
}



+ (void)agreeFriend:(NSString *)userID :(NSString*)qqianID replyID:(NSString*)replyID block:(void(^)(BOOL success))fetchBlock {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"friendId",nil];
    if (qqianID && qqianID.length > 0) {
        dic[@"qqianId"] = qqianID;
    }
    if (replyID && replyID.length > 0) {
        dic[@"replyId"] = replyID;
    }
    [HSGHNetworkSession postReq:HSGHServerFriendAgreeURL
                   appendParams:dic
                    returnClass:nil
                          block:^(HSGHFriendViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO);
                                  }
                              }
                          }];
}


+ (void)fetchAddBtnStateWithCurrentUserId:(NSString *)headerUserID WithOtherId:(NSString *)otherId WithQQianMode:(QQIAN_MODE)qqianMode FriendMode:(FRINED_CATE_MODE)friendMode WithMode:(NSNumber *)friendState WithBtn:(UIButton *)addBtn WithAddLabel:(UILabel *)label{
     HSGH_FRIEND_MODE FState = (HSGH_FRIEND_MODE)[friendState integerValue];
    if(qqianMode == QQIAN_HOME || qqianMode == QQIAN_MSG){
        if([headerUserID isEqualToString:@""]|| headerUserID == nil){
            addBtn.hidden = YES;
        }else{
            addBtn.hidden = NO;
        }
        if(FState == FRIEND_NONE || FState == FRIEND_FROM || FState == FRIEND_UKNOW){
            addBtn.userInteractionEnabled = YES;
            [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
        }else if (FState == FRIEND_SELF){
            addBtn.hidden = YES;
        }
        else {
            addBtn.userInteractionEnabled = NO;
            [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
        }
        
    }else if (qqianMode == QQIAN_FRIEND){ //如果在好友里
        if(friendMode == FRIEND_CATE_THIRD){
            if (FState == FRIEND_FROM){ //加我
                addBtn.hidden = NO;
                [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
                addBtn.userInteractionEnabled = YES;
            }else{
                addBtn.hidden = YES;
                
            }
        }else if (friendMode == FRIEND_CATE_THIRD){
            if( FState == FRIEND_TO){
                addBtn.hidden = NO;
                [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
                addBtn.userInteractionEnabled = YES;
            }else{
                addBtn.hidden = YES;
                
            }
        }else if (friendMode == FRIEND_CATE_SECOND){
            if(FState == FRIEND_MODE_ONE){
                addBtn.hidden = NO;
                [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
                addBtn.userInteractionEnabled = NO;
            }else{
                addBtn.hidden = YES;
            }
        }
        else{
            //其他
            if([headerUserID isEqualToString:@""]|| headerUserID == nil){
                addBtn.hidden = YES;
            }else{
                addBtn.hidden = NO;
            }
            if(FState == FRIEND_NONE || FState == FRIEND_FROM || FState == FRIEND_UKNOW){
                addBtn.userInteractionEnabled = YES;
                [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
            }else if (FState == FRIEND_SELF){
                addBtn.hidden = YES;
            }
            else  {
                addBtn.userInteractionEnabled = NO;
                [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:FState]] forState:UIControlStateNormal];
            }
        }
    }
    if(FState == FRIEND_TO){
        label.hidden = NO;
    }else{
        label.hidden = YES;
    }
    if( FState == FRIEND_ALL && friendMode != FRIEND_CATE_SECOND){
        addBtn.hidden = YES;
    }
    
    if([headerUserID isEqualToString:[HSGHUserInf shareManager].userId]){
        addBtn.hidden = YES;
    }
}

+ (void)fetchAddBtnIsUserInteractionEnabledWithUserId:(NSString *)userId WithMode:(NSNumber *)friendState WithBtn:(UIButton *)addBtn{
    HSGH_FRIEND_MODE mode = (HSGH_FRIEND_MODE)[friendState integerValue];
    if([userId isEqualToString:@""]|| userId == nil){
        addBtn.hidden = YES;
    }else{
        addBtn.hidden = NO;
    }
    if(mode == FRIEND_NONE || mode == FRIEND_FROM || mode == FRIEND_UKNOW){
        addBtn.userInteractionEnabled = YES;
        [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:mode]] forState:UIControlStateNormal];
    }else if (mode == FRIEND_SELF){
        addBtn.hidden = YES;
    }
    else  {
        addBtn.userInteractionEnabled = NO;
        [addBtn setImage:[UIImage imageNamed:[self getFriendStateImageWithMode:mode]] forState:UIControlStateNormal];
    }
   
}

+ (void)fetchFriendShipWithMode:(NSNumber *)friendState WithBtn:(UIButton *)addBtn WithUserID:(NSString *)userId WithQqianId:(NSString *)qqianId WithReplayId:(NSString *)replayId WithCallBack:(void(^)(BOOL success, UIImage *image))block WithAddLabel:(UILabel *)label{
    HSGH_FRIEND_MODE mode = (HSGH_FRIEND_MODE)[friendState integerValue];
    if(mode == FRIEND_NONE || mode == FRIEND_UKNOW){
        //先发送点赞 之后再处理事件
//        [self addFriend:qqianId replyID:replayId block:^(BOOL success) {
////             block(success,[UIImage imageNamed:[self getFriendStateImageWithMode:FRIEND_TO]]);
//        }];
         block(YES,[UIImage imageNamed:[self getFriendStateImageWithMode:FRIEND_TO]]);
        if(mode == FRIEND_NONE){
            label.hidden = NO;
            [HSGHFriendViewModel addFriend:qqianId replyID:replayId block:nil];
        }else{
            label.hidden = YES;
        }
        
    }else if(mode == FRIEND_FROM ){
        [self agreeFriend:userId :qqianId replyID:replayId block:^(BOOL success) {
          block(YES,[UIImage imageNamed:[self getFriendStateImageWithMode:FRIEND_ALL]]);
        }];
    }else{
        HSLog(@"状态不对哦");
    }
}


+ (void)refreshRedCountWithIsHidden:(BOOL )isHidden {
//    AppDelegate* delegate = [AppDelegate instanceApplication];
//    ViewController *vc = (ViewController *) (delegate.window.rootViewController);
//    if ( isHidden) {
//        [vc.tabBar.items[1] pp_addDotWithColor:nil];
//        [vc.tabBar.items[1] pp_moveBadgeWithX:0 Y:5];
//        
//    }
//    else {
//        [vc.tabBar.items[1] pp_hiddenBadge];
//    }
    
}
+ (void)newMessageRed {
//    AppDelegate* delegate = [AppDelegate instanceApplication];
//    ViewController *vc = (ViewController *) (delegate.window.rootViewController);
//    [vc.tabBar.items[1] pp_addDotWithColor:nil];
//    [vc.tabBar.items[1] pp_moveBadgeWithX:0 Y:5];
}


@end
