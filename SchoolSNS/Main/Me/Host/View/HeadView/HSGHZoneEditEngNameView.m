//
//  HSGHZoneEditEngNameView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 28/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHZoneEditEngNameView.h"
#import "HSGHUserInf.h"
#import "HSGHSettingsModel.h"
#import "AppDelegate.h"
#import "SchoolSNS-Swift.h"

//First 2/5
//Middle 2/5
//Last   1/5

#define ONLYEngReg  @"^[A-Za-z]+$"

@implementation HSGHZoneEditEngNameView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self updateDefaultName];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat between = 10;
    CGFloat space = self.width / 7;
    _firstNameTF = [[TXLimitedTextField alloc]initWithFrame:CGRectMake(between, 0, space * 2, self.height)];
    _firstNameTF.keyboardType = UIKeyboardTypeASCIICapable;
    _firstNameTF.limitedType = TXLimitedTextFieldTypeCustom;
    _firstNameTF.limitedNumber = 10;
    _firstNameTF.isFirstBig = true;
    _firstNameTF.textColor = HEXRGBCOLOR(0x272727);
    _firstNameTF.limitedRegEx = ONLYEngReg;
    _firstNameTF.font = [UIFont boldSystemFontOfSize:12.f];
    _firstNameTF.delegate = self;
    _firstNameTF.placeholder = @"FirstName";
    _firstNameTF.returnKeyType = UIReturnKeySend;
    [self addSubview:_firstNameTF];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(_firstNameTF.right + between, 0, 1, self.height)];
    line.backgroundColor = HEXRGBCOLOR(0xc8c9CA);
    [self addSubview:line];
    
    _middleNameTF = [[TXLimitedTextField alloc]initWithFrame:CGRectMake(line.right + between, 0, space * 2, self.height)];
    _middleNameTF.keyboardType = UIKeyboardTypeASCIICapable;
    _middleNameTF.isFirstBig = true;
    _middleNameTF.limitedType = TXLimitedTextFieldTypeCustom;
    _middleNameTF.limitedNumber = 10;
    _middleNameTF.textColor = HEXRGBCOLOR(0x272727);
    _middleNameTF.limitedRegEx = ONLYEngReg;
    _middleNameTF.font = [UIFont boldSystemFontOfSize:12.f];
    _middleNameTF.placeholder = @"MiddleName";
    _middleNameTF.delegate = self;
    _middleNameTF.returnKeyType = UIReturnKeySend;
    [self addSubview:_middleNameTF];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(_middleNameTF.right + between, 0, 1, self.height)];
    line2.backgroundColor = HEXRGBCOLOR(0xc8c9CA);
    [self addSubview:line2];
    
    
    UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(line2.right, 0, self.width - line2.right, self.height)];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:grayView];
    
    _lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(line2.right + between, 0, space*2, self.height)];
    _lastNameLabel.textColor = HEXRGBCOLOR(0x272727);
    _lastNameLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:_lastNameLabel];
    
    _lastNameTF = [[TXLimitedTextField alloc]initWithFrame:_lastNameLabel.frame];
    _lastNameTF.keyboardType = UIKeyboardTypeASCIICapable;
    _lastNameTF.isFirstBig = true;
    _lastNameTF.limitedType = TXLimitedTextFieldTypeCustom;
    _lastNameTF.limitedNumber = 10;
    _lastNameTF.textColor = HEXRGBCOLOR(0x272727);
    _lastNameTF.limitedRegEx = ONLYEngReg;
    _lastNameTF.font = [UIFont boldSystemFontOfSize:12.f];
    _lastNameTF.placeholder = @"LastName";
    _lastNameTF.delegate = self;
    _lastNameTF.returnKeyType = UIReturnKeySend;
    [self addSubview:_lastNameTF];
    
}

- (void)updateDefaultName {
    if (![HSGHUserInf shareManager].lastNameEn || [HSGHUserInf shareManager].lastNameEn.length == 0) {
        _lastNameTF.hidden = false;
        _lastNameLabel.hidden = true;
    }
    else {
        _lastNameTF.hidden = true;
        _lastNameLabel.hidden = false;
        _lastNameLabel.text = UN_NIL_STR([HSGHUserInf shareManager].lastNameEn);
    }
    
    if ([HSGHUserInf shareManager].middleNameEn) {
        _middleNameTF.text = [HSGHUserInf shareManager].middleNameEn;
    }
    if ([HSGHUserInf shareManager].firstNameEn) {
        _firstNameTF.text = [HSGHUserInf shareManager].firstNameEn;
    }
}

#pragma mark-delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self updateEngName];
    return YES;
}

- (void)updateEngName {
    [[AppDelegate instanceApplication] indicatorShow];
    __weak typeof(self) weakSelf = self;
    NSString* lastName = _lastNameTF.hidden ? _lastNameLabel.text : _lastNameTF.text;
    [HSGHSettingsModel modifyUserEngName:_firstNameTF.text middleName:_middleNameTF.text lastName:lastName block:^(BOOL status, NSString* errDes) {
        [[AppDelegate instanceApplication] indicatorDismiss];
        if (status) {
            Toast* toast = [[Toast alloc]initWithText:@"更新英文名成功" delay:0 duration:1.f];
            [toast show];
        } else {
            Toast* toast = [[Toast alloc]initWithText:@"更新失败，请稍后再试" delay:0 duration:1.f];
            [toast show];
        }
        
        if (weakSelf.doUpdateEngNameBlock) {
            weakSelf.doUpdateEngNameBlock(status);
        }
        
    }];
}


#pragma mark-public
- (BOOL)hasChange {
    NSString* lastName = _lastNameTF.hidden ? _lastNameLabel.text : _lastNameTF.text;
    if ([HSGHUserInf shareManager].firstNameEn && [HSGHUserInf shareManager].middleNameEn && [HSGHUserInf shareManager].lastNameEn){
        if ([_firstNameTF.text isEqualToString:[HSGHUserInf shareManager].firstNameEn] && [_middleNameTF.text isEqualToString:[HSGHUserInf shareManager].middleNameEn] && [lastName isEqualToString:[HSGHUserInf shareManager].lastNameEn]) {
            return false;
        }
    }
    return true;
}

- (void)toReponse {
    [_firstNameTF becomeFirstResponder];
}


@end
