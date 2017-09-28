//
//  HSGHCommentKeyboardModel.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHCommentKeyboardModel.h"
#import "HSGHNetworkSession.h"

@implementation HSGHCommentKeyboardModel

+ (BOOL)checkFriend:(NSString*)userId {
    return true;
}

+ (void)sendReply:(NSString*)qqianID replyId:(NSString*)replyId content:(NSString*)content block:(void(^)(BOOL success))fetchBlock {
        [HSGHNetworkSession postReq:HSGHHomeQQiansReplyURL
                       appendParams:@{@"content": content, @"qqianId": qqianID, @"replyId": replyId}
                        returnClass:nil
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

+ (void)sendComment:(NSString*)qqianID content:(NSString*)content block:(void(^)(BOOL success))fetchBlock{
        [HSGHNetworkSession postReq:HSGHHomeQQiansReplyURL
                       appendParams:@{@"content": content, @"qqianId": qqianID}
                        returnClass:nil
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


@end
