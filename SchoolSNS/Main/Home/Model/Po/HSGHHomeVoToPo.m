//
//  HSGHHomeVoToPo.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeVoToPo.h"

@implementation HSGHHomeVoToPo

+ (HSGHHomeQQianPo*)qqianVoToPo:(HSGHHomeQQianModel*)vo WithType:(HOME_MODE)mode
{
    HSGHHomeQQianPo* po = [HSGHHomeQQianPo new];
    po.contentIsMore = vo.contentIsMore;
    po.type = [NSNumber numberWithInt:mode];
    po.content = vo.content;
    po.createTime = vo.createTime;
    po.forwardCount = vo.forwardCount;
    po.qqianId = vo.qqianId;
    po.replyCount = vo.replyCount;
    po.isSelf = vo.isSelf;
    po.friendStatus = vo.friendStatus;
    po.up = vo.up;
    po.upCount = vo.upCount;
    po.image = [self imageVoToPo:vo.image];
    po.owner = [self ownerVoToPo:vo.owner];
    po.address = [self addressVoToPo:vo.address];
    po.creator = [self creatorVoToPo:vo.creator];
    [self forward:po.partForword VoToPo:vo.partForword];
    [self replay:po.partReplay VoToPo:vo.partReplay];
    [self up:po.partUp VoToPo:vo.partUp];
    return po;
}
+ (void)replay:(RLMArray<HSGHHomeReplayPo*>*)poArr VoToPo:(NSArray<HSGHHomeReplay*>*)voArr
{
    [voArr enumerateObjectsUsingBlock:^(HSGHHomeReplay* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        HSGHHomeReplayPo* po = [self replayVoToPo:obj];
        [poArr addObject:po];
    }];
}
+ (void)up:(RLMArray<HSGHHomeUpPo*>*)poArr VoToPo:(NSArray<HSGHHomeUp*>*)voArr
{
    [voArr enumerateObjectsUsingBlock:^(HSGHHomeUp* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        HSGHHomeUpPo* po = [self upVoToPo:obj];
        [poArr addObject:po];
    }];
}
+ (void)forward:(RLMArray<HSGHHomeForwardPo*>*)poArr VoToPo:(NSArray<HSGHHomeForward*>*)voArr
{
    [voArr enumerateObjectsUsingBlock:^(HSGHHomeForward* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        HSGHHomeForwardPo* po = [self forwardVoToPo:obj];
        [poArr addObject:po];
    }];
}
+ (HSGHHomeImagePo*)imageVoToPo:(HSGHHomeImage*)vo
{
    HSGHHomeImagePo* homeImage = [HSGHHomeImagePo new];
    homeImage.srcUrl = vo.srcUrl;
    homeImage.srcSize = vo.srcSize;
    homeImage.thumbWidth = vo.thumbWidth;
    homeImage.thumbHeight = vo.thumbHeight;
    homeImage.thumbUrl = vo.thumbUrl;
    homeImage.srcHeight = vo.srcHeight;
    homeImage.key = vo.key;
    homeImage.srcWidth = vo.srcWidth;
    homeImage.thumbSize = vo.thumbSize;
    return homeImage;
}

+ (HSGHHomeUniversityPo*)universityVoToPo:(HSGHHomeUniversity*)vo
{
    HSGHHomeUniversityPo* po = [HSGHHomeUniversityPo new];
    po.iconUrl = vo.iconUrl;
    po.name = vo.name;
    po.univId = vo.univId;
    return po;
}

+ (HSGHHomeAddressPo*)addressVoToPo:(HSGHHomeAddress*)vo
{
    HSGHHomeAddressPo* po = [HSGHHomeAddressPo new];
    po.data = vo.data;
    po.latitude = vo.latitude;
    po.longitude = vo.longitude;
    po.address = vo.address;
    return po;
}

+ (HSGHHomeUserInfoPo*)creatorVoToPo:(HSGHHomeUserInfo *)vo
{
    HSGHHomeUserInfoPo* po = [HSGHHomeUserInfoPo new];
    po.picture = [self imageVoToPo:vo.picture];
    po.unvi = [self universityVoToPo:vo.unvi];
    po.displayName = vo.displayName;
    po.fullName = vo.fullName;
    po.userId = vo.userId;
    return po;
}

+ (HSGHHomeUserInfoPo *)ownerVoToPo:(HSGHHomeUserInfo *)vo
{
    HSGHHomeUserInfoPo* po = [HSGHHomeUserInfoPo new];
    po.picture = [self imageVoToPo:vo.picture];
    po.unvi = [self universityVoToPo:vo.unvi];
    po.displayName = vo.displayName;
    po.fullName = vo.fullName;
    po.userId = vo.userId;
    return po;
}

+ (HSGHHomeForwardPo*)forwardVoToPo:(HSGHHomeForward*)vo
{
    HSGHHomeForwardPo* po = [HSGHHomeForwardPo new];
    po.toUser = [self ownerVoToPo:vo.toUser];
    po.fromUser = [self ownerVoToPo:vo.fromUser];
    po.content = vo.content;
    po.replayParentId = vo.replayParentId;
    po.up = vo.up;
    po.replayId = vo.replayId;
    po.createTime = vo.createTime;
    po.upCount = vo.upCount;
    return po;
}

+ (HSGHHomeReplayPo*)replayVoToPo:(HSGHHomeReplay*)vo
{
    HSGHHomeReplayPo* po = [HSGHHomeReplayPo new];
    po.toUser = [self ownerVoToPo:vo.toUser];
    po.fromUser = [self ownerVoToPo:vo.fromUser];
    po.content = vo.content;
    po.replayParentId = vo.replayParentId;
    po.up = vo.up;
    po.replayId = vo.replayId;
    po.createTime = vo.createTime;
    po.upCount = vo.upCount;
    return po;
}

+ (HSGHHomeUpPo*)upVoToPo:(HSGHHomeUp*)vo
{
    HSGHHomeUpPo* po = [HSGHHomeUpPo new];
    po.picture = [self imageVoToPo:vo.picture];
    po.unvi = [self universityVoToPo:vo.unvi];
    po.nickName = vo.nickName;
    po.fullName = vo.fullName;
    po.userId = vo.userId;
    return po;
    
}
@end
