//
//  HSGHFriendSecondView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import "HSGHFriendBaseView.h"

@interface HSGHFriendSecondView : HSGHFriendBaseView

- (void)setFriendArray:(NSArray *)friendArray;

- (void)frndSecondViewEndEdit;

/**
 friendArray好友列表
 dataArray格式化的好友列表数据
 sectionIndexArray好友分组标题
 */
- (void)setPreparedFriendArray:(NSArray *)friendArray andDataArray:(NSArray *)dataArray andSectionIndexArray:(NSArray *)sectionIndexArray;

@end
