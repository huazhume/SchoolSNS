//
//  HSGHServerInterfaceUrl.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 24/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHServerInterfaceUrl.h"


@interface HSGHServerInterfaceUrl ()

@end


@implementation HSGHServerInterfaceUrl

+ (NSString *)LoginURL {
    return HSGHServerLoginURL;
}

+ (BOOL)isSignatureBlackList:(NSString *)url {
    NSArray *blackList = @[
            HSGHServerGetTicketURL,
            HSGHServerVerityTicketURL,
            HSGHVerifyRenewalURL,
            HSGHServerForgetPSDURL,
            HSGHServerResetPSDURL,
            HSGHServerLoginURL,
            HSGHServerRegisterURL,
            HSGHFetchCityURL,
            HSGHFileUploadURL,
            HSGHFetchUnivURL,
            HSGHFetchAllUnivURL,
            HSGHHomeTestURL,
    ];

    for (NSString *u in blackList) {
        if ([u isEqualToString:url]) {
            return true;
        }
    }

    return false;
}

+ (NSString*)deleteHost:(NSString*)url {
    NSString* str = HSGHServerLoginHost;
    
    return [url substringFromIndex:str.length - 1];
}

@end
