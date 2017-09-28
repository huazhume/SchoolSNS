//
//  HSGHRegisterNetRequest.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 25/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHRegisterNetRequest.h"
#import "HSGHNetworkSession.h"
#import "HSGHTools.h"
#import "NSObject+YYModel.h"
#import "HSGHLoginNetRequest.h"
#import "HSGHUploadPicNetRequest.h"
#import "HSGHSettingsModel.h"

@implementation HSGHRegisterbachelorUniv
- (instancetype)init {
    self = [super init];
    if (self) {
//        self.univId = @"";
//        self.univStatus = UnivStatusOnline;
//        self.univIn = @"";
//        self.univIn = @"";
    }
    return self;
}

@end

@implementation HSGHRegisterNetModel

+ (instancetype)singleInstance {
    static HSGHRegisterNetModel *netModel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!netModel) {
            netModel = [self new];
            netModel.bachelorUniv = [HSGHRegisterbachelorUniv new];
            netModel.masterUniv = [HSGHRegisterbachelorUniv new];
            netModel.highSchool = [HSGHRegisterbachelorUniv new];
        }
    });
    return netModel;
}

- (HSGHLoginUserModel*)createLoginModel {
    HSGHLoginUserModel* userModel = [HSGHLoginUserModel new];
    userModel.isEmail = NO;
    userModel.phoneCode = self.phoneCode;
    userModel.phoneNumber = self.phoneNumber;
    return userModel;
}

@end

@implementation HSGHRegisterNetRequest
+ (void)requestFirstStep:(void (^)(BOOL success, BOOL hasExist, NSString *errorMsg))fetchBlock {
    HSGHRegisterNetModel* requestModel = [HSGHRegisterNetModel singleInstance];
    NSMutableDictionary* requestDic = [NSMutableDictionary new];
    requestDic[@"phoneNumber"] = UN_NIL_STR(requestModel.phoneNumber);
    requestDic[@"phoneCode"] = UN_NIL_STR(requestModel.phoneCode);
    requestDic[@"verifyCode"] = UN_NIL_STR(requestModel.verifyCode);
    requestDic[@"password"] = UN_NIL_STR(requestModel.password);
    [HSGHNetworkSession postReq:HSGHServerRegisterURL
                   appendParams:requestDic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) { //注册成功，走登入
                                  [HSGHLoginNetRequest login:[requestModel createLoginModel] password:requestModel.password block:^(BOOL success) {
                                      if (fetchBlock) {
                                          fetchBlock(success, NO, errorDes);
                                      }
                                  }];
                              }
                              else if (status == NetResUserExisted) {
                                  if (fetchBlock) {
                                      fetchBlock(NO, YES, errorDes);
                                  }
                              }
                              else {
                                  if (fetchBlock) {
                                      fetchBlock(false, NO, errorDes);
                                  }
                              }
                          }];
}



+ (void)request:(void (^)(BOOL success, NSString* errorMsg))fetchBlock {
    HSGHRegisterNetModel* requestModel = [HSGHRegisterNetModel singleInstance];
    if (!requestModel.imageKey) {
        [HSGHUploadPicNetRequest upload:[HSGHUploadPicNetRequest convertToNSData:requestModel.image] block:^(BOOL success, NSString *key, NSString *name) {
            if (success && key) {
                requestModel.imageKey = key;
                NSMutableDictionary* requestDic = [NSMutableDictionary new];
                if (requestModel.bachelorUniv.univId) {
                    if (requestModel.bachelorUniv.univOut) {
                        requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(requestModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(requestModel.bachelorUniv.univIn), @"univOut":UN_NIL_STR(requestModel.bachelorUniv.univOut), @"univStatus":@(requestModel.bachelorUniv.univStatus)};
                    }
                    else {
                        requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(requestModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(requestModel.bachelorUniv.univIn), @"univStatus":@(requestModel.bachelorUniv.univStatus)};
                    }
                }
                
                requestDic[@"phoneNumber"] = UN_NIL_STR(requestModel.phoneNumber);
                requestDic[@"phoneCode"] = UN_NIL_STR(requestModel.phoneCode);
                requestDic[@"verifyCode"] = UN_NIL_STR(requestModel.verifyCode);
                requestDic[@"password"] = UN_NIL_STR(requestModel.password);
                requestDic[@"firstName"] = UN_NIL_STR(requestModel.firstName);
                requestDic[@"homeCityId"] = UN_NIL_STR(requestModel.homeCityId);
                requestDic[@"imageKey"] = UN_NIL_STR(requestModel.imageKey);
                requestDic[@"lastName"] = UN_NIL_STR(requestModel.lastName);
                requestDic[@"nickName"] = UN_NIL_STR(requestModel.nickName);
                if (requestModel.bachelorUniv.univStatus == UnivStatusGraduation && requestModel.masterUniv.univId) {
                    if (requestModel.masterUniv.univId != nil && requestModel.masterUniv.univIn != nil) {
                        if (requestModel.masterUniv.univOut) {
                            requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(requestModel.masterUniv.univId), @"univIn":UN_NIL_STR(requestModel.masterUniv.univIn), @"univOut":UN_NIL_STR(requestModel.masterUniv.univOut), @"univStatus":@(requestModel.masterUniv.univStatus)};
                        }
                        else {
                            requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(requestModel.masterUniv.univId), @"univIn":UN_NIL_STR(requestModel.masterUniv.univIn),  @"univStatus":@(requestModel.masterUniv.univStatus)};
                        }
                    }
                }
                
                if (requestModel.highSchool.univId) {
                    requestDic[@"highSchool"] = @{@"univId":UN_NIL_STR(requestModel.highSchool.univId), @"univIn":UN_NIL_STR(requestModel.highSchool.univIn), @"univStatus":@(requestModel.highSchool.univStatus)};
                }
                requestDic[@"sex"] = @(requestModel.sex);
                
                [HSGHNetworkSession postReq:HSGHServerRegisterURL
                               appendParams:requestDic
                                returnClass:nil
                                      block:^(id obj, NetResStatus status, NSString *errorDes) {
                                          if (status == NetResSuccess) { //注册成功，走登入
                                              [HSGHLoginNetRequest login:[requestModel createLoginModel] password:requestModel.password block:^(BOOL success) {
                                                  if (fetchBlock) {
                                                      fetchBlock(success, errorDes);
                                                  }
                                              }];
                                          }
                                          else {
                                              if (fetchBlock) {
                                                  fetchBlock(false, errorDes);
                                              }
                                          }
                                      }];
            }
            else {
                if (fetchBlock) {
                    fetchBlock(false, @"");
                }
            }
        }];
    }
    else {
        {
            NSMutableDictionary* requestDic = [NSMutableDictionary new];
            if (requestModel.bachelorUniv.univId) {
                if (requestModel.bachelorUniv.univOut) {
                    requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(requestModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(requestModel.bachelorUniv.univIn), @"univOut":UN_NIL_STR(requestModel.bachelorUniv.univOut), @"univStatus":@(requestModel.bachelorUniv.univStatus)};
                }
                else {
                    requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(requestModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(requestModel.bachelorUniv.univIn), @"univStatus":@(requestModel.bachelorUniv.univStatus)};
                }
            }
            
            requestDic[@"phoneNumber"] = UN_NIL_STR(requestModel.phoneNumber);
            requestDic[@"phoneCode"] = UN_NIL_STR(requestModel.phoneCode);
            requestDic[@"verifyCode"] = UN_NIL_STR(requestModel.verifyCode);
            requestDic[@"password"] = UN_NIL_STR(requestModel.password);
            requestDic[@"firstName"] = UN_NIL_STR(requestModel.firstName);
            requestDic[@"homeCityId"] = UN_NIL_STR(requestModel.homeCityId);
            requestDic[@"imageKey"] = UN_NIL_STR(requestModel.imageKey);
            requestDic[@"lastName"] = UN_NIL_STR(requestModel.lastName);
            requestDic[@"nickName"] = UN_NIL_STR(requestModel.nickName);
            if (requestModel.bachelorUniv.univStatus == UnivStatusGraduation && requestModel.masterUniv.univId) {
                if (requestModel.masterUniv.univId != nil && requestModel.masterUniv.univIn != nil) {
                    if (requestModel.masterUniv.univOut) {
                        requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(requestModel.masterUniv.univId), @"univIn":UN_NIL_STR(requestModel.masterUniv.univIn), @"univOut":UN_NIL_STR(requestModel.masterUniv.univOut), @"univStatus":@(requestModel.masterUniv.univStatus)};
                    }
                    else {
                        requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(requestModel.masterUniv.univId), @"univIn":UN_NIL_STR(requestModel.masterUniv.univIn),  @"univStatus":@(requestModel.masterUniv.univStatus)};
                    }
                }
            }
            
            if (requestModel.highSchool.univId) {
                requestDic[@"highSchool"] = @{@"univId":UN_NIL_STR(requestModel.highSchool.univId), @"univIn":UN_NIL_STR(requestModel.highSchool.univIn), @"univStatus":@(requestModel.highSchool.univStatus)};
            }
            
            requestDic[@"sex"] = @(requestModel.sex);
            
            
            [HSGHNetworkSession postReq:HSGHServerRegisterURL
                           appendParams:requestDic
                            returnClass:nil
                                  block:^(id obj, NetResStatus status, NSString *errorDes) {
                                      if (status == NetResSuccess) { //注册成功，走登入
                                          [HSGHLoginNetRequest login:[requestModel createLoginModel] password:requestModel.password block:^(BOOL success) {
                                              if (fetchBlock) {
                                                  fetchBlock(success, @"");
                                              }
                                          }];
                                      }
                                      else {
                                          if (fetchBlock) {
                                              fetchBlock(false, errorDes);
                                          }
                                      }
                                  }];
        }
    }
    
}


@end
