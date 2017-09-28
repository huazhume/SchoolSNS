//
//  HSGHMoreCommentsVC
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeBaseViewController.h"

@interface HSGHMoreCommentsVC : HSGHHomeBaseViewController <UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray *replayArray;
@property (nonatomic, copy) NSString *qqianId;
@property (nonatomic, copy) NSString *currentReplyId;
@property (nonatomic, copy) NSIndexPath *currentIndexPath;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

+ (void)showWithArray:(NSArray *)array;

+ (void)show:(NSString*)qqianID userID:(NSString*)userId name:(NSString*)name block:(void (^)(BOOL isChanged, NSArray* array))block;

@end
