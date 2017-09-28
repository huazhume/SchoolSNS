//
// Created by FlyingPuPu on 27/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSGHTools : NSObject
+ (BOOL)ImageDataHasPNGPrefix:(NSData *)data;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (BOOL)isValidatePassword:(NSString *)password;

+ (BOOL)isValidateNickName:(NSString *)name;

+ (BOOL)isValidateVerityCode:(NSString*)code;

//国际通用匹配
+ (BOOL)isValidateAboradPhoneNumber:(NSString *)phonenumber;

+ (BOOL)isValidateCNPhoneNumber:(NSString *)phonenumber;
+ (BOOL)isValidatedPhone: (NSString*)phone phoneCode:(NSString*)phoneCode;


+ (NSURL *)smartURLForString:(NSString *)str;

+ (NSString *)getmd5WithString:(NSString *)string;

+ (NSString *)getMD5WithData:(NSData *)data;

+ (NSString *)getFileMD5WithPath:(NSString *)path;

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)converTimeStamp:(NSUInteger)timeInt;

+ (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (UIFont *)customFontWithPath:(NSString *)path size:(CGFloat)size;

+ (UIFont *)currentFont:(CGFloat)size;

+ (BOOL)isBoldFont:(UIFont *)font;

+ (void)setLineSpaceWithString:(UILabel *)label space:(CGFloat)space;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (CALayer *)lineWithLength:(CGFloat)length atPoint:(CGPoint)point;

+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

+ (NSDictionary *)convertObjectToDic:(id)obj;

+ (CGFloat)widthOfString:(NSString *)string
font:(UIFont *)font
                  height:(CGFloat)height;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (NSString *)dateFormatter:(NSString *)dateString timeZong:(NSString *) utc ;

+ (CGSize)getWidthWidthString:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate ;

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate ;

+ (NSUInteger)calcLabelRows:(UILabel*)label text:(NSString*)text;
+ (CGFloat)calcLabelHeight:(UILabel*)label text:(NSString*)text;


+ (NSString *)nowTimeStringWithDate:(NSDate *)timeDate;
+ (NSString*)getUTCDateString:(NSString*)utcDate ;

+ (void)writeNSDataToFile:(NSData*)data name:(NSString*)name;
+ (CGFloat)widthOfLab:(UILabel *)lab ;
+ (NSString*)getUTCFormateLocalDate ;
+ (CGFloat)getTextViewHeightString:(NSString*)text font:(UIFont*)font width:(CGFloat)width;

+ (NSString*)getDateString:(NSString*)utcDate;
@end
