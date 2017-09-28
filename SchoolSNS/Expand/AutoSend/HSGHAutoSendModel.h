//
//  HSGHDownloadModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/4/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


#define HSGHAutoSendHeadIconNotification             @"HSGHAutoSendHeadIconNotification"
#define HSGHAutoSendBgImageNotification              @"HSGHAutoSendBgImageNotification"
#define HSGHAutoSendSignatureNotification            @"HSGHAutoSendSignatureNotification"


@interface HSGHAutoSendModel : NSObject
+ (instancetype)singleInstance;
- (void)start;
- (void)stop;


@end
