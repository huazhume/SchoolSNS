//
//  HSGHFriendDetailViewModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModel.h"
#import "HSGHFriendBaseView.h"

@interface HSGHFriendDetailViewModel : NSObject
@property (nonatomic,strong) NSArray * qqians;
//新鲜事儿
+ (void)fetchFriendDetailWithUserID:(NSString *)userID WithMode:(FRINED_CATE_MODE)mode :(void (^)(BOOL success, NSArray *array))fetchBlock;
//首页数据
+ (void)fetchFistViewModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock ;

+ (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:
(HSGHHomeReplay *)model;

@end
