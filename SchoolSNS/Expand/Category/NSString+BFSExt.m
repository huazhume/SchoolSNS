//
//  NSString+BFLExt.m
//  BFLive
//
//  Created by BaoFeng on 15/7/16.
//  Copyright (c) 2015年 BF. All rights reserved.
//

#import "NSString+BFSExt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Common)
//email的正则表达式
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (NSString *)trim
{
    //去除前后空格和换行符
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return str;
}

- (BOOL)isEmpty
{
    NSString *trimStr = [self trim];
    if ([trimStr length] == 0)
    {
        return YES;
    }
    
    return NO;
}

- (CGFloat)widthForFont:(UIFont *)font
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width;
}
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width space:(CGFloat)space
{
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = space;
    
    NSDictionary * dict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
   
    if ([self widthForFont:font] < width) {//当是单行的时候也会有一个行间距，所以这里需要减去
        return rect.size.height-space ;
    }else{
        return rect.size.height;
    }
}
@end


@implementation NSString (HMAC_SHA)

+ (NSString *)HMAC_SHA1:(NSString *)key Value:(NSString *)value
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [value cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    return hash;
}

@end


@implementation NSString (MD5)

- (NSString*) MD5 {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [[self toHexString:output length:outputLength] uppercaseString];;
}

- (unsigned int) UTF8Length {
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

@end



@implementation NSString (urlEncode)

- (NSString *)urlEncodedString
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                     NULL,
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
}

+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}

@end


@implementation NSString (Emoji)

- (BOOL)isContainsEmoji
{
    __block BOOL isEomji = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return isEomji;
    
}


@end

@implementation NSString (JSON)

- (id)JSONValue
{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error != nil)
        return nil;
    return result;
}
@end

@implementation NSString (Topics)

-(NSString *)topicLayerInfo
{
    return [NSString stringWithFormat:@"已盖到%@楼",self];
}

-(NSString *)topicUpdateCountInfo
{
    long long updateCount = [self longLongValue];
    
    if(updateCount >=0 && updateCount < 100){
        return [NSString stringWithFormat:@"%lld",updateCount];
    }else if(updateCount >= 100){
        return @"99+";
    }else
    {
        HSLog(@"updateCount is a invalide value");
        return @"#N/A";
    }
}

-(NSString *)topicCountInfo
{
    return [NSString stringWithFormat:@"已有%@个话题",self];
}

@end


@implementation NSString (UrlQueryToDictionary)

- (NSDictionary *)stringSeparatedToDictionary;
{
    NSArray *paramArray = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    for (NSString *itemStr in paramArray){
        NSRange equalRange = [itemStr rangeOfString:@"="];
        if (equalRange.location == NSNotFound) {
            continue;
        }
        NSString *itemKey = [itemStr substringToIndex:equalRange.location];
        NSString *itemValue = itemStr.length > equalRange.location+equalRange.length ? [itemStr substringFromIndex:equalRange.location+equalRange.length] : @"";
        if (itemKey && itemValue) {
            [paramDict setObject:itemValue forKey:itemKey];
        }
    }
    return paramDict;
}
+(NSString *)modelTurnToJsonStr:(NSArray*)dictArray
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSMutableString * newStr = [[NSMutableString alloc]initWithString:jsonString];
    NSMutableString * str1 = [[NSMutableString alloc]initWithString:[newStr stringByReplacingOccurrencesOfString: @"\r" withString:@""]];
    NSString * str2 = [str1 stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    
    return str2;
}

+(NSString *)dictTurnToJsonStr:(NSDictionary*)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableString * newStr = [[NSMutableString alloc]initWithString:jsonString];
    NSMutableString * str1 = [[NSMutableString alloc]initWithString:[newStr stringByReplacingOccurrencesOfString: @"\r" withString:@""]];
    NSString * str2 = [str1 stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    return str2;

}

@end
