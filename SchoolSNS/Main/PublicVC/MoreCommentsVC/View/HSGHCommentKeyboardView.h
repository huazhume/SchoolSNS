//
//  HSGHCommentKeyboardView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 02/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTextView.h"
#import "SchoolSNS-Swift.h"

typedef void(^ClickBackBlock)();
typedef void(^ATButtonClickBlock)();//点击@ 回调


//Whole height is 45
@interface HSGHCommentKeyboardView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel; //Friend => #e02e43 , Stanger #a5a5a5 & can't touch
//发送按钮
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) YYTextView *inputTextView;
//@property (weak, nonatomic) IBOutlet AnimatableTextView *inputTextView;

@property (nonatomic, assign) BOOL isReplyMode;

@property (nonatomic, copy) ClickBackBlock clickBackBlock;
@property (nonatomic, copy) ATButtonClickBlock atButtonClickBlock;
@property (nonatomic, copy) void(^sendClick)();
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *userId;

- (void)setCommentMode:(NSString*)userId name:(NSString*)name; //评论模式下是发布者的ID

- (void)setReplayMode:(NSString*)userId name
                     :(NSString*)name;

- (void)updateATInfo:(NSString*)nickName userId:(NSString*)userId;

- (void)updateATInfo:(NSArray*)modelArray;

- (NSString*)fetchToServerContent;
@end
