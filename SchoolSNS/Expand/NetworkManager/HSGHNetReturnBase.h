//
// Created by FlyingPuPu on 28/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSGHNetReturnBase : NSObject
@property(nonatomic, assign) int resultCode;
@property(nonatomic, copy) NSString *resultDesc;

@property(nonatomic, assign, readonly, getter=isSuccess) BOOL success;
@end