//
//  HSGHUserDefalut.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHUserDefalut : NSObject
+(void)saveUserAnonymtimes:(NSNumber *)times;
+(NSNumber *)getAnonymtimes;
@end
