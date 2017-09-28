//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHBaseViewController.h"


@interface HSGHZoneVC : HSGHBaseViewController

- (instancetype)initWithUserID:(NSString *)userID;

+ (void)enterOtherZone:(NSString*)userID;

@end
