//
//  HSGHHomePoToVo.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomePoToVo.h"

@implementation HSGHHomePoToVo

+ (HSGHHomeQQianModel*)qqianPoToVo:(HSGHHomeQQianPo*)po
{
    HSGHHomeQQianModel* vo = [HSGHHomeQQianModel new];
    vo.contentIsMore = po.contentIsMore;
    vo.content = po.content;
    vo.createTime = po.createTime;
    vo.forwardCount = po.forwardCount;
    vo.qqianId = po.qqianId;
    vo.replyCount = po.replyCount;
    vo.isSelf = po.isSelf;
    vo.friendStatus = po.friendStatus;
    vo.up = po.up;
    vo.upCount = po.upCount;
    vo.image = [self imagePoToVo:po.image];
    vo.owner = [self ownerPoToVo:po.owner];
    vo.address = [self addressPoToVo:po.address];
    vo.creator = [self creatorPoToVo:po.creator];
    [self forward:vo.partForword PoToVo:po.partForword];
    [self replay:vo.partReplay PoToVo:po.partReplay];
    [self up:vo.partUp PoToVo:po.partUp];
    return vo;
}
+ (void)replay:(NSArray<HSGHHomeReplay*>*)voArr PoToVo:(RLMArray<HSGHHomeReplayPo*>*)poArr
{
    NSMutableArray<HSGHHomeReplay*>* muArr = [NSMutableArray array];

    for (HSGHHomeReplayPo* po in poArr) {
        HSGHHomeReplay* vo = [self replayPoToVo:po];
        [muArr addObject:vo];
    }
    voArr = [NSArray arrayWithArray:muArr];
}
+ (void)up:(NSArray<HSGHHomeUp*>*)voArr PoToVo:(RLMArray<HSGHHomeUpPo*>*)poArr
{

    NSMutableArray<HSGHHomeUp*>* muArr = [NSMutableArray array];

    for (HSGHHomeUpPo* po in poArr) {
        HSGHHomeUp* vo = [self upPoToVo:po];
        [muArr addObject:vo];
    }
    voArr = [NSArray arrayWithArray:muArr];
}

+ (void)forward:(NSArray<HSGHHomeForward*>*)voArr PoToVo:(RLMArray<HSGHHomeForwardPo*>*)poArr
{

    NSMutableArray<HSGHHomeForward*>* muArr = [NSMutableArray array];

    for (HSGHHomeForwardPo* po in poArr) {
        HSGHHomeForward* vo = [self forwardPoToVo:po];
        [muArr addObject:vo];
    }
    voArr = [NSArray arrayWithArray:muArr];
}

+ (HSGHHomeImage*)imagePoToVo:(HSGHHomeImagePo*)po
{
    HSGHHomeImage* vo = [HSGHHomeImage new];
    vo.srcUrl = po.srcUrl;
    vo.srcSize = po.srcSize;
    vo.thumbWidth = po.thumbWidth;
    vo.thumbHeight = po.thumbHeight;
    vo.thumbUrl = po.thumbUrl;
    vo.srcHeight = po.srcHeight;
    vo.key = po.key;
    vo.srcWidth = po.srcWidth;
    vo.thumbSize = po.thumbSize;
    return vo;
}

+ (HSGHHomeUniversity*)universityPoToVo:(HSGHHomeUniversityPo*)po
{
    HSGHHomeUniversity* vo = [HSGHHomeUniversity new];
    vo.iconUrl = po.iconUrl;
    vo.name = po.name;
    vo.univId = po.univId;
    return vo;
}

+ (HSGHHomeAddress*)addressPoToVo:(HSGHHomeAddressPo*)po
{
    HSGHHomeAddress* vo = [HSGHHomeAddress new];
    vo.data = po.data;
    vo.latitude = po.latitude;
    vo.longitude = po.longitude;
    vo.address = po.address;
    return vo;
}

+ (HSGHHomeUserInfo *)creatorPoToVo:(HSGHHomeUserInfoPo *)po
{
    HSGHHomeUserInfo* vo = [HSGHHomeUserInfo new];
    vo.picture = [self imagePoToVo:po.picture];
    vo.unvi = [self universityPoToVo:po.unvi];
    vo.displayName = po.displayName;
    vo.fullName = po.fullName;
    vo.userId = po.userId;
    return vo;
}

+ (HSGHHomeUserInfo*)ownerPoToVo:(HSGHHomeUserInfoPo *)po
{
    HSGHHomeUserInfo * vo = [HSGHHomeUserInfo new];
    vo.picture = [self imagePoToVo:po.picture];
    vo.unvi = [self universityPoToVo:po.unvi];
    vo.displayName = po.displayName;
    vo.fullName = po.fullName;
    vo.userId = vo.userId;
    return vo;
}

+ (HSGHHomeForward*)forwardPoToVo:(HSGHHomeForwardPo*)po
{
    HSGHHomeForward* vo = [HSGHHomeForward new];
    vo.toUser = [self ownerPoToVo:po.toUser];
    vo.fromUser = [self ownerPoToVo:po.fromUser];
    vo.content = po.content;
    vo.replayParentId = po.replayParentId;
    vo.up = po.up;
    vo.replayId = po.replayId;
    vo.createTime = po.createTime;
    vo.upCount = po.upCount;
    return vo;
}

+ (HSGHHomeReplay*)replayPoToVo:(HSGHHomeReplayPo*)po
{
    HSGHHomeReplay* vo = [HSGHHomeReplay new];
    vo.toUser = [self ownerPoToVo:po.toUser];
    vo.fromUser = [self ownerPoToVo:po.fromUser];
    vo.content = po.content;
    vo.replayParentId = po.replayParentId;
    vo.up = po.up;
    vo.replayId = po.replayId;
    vo.createTime = po.createTime;
    vo.upCount = po.upCount;
    return vo;
}

+ (HSGHHomeUp*)upPoToVo:(HSGHHomeUpPo*)po
{
    HSGHHomeUp* vo = [HSGHHomeUp new];
    vo.picture = [self imagePoToVo:po.picture];
    vo.unvi = [self universityPoToVo:po.unvi];
    vo.nickName = po.nickName;
    vo.fullName = po.fullName;
    vo.userId = po.userId;
    return vo;
}

@end
