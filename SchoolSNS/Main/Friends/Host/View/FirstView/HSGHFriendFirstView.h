//
//  HSGHFriendFirstView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHFriendFirstHeaderView.h"
#import "HSGHFriendBaseView.h"


@interface HSGHFriendFirstView : HSGHFriendBaseView

//@property(nonatomic, strong) HSGHFriendFirstHeaderView * headerView;
- (void)setRecommentArray:(NSArray *)recommentArray;
- (void)setSearchArray:(NSArray *)searchArray isSuccess:(BOOL)isSuccess ;
- (void)frndFirstViewEndEdit;

@end
