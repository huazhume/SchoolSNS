//
//  HSGHHomePo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHRealmBaseModel.h"



@interface HSGHHomePo : HSGHRealmBaseModel

@end

// AddressPo

@interface HSGHHomeAddressPo : HSGHRealmBaseModel
@property(nonatomic, copy) NSString *data;
@property(nonatomic, strong) NSNumber<RLMInt> *latitude;
@property(nonatomic, strong) NSNumber<RLMInt> *longitude;
@property(nonatomic, copy) NSString *address;
@end

// UniversityPo
@interface HSGHHomeUniversityPo : HSGHRealmBaseModel
@property(nonatomic, copy) NSString *iconUrl;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *univId;
@end

// ImagePo
@interface HSGHHomeImagePo : HSGHRealmBaseModel

@property(nonatomic, copy) NSString *srcUrl;
@property(nonatomic, strong) NSNumber<RLMInt> *srcSize;
@property(nonatomic, strong) NSNumber<RLMInt> *thumbWidth;
@property(nonatomic, strong) NSNumber<RLMInt> *thumbHeight;
@property(nonatomic, copy) NSString *thumbUrl;
@property(nonatomic, strong) NSNumber<RLMInt> *srcHeight;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, strong) NSNumber<RLMInt> *srcWidth;
@property(nonatomic, strong) NSNumber<RLMInt> *thumbSize;

@end

// CreatorPo
@interface HSGHHomeUserInfoPo : HSGHRealmBaseModel

@property(nonatomic, strong) HSGHHomeImagePo *picture;
@property(nonatomic, strong) HSGHHomeUniversityPo *unvi;
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *fullNameEn;
@property(nonatomic, copy) NSString *userId;

@end



// partForward
@interface HSGHHomeForwardPo : HSGHRealmBaseModel
@property(nonatomic, strong) HSGHHomeUserInfoPo *toUser;
@property(nonatomic, strong) HSGHHomeUserInfoPo *fromUser;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *replayParentId;
@property(nonatomic, strong) NSNumber<RLMInt> *up;
@property(nonatomic, copy) NSString *replayId;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber<RLMInt> *upCount;
@end

// partReplay

@interface HSGHHomeReplayPo : HSGHRealmBaseModel

@property(nonatomic, strong) HSGHHomeUserInfoPo *toUser;
@property(nonatomic, strong) HSGHHomeUserInfoPo *fromUser;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *replayParentId;
@property(nonatomic, assign) BOOL up;
@property(nonatomic, copy) NSString *replayId;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber<RLMInt> *upCount;
@end

// partUp
@interface HSGHHomeUpPo : HSGHRealmBaseModel

@property(nonatomic, strong) HSGHHomeImagePo *picture;
@property(nonatomic, strong) HSGHHomeUniversityPo *unvi;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *userId;
@end


RLM_ARRAY_TYPE(HSGHHomeForwardPo)
RLM_ARRAY_TYPE(HSGHHomeReplayPo)
RLM_ARRAY_TYPE(HSGHHomeUpPo)

@interface HSGHHomeQQianPo : HSGHRealmBaseModel
@property(nonatomic, strong)NSNumber<RLMInt> * type;
@property(nonatomic, strong)NSNumber<RLMInt> * contentIsMore;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber<RLMInt> *forwardCount;
@property(nonatomic, copy) NSString *qqianId;
@property(nonatomic, strong) NSNumber<RLMInt> *replyCount;
@property(nonatomic, strong) NSNumber<RLMInt> *isSelf;
@property(nonatomic, strong) NSNumber<RLMInt> * friendStatus;
@property(nonatomic, strong) NSNumber<RLMInt> *up;
@property(nonatomic, strong) NSNumber<RLMInt> *upCount;
@property(nonatomic, strong) HSGHHomeImagePo *image;
@property(nonatomic, strong) HSGHHomeUserInfoPo *owner;
@property(nonatomic, strong) HSGHHomeAddressPo *address;
@property(nonatomic, strong) HSGHHomeUserInfoPo *creator;

@property(nonatomic, strong) RLMArray<HSGHHomeForwardPo *><HSGHHomeForwardPo> *partForword;
@property(nonatomic, strong) RLMArray<HSGHHomeReplayPo *><HSGHHomeReplayPo> *partReplay;
@property(nonatomic, strong) RLMArray<HSGHHomeUpPo *><HSGHHomeUpPo> *partUp;


@end
