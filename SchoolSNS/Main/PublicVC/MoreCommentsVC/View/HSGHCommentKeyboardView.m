//
//  HSGHCommentKeyboardView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 02/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHCommentKeyboardView.h"
#import "HSGHCommentKeyboardModel.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHFriendViewModel.h"

@implementation HSGHCommentKeyboardView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView {
    [self.checkButton setEnabled:NO];

    _inputTextView = [[YYTextView alloc] init];
    [_backView addSubview:_inputTextView];
    _inputTextView.backgroundColor = HEXRGBCOLOR(0xFCFCFC);
    _inputTextView.font = [UIFont systemFontOfSize:14.f];
    _inputTextView.textColor = HEXRGBCOLOR(0x272727);
//    _inputTextView.returnKeyType = UIReturnKeyDone;
    _inputTextView.textVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputTextView.placeholderFont = [UIFont systemFontOfSize:14.f];
  
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 15;
    _backView.layer.borderWidth = 0.5;
    _backView.layer.borderColor = HEXRGBCOLOR(0xe3e3e3).CGColor;
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView).offset(15);
        make.right.equalTo(_backView).offset(-30);
        make.centerY.equalTo(_backView);
        make.top.equalTo(_backView).offset(1.5);
    }];
    [self setCommentMode:_userId name:_name];
}


- (void)enablePrivatedMsg:(BOOL)enable {
    _checkButton.enabled = enable;
    _wordLabel.textColor = enable ? HEXRGBCOLOR(0xe02e43) : HEXRGBCOLOR(0xa5a5a5);
    _checkImageView.highlighted = NO;
    [_checkImageView setImage:[UIImage imageNamed:@"reg_name_check_n"]];
}

- (IBAction)clickPrivatedMsg:(id)sender {
    if (self.sendClick) {
        self.sendClick();
    }
}

- (IBAction)clickBack:(id)sender {
    if (self.clickBackBlock) {
        self.clickBackBlock();
    }
}


- (void)setCommentMode:(NSString*)userId name:(NSString*)name{
    _isReplyMode = false;
    [self enablePrivatedMsg:[HSGHCommentKeyboardModel checkFriend:userId]];
    if (UN_NIL_STR(userId).length == 0) {
        _inputTextView.placeholderText = [NSString stringWithFormat:@"评论%@的新鲜事", @"匿名发布者"];
    }
    else {
        _inputTextView.placeholderText = [NSString stringWithFormat:@"评论%@的新鲜事",name];
    }
}

- (void)setReplayMode:(NSString*)userId name:(NSString*)name{
    _userId = userId;
    name = name;
    _isReplyMode = true;
    [self enablePrivatedMsg:[HSGHCommentKeyboardModel checkFriend:userId]];
    if (UN_NIL_STR(userId).length == 0) {
        _inputTextView.placeholderText = [NSString stringWithFormat:@"回复%@的评论", @"匿名发布者"];
    }
    else {
        _inputTextView.placeholderText = [NSString stringWithFormat:@"回复%@的评论",name];
    }
}

- (void)updateATInfo:(NSString*)nickName userId:(NSString*)userId{
    [HSGHCommentsCallFriendViewModel addOneFriend:nickName userId:userId location:_inputTextView.selectedRange.location yyTextView:_inputTextView];
}

- (void)updateATInfo:(NSArray*)modelArray {
    for (int i=0; i<modelArray.count; i++) {
        HSGHFriendSingleModel* model = modelArray[i];
        [HSGHCommentsCallFriendViewModel addOneFriend:model.displayName userId:model.userId location:_inputTextView.selectedRange.location yyTextView:_inputTextView];
    }
}

- (NSString*)fetchToServerContent {
    return [HSGHCommentsCallFriendViewModel convertToMatchedTextBindings:_inputTextView];
}
- (IBAction)ATButtonClick:(id)sender {
    if (self.atButtonClickBlock) {
        self.atButtonClickBlock();
    }
}

@end

