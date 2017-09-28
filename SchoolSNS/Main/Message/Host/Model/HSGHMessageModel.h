//
//  HSGHMessageModel.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModel.h"

@interface HSGHSingleMsg : NSObject
@property (nonatomic, strong) HSGHHomeUserInfo* user;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, copy)  NSString* contentPart;
@property (nonatomic, strong) NSDate* createTime;
@property (nonatomic, copy) NSString* messageId;
@property (nonatomic, strong) NSNumber* read;
@property (nonatomic, assign) NSInteger type;

@end

@interface HSGHMessageModel : NSObject
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray* messages;

@property (nonatomic, assign) NSUInteger from;

@property (nonatomic, assign) NSInteger atCount;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, assign) NSInteger upCount;
//弃用
+ (void)getMessageCount:(void(^)(BOOL success, id response))fetchBlock;

/**
 查询消息

 @param type
 @param isRefreshAll
 @param fetchBlock
 */
- (void)fetchMessages:(NSUInteger)type isRefreshAll:(BOOL)isRefreshAll block:(void(^)(BOOL success))fetchBlock;

+ (void)refreshRedCount;

- (NSArray*)fetchMessages;

/**
 查询所有未读消息

 @param type
 @param pageNumber
 @param fetchBlock
 */
+ (void)fetchMessageViewModelArrWithType:(NSUInteger)type Page:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock ;

//弃用
+ (void)fetchResetMessageNumberWithType:(NSNumber *)type :(void (^)(BOOL success))fetchBlock  ;
//弃用
+ (void)newMessageRed;


/**
 修改消息已读状态

 @param messageId ID
 @param fetchBlock 回掉
 */
+ (void)fetchIsReadWithMessageId:(NSString *)messageId :(void (^)(BOOL success))fetchBlock ;

+ (void)fetchRemoveWithMessageId:(NSString *)messageId :(void (^)(BOOL success))fetchBlock ;
@end
