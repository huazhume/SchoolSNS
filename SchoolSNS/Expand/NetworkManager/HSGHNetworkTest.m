//
// Created by FlyingPuPu on 28/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHNetworkTest.h"
#import "HSGHNetworkSession.h"

@implementation SubUser

@end

@implementation HSGHNetworkTest {

}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [SubUser class],
            @"img": SubUser.class,
            @"script_ver": @"script_ver",
            @"script_download": @"script_download",
            @"script_lowest_ver": @"script_lowest_ver"};
}


+ (void)TestRequest {
    [HSGHNetworkSession postReq:@"http://localhost:8080/FPPServer"
                   appendParams:nil
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status, NSString *errorDes) {
                              HSLog(@"");
                          }];
}
@end
