//
//  HSGHMsgDetailViewModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSGHHomeQQianModel;


@interface HSGHMsgDetailViewModel : NSObject


/**
 获取消息详情

 @param msgId
 @param fetchBlock
 */
+ (void)fetchFriendDetailWithMsgID:(NSString *)msgId :(void (^)(BOOL success, NSArray *array))fetchBlock;

@property (nonatomic ,strong)HSGHHomeQQianModel * qQianVo;

@end

