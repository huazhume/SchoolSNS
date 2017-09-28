//
//  HSGHFriendVoToPo.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendVoToPo.h"

@implementation HSGHFriendVoToPo

/*@property(nonatomic, strong) NSString *fullName;
 @property(nonatomic, strong) NSString *nickName;
 @property(nonatomic, strong) HSGHHomeImagePo *picture;
 @property(nonatomic, strong) HSGHHomeUniversityPo *unvi;
 @property(nonatomic, strong) NSString *userId;
 @property(nonatomic, strong) NSNumber<RLMInt> * status;
 @property(nonatomic, strong) NSString *applyTime;
 */
+ (HSGHFriendPo *)friendVoToPo:(HSGHFriendSingleModel *)vo WithType:(FRINED_CATE_TYPE)mode {
    HSGHFriendPo * po = [HSGHFriendPo new];
    po.type = [NSNumber numberWithInt:mode];
    po.picture = [HSGHHomeVoToPo imageVoToPo:vo.picture];
    po.unvi = [HSGHHomeVoToPo universityVoToPo:vo.unvi];
    po.fullName = vo.fullName;
    po.nickName = vo.nickName;
    po.userId = vo.userId;
    po.status = vo.status;
    po.applyTime = vo.applyTime;
    po.displayName = vo.displayName;
    return po;
}

@end
