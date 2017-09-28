//
//  HSGHEncrypt.m
//  Https
//
//  Created by Qianqian li on 2017/2/15.
//  Copyright © 2017年 zhangchao. All rights reserved.
//

#import "HSGHEncrypt.h"
#import "HSGHUserInf.h"
#import "GTMBase64.h"

#import<CommonCrypto/CommonDigest.h>

@implementation HSGHEncrypt


+(instancetype)shareInstance
{
    static HSGHEncrypt *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HSGHEncrypt alloc] init];
        
    });
    return _sharedInstance;

}

-(NSString *)enumerateDict:(NSDictionary *)dict
{
//    dict = @{@"Ab":@"shddd",
//             @"Ad":@"bbhd",
//             @"Host":@"127.0.0.1",
//             @"Time_Out":@"120000000000",
//             @"User_Id":@"jack.wu@gmail.com",
//             @"Connection":@"keep-live",
//             @"Cache-Control":@"no-cache"};
    //将header当中所有的以A（不区分大小写）开通的header值都需要取
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
 
    [dict1 setObject:@"time-out" forKey:dict[@"time-out"]];
    [dict1 setObject:@"user-account" forKey:dict[@"user_account"]];
    
//    [dict1 setObject:@"Secret_Key" forKey:[HSGHUserInf shareManager].secret_key];

    NSMutableArray * array =[NSMutableArray array];

   [dict1 enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
   
    NSString *newStr = [NSString stringWithFormat:@"%@:%@",key,obj];
    
    [array addObject:newStr];
  }];
    
    
   [array sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
    
       return [self compareTwoStr1:obj1 Str2:obj2];
   }];
    
    
    NSString * newStr = [array componentsJoinedByString:@""];
    HSLog(@"%@",newStr);

    NSString * md5Str = [self md5:newStr] ;
    NSString * sha1Str = [self encodeBase64Data:md5Str] ;

    HSLog(@"%@",md5Str);
    return sha1Str;
}

-(NSComparisonResult)compareTwoStr1:(NSString *)obj1 Str2:(NSString *)obj2
{
    
    char *cString1 = (char *)[obj1 UTF8String];
    char *cString2 = (char *)[obj2 UTF8String];
    int a = strcmp(cString1,cString2);
    if ( a > 0) {
        return NSOrderedDescending;

    }
    else if(a ==0)
    {
        return NSOrderedSame;

        
    }
    else
        return NSOrderedAscending;
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


/**< GTMBase64编码 */
- (NSString*)encodeBase64Data:(NSString *)datastr {
    
    NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];

    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


@end
