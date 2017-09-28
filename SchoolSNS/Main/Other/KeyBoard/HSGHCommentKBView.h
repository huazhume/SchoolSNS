//
//  HSGHCommentKBView.h
//  SchoolSNS
//
//  Created by huaral on 2017/7/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeBaseView.h"
#import "SchoolSNS-Swift.h"
#import "YYTextView.h"



@interface HSGHCommentKBView : UIView
typedef void(^KeyBoardBlock)(NSIndexPath * indexPath,NSInteger homeMode,NSIndexPath * commentIndex,NSInteger editMode);
typedef void(^KeyBoardAtBlock)();


@property (strong, nonatomic)  YYTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (copy, nonatomic) KeyBoardBlock block;
@property (copy, nonatomic) KeyBoardAtBlock atBlock;

@property (strong ,nonatomic) NSIndexPath * indexPath;
@property (assign ,nonatomic) NSInteger editMode;
@property (assign ,nonatomic) NSInteger HomeMode;
@property (strong ,nonatomic) NSIndexPath * commentIndex;

@property (weak, nonatomic) IBOutlet UIView *textViewbg;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;



@property (assign, nonatomic)   CGFloat keyboardHeight;
@end
