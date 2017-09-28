//
//  HSGHFriendPo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomePo.h"
#import "HSGHRealmBaseModel.h"

@interface HSGHFriendPo :HSGHRealmBaseModel
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, strong) HSGHHomeImagePo *picture;
@property(nonatomic, strong) HSGHHomeUniversityPo *unvi;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, strong) NSNumber<RLMInt> * status;
@property(nonatomic, copy) NSString *applyTime;
@property(nonatomic, strong) NSNumber <RLMInt> * type;
@property(nonatomic, copy) NSString *displayName;


@end
