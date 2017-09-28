//
//  HSGHCommentKeyboardModel.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHCommentKeyboardModel : NSObject

+ (BOOL)checkFriend:(NSString*)userId;

+ (void)sendReply:(NSString*)qqianID replyId:(NSString*)replyId content:(NSString*)content block:(void(^)(BOOL success))fetchBlock;

+ (void)sendComment:(NSString*)qqianID content:(NSString*)content block:(void(^)(BOOL success))fetchBlock;

@end
