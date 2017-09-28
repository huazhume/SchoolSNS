//
//  HSGHAtViewModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHAtViewModel.h"
#import "HSGHFriendViewModel.h"

@implementation HSGHAtViewModel

+ (NSArray *)predicateArr:(NSArray<HSGHFriendSingleModel *> *)arr WithKey:(NSString *)key {
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"(nickName CONTAINS[c] %@ ) or ( nickName MATCHES %@ )", key,key];
    return [NSArray arrayWithArray:[arr filteredArrayUsingPredicate:preicate]];
}
@end
