//
//  HSGHKeyBoardView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeBaseView.h"
#import "SchoolSNS-Swift.h"
#import "YYTextView.h"




typedef void(^KeyBoardBlock)(NSIndexPath * indexPath,NSInteger homeMode,NSIndexPath * commentIndex,NSInteger editMode);
typedef void(^KeyBoardAtBlock)();

@interface HSGHKeyBoardView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet YYTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardToBottm;
@property (weak, nonatomic) IBOutlet UIView *keyboardView;



@property (assign, nonatomic)   CGFloat keyboardHeight;


//old
@property (assign ,nonatomic) NSInteger type;


@property (weak, nonatomic) IBOutlet UIView *textViewbg;
@property (copy, nonatomic) KeyBoardBlock block;
@property (copy, nonatomic) KeyBoardAtBlock atBlock;
@property (strong ,nonatomic) NSIndexPath * indexPath;
@property (assign ,nonatomic) NSInteger editMode;
@property (assign ,nonatomic) NSInteger HomeMode;
@property (strong ,nonatomic) NSIndexPath * commentIndex;

- (void)startInputText ;
@end
