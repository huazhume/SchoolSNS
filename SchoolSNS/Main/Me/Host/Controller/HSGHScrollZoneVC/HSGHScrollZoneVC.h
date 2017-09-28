//
//  HSGHScrollZoneVC.h
//  SchoolSNS
//
//  Created by Murloc on 15/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeBaseViewController.h"
@class HSGHZoneModel;
@interface HSGHScrollZoneVC : HSGHHomeBaseViewController
@property (nonatomic, copy) NSString* userID;
@property (nonatomic, strong) HSGHZoneModel *model;

- (instancetype)initWithUserID:(NSString*)userID;
- (instancetype)initWithUserID:(NSString*)userID model:(HSGHZoneModel *)model;
+ (void)enterOtherZone:(NSString *)userID;

@end
