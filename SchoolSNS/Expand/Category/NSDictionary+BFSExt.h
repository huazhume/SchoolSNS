//
//  NSDictionary+BFLExt.h
//  BFLive
//
//  Created by Baofeng on 15/12/9.
//  Copyright (c) 2015年 BF. All rights reserved.
//
//  json解析容错


@interface NSDictionary (String)

/**
 *  json解析要求返回string类型
 *
 *
 */
- (NSString *)stringForKey:(NSString *)aKey;

/**
 *  json解析要求返回array类型
 *
 *
 */
- (NSArray*) arrayForKey:(NSString *)aKey;

/**
 *  json解析要求返回dict类型
 *
 *
 */
- (NSDictionary *)dictionaryForKey:(NSString *)aKey;

@end
