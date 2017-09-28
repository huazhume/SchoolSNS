//
//  NSDictionary+BFLExt.m
//  BFLive
//
//  Created by Baofeng on 15/12/9.
//  Copyright (c) 2015年 BF. All rights reserved.
//

#import "NSDictionary+BFSExt.h"

@implementation NSDictionary (String)

- (NSString *)stringForKey:(NSString *)aKey
{
    return [self stringForKey:aKey withDefaultValue:@""];
}

- (NSString *)stringForKey:(NSString *)aKey withDefaultValue:(NSString *)defValue
{
    id value = [self objectForKey:aKey];
   
    if ((value && [value isKindOfClass:[NSNumber class]]) || (value && [value isKindOfClass:[NSString class]])) {
        
         return [NSString stringWithFormat:@"%@",value];
        
    }else{
        
         return [NSString stringWithFormat:@"%@",defValue];
   
    }
   
}

- (NSArray *)arrayForKey:(NSString *)aKey
{
    id value = [self objectForKey:aKey];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }else{
        return [[NSArray alloc] init];
    }
}

- (NSDictionary *)dictionaryForKey:(NSString *)aKey
{
    id value = [self objectForKey:aKey];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }else{
        return [[NSDictionary alloc] init];
    }
}

@end

