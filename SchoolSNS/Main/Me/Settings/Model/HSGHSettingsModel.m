//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHSettingsModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHUserInf.h"
#import "HSGHRegisterNetRequest.h"
#import "HSGHUploadPicNetRequest.h"
#import "HSGHLoginNetRequest.h"
#import "HSGHAutoSendModel.h"
#import "HSGHNameMatch.h"

@implementation HSGHSettingsModel {

}



+ (void)resetPassword:(NSString *)oldPSD newPSD:(NSString*)newPSD block:(void (^)(BOOL success))fetchBlock {
    NSDictionary *dic = @{@"newPassword": UN_NIL_STR(newPSD), @"oldPassword": UN_NIL_STR(oldPSD)};
    [HSGHNetworkSession postReq:HSGHHomeModifyPSDURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}


+ (void)suggest:(NSString *)message type:(NSUInteger)type block:(void (^)(BOOL success))fetchBlock {
    NSDictionary *dic = @{@"message": message, @"type": @(type)};
    [HSGHNetworkSession postReq:HSGHServerSuggest
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}

+ (void)report:(NSString *)message type:(NSUInteger)type  userId:(NSString*)userId block:(void (^)(BOOL success))fetchBlock {
    NSDictionary *dic = @{@"message": message, @"type": @(type), @"userId": UN_NIL_STR(userId)};
    [HSGHNetworkSession postReq:HSGHServerReport
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}


+ (void)sendVerityCode:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic;
    if (userModel.isEmail) {
        dic = @{@"email": UN_NIL_STR(userModel.email), @"category":@(userModel.category)};
    }
    else {
        dic = @{@"phoneCode": UN_NIL_STR(userModel.phoneCode), @"phoneNumber": UN_NIL_STR(userModel.phoneNumber), @"category":@(userModel.category)};
    }
    
    [HSGHNetworkSession postReq:HSGHHomeSettingsSendVerifyCodeURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  if (status == NetResUserExisted) {
                                      fetchBlock(NO, nil);
                                  }
                                  else {
                                      fetchBlock(status == NetResSuccess, errorDes);
                                  }
                              }
                          }];
}


+ (void)binding:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic;
    if (userModel.isEmail) {
        dic = @{@"email": UN_NIL_STR(userModel.email), @"verifyCode":UN_NIL_STR(userModel.verifyCode)};
    }
    else {
        dic = @{@"phoneCode": UN_NIL_STR(userModel.phoneCode), @"phoneNumber": UN_NIL_STR(userModel.phoneNumber), @"verifyCode":UN_NIL_STR(userModel.verifyCode)};
    }
    
    [HSGHNetworkSession postReq:HSGHHomeBindingURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  if (status == NetResUserExisted) {
                                      fetchBlock(NO, nil);
                                  }
                                  else {
                                      fetchBlock(status == NetResSuccess, errorDes);
                                  }
                              }
                          }];
}


+ (void)unbinding:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic;
    if (userModel.isEmail) {
        dic = @{@"email": UN_NIL_STR(userModel.email), @"verifyCode":UN_NIL_STR(userModel.verifyCode)};
    }
    else {
        dic = @{@"phoneCode": UN_NIL_STR(userModel.phoneCode), @"phoneNumber": UN_NIL_STR(userModel.phoneNumber), @"verifyCode":UN_NIL_STR(userModel.verifyCode)};
    }
    
    [HSGHNetworkSession postReq:HSGHHomeUnBindingURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  if (status == NetResUserExisted) {
                                      fetchBlock(NO, nil);
                                  }
                                  else {
                                      fetchBlock(status == NetResSuccess, errorDes);
                                  }
                              }
                          }];
}


//ShowUniv
+ (void)showUniv:(BOOL)status block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic = @{@"showUniv": @(true)};
    [HSGHNetworkSession postReq:HSGHHomeSettingsShowUnivURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  if (status == NetResUserExisted) {
                                      fetchBlock(NO, nil);
                                  }
                                  else {
                                      fetchBlock(status == NetResSuccess, errorDes);
                                  }
                              }
                          }];
}

//ModifyUser
//HSGHHomeModifyUserURL
+ (void)modifyUser:(BOOL)isComplete  block:(void (^)(BOOL success, NSString* errorMsg))fetchBlock {
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
                
                requestDic[@"firstName"] = UN_NIL_STR(requestModel.firstName);
                requestDic[@"homeCityId"] = UN_NIL_STR(requestModel.homeCityId);
                requestDic[@"imageKey"] = UN_NIL_STR(requestModel.imageKey);
                requestDic[@"lastName"] = UN_NIL_STR(requestModel.lastName);
                requestDic[@"nickName"] = UN_NIL_STR(requestModel.nickName);
                
                if (requestModel.firstNameEn && requestModel.firstName.length > 0) {
                    requestDic[@"firstNameEn"] = UN_NIL_STR(requestModel.firstNameEn.capitalizedString);
                }
                if (requestModel.middleNameEn && requestModel.middleNameEn.length > 0) {
                    requestDic[@"middleNameEn"] = UN_NIL_STR(requestModel.middleNameEn.capitalizedString);
                }
                
                if (requestModel.lastNameEn && requestModel.lastNameEn.length > 0) {
                    requestDic[@"lastNameEn"] = UN_NIL_STR(requestModel.lastNameEn.capitalizedString);
                }
                
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
                
                [HSGHNetworkSession postReq:isComplete? HSGHHomeCompleteUserURL : HSGHHomeModifyUserURL
                               appendParams:requestDic
                                returnClass:nil
                                      block:^(id obj, NetResStatus status, NSString *errorDes) {
                                          if (status == NetResSuccess) { //注册成功，走登入
                                              [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                                  if (success) {
                                                      if (fetchBlock) {
                                                          fetchBlock(true, @"");
                                                          
                                                          //注册成功后，需要自动发动头像的新鲜事
                                                          [HSGHUserInf shareManager].headIconImage = requestModel.image;
                                                          [HSGHUserInf shareManager].headIconImageKey = requestModel.imageKey;
                                                      }
                                                  }
                                                  else {
                                                      if (fetchBlock) {
                                                          fetchBlock(false, @"出了点小问题，请稍后再试");
                                                      }
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
            
            requestDic[@"firstName"] = UN_NIL_STR(requestModel.firstName);
            requestDic[@"homeCityId"] = UN_NIL_STR(requestModel.homeCityId);
            requestDic[@"imageKey"] = UN_NIL_STR(requestModel.imageKey);
            requestDic[@"lastName"] = UN_NIL_STR(requestModel.lastName);
            requestDic[@"nickName"] = UN_NIL_STR(requestModel.nickName);
            
            if (requestModel.firstNameEn && requestModel.firstName.length > 0) {
                requestDic[@"firstNameEn"] = UN_NIL_STR(requestModel.firstNameEn.capitalizedString);
            }
            if (requestModel.middleNameEn && requestModel.middleNameEn.length > 0) {
                requestDic[@"middleNameEn"] = UN_NIL_STR(requestModel.middleNameEn.capitalizedString);
            }
            
            if (requestModel.lastNameEn && requestModel.lastNameEn.length > 0) {
                requestDic[@"lastNameEn"] = UN_NIL_STR(requestModel.lastNameEn.capitalizedString);
            }
            
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
            
            
            [HSGHNetworkSession postReq:isComplete? HSGHHomeCompleteUserURL : HSGHHomeModifyUserURL
                           appendParams:requestDic
                            returnClass:nil
                                  block:^(id obj, NetResStatus status, NSString *errorDes) {
                                      if (status == NetResSuccess) { //注册成功，走登入
                                          [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                              if (success) {
                                                  if (fetchBlock) {
                                                      fetchBlock(true, @"");
                                                      
                                                      //注册成功后，需要自动发动头像的新鲜事
                                                      [HSGHUserInf shareManager].headIconImage = requestModel.image;
                                                      [HSGHUserInf shareManager].headIconImageKey = requestModel.imageKey;
                                                      
                                                  }
                                              }
                                              else {
                                                  if (fetchBlock) {
                                                      fetchBlock(false, @"出了点小问题，请稍后再试");
                                                  }
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


//ModifyUserSettings
+ (void)ModifyUserSignature:(NSString*)signature block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    if (signature == nil) {
        return;
    }
    NSDictionary *dic = @{@"signature": signature};
    [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  HSGHUserInf.shareManager.signature = signature;
                                  [HSGHUserInf.shareManager saveUserDefault];
                                  
                                  //自动发送新鲜事
                                  [[NSNotificationCenter defaultCenter] postNotificationName:HSGHAutoSendSignatureNotification object:nil];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess, errorDes);
                              }
                          }];
}


+ (void)modifyUserEngName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    if (!firstName || !lastName) {
        return;
    }
    
    NSDictionary *dic = @{@"firstNameEn": UN_NIL_STR(firstName.capitalizedString), @"middleNameEn": UN_NIL_STR(middleName.capitalizedString), @"lastNameEn": UN_NIL_STR(lastName.capitalizedString)};
    [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  HSGHUserInf.shareManager.firstNameEn = UN_NIL_STR(firstName.capitalizedString);
                                  HSGHUserInf.shareManager.middleNameEn = UN_NIL_STR(middleName.capitalizedString);
                                  HSGHUserInf.shareManager.lastNameEn = UN_NIL_STR(lastName.capitalizedString);
                                  [HSGHUserInf.shareManager saveUserDefault];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess, errorDes);
                              }
                          }];
}


+ (void)modifyUserName:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSMutableDictionary* requestDic = [NSMutableDictionary new];
    HSGHRegisterNetModel* requestModel = [HSGHRegisterNetModel singleInstance];
    requestDic[@"firstName"] = UN_NIL_STR(requestModel.firstName);
    requestDic[@"homeCityId"] = UN_NIL_STR(requestModel.homeCityId);
    requestDic[@"lastName"] = UN_NIL_STR(requestModel.lastName);
    requestDic[@"firstNameEn"] = UN_NIL_STR(requestModel.firstNameEn.capitalizedString);
    requestDic[@"middleNameEn"] = UN_NIL_STR(requestModel.middleNameEn.capitalizedString);
    requestDic[@"lastNameEn"] = UN_NIL_STR(requestModel.lastNameEn.capitalizedString);
    [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                   appendParams:requestDic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                      fetchBlock(success, nil);
                                  }];
                              }
                              else {
                                  if (fetchBlock) {
                                      fetchBlock(status == NetResSuccess, errorDes);
                                  }
                              }
                          }];
}


+ (void)modifyUserCHName:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSMutableDictionary* requestDic = [NSMutableDictionary new];
    HSGHRegisterNetModel* requestModel = [HSGHRegisterNetModel singleInstance];
    requestDic[@"firstName"] = UN_NIL_STR(requestModel.firstName);
    requestDic[@"lastName"] = UN_NIL_STR(requestModel.lastName);
    requestDic[@"firstNameEn"] = UN_NIL_STR([HSGHUserInf shareManager].firstNameEn.capitalizedString);
    requestDic[@"middleNameEn"] = UN_NIL_STR([HSGHUserInf shareManager].middleNameEn.capitalizedString);
    requestDic[@"lastNameEn"] = UN_NIL_STR([HSGHNameMatch pinyinMultiOfString:UN_NIL_STR(requestModel.lastName)]);
    
    [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                   appendParams:requestDic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                      fetchBlock(success, nil);
                                  }];
                              }
                              else {
                                  if (fetchBlock) {
                                      fetchBlock(status == NetResSuccess, errorDes);
                                  }
                              }
                          }];
}




+ (void)modifyUserImage:(UIImage*)image  isBgImage:(BOOL)isBgImage  block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    if (!image) {
        return;
    }
    
    [HSGHUploadPicNetRequest upload:[HSGHUploadPicNetRequest convertToNSData:image] block:^(BOOL success, NSString *key, NSString *name) {
        if (success && key) {
            NSDictionary *dic = @{isBgImage ? @"backgroud" : @"imageKey": UN_NIL_STR(key)};
            [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                           appendParams:dic
                            returnClass:nil
                                  block:^(id obj, NetResStatus status, NSString *errorDes) {
                                      if (status == NetResSuccess) {
                                          [HSGHLoginNetRequest getUserInfo: nil];
                                          
                                          //自动发送新鲜事
                                          if (isBgImage) {
                                              [HSGHUserInf shareManager].headBgImage = image;
                                              [HSGHUserInf shareManager].headBgImageKey = key;
                                              [[NSNotificationCenter defaultCenter] postNotificationName:HSGHAutoSendBgImageNotification object:nil];
                                          }
                                          else {
                                              [HSGHUserInf shareManager].headIconImage = image;
                                              [HSGHUserInf shareManager].headIconImageKey = key;
                                              [[NSNotificationCenter defaultCenter] postNotificationName:HSGHAutoSendHeadIconNotification object:nil];
                                          }
                                          
                                      }
                                      
                                      if (fetchBlock) {
                                          fetchBlock(status == NetResSuccess, errorDes);
                                      }
            }];
        }
        else {
            if (fetchBlock) {
                fetchBlock(NO, @"出了一点小问题，请稍后再试!");
            }
        }
    }];
}

+ (void)modifyNotification:(BOOL)agree apply:(BOOL)apply at:(BOOL)at reply:(BOOL)reply up:(BOOL)up block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic = @{@"notifyAgree" : @(agree), @"notifyApply" : @(apply), @"notifyAt" : @(at), @"notifyReply" : @(reply), @"notifyUp" : @(up)};
    [HSGHNetworkSession postReq:HSGHHomeModifyUserSettingsURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserSettings: nil];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess, errorDes);
                              }
                          }];
}

+ (void)modifyPrivacy:(BOOL)showQQianAlumni showQQianStranger:(BOOL)showQQianStranger searchByName:(BOOL)searchByName
             showUniv:(BOOL)showUniv displayMode:(NSUInteger)displayMode block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic;
    if ([HSGHUserInf hasEngName]) {
//        dic = @{@"showQQianAlumni" : @(showQQianAlumni), @"showQQianStranger" : @(showQQianStranger), @"searchByName" : @(searchByName),
//          @"showUniv" : @(showUniv), @"displayNameMode" : @(displayMode)};
        dic = @{@"searchByName" : @(searchByName),@"showUniv" : @(true), @"displayNameMode" : @(displayMode)};
    }
    else {
//        dic = @{@"showQQianAlumni" : @(showQQianAlumni), @"showQQianStranger" : @(showQQianStranger), @"searchByName" : @(searchByName),
//          @"showUniv" : @(showUniv)};
        dic = @{@"searchByName" : @(searchByName),@"showUniv" : @(true)};
    }

    [HSGHNetworkSession postReq:HSGHHomeModifyUserSettingsURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserSettings: nil];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess, errorDes);
                              }
                          }];
}

+ (void)modifyUersDisplayNameMode:(NSUInteger)displayMode block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSDictionary *dic = @{@"displayNameMode" : @(displayMode)};
    [HSGHNetworkSession postReq:HSGHHomeModifyUserSettingsURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserInfo: nil];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess, errorDes);
                              }
                          }];
}

//HSGHRegisterNetModel
+ (void)modifyUersSchoolInfo:(HSGHRegisterNetModel*)netModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSMutableDictionary *requestDic = [NSMutableDictionary new];
    
    if (netModel.bachelorUniv.univId && netModel.bachelorUniv.univId.length > 0) {
        if (netModel.bachelorUniv.univStatus == UnivStatusGraduation) {
            requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(netModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(netModel.bachelorUniv.univIn), @"univOut":UN_NIL_STR(netModel.bachelorUniv.univOut), @"univStatus":@(netModel.bachelorUniv.univStatus)};
        }
        else {
            requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(netModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(netModel.bachelorUniv.univIn),  @"univStatus":@(netModel.bachelorUniv.univStatus)};
        }
    }
    
    if (netModel.bachelorUniv.univStatus == UnivStatusGraduation && netModel.masterUniv.univId) {
        if (netModel.masterUniv.univStatus == UnivStatusGraduation) {
            requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(netModel.masterUniv.univId), @"univIn":UN_NIL_STR(netModel.masterUniv.univIn), @"univOut":UN_NIL_STR(netModel.masterUniv.univOut), @"univStatus":@(netModel.masterUniv.univStatus)};
        }
        else {
            requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(netModel.masterUniv.univId), @"univIn":UN_NIL_STR(netModel.masterUniv.univIn),  @"univStatus":@(netModel.masterUniv.univStatus)};
        }
    }
    
    
    if (netModel.highSchool.univId && netModel.highSchool.univId.length > 0) {
        requestDic[@"highSchool"] = @{@"univId":UN_NIL_STR(netModel.highSchool.univId), @"univIn":UN_NIL_STR(netModel.highSchool.univIn), @"univStatus":@(netModel.highSchool.univStatus)};
    }
    
    [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                   appendParams:requestDic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                      if (fetchBlock) {
                                          fetchBlock(success, @"出了一点小问题，请稍后再试");
                                      }
                                  }];
                              }
                              else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, errorDes);
                                  }
                              }
                          }];
}


+ (void)modifyAndDeleteSchoolInfo:(HSGHRegisterNetModel*)netModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock {
    NSMutableDictionary *requestDic = [NSMutableDictionary new];
    
    if (netModel.bachelorUniv.univId && netModel.bachelorUniv.univId.length > 0) {
        if (netModel.bachelorUniv.univStatus == UnivStatusGraduation) {
            requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(netModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(netModel.bachelorUniv.univIn), @"univOut":UN_NIL_STR(netModel.bachelorUniv.univOut), @"univStatus":@(netModel.bachelorUniv.univStatus)};
        }
        else {
            requestDic[@"bachelorUniv"] = @{@"univId":UN_NIL_STR(netModel.bachelorUniv.univId), @"univIn":UN_NIL_STR(netModel.bachelorUniv.univIn),  @"univStatus":@(netModel.bachelorUniv.univStatus)};
        }
    }
    
    if (netModel.bachelorUniv.univStatus == UnivStatusGraduation && netModel.masterUniv.univId) {
        if (netModel.masterUniv.univStatus == UnivStatusGraduation) {
            requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(netModel.masterUniv.univId), @"univIn":UN_NIL_STR(netModel.masterUniv.univIn), @"univOut":UN_NIL_STR(netModel.masterUniv.univOut), @"univStatus":@(netModel.masterUniv.univStatus)};
        }
        else {
            requestDic[@"masterUniv"] = @{@"univId":UN_NIL_STR(netModel.masterUniv.univId), @"univIn":UN_NIL_STR(netModel.masterUniv.univIn),  @"univStatus":@(netModel.masterUniv.univStatus)};
        }
    }

    
    if (netModel.highSchool.univId && netModel.highSchool.univId.length > 0) {
        requestDic[@"highSchool"] = @{@"univId":UN_NIL_STR(netModel.highSchool.univId), @"univIn":UN_NIL_STR(netModel.highSchool.univIn), @"univStatus":@(netModel.highSchool.univStatus)};
    }
    
    [HSGHNetworkSession postReq:HSGHHomeModifyUnivURL
                   appendParams:requestDic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                      if (fetchBlock) {
                                          fetchBlock(success, @"出了一点小问题，请稍后再试");
                                      }
                                  }];
                              }
                              else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, errorDes);
                                  }
                              }
                          }];
}


+ (void)defaultFixesName {
    NSString* convertName = [HSGHNameMatch pinyinMultiOfString:[HSGHUserInf shareManager].lastName].capitalizedString;
    if (![convertName isEqualToString:[HSGHUserInf shareManager].lastNameEn]) {
        NSMutableDictionary* requestDic = [NSMutableDictionary new];
        requestDic[@"lastNameEn"] = convertName;
        if ([HSGHUserInf shareManager].firstNameEn.length == 0) {
            requestDic[@"firstNameEn"] = [HSGHNameMatch pinyinMultiOfString:[HSGHUserInf shareManager].firstName].capitalizedString;
        }
        else {
            requestDic[@"firstNameEn"] = UN_NIL_STR([HSGHUserInf shareManager].firstNameEn);
        }
        requestDic[@"middleNameEn"] = UN_NIL_STR([HSGHUserInf shareManager].middleNameEn);

        [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                       appendParams:requestDic
                        returnClass:nil
                              block:^(id obj, NetResStatus status, NSString *errorDes) {
                                  if (status == NetResSuccess) {
                                      [HSGHLoginNetRequest getUserInfo:^(BOOL success) {
                                      }];
                                  }
                              }];
    }
}

+ (void)modifyCityID:(NSString *)cityID block:(void (^)(BOOL, NSString *))fetchBlock {
    [HSGHNetworkSession postReq:HSGHHomeModifyUserURL
                   appendParams:@{@"homeCityId":UN_NIL_STR(cityID)}
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  fetchBlock(YES,nil);
                              }else{
                                  fetchBlock(NO,nil);
                              }
                          }];
}

@end
