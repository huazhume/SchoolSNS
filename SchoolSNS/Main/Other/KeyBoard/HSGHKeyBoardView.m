//
//  HSGHKeyBoardView.m
//  SchoolSNS
//HSGHKeyBoardView
//  Created by Huaral on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHKeyBoardView.h"
#import "HSGHTools.h"
#import "YYText.h"


@interface HSGHKeyBoardView () <YYTextViewDelegate> {

    CGRect originFrame;
}




@end
@implementation HSGHKeyBoardView

- (void)awakeFromNib
{

    [super awakeFromNib];
    //注册通知，监听键盘出现
    _textView = [[YYTextView alloc]init];
    _textView.backgroundColor = HEXRGBCOLOR(0xFCFCFC);
    _textView.layer.borderColor = [HEXRGBCOLOR(0xE3E3E3) CGColor];
    _textView.layer.borderWidth = 0.5;
//    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.textColor = HEXRGBCOLOR(0x272727);
    
    _textView.textVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    _textView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.textContainerInset = UIEdgeInsetsMake(8, 5, 6, 5);
    _textView.placeholderFont = [UIFont systemFontOfSize:14.f];
    _textView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    
    [self.textViewbg addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_textViewbg);
        make.top.mas_equalTo(_textViewbg);
        make.bottom.mas_equalTo(_textViewbg);
        make.right.mas_equalTo(_textViewbg);
    }];
    [self addNotificattionCenter];
    self.textView.keyboardType = UIKeyboardTypeDefault;
//    self.textView.returnKeyType = UIReturnKeyDefault;
    //添加事件
    UITapGestureRecognizer * gesturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardRemoveFromSuperView)];
    [self.bgView addGestureRecognizer:gesturer];
    self.bgView.userInteractionEnabled = YES;
    self.textView.delegate = self;
//    [self.textView becomeFirstResponder];
//    [self keyboardShowAnimation];
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = YES;
}

- (void)startInputText {
    [self.textView becomeFirstResponder];
    [self keyboardShowAnimation];
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
- (void)keyboardChange:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
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
        [self textViewDidChange:self.textView];
    } else {
       self.keyboardToBottm = 0;
       _keyboardHeight = 0;
    }
    [self layoutIfNeeded];
    [UIView commitAnimations];
    
}

#pragma mark - textVIew delegate

- (void)textViewDidChange:(YYTextView *)textView{
    self.publishBtn.alpha = (self.textView.text.length > 0 ? 1 : 0.5);
    CGSize contentSize = [HSGHTools getWidthWidthString:self.textView.text font:[UIFont systemFontOfSize:15] width:(HSGH_SCREEN_WIDTH - 24)];
    if (contentSize.height > 35) {
        if (contentSize.height >= 75) {
            contentSize.height = 75;
        }
        self.textViewHeight.constant = contentSize.height + 15;
    } else {
        self.textViewHeight.constant = 35 + 15;
    }
    self.keyboardToBottm.constant = _keyboardHeight;
}
#pragma mark - 事件
- (void)keyboardRemoveFromSuperView {
    [self removeFromSuperview];
}
- (void)keyboardShowAnimation
{
    [UIView animateWithDuration:0.27
                     animations:^{
                         self.keyboardToBottm.constant = _keyboardHeight;
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){

                     }];
}

- (void)keyboardCloseAnimation
{
    [UIView animateWithDuration:0.27
                     animations:^{
                         self.keyboardToBottm.constant = 0;
                     }
                     completion:^(BOOL finished){

                     }];
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    self.publishBtn.alpha = (self.textView.text.length > 0 ? 1 : 0.5);
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
    if( [text isEqualToString:@"\n"]){
        if ([_textView.text isEqualToString:@""] || _textView.text == nil) {
            
        } else {
            if (_block) {
                self.block(_indexPath, _HomeMode, _commentIndex, _editMode);
                [_textView resignFirstResponder];
            }
        }
        return NO;
    }
    
    return YES;
}


- (void)dealloc
{
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     
     name:UIKeyboardDidHideNotification
     object:nil];
}


@end
