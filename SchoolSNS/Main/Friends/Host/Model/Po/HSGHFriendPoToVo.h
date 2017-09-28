//
//  HSGHFriendPoToVo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSGHFriendPo.h"
#import "HSGHFriendViewModel.h"
#import "HSGHHomePoToVo.h"
@interface HSGHFriendPoToVo : NSObject

+(HSGHFriendSingleModel *)friendPoToVo:(HSGHFriendPo *)po ;
@end
