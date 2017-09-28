//
//  NSString+BFLExt.h
//  BFLive
//
//  Created by BaoFeng on 15/7/16.
//  Copyright (c) 2015年 BF. All rights reserved.
//

@interface NSString (Common)


//email的正则表达式
+ (BOOL) validateEmail:(NSString *)email;
- (NSString *)trim;
- (BOOL)isEmpty;
//根据字体、宽度、行间距计算文本的高度
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width space:(CGFloat)space;
//根据字体、计算文本的宽度
- (CGFloat)widthForFont:(UIFont *)font;
@end

//HMAC_SHA加密
@interface NSString (HMAC_SHA)
+ (NSString *)HMAC_SHA1:(NSString *)key Value:(NSString *)value;
@end


//MD5加密
@interface NSString (MD5)
- (NSString*) MD5;
@end


@interface NSString (urlEncode)
- (NSString *)urlEncodedString;
+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param;
@end


@interface NSString (Emoji)
/**是否包含emoji*/
- (BOOL)isContainsEmoji;
@end

//NSString Json串转数组或字典
@interface NSString (JSON)
- (id)JSONValue;
@end


@interface NSString (Topics)
- (NSString *)topicLayerInfo;
- (NSString *)topicUpdateCountInfo;
- (NSString *)topicCountInfo;
@end

@interface NSString (UrlQueryToDictionary)

- (NSDictionary *)stringSeparatedToDictionary;
+(NSString *)modelTurnToJsonStr:(NSArray*)dictArray;

+(NSString *)dictTurnToJsonStr:(NSDictionary*)dict;

@end
