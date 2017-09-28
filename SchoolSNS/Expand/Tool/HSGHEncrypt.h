//
//  HSGHEncrypt.h
//  Https
//
//  Created by Qianqian li on 2017/2/15.
//  Copyright © 2017年 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHEncrypt : NSObject
+(instancetype)shareInstance;

-(NSDictionary *)enumerateDict:(NSDictionary *)dict;

@end
