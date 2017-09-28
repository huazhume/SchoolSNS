//
//  HSGHInspectNetwork.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHInspectNetwork.h"
#import "Reachability.h"


@implementation HSGHInspectNetwork
+(RQNetworkType)inspectNetwork
{
    RQNetworkType networkType = RQNoNetwork;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            networkType = RQNoNetwork;
            //无网络
            break;
        case ReachableViaWWAN:
            networkType = RQYesNetworkWAN;
            //3g网络
            break;
        case ReachableViaWiFi:
            networkType = RQYesNetworkWiFi;
            //wifi网络
            break;
        default:
            break;
    }
    return networkType;
}

@end
