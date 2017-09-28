//
//  HSGHHomeViewModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeViewModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHRealmManager.h"
#import "HSGHHomePo.h"
#import "HSGHHomeVoToPo.h"
#import "HSGHUserInf.h"
#import "HSGHHomePoToVo.h"
#import "Reachability.h"
#import "HSGHLocationManager.h"

#import "HSGHUserInf.h"


@implementation HSGHHomeViewModel


+(HSGH_NetworkType_MODE)inspectNetwork
{
    HSGH_NetworkType_MODE networkType = HSGH_NONETWORK_MODE;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            networkType = HSGH_NONETWORK_MODE;
            //无网络
            break;
        case ReachableViaWWAN:
            networkType = HSGH_YESWAN_MODE;
            //3g网络
            break;
        case ReachableViaWiFi:
            networkType = HSGH_YESWIFT_MODE;
            //wifi网络
            break;
        default:
            break;
    }
    return networkType;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"qqians" : [HSGHHomeQQianModel class] };
}

+ (HSGHHomeQQianModelFrame *)commentQQianModel:(HSGHHomeQQianModel *)model WithText:(NSString *)text Mode :(EDIT_MODE)editMode{
    HSGHHomeQQianModel* qqiansVO = model;
    HSGHHomeReplay* replay = [HSGHHomeReplay new];
    HSGHHomeUserInfo * from = [HSGHHomeUserInfo new];
    HSGHHomeImage* creatorPicture = [HSGHHomeImage new];
    creatorPicture.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    HSGHHomeUniversity* uni = [HSGHHomeUniversity new];
    uni.iconUrl = [HSGHUserInf shareManager].bachelorUniv.iconUrl;
    uni.name = [HSGHUserInf shareManager].bachelorUniv.name;
    from.picture = creatorPicture;
    from.unvi = uni;
    from.displayName = [HSGHUserInf shareManager].nickName;
    from.userId = [HSGHUserInf shareManager].userId;
    replay.fromUser = from;
    replay.content = text;
    if (editMode == HOME_COMMENT_MODE) {
        //评论
        qqiansVO.replyCount = @([qqiansVO.replyCount integerValue] + 1);
    } else if (editMode == EDIT_FORWARD_MODE) {
        qqiansVO.forwardCount = @([qqiansVO.forwardCount integerValue] + 1);
    }
    NSMutableArray* replayArr = [NSMutableArray arrayWithArray:qqiansVO.partReplay];
    [replayArr insertObject:replay atIndex:0];
    
    qqiansVO.partReplay = [NSArray arrayWithArray:replayArr];
    HSGHHomeQQianModelFrame* voFrame = [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [voFrame setModel:qqiansVO];
    return voFrame;
}
+ (HSGHHomeQQianModelFrame *)upQQianModel:(HSGHHomeQQianModel *)model {
    HSGHHomeQQianModel* qqiansVO = model;
    qqiansVO.upCount = [NSNumber numberWithInteger:[qqiansVO.upCount integerValue] + 1];
    qqiansVO.up = @1;
    NSMutableArray* mutableArr = [NSMutableArray arrayWithArray:qqiansVO.partUp];
    //点赞成功 修改model
    HSGHHomeUp* modelup = [HSGHHomeUp new];
    HSGHHomeImage* image = [HSGHHomeImage new];
    image.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    modelup.picture = image;
    modelup.unvi.name = [HSGHUserInf shareManager].bachelorUniv.name;
    modelup.fullName =
    [NSString stringWithFormat:@"%@%@", [HSGHUserInf shareManager].firstName,
     [HSGHUserInf shareManager].lastName];
    modelup.userId = [HSGHUserInf shareManager].userId;
    [mutableArr insertObject:modelup atIndex:0];
    qqiansVO.partUp = [NSArray arrayWithArray:mutableArr];
    HSGHHomeQQianModelFrame* frame = [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [frame setModel:qqiansVO];
    return frame;
}

// 测试数据接口
+ (void)fetchTestModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeTestURL
                   appendParams:@{@"from":@0,@"size":@100,@"type":@3}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      //保存数据
                                      [self saveData:obj.qqians WithType:HOME_FIRST_MODE];
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
//                                      fetchBlock(YES , [self transToHomeViewFrameWithHomeModel:[self fetchDataWithType:HOME_FIRST_MODE]]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                          }];
}

// 首页数据
+ (void)fetchFistViewModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansURL
                   appendParams:@{@"from":@0,@"size":@10,@"type":@3}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}


//HSGHSearchQQiansURL
+ (void)fetchSearchQQiansModelArrWitQQiansID :(NSString *)qqiansId :(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHSearchQQiansURL
                   appendParams:@{@"idArray":@[qqiansId]}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}


// 首页数据分页
+ (void)fetchFistViewModelArrWithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansURL
                   appendParams:@{@"from": [NSNumber numberWithInteger:pageNumber * 10],@"size":@10,@"type":@3}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                      if(pageNumber == 0 && obj.qqians.count > 0){
                                          [self deleteDataWithType:HOME_FIRST_MODE];
                                          [self saveData:obj.qqians WithType:HOME_FIRST_MODE];
                                      }
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}

// 附近数据分页
+ (void)fetchSecondViewModelArrWithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock {
   
    HSGHLocationManager * sharedManager = [HSGHLocationManager sharedManager];
    
    while (YES) { //判断是否定到位了
        if(sharedManager.coordinate.longitude != -1 && sharedManager.coordinate.latitude != -1){
            HSLog(@"_____%lf____%lf",sharedManager.coordinate.longitude,sharedManager.coordinate.latitude);
            break;
        }
    }
    [HSGHNetworkSession postReq:HSGHHomeQQiansLocationURL
                   appendParams:@{@"from":[NSNumber numberWithInteger:pageNumber * 10],@"size":@10,@"latitude": @(sharedManager.coordinate.latitude),
                                  @"longitude": @(sharedManager.coordinate.longitude)}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                      if(pageNumber == 0 && obj.qqians.count > 0){
                                          [self deleteDataWithType:HOME_SECOND_MODE];
                                          [self saveData:obj.qqians WithType:HOME_SECOND_MODE];
                                      }
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];

}

// 附近数据
+ (void)fetchSecondViewModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansLocationURL
                   appendParams:@{@"from":@0,@"size":@10,@"latitude": @0,
                                  @"longitude": @0}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                          }];
}

//WithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock

// 全网分页数据
+ (void)fetchThirdViewModelArrWithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansRecomURL
                   appendParams:@{@"from":[NSNumber numberWithInteger:pageNumber * 10],@"size":@10}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                      if(pageNumber == 0 && obj.qqians.count > 0){
//                                          [self deleteDataWithType:HOME_THIRD_MODE];
//                                          [self saveData:obj.qqians WithType:HOME_THIRD_MODE];
                                      }
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                          }];
}
//全网数据
+ (void)fetchThirdViewModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansRecomURL
                   appendParams:@{@"from":@0,@"size":@10}
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}


//评论
+ (void)fetchCommentWithParams:(NSDictionary *)params :(void (^)(BOOL success, NSString * replayId))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansReplyURL
                   appendParams:params
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel  * obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES, obj.replyId);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO ,nil);
                                  }
                              }
                          }];
//    fetchBlock(YES);
}

//转发
+ (void)fetchForwardWithParams:(NSDictionary *)params :(void (^)(BOOL success,NSString * replayId ))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansForwardURL
                   appendParams:params
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel * obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,obj.replyId);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                          }];
}
//取消转发
+ (void)forwardCancelWithParams:(NSDictionary *)params :(void (^)(BOOL success,NSString * replayId ))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansForwardCancelURL
                   appendParams:params
                    returnClass:[self class]
                          block:^(HSGHHomeViewModel * obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,obj.replyId);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                          }];
    
}

//回复
+ (void)fetchReplayWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansReplyURL
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
//删除
+ (void)fetchRemoveWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansRemoveURL
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



+ (NSMutableArray *)transToHomeViewFrameWithHomeModel:(NSArray *)modelArr {
    NSMutableArray *muArr = [NSMutableArray array];
    [modelArr enumerateObjectsUsingBlock:^(HSGHHomeQQianModel *obj, NSUInteger idx,
                                           BOOL *_Nonnull stop) {
        HSGHHomeQQianModelFrame *modelF =
        [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
        modelF.model = obj;
        [muArr addObject:modelF];
    }];
    return muArr;
}



+ (void)saveData:(NSArray<HSGHHomeQQianModel *> *)datas WithType:(HOME_MODE)mode {
     HSGHRealmManager *manager =  [HSGHRealmManager sharedManager];
    NSMutableArray * poArr = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(HSGHHomeQQianModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [poArr addObject:[HSGHHomeVoToPo qqianVoToPo:obj WithType:mode]];
    }];
    [manager insertRealmModel:poArr];
    
}

+ (NSArray *)fetchDataWithType:(HOME_MODE)mode {
    HSGHRealmManager * manager = [HSGHRealmManager sharedManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@",@(mode)];
    RLMResults * results = [manager searchResultsWithClass:[HSGHHomeQQianPo class] WithPredicate:pred];
    NSMutableArray * voArr = [NSMutableArray array];
    for(int i =0 ; i< results.count ; i ++){
        [voArr addObject:[HSGHHomePoToVo qqianPoToVo:results[i]]];
    }
    return [self transToHomeViewFrameWithHomeModel:voArr];
}
+ (void)cancelUpQqians:(NSString *)userID :(NSString*)qqianID replyID:(NSString*)replyID block:(void(^)(BOOL success))fetchBlock {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"friendId",nil];
    if (qqianID && qqianID.length > 0) {
        dic[@"qqianId"] = qqianID;
    }
    if (replyID && replyID.length > 0) {
        dic[@"replyId"] = replyID;
    }
    [HSGHNetworkSession postReq:HSGHUpCancel
                   appendParams:dic
                    returnClass:nil
                          block:^(HSGHHomeViewModel *obj, NetResStatus status,
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

+ (void)deleteDataWithType:(HOME_MODE)mode {
    HSGHRealmManager * manager = [HSGHRealmManager sharedManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@",@(mode)];
    [manager deleteDataWithClass:[HSGHHomeQQianPo class] WithPredicate:pred];
    
}


@end
