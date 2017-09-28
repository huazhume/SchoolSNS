//
//  HSGHMsgDetailViewModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHMsgDetailViewModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHHomeModel.h"

#import "HSGHHomeModelFrame.h"

@implementation HSGHMsgDetailViewModel





//获取消息详情
+ (void)fetchFriendDetailWithMsgID:(NSString *)msgId :(void (^)(BOOL success, NSArray *array))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeQQiansMsgDetailURL
                   appendParams:@{@"messageId":msgId}
                    returnClass:[self class]
                          block:^(HSGHMsgDetailViewModel * obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel: obj.qQianVo ? @[obj.qQianVo] : @[]]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}

+ (NSMutableArray *)transToHomeViewFrameWithHomeModel:(NSArray *)modelArr {
    NSMutableArray *muArr = [NSMutableArray array];
    [modelArr enumerateObjectsUsingBlock:^(HSGHHomeQQianModel *obj, NSUInteger idx,
                                           BOOL *_Nonnull stop) {
        HSGHHomeQQianModelFrame *modelF =
        [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithMode:QQIAN_MSG];
        modelF.model = obj;
        [muArr addObject:modelF];
    }];
    return muArr;
}



+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"qQianVo" : HSGHHomeQQianModel.class };
}

@end
