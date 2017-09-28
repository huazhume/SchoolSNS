//
//  HSGHMoreCommentsModel.m
//  SchoolSNS
//
//  Created by Murloc on 17/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHMoreCommentsModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHHomeModel.h"
#import "HSGHMoreCommentsViewCell.h"
#import "HSGHMoreCommentsHelp.h"
#import "HSGHFriendViewModel.h"

#pragma mark- subClass
@implementation HSGHSubCommentsLayout



@end


@implementation HSGHCommentsLayout

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _conversationLayoutArray = [NSMutableArray array];
    }
    
    return self;
}
@end




@interface HSGHMoreCommentsLayoutModel()

//Below from net, will be converted to cellReplay
@property(nonatomic, strong) HSGHHomeUserInfo *toUser;
@property(nonatomic, strong) HSGHHomeUserInfo *fromUser;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *replayParentId;
@property(nonatomic, assign) BOOL up;
@property(nonatomic, copy) NSString *replayId;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber* upCount;
@property(nonatomic, assign) NSInteger friendStatus;

@end

@implementation HSGHMoreCommentsLayoutModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"conversationArray" : [HSGHMoreCommentsLayoutModel class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _conversationArray = [NSMutableArray new];
        _cellReplay = [HSGHHomeReplay new];
        _layout = [HSGHCommentsLayout new];
    }
    return self;
}

- (void)innerConvert {
    [self innerConvert:false];
}

- (void)innerConvert:(BOOL)isConversion {
    _cellReplay.toUser = _toUser;
    _cellReplay.fromUser = _fromUser;
    _cellReplay.content = _content;
    _cellReplay.replayParentId = self.replayParentId;
    _cellReplay.up = self.up;
    _cellReplay.replayId = self.replayId;
    _cellReplay.createTime = self.createTime;
    _cellReplay.upCount = self.upCount;
    _cellReplay.friendStatus = [NSNumber numberWithInteger:self.friendStatus];
    _layout = [[self class] calcLayout:isConversion data:self];
}


#define LayoutHeadHeight  59
//#define LayoutLeft   50
#define LayoutSpace  8
#define LayoutRight  12
#define LimitedLines   10
#define LimitedSubCellCount  2
#define CellMoreHeight  0
#define BottomHeight   0
+ (HSGHCommentsLayout*)calcLayout:(BOOL)isConversion data:(HSGHMoreCommentsLayoutModel *)data {
    HSGHCommentsLayout* layout = [HSGHCommentsLayout new];
    
//    CGFloat width = [HSGHMoreCommentsViewCell getLabelWidth];
    CGFloat width = HSGH_SCREEN_WIDTH - 57.5;
    if (data.cellReplay.toUser.userId.integerValue != 0) {
        width -= 26;
    }
    NSAttributedString*  attributedString = [[NSAttributedString alloc] initWithString:data.cellReplay.content];
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    layout.normalLabelHeight = textLayout.textBoundingSize.height;
    layout.normalWholeHeight = layout.normalLabelHeight + LayoutHeadHeight + 5;
    layout.extendedLabelHeight = layout.normalLabelHeight;
    layout.extendedWholeHeight = layout.normalWholeHeight;
 //   layout.extendedLabelHeight = textLayout.textBoundingSize.height;
    
  //  layout.isShowMore = textLayout.rowCount > LimitedLines;
    
//    if (!layout.isShowMore) {
//        layout.normalLabelHeight = layout.extendedLabelHeight;
//    } else {
//        container.maximumNumberOfRows = LimitedLines;
//        YYTextLayout *closedTextLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
//        layout.normalLabelHeight = closedTextLayout.textBoundingSize.height;
//    }
//    layout.top = LayoutHeadHeight;
    
    
    //calc cells
//    if (isConversion) {
//        layout.cellsHeight = 0;
//    }
//    else {
//        CGFloat top = LayoutSpace;
//        NSUInteger index = 0;
//
//        YYTextContainer *subContainer = [YYTextContainer new];
//        subContainer.size = CGSizeMake(width - LayoutSpace * 2, CGFLOAT_MAX);
//        subContainer.maximumNumberOfRows = 0;
//    }
    
    //Last calc the whole height
//    if (layout.isShowMore) {
//        layout.extendedWholeHeight = LayoutHeadHeight + layout.extendedLabelHeight + LayoutSpace + layout.cellsHeight + CellMoreHeight;
//        layout.normalWholeHeight = LayoutHeadHeight + layout.normalLabelHeight + LayoutSpace + layout.cellsHeight + CellMoreHeight;
//    }
//    else {
//        layout.extendedWholeHeight = LayoutHeadHeight + layout.extendedLabelHeight + LayoutSpace + layout.cellsHeight;
//        layout.normalWholeHeight = LayoutHeadHeight + layout.normalLabelHeight + LayoutSpace + layout.cellsHeight;
//    }

    
//    layout.extendedWholeHeight += BottomHeight;
//    layout.normalWholeHeight += BottomHeight;

    return layout;
}

@end

//@interface HSGHMoreDetailsCommentsModel : HSGHMoreCommentsModel
//
//@end
//
//@implementation HSGHMoreDetailsCommentsModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"replyVos" : @"replyVos.conversationArray"};
//}
//
//@end


@interface HSGHMoreCommentsModel()

@property (nonatomic, assign) NSUInteger detailFrom;
@property (nonatomic, assign) NSUInteger from;
@property (nonatomic, strong) NSMutableArray* replyVos;


@end

@implementation HSGHMoreCommentsModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _commentsArray = [NSMutableArray arrayWithCapacity:2];
        _commentsArray[0] = [NSMutableArray new];
        _commentsArray[1] = [NSMutableArray new];
        
        _detailsReply = [NSMutableArray new];
        
    }
    return self;
}

#pragma mark - network request
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"replyVos" : @"replyVos.conversationArray"};
//}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"replyVos": [HSGHMoreCommentsLayoutModel class]};
}


- (void)requestDetails:(NSString *)replyID qqianID:(NSString*)qqianID isRefreshAll:(BOOL)isRefreshAll block:(void (^)(BOOL success, BOOL hasMore))fetchBlock {
    if (isRefreshAll) {
        _detailFrom = 0;
    }
    NSDictionary *dic = @{@"replyId": UN_NIL_STR(replyID), @"qqianId": UN_NIL_STR(qqianID)};
    __weak typeof(self) weakSelf = self;
    [HSGHNetworkSession postReq:HSGHGetConversationAll
                   appendParams:dic
                    returnClass:[self class]
                          block:^(HSGHMoreCommentsModel *obj, NetResStatus status, NSString *errorDes) {
                              if (NetResSuccess == status) {
                                  weakSelf.detailFrom += HSGH_PAGE_SIZE;
                                  if (isRefreshAll) {
                                      [weakSelf.detailsReply removeAllObjects];
                                  }
                                  
                                  if (obj.replyVos.count > 0) {
                                      HSGHMoreCommentsLayoutModel* layoutModel = obj.replyVos.firstObject;
                    
                                      NSArray* conversationArray = layoutModel.conversationArray;
                                      for (HSGHHomeReplay* reply in conversationArray) {
                                          HSGHMoreCommentsLayoutModel* layout = [HSGHMoreCommentsHelp convertToLayoutModel:reply];
                                          [weakSelf.detailsReply addObject: layout];

                                      }
                                  }
                                  
                                  if (fetchBlock) {
                                      fetchBlock(YES, true);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, true);
                                  }
                              }
                          }];
}


- (void)requestHot:(NSString *)requestID block:(void (^)(BOOL success, BOOL hasMore))fetchBlock {
    NSDictionary *dic = @{@"from": @(0), @"qqianId": requestID, @"size": @(HSGH_PAGE_SIZE)};
    __weak typeof(self) weakSelf = self;
    [HSGHNetworkSession postReq:HSGHGetHotReply
                   appendParams:dic
                    returnClass:[self class]
                          block:^(HSGHMoreCommentsModel *obj, NetResStatus status, NSString *errorDes) {
                              if (NetResSuccess == status) {
                                  [weakSelf.commentsArray[0] removeAllObjects];
                                  
                                  if (obj.replyVos.count > 0) {
                                      for (HSGHMoreCommentsLayoutModel *cell in obj.replyVos) {
                                          [cell innerConvert];
                                      }
                                      
                                      [weakSelf.commentsArray[0] addObjectsFromArray:obj.replyVos];
                                  }

                                  if (fetchBlock) {
                                      fetchBlock(YES, true);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, true);
                                  }
                              }
                          }];
}

//新版获取所有评论的接口
- (void)requestAllComment:(NSString *)requestID isRefreshAll:(BOOL)isRefreshAll block:(void (^)(BOOL, BOOL))fetchBlock {
    if (isRefreshAll) {
        _from = 0;
    }
    NSDictionary *dic = @{@"from": @(_from), @"qqianId": requestID, @"size": @(HSGH_PAGE_SIZE)};
    __weak typeof(self) weakSelf = self;
    [HSGHNetworkSession postReq:HSGHGetAllReply
                   appendParams:dic
                    returnClass:[self class]
                          block:^(HSGHMoreCommentsModel *obj, NetResStatus status, NSString *errorDes) {
                              if (NetResSuccess == status) {
                                  weakSelf.from += HSGH_PAGE_SIZE;
                                  if (isRefreshAll) {
                                      [weakSelf.dataArr removeAllObjects];
                                      weakSelf.dataArr = [NSMutableArray array];
                                  }
                                  
                                  if (obj.replyVos.count > 0) {
                                      for (HSGHMoreCommentsLayoutModel *cell in obj.replyVos) {
                                          [cell innerConvert];
                                          for (HSGHMoreCommentsLayoutModel *secondReplay in cell.conversationArray) {
                                              [secondReplay innerConvert];
                                          }
                                          [weakSelf.dataArr addObject:cell];
                                      }
                                      
                                  //    [weakSelf.dataArr addObjectsFromArray:obj.replyVos];
                                  }
                                  if (fetchBlock) {
                                      fetchBlock(YES, true);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, true);
                                  }
                              }
                          }];
}

//旧版获取所有评论的接口
- (void)request:(NSString *)requestID isRefreshAll:(BOOL)isRefreshAll block:(void (^)(BOOL success, BOOL hasMore))fetchBlock {
    if (isRefreshAll) {
        _from = 0;
    }
    NSDictionary *dic = @{@"from": @(_from), @"qqianId": requestID, @"size": @(HSGH_PAGE_SIZE)};
    __weak typeof(self) weakSelf = self;
    [HSGHNetworkSession postReq:HSGHGetAllReply
                   appendParams:dic
                    returnClass:[self class]
                          block:^(HSGHMoreCommentsModel *obj, NetResStatus status, NSString *errorDes) {
                              if (NetResSuccess == status) {
                                  weakSelf.from += HSGH_PAGE_SIZE;
                                  if (isRefreshAll) {
                                      [weakSelf.commentsArray[1] removeAllObjects];
                                  }
                                  
                                  if (obj.replyVos.count > 0) {
                                      for (HSGHMoreCommentsLayoutModel *cell in obj.replyVos) {
                                          [cell innerConvert];
                                      }
                                      
                                      [weakSelf.commentsArray[1] addObjectsFromArray:obj.replyVos];
                                  }
                                  
                                  if (fetchBlock) {
                                      fetchBlock(YES, true);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, true);
                                  }
                              }
                          }];
}


- (void)changeFriendStateWithFromUserId:(NSString *)userId indexPath:(NSIndexPath *)indexPath{
    _indexPathArr = [NSMutableArray array];
    NSMutableArray *array = self.dataArr;
    if (indexPath.row > 0) {
        HSGHMoreCommentsLayoutModel *model = self.dataArr[indexPath.section];
        array = model.conversationArray;
    }
    
    [array enumerateObjectsUsingBlock:^(HSGHMoreCommentsLayoutModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.fromUser.userId isEqualToString:userId]){
            //            [_indexPathArr addObject:];
            //如果确定为同一个人的话
            if(obj.friendStatus == FRIEND_NONE){
                obj.friendStatus = FRIEND_TO;
            }else if (obj.friendStatus == FRIEND_FROM){
                obj.friendStatus = FRIEND_ALL;
            }
            [array replaceObjectAtIndex:idx withObject:obj];//替换
        }
    }];
}

@end
