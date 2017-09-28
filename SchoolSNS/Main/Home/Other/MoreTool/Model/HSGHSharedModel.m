//
//  HSGHSharedModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHSharedModel.h"

#import "HSGHNetworkSession.h"


@implementation HSGHSharedModel
+ (void)fetchReportWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock{
    //HSGHHomeQQiansReportURL
    [HSGHNetworkSession postReq:HSGHHomeQQiansReportURL
                   appendParams:params
                    returnClass:[self class]
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

+ (void)reportAndDeleteWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock{
    //HSGHHomeQQiansReportAndDeleteURL
    [HSGHNetworkSession postReq:HSGHHomeQQiansReportAndDeleteURL
                   appendParams:params
                    returnClass:[self class]
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
