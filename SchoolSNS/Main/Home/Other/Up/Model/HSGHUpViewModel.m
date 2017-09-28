//
//  HSGHUpViewModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHUpViewModel.h"
#import "HSGHNetworkSession.h"


@implementation HSGHUpViewModel
// 点赞列表
+ (void)fetchUpViewModelArrWithPage:(NSInteger) pageNumber WithQqianId:(NSString *)qqianID :(void (^)(BOOL success, NSArray *array))fetchBlock{
    [HSGHNetworkSession postReq:HSGHHomeQQiansUpDetailURL
                   appendParams:@{@"from":[NSNumber numberWithInteger:pageNumber * 15],@"size":@15,@"qqianId":qqianID}
                    returnClass:[self class]
                          block:^(HSGHUpViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,obj.upUserVos);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"upUserVos" : [HSGHHomeUserInfo class] };
}
@end
