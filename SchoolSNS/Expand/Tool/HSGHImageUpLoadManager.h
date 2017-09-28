//
//  HSGHImageUpLoadManager.h
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/30.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^upLoadCompleteBlock)(NSString * jsonStr);

@interface HSGHImageUpLoadManager : NSObject
+(void)upLoadPicToServerWithImages:(NSArray *)array compleBlock:(upLoadCompleteBlock)block;

@end
