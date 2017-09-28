//
//  HSGHMessageModel.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHMessageModel.h"
#import "HSGHNetworkSession.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "HSGHUserInf.h"
#import "PPBadgeView.h"

@interface HSGHSingleMsg()

@end

@implementation HSGHSingleMsg



@end

@interface HSGHMessageModel()


@end


@implementation HSGHMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"messages": [HSGHSingleMsg class]};
}

+ (void)getMessageCount:(void(^)(BOOL success, id response))fetchBlock{
    return;
    [HSGHNetworkSession postReq:HSGHMessageCountURL
                   appendParams:nil
                    returnClass:[self class]
                          block:^(HSGHMessageModel* obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES, obj);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, 0);
                                  }
                              }
                              
                          }];
}


+ (void)refreshRedCount {
    
//    if ([[HSGHUserInf shareManager] logined]) {
//        [HSGHMessageModel getMessageCount:^(BOOL success, HSGHMessageModel * obj) {
//            if (success) {
//                AppDelegate* delegate = [AppDelegate instanceApplication];
//                ViewController *vc = (ViewController *) (delegate.window.rootViewController);
//                if ([vc isKindOfClass:[UITabBarController class]]) {
//                    if (obj.count > 0) {
//                        [vc.tabBar.items[3] pp_addDotWithColor:nil];
//                        [vc.tabBar.items[3] pp_moveBadgeWithX:0 Y:5];
//                    }
//                    else {
//                        [vc.tabBar.items[3] pp_hiddenBadge];
//                    }
//                    //消息数
//                    HSGHNotificationMessage * messageModel = vc.messageMsgNumModel;
//                    messageModel.firstMsgNum = obj.replyCount;
//                    messageModel.secondMsgNum = obj.atCount;
//                    messageModel.thirdMsgNum = obj.upCount;
//                    vc.messageMsgNumModel = messageModel;
//                }
//            }
//        }];
//    }
}

+ (void)newMessageRed {
    return;
    AppDelegate* delegate = [AppDelegate instanceApplication];
    ViewController *vc = (ViewController *) (delegate.window.rootViewController);
//    [vc.tabBar.items[3] pp_addDotWithColor:nil];
//    [vc.tabBar.items[3] pp_moveBadgeWithX:0 Y:5];
    
//    [vc.tabBar.items[3] pp_increase];
//    [vc.tabBar.items[3] pp_moveBadgeWithX:2 Y:4];
    
    
    [HSGHMessageModel getMessageCount:^(BOOL success, HSGHMessageModel * obj) {
        if (success) {
            //消息数
            int tipCnt = (int)obj.count;
            
            if (tipCnt==0) {
                [vc.tabBar.items[3] pp_hiddenBadge];
            } else if (tipCnt < 99 ) {
                [vc.tabBar.items[3] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",tipCnt]];
            } else {
                [vc.tabBar.items[3] pp_addBadgeWithText:@"99+"];
            }
        }
    }];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _messages = [NSMutableArray array];
    }
    return self;
}

//type 1:@  2:回复 3:点赞
- (void)fetchMessages:(NSUInteger)type isRefreshAll:(BOOL)isRefreshAll block:(void(^)(BOOL success))fetchBlock{
    if (isRefreshAll) {
        _from = 0;
    }
    AppDelegate* delegate = [AppDelegate instanceApplication];
    ViewController *vc = (ViewController *) (delegate.window.rootViewController);
    __weak typeof(self) weakSelf = self;
    [HSGHNetworkSession postReq:HSGHMessageFetchURL
                   appendParams:@{@"from":@(_from), @"size" : @(HSGH_PAGE_SIZE), @"type" : @(type)}
                    returnClass:[self class]
                          block:^(HSGHMessageModel* obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  int tipCnt = (int)obj.count;
                                  
                                  if (tipCnt==0) {
                                      [vc.tabBar.items[3] pp_hiddenBadge];
                                  } else if (tipCnt < 99 ) {
                                      [vc.tabBar.items[3] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",tipCnt]];
                                  } else {
                                      [vc.tabBar.items[3] pp_addBadgeWithText:@"99+"];
                                  }
                                  weakSelf.from += HSGH_PAGE_SIZE;
                                  if (isRefreshAll) {
//                                      [weakSelf.messages removeAllObjects];
                                  }
                                  
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

// 获取所有消息
+ (void)fetchMessageViewModelArrWithType:(NSUInteger)type Page:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock {
    AppDelegate* delegate = [AppDelegate instanceApplication];
    ViewController *vc = (ViewController *) (delegate.window.rootViewController);
    [HSGHNetworkSession postReq:HSGHMessageFetchURL
                   appendParams:@{@"from": [NSNumber numberWithInteger:pageNumber * 30],@"size":@30,@"type":@(type)}
                    returnClass:[self class]
                          block:^(HSGHMessageModel* obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  int tipCnt = (int)obj.count;
                                  
                                  if (tipCnt==0) {
                                      [vc.tabBar.items[3] pp_hiddenBadge];
                                  } else if (tipCnt < 99 ) {
                                      [vc.tabBar.items[3] pp_addBadgeWithText:[NSString stringWithFormat:@"%zd",tipCnt]];
                                  } else {
                                      [vc.tabBar.items[3] pp_addBadgeWithText:@"99+"];
                                  }
                                  if (fetchBlock) {
                                      fetchBlock(YES,obj.messages);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}


//重置消息提醒数字
+ (void)fetchResetMessageNumberWithType:(NSNumber *)type :(void (^)(BOOL success))fetchBlock {
    return;
    [HSGHNetworkSession postReq:HSGHMessageResetURL
                   appendParams:@{@"category":type}
                    returnClass:[self class]
                          block:^(HSGHMessageModel* obj, NetResStatus status,
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

+ (void)fetchIsReadWithMessageId:(NSString *)messageId :(void (^)(BOOL success))fetchBlock {
    [HSGHNetworkSession postReq:HSGHMessageIsReadURL
                   appendParams:@{@"messageId":messageId}
                    returnClass:[self class]
                          block:^(HSGHMessageModel* obj, NetResStatus status,
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
//HSGHMessageRemoveURL
+ (void)fetchRemoveWithMessageId:(NSString *)messageId :(void (^)(BOOL success))fetchBlock {
    [HSGHNetworkSession postReq:HSGHMessageRemoveURL
                   appendParams:@{@"messageId":messageId}
                    returnClass:[self class]
                          block:^(HSGHMessageModel* obj, NetResStatus status,
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


- (NSArray*)fetchMessages {
    return _messages.copy;
}

@end
