//
//  HSGHHomeModelVo.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeModel.h"
#import "NSObject+YYModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHHomeModelFrame.h"
#import "HSGHServerInterfaceUrl.h"
#import "HSGHUserInf.h"

@implementation HSGHHomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end

@implementation HSGHHomeQQianModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isSelf"  : @"self"};
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"self"]) {
        self.isSelf = value;
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"partUp" : [HSGHHomeUp class] ,@"partReplay":[HSGHHomeReplay class],@"partForword":[HSGHHomeForward class]};
}
@end
@implementation HSGHHomeAddress
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end
@implementation HSGHHomeUserInfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end
@implementation HSGHHomeImage
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end
@implementation HSGHHomeReplay
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end
@implementation HSGHHomeUp
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end
@implementation HSGHHomeForward
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end

@implementation HSGHHomeUniversity

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end








