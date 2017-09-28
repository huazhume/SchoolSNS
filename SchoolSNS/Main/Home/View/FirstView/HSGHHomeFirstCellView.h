//
//  HSGHHomeFirstCellView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHFirstHeaderView.h"
#import "HSGHFirstContentView.h"
#import "HSGHMeToolView.h"
#import "HSGHFirstCommentView.h"
#import "HSGHForwardView.h"
#import "HSGHHomeModelFrame.h"



@interface HSGHHomeFirstCellView : UIView
@property(weak, nonatomic) IBOutlet HSGHFirstContentView *ContentView;
@property(weak, nonatomic) IBOutlet HSGHMeToolView *ToolView;
@property(weak, nonatomic) IBOutlet HSGHFirstCommentView *CommentView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *toolsHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwordViewHeight;
@property (weak, nonatomic) IBOutlet HSGHForwardView * forwardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTop;




- (void)setContentFrame:(HSGHHomeQQianModelFrame *)frame WithIsFriend:(BOOL)isFriend;
@property(nonatomic, strong) IBOutlet UIView *view;

@end
