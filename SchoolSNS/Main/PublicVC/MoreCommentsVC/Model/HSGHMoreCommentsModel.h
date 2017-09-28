//
//  HSGHMoreCommentsModel.h
//  SchoolSNS
//
//  Created by Murloc on 17/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSGHHomeReplay;
@class HSGHHomeUserInfo;


@interface HSGHSubCommentsLayout : NSObject
@property (nonatomic, assign)CGFloat top;
@property (nonatomic, assign)CGFloat normalLabelHeight;
@property (nonatomic, assign)BOOL showMore;
@end

@interface HSGHCommentsLayout : NSObject
@property (nonatomic, assign)CGFloat top;

@property (nonatomic, assign)CGFloat normalLabelHeight;
@property(nonatomic, assign) CGFloat extendedLabelHeight;
@property (nonatomic, assign) CGFloat normalWholeHeight;
@property(nonatomic, assign) CGFloat extendedWholeHeight;
@property (nonatomic, assign) BOOL  isShowMore;
@property (nonatomic, assign) BOOL  isExtended;

@property (nonatomic, assign) CGFloat cellsHeight;
@property (nonatomic, strong) NSMutableArray<HSGHSubCommentsLayout*>* conversationLayoutArray;

@end


@interface HSGHMoreCommentsLayoutModel : NSObject
@property (nonatomic, strong) HSGHCommentsLayout* layout;

@property (nonatomic, strong) HSGHHomeReplay* cellReplay;
@property (nonatomic, strong) NSMutableArray<HSGHMoreCommentsLayoutModel*>* conversationArray;


- (void)innerConvert;
+ (HSGHCommentsLayout*)calcLayout:(BOOL)isConversion data:(HSGHMoreCommentsLayoutModel *)data;
@end


@interface HSGHMoreCommentsModel : NSObject
@property (nonatomic, strong) NSMutableArray* commentsArray; //0 ==> hot ,  1 ==> replyVos

@property(nonatomic, strong)NSMutableArray <NSIndexPath *> *indexPathArr;

@property (nonatomic, strong) NSMutableArray* detailsReply;
//现在用这个，上面那些我也不知道是干嘛的，前面人留下的坑
@property (nonatomic,strong) NSMutableArray *dataArr;

- (void)requestHot:(NSString *)requestID block:(void (^)(BOOL success, BOOL hasMore))fetchBlock;

- (void)request:(NSString *)requestID isRefreshAll:(BOOL)isRefreshAll block:(void (^)(BOOL success, BOOL hasMore))fetchBlock;

- (void)requestDetails:(NSString *)replyID qqianID:(NSString*)qqianID isRefreshAll:(BOOL)isRefreshAll block:(void (^)(BOOL success, BOOL hasMore))fetchBlock;

- (void)changeFriendStateWithFromUserId:(NSString *)userId indexPath:(NSIndexPath *)indexPath;

- (void)requestAllComment:(NSString *)requestID isRefreshAll:(BOOL)isRefreshAll block:(void (^)(BOOL success, BOOL hasMore))fetchBlock;
@end
