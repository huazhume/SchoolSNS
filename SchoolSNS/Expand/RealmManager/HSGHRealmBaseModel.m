//
//  HSGHRealmBaseModel.m
//  RealmManager
//
//  Created by Huaral on 2017/4/28.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import "HSGHRealmBaseModel.h"

@implementation HSGHRealmBaseModel

// Specify default values for properties


/**
 设置主键

 @return 主键key
 */

//+(NSString *)primaryKey{
//    return @"";
//}

/**
 默认属性

 @return 属性键值字典
 */
+ (NSDictionary *)defaultPropertyValues
{
    return @{};
}

// Specify properties to ignore (Realm won't persist these)

/**
 属性忽略
 
 @return 需要忽略本地化的属性
 */
+ (NSArray *)ignoredProperties
{
    return @[];
}

@end
