//
//  HSGHUserDefalut.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHUserDefalut.h"

@implementation HSGHUserDefalut

+(void)saveUserAnonymtimes:(NSNumber *)times{
    NSUserDefaults * userNamedeflaut = [NSUserDefaults standardUserDefaults];
    [userNamedeflaut setObject:times  forKey:@"anonymtimes"];
    [userNamedeflaut synchronize];
}

+(NSNumber *)getAnonymtimes{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"anonymtimes"];
}
@end
