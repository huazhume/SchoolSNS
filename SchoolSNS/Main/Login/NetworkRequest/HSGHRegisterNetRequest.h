//
//  HSGHRegisterNetRequest.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 25/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

//Register -> Login
@interface HSGHRegisterbachelorUniv : NSObject
@property(nonatomic, copy) NSString *univId;
@property(nonatomic, assign) NSInteger univStatus;
@property(nonatomic, copy) NSString *univIn;
@property(nonatomic, copy) NSString *univOut;
@end


@interface HSGHRegisterNetModel : NSObject
@property(nonatomic, strong) HSGHRegisterbachelorUniv *bachelorUniv;
@property(nonatomic, copy) NSString *backgroud;

@property(nonatomic, copy) NSString *firstNameEn;
@property(nonatomic, copy) NSString *lastNameEn;
@property(nonatomic, copy) NSString *middleNameEn;

@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *homeCityId;
@property(nonatomic, copy) NSString *imageKey;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, strong) HSGHRegisterbachelorUniv *masterUniv;


@property(nonatomic, copy)   NSString *nickName;
//@property(nonatomic, copy) NSString *email;  //delete
@property(nonatomic, copy)   NSString *password;
@property (nonatomic, copy)  NSString *phoneCode;
@property (nonatomic, copy)  NSString *phoneNumber;

@property(nonatomic, strong) HSGHRegisterbachelorUniv *highSchool;
@property(nonatomic, assign) NSInteger sex;
@property(nonatomic, copy) NSString *verifyCode;

@property (nonatomic, strong) UIImage *image;

+ (instancetype)singleInstance;
@end

@interface HSGHRegisterNetRequest : NSObject

+ (void)requestFirstStep:(void (^)(BOOL success, BOOL hasExist, NSString *errorMsg))fetchBlock;
+ (void)request:(void (^)(BOOL success, NSString* errorMsg))fetchBlock;

@end
