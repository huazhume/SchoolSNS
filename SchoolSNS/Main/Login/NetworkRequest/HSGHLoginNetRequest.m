//
//  HSGHLoginNetRequest.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 25/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHLoginNetRequest.h"
#import "HSGHTools.h"
#import "HSGHNetworkSession.h"
#import "HSGHUserInf.h"

@implementation HSGHLoginUserModel

@end


//GetTicker -> VerityTicker -> Renew -> getUser

@implementation HSGHLoginNetRequest
#pragma mark - internal actions

+ (void)getTicket:(HSGHLoginUserModel*)userModel block:(void (^)(BOOL, NSString *))fetchBlock {
    NSDictionary *dic;
    if (userModel.isEmail) {
        dic = @{@"email": UN_NIL_STR(userModel.email)};
    }
    else {
        dic = @{@"phoneCode": UN_NIL_STR(userModel.phoneCode), @"phoneNumber": UN_NIL_STR(userModel.phoneNumber)};
    }
    
    [HSGHNetworkSession postReq:HSGHServerGetTicketURL
                   appendParams:dic returnClass:[self class] block:^(id obj, NetResStatus status, NSString *errorDes) {
                if (fetchBlock) {
                    if (status == NetResSuccess) {
                        HSGHUserInf.shareManager.ticket = ((HSGHLoginNetRequest *) obj).ticket;
                        fetchBlock(true, ((HSGHLoginNetRequest *) obj).ticket);
                    } else {
                        fetchBlock(false, nil);
                    }
                }
            }];
}

+ (void)verityTicket:(NSString *)ticket password:(NSString *)password block:(void (^)(BOOL success))fetchBlock {
    NSString *md5 = [HSGHTools getmd5WithString:[ticket stringByAppendingString:[HSGHTools getmd5WithString:password]]];
    NSDictionary *dic = @{@"ticket": ticket, @"signature": md5};
    [HSGHNetworkSession postReq:HSGHServerVerityTicketURL
                   appendParams:dic
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  HSGHLoginNetRequest* data = obj;
                                  HSGHUserInf.shareManager.token = data.token;
                                  HSGHUserInf.shareManager.secret = data.secret;
                                  HSGHUserInf.shareManager.renewal = data.renewal;
                                  [[HSGHUserInf shareManager] saveUserDefault];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}

+ (void)renewTicket:(void (^)(BOOL success))fetchBlock {
    NSString *renewal = [HSGHUserInf shareManager].renewal;
    NSString *token = [HSGHUserInf shareManager].token;
    NSString *sercet = [HSGHUserInf shareManager].secret;
    NSDictionary *dic = @{@"renewal": UN_NIL_STR(renewal), @"token": UN_NIL_STR(token), @"sercet": UN_NIL_STR(sercet)};

    [HSGHNetworkSession postReq:HSGHVerifyRenewalURL
                   appendParams:dic
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                                  HSGHLoginNetRequest* data = obj;
                                  HSGHUserInf.shareManager.token = data.token;
                                  HSGHUserInf.shareManager.secret = data.secret;
                                  HSGHUserInf.shareManager.renewal = data.renewal;
                                  [[HSGHUserInf shareManager] saveUserDefault];
                              }
                          }];
}

+ (void)getUserInfo:(void (^)(BOOL success))fetchBlock {
    [HSGHNetworkSession postReq:HSGHGetUserURL
                   appendParams:nil
                    returnClass:[HSGHUserInf class]
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHUserInf saveFormNet: (HSGHUserInf*)obj];
                                  [HSGHLoginNetRequest getUserSettings:nil];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}

+ (void)getUserSettings:(void (^)(BOOL))fetchBlock {
    [HSGHNetworkSession postReq:HSGHGetUserSettingsURL
                   appendParams:nil
                    returnClass:[HSGHUserInf class]
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  [HSGHUserInf saveUserSettings: (HSGHUserInf*)obj];
                              }
                              
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess);
                              }
                          }];
}



#pragma mark - public actions
+ (void)sendVerityCode:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, BOOL userIsExisted, NSString* errDes))fetchBlock {
    NSDictionary *dic;
    if (userModel.isEmail) {
        dic = @{@"email": UN_NIL_STR(userModel.email), @"category":@(userModel.category)};
    }
    else {
        dic = @{@"phoneCode": UN_NIL_STR(userModel.phoneCode), @"phoneNumber": UN_NIL_STR(userModel.phoneNumber), @"category":@(userModel.category)};
    }
    
    [HSGHNetworkSession postReq:HSGHServerVerityCodeURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  if (status == NetResUserExisted) {
                                      fetchBlock(NO, YES, nil);
                                  }
                                  else {
                                      fetchBlock(status == NetResSuccess, NO, errorDes);
                                  }
                              }
                          }];
}




+ (void)login:(HSGHLoginUserModel *)userModel password:(NSString *)password block:(void (^)(BOOL success))fetchBlock {
    //1
    [self getTicket:userModel block:^(BOOL success, NSString *ticket) {
        if (success) {
            //2
            [self verityTicket:ticket password:password block:^(BOOL isSuccess) {
                //3
                if (isSuccess) {
                    [self getUserInfo:^(BOOL s) {
                        if (fetchBlock) {
                            fetchBlock(s);
                        }
                        if (s) { //Save password
                            [HSGHUserInf refreshPSD:password];
                        }
                    }];
                } else {
                    if (fetchBlock) {
                        if (fetchBlock) {
                            fetchBlock(false);
                        }
                    }
                }
            }];
        } else {
            if (fetchBlock) {
                if (fetchBlock) {
                    fetchBlock(false);
                }
            }
        }
    }];
}

+ (void)forgetPassword:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errorDes))fetchBlock {
    NSDictionary *dic ;
    if (userModel.isEmail) {
        dic = @{@"email" :  UN_NIL_STR(userModel.email), @"newPassword": UN_NIL_STR(userModel.secondPSD), @"verifyCode": UN_NIL_STR(userModel.verifyCode)};
    } else {
        dic = @{@"phoneCode" : UN_NIL_STR(userModel.phoneCode), @"phoneNumber": UN_NIL_STR(userModel.phoneNumber), @"verifyCode": UN_NIL_STR(userModel.verifyCode), @"newPassword": UN_NIL_STR(userModel.secondPSD)};
    }
    
    [HSGHNetworkSession postReq:HSGHServerResetPSDURL
                   appendParams:dic
                    returnClass:nil
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (fetchBlock) {
                                  fetchBlock(status == NetResSuccess, errorDes);
                              }
                          }];
}

@end


@interface UnivSingle ()

@end

@implementation UnivSingle
+ (BOOL)supportsSecureCoding {
    return true;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.univId forKey:@"univId"];
    [aCoder encodeInteger:self.city forKey:@"city"];
    [aCoder encodeInteger:self.educationalLevel forKey:@"educationalLevel"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.univId = [aDecoder decodeObjectForKey:@"univId"];
        self.city = [aDecoder decodeIntForKey:@"city"];
        self.educationalLevel = [aDecoder decodeIntForKey:@"educationalLevel"];
    }
    return self;
}
@end

@interface HSGHFetchUniv ()



@end

@implementation HSGHFetchUniv
#pragma mark -- coding
+ (BOOL)supportsSecureCoding {
    return true;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.universities forKey:@"universities"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.universities = [aDecoder decodeObjectForKey:@"universities"];
    }
    return self;
}


- (void)saveSchoolInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:data forKey:@"hsghSchoolInfo"];
    [user synchronize];
}

+ (HSGHFetchUniv *)restoreFormSaved {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"hsghSchoolInfo"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"universities": [UnivSingle class]};
}

+ (void)fetch:(NSString *)searchKey isAll:(BOOL)isAll isHighSchool:(BOOL)isHighSchool block:(void (^)(BOOL success, NSArray *array))fetchBlock {
    if (!isAll && searchKey.length < 1) {
        if (fetchBlock) {
            fetchBlock(NO, nil);
        }
        return;
    }
    
    //Restore form the saved if getAll
    if (isAll && !isHighSchool) {
        HSGHFetchUniv* data = [HSGHFetchUniv restoreFormSaved];
        if (data && data.universities.count > 0) {
            if (fetchBlock) {
                fetchBlock(true, data.universities);
            }
            return;
        } else {
            if (fetchBlock) {
                fetchBlock(NO, nil);
            }
        }
    }
    
    NSDictionary *dic = @{@"key": searchKey};
    [HSGHNetworkSession postReq:(isHighSchool ? HSGHFetchHighSchoolURL : (isAll ? HSGHFetchAllUnivURL : HSGHFetchUnivURL))
                   appendParams:dic
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  HSGHFetchUniv *data = obj;
                                  if (data && data.universities) {
                                      if (isAll && !isHighSchool) {
                                          [data saveSchoolInfo];
                                      }
                                      if (fetchBlock) {
                                           fetchBlock(true, data.universities);
                                      }
                                  } else {
                                      fetchBlock(true, @[]);
                                  }
                                  
                              }
                          }];
}

@end
