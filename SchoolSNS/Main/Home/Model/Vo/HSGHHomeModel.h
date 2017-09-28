//
//  HSGHHomeModelVo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHRealmBaseModel.h"

@class HSGHHomeModelFrame;



@interface HSGHHomeAddress : NSObject
@property(nonatomic, copy) NSString *data;
@property(nonatomic, strong) NSNumber *latitude;
@property(nonatomic, strong) NSNumber *longitude;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) float distance;
@end

@interface HSGHHomeUniversity : NSObject
@property(nonatomic, copy) NSString *iconUrl;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *univId;
@end

@interface HSGHHomeImage : NSObject

@property(nonatomic, copy) NSString *srcUrl;
@property(nonatomic, strong) NSNumber *srcSize;
@property(nonatomic, strong) NSNumber *thumbWidth;
@property(nonatomic, strong) NSNumber *thumbHeight;
@property(nonatomic, copy) NSString *thumbUrl;
@property(nonatomic, strong) NSNumber *srcHeight;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, strong) NSNumber *srcWidth;
@property(nonatomic, strong) NSNumber *thumbSize;

@end

@interface HSGHHomeUserInfo : NSObject

@property(nonatomic, strong) HSGHHomeImage *picture;
@property(nonatomic, strong) HSGHHomeUniversity *unvi;
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *fullNameEn;

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSNumber * friendStatus;

/*
 "displayName": "string",
 "fullName": "string",
 "fullNameEn": "string",
 "nickName": "string",
 */

@end

// partForward
@interface HSGHHomeForward : NSObject
@property(nonatomic, strong) HSGHHomeUserInfo *toUser;
@property(nonatomic, strong) HSGHHomeUserInfo *fromUser;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *replayParentId;
@property(nonatomic, strong) NSNumber *up;
@property(nonatomic, copy) NSString *replayId;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber *upCount;
@end

// partReplay

@interface HSGHHomeReplay : NSObject
@property(nonatomic, strong) HSGHHomeUserInfo *toUser;
@property(nonatomic, strong) HSGHHomeUserInfo *fromUser;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *replayParentId;
@property(nonatomic, assign) BOOL up;
@property(nonatomic, copy) NSString *replayId;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber *upCount;
@property (nonatomic,strong) NSNumber * friendStatus;

@property (nonatomic,assign) BOOL  addedByComment; //是否通过评论添加的好友
@property (nonatomic,copy) NSString*  addedTime; //添加的时间
@property  (nonatomic, strong) NSArray<HSGHHomeReplay *>*replyVos;
@property (nonatomic, strong) HSGHHomeUserInfo * friendApplyUser;


@end

// partUp
@interface HSGHHomeUp : NSObject

@property(nonatomic, strong) HSGHHomeImage *picture;
@property(nonatomic, strong) HSGHHomeUniversity *unvi;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *userId;
@end

// qqian VO
@interface HSGHHomeQQianModel : NSObject

@property(nonatomic, strong)NSNumber * contentIsMore;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSAttributedString *contentAtt;//对应content的属性字符串
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSNumber *forwardCount;
@property(nonatomic, copy) NSString *qqianId;
@property(nonatomic, strong) NSNumber *replyCount;
@property(nonatomic, strong) NSNumber *isSelf;
@property(nonatomic, strong) NSNumber * friendStatus;
@property(nonatomic, strong) NSNumber *up;
@property(nonatomic, strong) NSNumber *upCount;
@property(nonatomic, assign) NSUInteger mediaType; //New add, 1 pic, 2 video
@property(nonatomic, strong) HSGHHomeImage *image;
@property(nonatomic, strong) HSGHHomeUserInfo *owner;
@property(nonatomic, strong) HSGHHomeAddress *address;
@property(nonatomic, strong) HSGHHomeUserInfo *creator;
@property(nonatomic, strong) NSNumber *forward;
@property (nonatomic, strong) HSGHHomeUserInfo * friendApplyUser;
@property(nonatomic, assign) int hasForward;//我是否已转发



@property(nonatomic, strong) NSArray<HSGHHomeForward *> *partForword;
@property(nonatomic, strong) NSArray<HSGHHomeReplay *> *partReplay;
@property(nonatomic, strong) NSArray<HSGHHomeUp *> *partUp;


//new
@property(nonatomic, strong) NSNumber *friendAddMode;
@property(nonatomic, copy) NSString * friendAddTime;

@end

// main VO
@interface HSGHHomeModel : NSObject
@property(nonatomic, strong) NSNumber *first;
@property(nonatomic, strong) NSNumber *last;
@property(nonatomic, strong) NSArray *qqians;
@property(nonatomic, strong) NSArray<HSGHHomeModelFrame *> * datalist;

@end
