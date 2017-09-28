//
// Created by FlyingPuPu on 28/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubUser : NSObject

@property(nonatomic, copy) NSString *img_path;
@property(nonatomic, copy) NSString *type;

@end

@interface HSGHNetworkTest : NSObject

@property(nonatomic, copy) NSArray *list;
@property(nonatomic, strong) SubUser *img;
@property(nonatomic, copy) NSString *script_ver;
@property(nonatomic, copy) NSString *script_download;
@property(nonatomic, copy) NSString *script_lowest_ver;

+ (void)TestRequest;
@end