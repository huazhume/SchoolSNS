//
//  HSGHInspectNetwork.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    RQNoNetwork = 0,
    RQYesNetworkWAN,
    RQYesNetworkWiFi
}RQNetworkType;

@interface HSGHInspectNetwork : NSObject
+(RQNetworkType)inspectNetwork;//检查网络

@end
