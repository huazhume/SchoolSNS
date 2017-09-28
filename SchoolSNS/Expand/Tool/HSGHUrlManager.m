//
//  HSGHUrlManager.m
//  HSGHNBC
//
//  Created by Qianqian li on 2017/2/16.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHUrlManager.h"

@implementation HSGHUrlManager

+ (NSString *)requestTopicURL:(NSString *)svcCode
{
    
    
   return [NSString stringWithFormat:@"%@/%@",KRequestAddressURL, svcCode];

}



@end
