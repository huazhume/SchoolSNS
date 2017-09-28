//
//  HSGHZoneAreaBCellVC.h
//  SchoolSNS
//
//  Created by Murloc on 16/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHZoneModel.h"

@protocol AreaBDelegate<NSObject>
- (void)refreshPersonalInfo;
- (void)keyBoardShow:(NSIndexPath *)indexPath;
- (void)adjustTableViewToFitKeyboardWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath WithCommentHeight:(CGFloat)commentHeight;
@end

@interface HSGHZoneAreaBCellVC : UIViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) HSGHZoneModel *model;
@property (nonatomic, copy)  NSString* userID;
@property (nonatomic, weak) id<AreaBDelegate> delegate;

- (void)resetBlock;
- (void)refreshData;
@end
