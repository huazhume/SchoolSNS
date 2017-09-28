//
//  HSGHDetailCommentView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"
#import "HSGHFriendViewModel.h"

@class HSGHHomeReplay;



typedef void(^CommentBlock)();

//加好友
typedef void(^AddBtnBlock)(UIButton * btn, NSNumber * state, NSString * replayId ,UILabel * label,UIView * friendView ,NSIndexPath * indexPath);

//回复
typedef void(^CommentReplayBlock) (NSIndexPath * indexPath);


typedef void(^UpCommentReplayBlock) (NSInteger type , NSIndexPath * indexPath);

@interface HSGHDetailCommentView : UIView

@property(nonatomic, strong) IBOutlet UIView *view;
@property(nonatomic, strong) HSGHHomeQQianModel * qqianVo;
- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF;

@property (nonatomic ,copy) CommentBlock block;
@property (nonatomic ,copy) AddBtnBlock addblock;
@property (nonatomic ,copy) UpCommentReplayBlock upCommet;
@property (nonatomic ,copy) CommentReplayBlock commentBlock;
@property (strong, nonatomic) HSGHFriendSingleModel * singleModel;

@end
