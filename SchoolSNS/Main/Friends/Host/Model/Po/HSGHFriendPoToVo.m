//
//  HSGHFriendPoToVo.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendPoToVo.h"

@implementation HSGHFriendPoToVo

+(HSGHFriendSingleModel *)friendPoToVo:(HSGHFriendPo *)po {
    HSGHFriendSingleModel * vo = [HSGHFriendSingleModel new];
    vo.picture = [HSGHHomePoToVo imagePoToVo:po.picture];
    vo.unvi = [HSGHHomePoToVo universityPoToVo:po.unvi];
    vo.fullName = po.fullName;
    vo.nickName = po.nickName;
    vo.userId = po.userId;
    vo.status = po.status;
    vo.applyTime = po.applyTime;
    vo.displayName = po.displayName;
    return vo;
}

@end
