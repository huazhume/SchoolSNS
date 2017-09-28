//
//  HSGHDetailTableViewCell.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHFirstHeaderView.h"
#import "HSGHFirstContentView.h"
#import "HSGHFirstToolsView.h"
//#import "HSGHFirstCommentView.h"
#import "HSGHForwardView.h"
#import "HSGHDetailCommentView.h"
#import "HSGHHomeModelFrame.h"
#import "HSGHDetailTimeView.h"
#import "HSGHFriendViewModel.h"
#import "UIView+WebVideoCache.h"

@interface HSGHDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeHeight;

@property(weak, nonatomic) IBOutlet HSGHFirstHeaderView *HeaderView;
@property(weak, nonatomic) IBOutlet HSGHFirstContentView *ContentView;
@property(weak, nonatomic) IBOutlet HSGHFirstToolsView *ToolView;
@property(weak, nonatomic) IBOutlet HSGHDetailCommentView *CommentView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *toolsHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwordViewHeight;
@property (weak, nonatomic) IBOutlet HSGHForwardView * forwardView;
@property (weak, nonatomic) IBOutlet HSGHDetailTimeView *timeView;

- (void)setcellFrame:(HSGHHomeQQianModelFrame *)frame WithSingleModel:(HSGHFriendSingleModel *)singleModel ;


- (void)setcellFrame:(HSGHHomeQQianModelFrame *)frame;
@end
