//
//  HSGHFriendStateManager.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendStateManager.h"
#import "HSGHNetworkSession.h"

/*
 #define FRIEND_NONE_IMAGE @"friend_none" //没有添加好友的状态
 #define FRIEND_TO_IMAGE  @"frined_to" //添加对方 对方未同意
 #define FRIEND_FROM_IMAGE @"frined_from"//对方添加你 你未同意
 #define FRIEND_ALL_IMAGE @"friend_all" // 互相为好友
 */


@implementation HSGHFriendStateManager
//
//- (instancetype)initWithMode:(HSGH_FRIEND_MODE)mode {
//    if(self = [super init]){
//        //初始化
//         NSString * imageFileName = @"";
//        switch (mode) {
//            case FRIEND_NONE:
//                imageFileName = FRIEND_NONE_IMAGE;
//                break;
//            case FRIEND_TO:
//                imageFileName = FRIEND_TO_IMAGE;
//                break;
//            case FRIEND_FROM:
//                imageFileName = FRIEND_FROM_IMAGE;
//                break;
//            case FRIEND_ALL:
//                imageFileName = FRIEND_ALL_IMAGE;
//                break;
//            default:
//                break;
//        }
//        self.friendModeImage = [UIImage imageNamed:imageFileName];
//        self.mode = FRIEND_NONE;
//       self.friendModeImage = [UIImage imageNamed:imageFileName];
//    }
//    return self;
//}
//
//
//
//- (void)setMode:(HSGH_FRIEND_MODE)mode {
//    _mode = mode;
//    NSString * imageFileName = @"";
//    switch (mode) {
//        case FRIEND_NONE:
//            imageFileName = FRIEND_NONE_IMAGE;
//            break;
//        case FRIEND_TO:
//            imageFileName = FRIEND_TO_IMAGE;
//            break;
//        case FRIEND_FROM:
//           imageFileName = FRIEND_FROM_IMAGE;
//            break;
//        case FRIEND_ALL:
//            imageFileName = FRIEND_ALL_IMAGE;
//            break;
//        default:
//            break;
//    }
//     self.friendModeImage = [UIImage imageNamed:imageFileName];
//}


//<<<<<<< HEAD
//- (void)fetchFriendWithMode:(HSGH_FRIEND_MODE)mode WithParams:(NSDictionary *)params :(void (^)(NSInteger state))fetchBlock {
//    if(self.mode != FRIEND_ALL && self.mode != FRIEND_TO && self.mode != FRIEND_SELF){ // 还没有成为好友 或者已经发送了好友请求
//        [HSGHNetworkSession postReq:HSGHServerFriendApplyURL
//                       appendParams:params
//                        returnClass:[self class]
//                              block:^(id obj, NetResStatus status,
//                                      NSString *errorDes) {
//                                  if (status == NetResSuccess) {
//                                      if (fetchBlock) {
//                                          NSString * imageFileName = @"";
//                                          switch (self.mode) {
//                                              case FRIEND_NONE:
//                                                  self.mode = FRIEND_TO;
//                                                  imageFileName = FRIEND_TO_IMAGE;
//                                                  break;
//                                              case FRIEND_TO:
//                                                  break;
//                                              case FRIEND_FROM:
//                                                   self.mode = FRIEND_ALL;
//                                                   imageFileName = FRIEND_ALL_IMAGE;
//                                                  break;
//                                              case FRIEND_ALL:
//                                                  break;
//                                              default:
//                                                  break;
//                                          }
//                                          self.friendModeImage = [UIImage imageNamed:imageFileName];
//                                          fetchBlock(YES);
//                                      }
//                                  } else {
//                                      if (fetchBlock) {
//                                          fetchBlock(NO);
//                                      }
//                                  }
//                                  
//                              }];
//    }else {
//        fetchBlock(-1); // 已经互相成为了好友 或者发送了好友请求
//    }
//}
//=======
//- (void)fetchFriendWithMode:(HSGH_FRIEND_MODE)mode WithParams:(NSDictionary *)params :(void (^)(NSInteger state))fetchBlock {
//    if(self.mode != FRIEND_ALL){ // 还没有成为好友
//        [HSGHNetworkSession postReq:HSGHServerFriendApplyURL
//                       appendParams:params
//                        returnClass:[self class]
//                              block:^(id obj, NetResStatus status,
//                                      NSString *errorDes) {
//                                  if (status == NetResSuccess) {
//                                      if (fetchBlock) {
//                                          self.mode = self.mode + 1;
//                                          NSString * imageFileName = @"";
//                                          switch (self.mode) {
//                                              case FRIEND_NONE:
//                                                  imageFileName = FRIEND_NONE_IMAGE;
//                                                  break;
//                                              case FRIEND_TO:
//                                                  imageFileName = FRIEND_TO_IMAGE;
//                                                  break;
//                                              case FRIEND_FROM:
//                                                  imageFileName = FRIEND_FROM_IMAGE;
//                                                  break;
//                                              case FRIEND_ALL:
//                                                  imageFileName = FRIEND_ALL_IMAGE;
//                                                  break;
//                                              default:
//                                                  break;
//                                          }
//                                          self.friendModeImage = [UIImage imageNamed:imageFileName];
//                                          fetchBlock(YES);
//                                      }
//                                  } else {
//                                      if (fetchBlock) {
//                                          fetchBlock(NO);
//                                      }
//                                  }
//                                  
//                              }];
//    }else {
//        fetchBlock(-1); // 已经互相成为了好友
//    }
//}
//>>>>>>> 22e0ef1adf1e312a0ba0293800a42641e1811848
@end
