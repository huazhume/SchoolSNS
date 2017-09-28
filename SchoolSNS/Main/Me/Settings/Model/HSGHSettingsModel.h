//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHLoginNetRequest.h"
#import "HSGHRegisterNetRequest.h"

@interface HSGHSettingsModel : NSObject
typedef NS_ENUM(NSUInteger, UnivStatus) {
    UnivStatusOnline = 2,
    UnivStatusGraduation = 3
};


+ (void)resetPassword:(NSString *)oldPSD newPSD:(NSString*)newPSD block:(void (^)(BOOL success))fetchBlock;
+ (void)suggest:(NSString *)message type:(NSUInteger)type block:(void (^)(BOOL success))fetchBlock;
+ (void)report:(NSString *)message type:(NSUInteger)type  userId:(NSString*)userId block:(void (^)(BOOL success))fetchBlock;
+ (void)sendVerityCode:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)binding:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)unbinding:(HSGHLoginUserModel *)userModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)showUniv:(BOOL)status block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUser:(BOOL)isComplete block:(void (^)(BOOL success, NSString* errorMsg))fetchBlock;


+ (void)ModifyUserSignature:(NSString*)signature block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUserName:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUserCHName:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUserEngName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUserImage:(UIImage*)image  isBgImage:(BOOL)isBgImage  block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyNotification:(BOOL)agree apply:(BOOL)apply at:(BOOL)at reply:(BOOL)reply up:(BOOL)up block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyPrivacy:(BOOL)showQQianAlumni showQQianStranger:(BOOL)showQQianStranger searchByName:(BOOL)searchByName
             showUniv:(BOOL)showUniv displayMode:(NSUInteger)displayMode block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUersDisplayNameMode:(NSUInteger)displayMode block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)modifyUersSchoolInfo:(HSGHRegisterNetModel*)netModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock;

+ (void)modifyAndDeleteSchoolInfo:(HSGHRegisterNetModel*)netModel block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
+ (void)defaultFixesName;

+ (void)modifyCityID:(NSString *)cityID block:(void (^)(BOOL success, NSString* errDes))fetchBlock;
@end
