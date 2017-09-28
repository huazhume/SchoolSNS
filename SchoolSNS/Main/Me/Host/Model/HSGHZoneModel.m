//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHZoneModel.h"
#import "HSGHFriendViewModel.h"
#import "HSGHHomeModelFrame.h"
#import "HSGHNetworkSession.h"
#import "HSGHUserInf.h"

@implementation HSGHFriendModel

@end

@interface HSGHOtherUser ()

@end

@implementation HSGHOtherUser

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{ @"friends" : [HSGHFriendModel class] };
}

@end

@interface HSGHZoneModel ()

@end

@implementation HSGHZoneModel {
@private
  bool isMine;
}

- (instancetype)initWithUserID:(NSString *)anUserID {
    self = [super init];
    if (self) {
        isMine = [HSGHZoneModel isMine:anUserID];
        _qqians = [NSMutableArray array];
        _qqiansForward = [NSMutableArray array];
        _friendUser = [NSMutableArray array];
    }
    
    return self;
}

- (NSMutableArray *)transWithArr:(NSArray *)arr {
    NSMutableArray *muArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(HSGHHomeQQianModel *obj, NSUInteger idx,
                                      BOOL *_Nonnull stop) {
        HSGHHomeQQianModelFrame *modelF =
        [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                                  WithMode:QQIAN_HOME];
        modelF.model = obj;
        [muArr addObject:modelF];
    }];
    return muArr;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"qqians" : [HSGHHomeQQianModel class] };
}

#pragma mark - public
- (BOOL)isFriend {
    if (_friendAddTime) {
        return true;
    }
    
    return false;
}
//没看到哪里用
- (void)requestPublicFriend:(NSString *)anotherUserID
                      block:(void (^)(BOOL status))fetchBlock {
    if (!anotherUserID) {
        if (fetchBlock) {
            fetchBlock(NO);
        }
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{ @"anotherUserId" : UN_NIL_STR(anotherUserID) };
    [HSGHNetworkSession
     postReq:HSGHZoneGetPublicFriends
     appendParams:params
     returnClass:[HSGHOtherUser class]
     block:^(HSGHOtherUser *obj, NetResStatus status,
             NSString *errorDes) {
         if (status == NetResSuccess) {
             [weakSelf.friendUser removeAllObjects];
             if (obj && obj.friends.count > 0) {
                 [weakSelf.friendUser addObjectsFromArray:obj.friends];
             }
         }
         
         if (fetchBlock) {
             fetchBlock(status == NetResSuccess);
         }
     }];
}

//没看到哪里用
- (void)request:(NSString *)userID
     refreshAll:(BOOL)refreshAll
          block:(void (^)(BOOL status))fetchBlock {
    if (refreshAll) {
        _from = 0;
    }
    if (!userID) {
        if (fetchBlock) {
            fetchBlock(NO);
        }
        return;
    }
    
    NSDictionary *params = @{
                             @"from" : @(_from),
                             @"size" : @(HSGH_PAGE_SIZE),
                             @"type" : @(0),
                             @"userId" : userID
                             };
    [HSGHNetworkSession
     postReq:HSGHHomeQQiansPersonURL
     appendParams:params
     returnClass:[self class]
     block:^(HSGHZoneModel *obj, NetResStatus status,
             NSString *errorDes) {
         if (status == NetResSuccess) {
             if (refreshAll) {
                 [_qqians removeAllObjects];
                 [_qqiansForward removeAllObjects];
             }
             
             if (obj.user) {
                 _user = obj.user;
                 _friendAddTime = obj.friendAddTime;
             }
             
             NSMutableArray *mineData = [NSMutableArray new];
             NSMutableArray *data = [NSMutableArray new];
             [obj.qqians enumerateObjectsUsingBlock:^(
                                                      HSGHHomeQQianModel *qqianVO, NSUInteger idx,
                                                      BOOL *_Nonnull stop) {
                 if (qqianVO.forward.integerValue == 0) {
                     [mineData addObject:qqianVO];
                 } else {
                     [data addObject:qqianVO];
                 }
                 
             }];
             
             if (mineData.count > 0) {
                 [_qqians
                  addObjectsFromArray:
                  [self
                   transWithArr:[NSArray arrayWithArray:mineData]]];
             }
             
             if (mineData.count > 0) {
                 [_qqiansForward
                  addObjectsFromArray:
                  [self transWithArr:[NSArray arrayWithArray:data]]];
             }
             
             _from += HSGH_PAGE_SIZE;
         }
         
         if (fetchBlock) {
             fetchBlock(status == NetResSuccess);
         }
         
     }];
}

+ (BOOL)isMine:(NSString *)userID {
    return [userID isEqualToString:[HSGHUserInf shareManager].userId];
}

- (NSArray *)fetchData {
    return _qqians;
}

- (NSArray *)fetchForwardData {
    return _qqiansForward;
}

- (NSArray *)fetchFriendData {
    return _friendUser;
}

- (HSGHOtherUser *)fetchCurrentUser {
    return _user;
}

//废弃
+ (void)changeSingnature:(NSString *)sign
                   block:(void (^)(BOOL status))fetchBlock {
    if (sign == nil) {
        return;
    }
    [HSGHNetworkSession postReq:HSGHHomeModifySignURL
                   appendParams:@{
                                  @"sign" : sign
                                  }
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  [HSGHUserInf shareManager].signature = sign;
                                  [[HSGHUserInf shareManager] saveUserDefault];
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}

+ (void)changeNickName:(NSString *)nickName
                 block:(void (^)(BOOL status))fetchBlock {
    if (nickName == nil) {
        return;
    }
    // Todo
    if (fetchBlock) {
        fetchBlock(true);
        return;
    }
    
    [HSGHNetworkSession postReq:HSGHHomeModifySignURL
                   appendParams:@{
                                  @"nickName" : nickName
                                  }
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  [HSGHUserInf shareManager].nickName = nickName;
                                  [[HSGHUserInf shareManager] saveUserDefault];
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}

// more
- (void)qqianMoreWithHomeType:(HOME_MODE)mode
                     andIndex:(NSIndexPath *)indexPath
                  andIsSecond:(BOOL)isSecond {
    _datalist = isSecond ? [self fetchForwardData] : [self fetchData];
    HSGHHomeQQianModelFrame *Frame =
    (HSGHHomeQQianModelFrame *)_datalist[indexPath.row];
    HSGHHomeQQianModel *qqiansVO = Frame.model;
    qqiansVO.contentIsMore = @(![qqiansVO.contentIsMore integerValue]);
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_HOME];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    
    if (isSecond) {
        _qqiansForward = [NSMutableArray arrayWithArray:arr];
    } else {
        _qqians = [NSMutableArray arrayWithArray:arr];
    }
    if (self.block) {
        self.block(indexPath);
    }
}

// up
- (void)qqianUpWithHomeType:(HOME_MODE)mode
                   andIndex:(NSIndexPath *)indexPath
                andIsSecond:(BOOL)isSecond {
    _datalist = isSecond ? [self fetchForwardData] : [self fetchData];
    HSGHHomeQQianModel *qqiansVO =
    ((HSGHHomeQQianModelFrame *)_datalist[indexPath.row]).model;
    qqiansVO.upCount =
    [NSNumber numberWithInteger:[qqiansVO.upCount integerValue] + 1];
    qqiansVO.up = @1;
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:qqiansVO.partUp];
    //点赞成功 修改model
    HSGHHomeUp *modelup = [HSGHHomeUp new];
    HSGHHomeImage *image = [HSGHHomeImage new];
    image.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
    modelup.picture = image;
    modelup.unvi.name = [HSGHUserInf shareManager].bachelorUniv.name;
    modelup.fullName =
    [NSString stringWithFormat:@"%@%@", [HSGHUserInf shareManager].firstName,
     [HSGHUserInf shareManager].lastName];
    modelup.userId = [HSGHUserInf shareManager].userId;
    [mutableArr insertObject:modelup atIndex:0];
    qqiansVO.partUp = [NSArray arrayWithArray:mutableArr];
    HSGHHomeQQianModelFrame *frame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_HOME];
    [frame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:frame];
    if (isSecond) {
        _qqiansForward = [NSMutableArray arrayWithArray:arr];
    } else {
        _qqians = [NSMutableArray arrayWithArray:arr];
    }
    if (self.block) {
        self.block(indexPath);
    }
}

//取消点赞
- (void)cancelQqianUpWithHomeType:(HOME_MODE)mode andIndexPath:(NSIndexPath *)indexPath andIsSecond:(BOOL)isSecond {
    NSArray * datalist = [NSArray arrayWithArray:isSecond ? [self fetchForwardData] : [self fetchData]];
    HSGHHomeQQianModel *model =
    ((HSGHHomeQQianModelFrame *)datalist[indexPath.row]).model;
    HSLog(@"%@",model.qqianId);
    model.up = @(0);
    model.upCount =[NSNumber numberWithUnsignedInteger:[model.upCount integerValue] - 1];
    //便利数组
    NSMutableArray * upModelArr = [NSMutableArray arrayWithArray:model.partUp];
    __block NSUInteger index = 999999;
    
    [model.partUp enumerateObjectsUsingBlock:^(HSGHHomeUp * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[HSGHUserInf shareManager].userId  isEqualToString:obj.userId]){
            index = idx;
        }
    }];
    if(index != 999999){
        [upModelArr removeObjectAtIndex:index];
    }
    model.partUp = [NSArray arrayWithArray:upModelArr];
    
    HSGHHomeQQianModelFrame * modelF2 =  [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_HOME];
    [modelF2 setModel:model];
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:modelF2];
    
    if (isSecond) {
        _qqiansForward = [NSMutableArray arrayWithArray:arr];
    } else {
        _qqians = [NSMutableArray arrayWithArray:arr];
    }
    if (self.block) {
        self.block(indexPath);
    }
}

- (void)modifyAddFriendMeDataWithIndexPath:(NSIndexPath *)indexPath
                               andIsSecond:(BOOL)isSecond {
    NSArray *datalist = isSecond ? _qqiansForward : _qqians;
    HSGHHomeQQianModelFrame *modelF = datalist[indexPath.row];
    HSGHHomeQQianModel *qqiansVO = modelF.model;
    NSString *imageFileName = @"";
    switch ((HSGH_FRIEND_MODE)[qqiansVO.friendStatus integerValue]) {
        case FRIEND_NONE:
            imageFileName = FRIEND_TO_IMAGE;
            qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_TO];
            break;
        case FRIEND_TO:
            break;
        case FRIEND_FROM:
            imageFileName = FRIEND_ALL_IMAGE;
            qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_ALL];
            break;
        case FRIEND_UKNOW:
            imageFileName = FRIEND_ALL_IMAGE;
            qqiansVO.friendStatus = [NSNumber numberWithInt:FRIEND_ALL];
            break;
        default:
            break;
    }
    HSGHHomeQQianModelFrame *voFrame =
    [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                              WithMode:QQIAN_HOME];
    [voFrame setModel:qqiansVO];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datalist];
    [arr replaceObjectAtIndex:indexPath.row withObject:voFrame];
    if (isSecond) {
        _qqiansForward = [NSMutableArray arrayWithArray:arr];
    } else {
        _qqians = [NSMutableArray arrayWithArray:arr];
    }
}

// remove
- (void)qqianRemoveHomeType:(HOME_MODE)mode
               andIndexPath:(NSIndexPath *)indexPath
                andIsSecond:(BOOL)isSecond {
    _datalist = isSecond ? [self fetchForwardData] : [self fetchData];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_datalist];
    [arr removeObjectAtIndex:indexPath.row];
    if (isSecond) {
        _qqiansForward = [NSMutableArray arrayWithArray:arr];
    } else {
        _qqians = [NSMutableArray arrayWithArray:arr];
    }
    if (self.block) {
        self.block(nil);
    }
}

// comment forword
- (void)qqianCommentAndForwardWithHomeType:(HOME_MODE)mode
                                   andEdit:(EDIT_MODE)editMode
                              andMainIndex:(NSIndexPath *)mainIndexPath
                             andNomalIndex:(NSIndexPath *)nomalIndex
                                   andText:(NSString *)text
                               andIsSecond:(BOOL)isSecond {
    _datalist = isSecond ? [self fetchForwardData] : [self fetchData];
    HSGHHomeQQianModelFrame *originFrame =
    (HSGHHomeQQianModelFrame *)_datalist[mainIndexPath.row];
    if ([originFrame.model.forward integerValue] == NO) {
        HSGHHomeQQianModel *qqiansVO =
        ((HSGHHomeQQianModelFrame *)_datalist[mainIndexPath.row]).model;
        HSGHHomeReplay *replay = [HSGHHomeReplay new];
        
        HSGHHomeUserInfo *from = [HSGHHomeUserInfo new];
        HSGHHomeImage *image = [HSGHHomeImage new];
        image.srcUrl = [HSGHUserInf shareManager].picture.srcUrl;
        from.picture = image;
        from.unvi.name = [HSGHUserInf shareManager].bachelorUniv.name;
        from.displayName =
        [NSString stringWithFormat:@"%@", [HSGHUserInf shareManager].nickName];
        ;
        from.userId = [HSGHUserInf shareManager].userId;
        replay.fromUser = from;
        replay.content = text;
        if (editMode == HOME_COMMENT_MODE) {
            //评论
            qqiansVO.replyCount = @([qqiansVO.replyCount integerValue] + 1);
        } else {
            qqiansVO.forwardCount = @([qqiansVO.forwardCount integerValue] + 1);
        }
        NSMutableArray *replayArr =
        [NSMutableArray arrayWithArray:qqiansVO.partReplay];
        [replayArr insertObject:replay atIndex:0];
        
        qqiansVO.partReplay = [NSArray arrayWithArray:replayArr];
        HSGHHomeQQianModelFrame *voFrame =
        [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH
                                                  WithMode:QQIAN_HOME];
        [voFrame setModel:qqiansVO];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_datalist];
        [arr replaceObjectAtIndex:mainIndexPath.row withObject:voFrame];
        _datalist = [NSMutableArray arrayWithArray:arr];
        if (isSecond) {
            _qqiansForward = [NSMutableArray arrayWithArray:_datalist];
        } else {
            _qqians = [NSMutableArray arrayWithArray:_datalist];
        }
        if (self.block) {
            self.block(mainIndexPath);
        }
    }
}

//刷新个人页面数据
- (void)requestMine:(NSString *)userID
         refreshAll:(BOOL)refreshAll
              block:(void (^)(BOOL status))fetchBlock {
    if (refreshAll) {
        _mineFrom = 0;
    }
    if (!userID) {
        if (fetchBlock) {
            fetchBlock(NO);
        }
        return;
    }
    
    NSDictionary *params = @{
                             @"from" : @(_mineFrom),
                             @"size" : @(HSGH_PAGE_SIZE),
                             @"type" : @(2),
                             @"userId" : userID
                             };
    [HSGHNetworkSession
     postReq:HSGHHomeQQiansPersonURL
     appendParams:params
     returnClass:[self class]
     block:^(HSGHZoneModel *obj, NetResStatus status,
             NSString *errorDes) {
         if (status == NetResSuccess) {
             if (refreshAll) {
                 [_qqians removeAllObjects];
                 if (obj.user) {
                     _user = obj.user;
                     _friendAddTime = obj.friendAddTime;
                 }
             }
             
             if (obj.qqians.count > 0) {
                 [_qqians addObjectsFromArray: [self transWithArr:[NSArray arrayWithArray:obj.qqians]]];
             }
             
             _mineFrom += HSGH_PAGE_SIZE;
         }
         
         if (fetchBlock) {
             fetchBlock(status == NetResSuccess);
         }
     }];
}
//刷新个人页面数据
- (void)requestForward:(NSString *)userID
            refreshAll:(BOOL)refreshAll
                 block:(void (^)(BOOL status))fetchBlock {
    if (refreshAll) {
        _forwardFrom = 0;
    }
    if (!userID) {
        if (fetchBlock) {
            fetchBlock(NO);
        }
        return;
    }
    
    NSDictionary *params = @{
                             @"from" : @(_forwardFrom),
                             @"size" : @(HSGH_PAGE_SIZE),
                             @"type" : @(3),
                             @"userId" : userID
                             };
    [HSGHNetworkSession
     postReq:HSGHHomeQQiansPersonURL
     appendParams:params
     returnClass:[self class]
     block:^(HSGHZoneModel *obj, NetResStatus status,
             NSString *errorDes) {
         if (status == NetResSuccess) {
             if (refreshAll) {
                 [_qqiansForward removeAllObjects];
             }
             
             if (obj.qqians.count > 0) {
                 [_qqiansForward
                  addObjectsFromArray:
                  [self transWithArr:[NSArray
                                      arrayWithArray:obj.qqians]]];
             }
             
             _forwardFrom += HSGH_PAGE_SIZE;
         }
         
         if (fetchBlock) {
             fetchBlock(status == NetResSuccess);
         }
         
     }];
}

@end
