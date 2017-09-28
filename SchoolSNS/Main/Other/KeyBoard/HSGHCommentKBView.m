//
//  HSGHCommentKBView.m
//  SchoolSNS
//
//  Created by huaral on 2017/7/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHCommentKBView.h"

@interface HSGHCommentKBView ()<YYTextViewDelegate>
@property (nonatomic, strong)UIView * sepratorView;

@end

@implementation HSGHCommentKBView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    //注册通知，监听键盘出现
    _textView = [[YYTextView alloc]init];
    _textView.backgroundColor = HEXRGBCOLOR(0xFCFCFC);
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.textColor = HEXRGBCOLOR(0x272727);
//    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textView.placeholderFont = [UIFont systemFontOfSize:14.f];
    [self.textViewbg addSubview:_textView];
    _textView.backgroundColor = [UIColor clearColor];
    [_textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_textViewbg).offset(15);
        make.top.mas_equalTo(_textViewbg).offset(1.5);
        make.centerY.equalTo(self);
        make.right.mas_equalTo(_textViewbg).offset(-30);
    }];

    _textViewbg.layer.masksToBounds = YES;
    _textViewbg.layer.cornerRadius = 15;
    _textViewbg.layer.borderWidth = 0.5;
    _textViewbg.layer.borderColor = HEXRGBCOLOR(0xe3e3e3).CGColor;
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
 //   self.publishBtn.alpha = (self.textView.text.length > 0 ? 1 : 0.5);
}


- (void)addNotificattionCenter
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillShowNotification
     object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChange:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

//监听键盘 高度变化
- (void)keyboardChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        _keyboardHeight = keyboardEndFrame.size.height;
        [self textViewDidChange:_textView];
    } else {
        self.frame = CGRectMake(0, HSGH_SCREEN_HEIGHT+ 10, HSGH_SCREEN_WIDTH,
                                50);;
        _keyboardHeight = 0;
    }
    [self layoutIfNeeded];
    [UIView commitAnimations];
}



- (void)textViewDidChange:(YYTextView *)textView {
    
    self.publishBtn.enabled = (self.textView.text.length > 0 ? 1 : 0);
    
    CGSize contentSize = [self.textView.text
                          sizeWithFont:[UIFont systemFontOfSize:14]
                          constrainedToSize:CGSizeMake(HSGH_SCREEN_WIDTH  - 12, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    
    if (contentSize.height > 30) {
        if (contentSize.height >= 60) {
            contentSize.height = 60;
        }
        self.frame = CGRectMake(0, HSGH_SCREEN_HEIGHT  - _keyboardHeight -
                                contentSize.height - 15,
                                HSGH_SCREEN_WIDTH, contentSize.height + 15);
        self.textViewHeight.constant = contentSize.height;
    } else {
        self.frame =
        CGRectMake(0, HSGH_SCREEN_HEIGHT  - _keyboardHeight - 30 - 15,
                   HSGH_SCREEN_WIDTH, 45);
        self.textViewHeight.constant = 30;
    }
}
- (IBAction)detailMsgATButtonClick:(id)sender {
    HSLog(@"---HSGHCommentKBView---AT---");
    if (_atBlock) {
        _atBlock();
    }
}

- (IBAction)publishBtn:(id)sender
{
    if ([_textView.text isEqualToString:@""] || _textView.text == nil) {
        
    } else {
        if (_block) {
            self.block(_indexPath, _HomeMode, _commentIndex, _editMode);
            [_textView resignFirstResponder];
        }
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 800) {
        return NO;
    }
    
    if ([text isEqualToString:@"@"]) {
        if(_atBlock){
            self.atBlock();
        }
        return NO;
    }
    
    return YES;
}


- (UIView *)sepratorView {
    if(!_sepratorView){
        _sepratorView = [UIView new];
    }
    return _sepratorView;
}






@end
