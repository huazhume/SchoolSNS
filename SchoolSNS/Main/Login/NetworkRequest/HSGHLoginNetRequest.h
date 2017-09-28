//
//  HSGHLoginNetRequest.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 25/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHLoginUserModel : NSObject
@property (nonatomic, assign) NSUInteger category;  //1.注册 2.忘记密码
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phoneCode;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) BOOL isEmail;

@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *secondPSD;

@end

@interface HSGHLoginNetRequest : NSObject
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *renewal;

+ (void)forgetPassword:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errorDes))fetchBlock;
+ (void)login:(HSGHLoginUserModel *)userModel password:(NSString *)password block:(void (^)(BOOL success))fetchBlock;
+ (void)sendVerityCode:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, BOOL userIsExisted,NSString* errDes))fetchBlock;
+ (void)getUserInfo:(void (^)(BOOL success))fetchBlock;
+ (void)getUserSettings:(void (^)(BOOL))fetchBlock;
+ (void)renewTicket:(void (^)(BOOL success))fetchBlock;
@end


@interface UnivSingle: NSObject<NSSecureCoding>
@property (nonatomic, copy) NSString *univId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) NSInteger city; //1国内，其他国外
@property (nonatomic, assign) NSInteger educationalLevel;

@end

@interface HSGHFetchUniv: NSObject<NSSecureCoding>
@property (nonatomic, strong) NSArray *universities;

+ (void)fetch:(NSString *)searchKey isAll:(BOOL)isAll isHighSchool:(BOOL)isHighSchool block:(void (^)(BOOL success, NSArray *array))fetchBlock;
@end
