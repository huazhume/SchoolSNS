//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHHeadView.h"
#import "HSGHTools.h"
#import "UIImage+BFSExt.h"
#import "UIImageView+CornerRadius.h"
#import "UIImageView+LBBlurredImage.h"
#import "THLabel.h"
#import "YZInputView.h"
#import "HSGHZoneModel.h"
#import "AppDelegate.h"
#import "HSGHZoneEditEngNameView.h"

@interface HSGHHeadView () <UITextViewDelegate>{
    BOOL _isMine;
}
@property(nonatomic, strong) UIImageView *bgBlurImageView;
@property(nonatomic, strong) UIImageView *sexImageView;
@property(nonatomic, strong) THLabel *nameLabel;
@property(nonatomic, strong) THLabel *signatureLabel;

@property(nonatomic, strong) UIImageView *editNameImageView; //only mine
@property(nonatomic, strong) UIImageView *editImageView; //only mine
@property(nonatomic, strong) UIButton *editSignatureButton; //only mine
@property(nonatomic, strong) UIButton *editNickNameButton; //only mine
@property(nonatomic, strong) UIButton *settingsButton; //only mine
@property(nonatomic, strong) UIButton *editBGButton; //only mine

@property(nonnull, strong)   YZInputView *editTextTF; //only mine

@property(nonnull, strong)   HSGHZoneEditEngNameView  *editEngNameView; //only mine


@property(nonatomic, strong) UIImage*   inputImage;

@end


@implementation HSGHHeadView {

}
- (instancetype)initWithFrame:(CGRect)frame isMine:(BOOL)isMine {
    self = [self initWithFrame:frame];
    _isMine = isMine;
    if (isMine) {
        //Lazy load
        [self addSubview:self.settingsButton];
        [self addSubview:self.editBGButton];
        [self addSubview:self.editImageView];
//        [self buildEditBGImage];
    }
    [self buildEditImage];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    //NSLog(@"================ release the zoneVC");
}


- (void)setup {
    _bgBlurImageView = [UIImageView new];
    _bgBlurImageView.frame = self.bounds;
    _bgBlurImageView.clipsToBounds = YES;
    _bgBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgBlurImageView.backgroundColor = HEXRGBCOLOR(0xBFBFBF);//HEXRGBCOLOR(0xFAFAFA);
    [self addSubview:_bgBlurImageView];
    
    //HeadIcon contain view
    UIView* containView = [UIView new];
    containView.backgroundColor = [UIColor whiteColor];
    containView.frame = CGRectMake(0, 0, 75, 75);
    containView.layer.cornerRadius = containView.width / 2.f;
    containView.layer.borderColor = HEXRGBCOLOR(0xbcbcbc).CGColor;
    containView.layer.borderWidth = 0.5;
    [self addSubview:containView];
    containView.left = (self.width - 75) / 2;
    if (isIPhone5) {
        containView.top = self.height * 166 /456 - 20;
    } else {
        containView.top = self.height * 166 /456;
    }
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 66, 66)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headImageView zy_cornerRadiusAdvance:33.f rectCornerType:UIRectCornerAllCorners];
    [containView addSubview:_headImageView];
    
    _sexImageView = [UIImageView new];
    _sexImageView.frame = CGRectMake(containView.right - 17 + 3, containView.bottom - 17 +3, 17, 17);
    [self addSubview:_sexImageView];
    _sexImageView.hidden = YES;

    _nameLabel = [THLabel new];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.shadowColor = HEXRGBACOLOR(0x000000, 1.0);
    _nameLabel.shadowOffset = CGSizeMake(-0.1, 0.2);
    _nameLabel.shadowBlur = 0.5;
    _nameLabel.frame = CGRectMake(0, containView.bottom + 10, self.width, 16.5);
    [self addSubview:_nameLabel];
    
    _signatureLabel = [THLabel new];
    _signatureLabel.textColor = [UIColor whiteColor];
    _signatureLabel.font = [UIFont systemFontOfSize:11.f];
    _signatureLabel.textAlignment = NSTextAlignmentRight;
    _signatureLabel.shadowColor = HEXRGBACOLOR(0x000000, 0.6);
    _signatureLabel.shadowOffset = CGSizeMake(0.0, 0.5);
    _signatureLabel.shadowBlur = 2.0;
    _signatureLabel.frame = CGRectMake(0, _nameLabel.bottom + 10, self.width - 30, 12);
    [self addSubview:_signatureLabel];
}

- (void)buildEditImage {
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = _headImageView.bounds;
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addSubview:headButton];
    [headButton addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buildEditBGImage {
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = _bgBlurImageView.bounds;
    _bgBlurImageView.userInteractionEnabled = YES;
    [_bgBlurImageView addSubview:headButton];
    [headButton addTarget:self action:@selector(clickBG) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)settingsButton {
    if (!_settingsButton) {
        //30, 30
        _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingsButton setImage:[UIImage imageNamed:@"zone_settings"]
                                   forState:UIControlStateNormal];
        [_settingsButton setImage:[UIImage imageNamed:@"zone_settings"]
                                   forState:UIControlStateHighlighted];
        [_settingsButton setImage:[UIImage imageNamed:@"zone_settings"]
                                   forState:UIControlStateSelected];
        _settingsButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 30, 30);
        _settingsButton.frame = CGRectMake(0, 0, 75, 75);
        [self addSubview:_settingsButton];
        
        [_settingsButton addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingsButton;
}

- (UIButton *)editBGButton {
    if (!_editBGButton) {
        //30, 30
        _editBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBGButton setImage:[UIImage imageNamed:@"zone_edit_icon"]
                         forState:UIControlStateNormal];
        [_editBGButton setImage:[UIImage imageNamed:@"zone_edit_icon"]
                         forState:UIControlStateHighlighted];
        [_editBGButton setImage:[UIImage imageNamed:@"zone_edit_icon"]
                         forState:UIControlStateSelected];
        _editBGButton.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 30, 15);
        _editBGButton.frame = CGRectMake(self.width - 75, 0, 75, 75);
        [self addSubview:_editBGButton];
        
        [_editBGButton addTarget:self action:@selector(clickBG) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingsButton;
}


- (UIImageView *)editImageView {
    if (!_editImageView) {
        __weak typeof(self) weakSelf = self;

        _editNameImageView = [UIImageView new];
        _editNameImageView.image = [UIImage imageNamed:@"zone_edit_icon"];
//        if ([HSGHUserInf shareManager].displayNameMode == 2) {
            [self addSubview:_editNameImageView];
            [_editNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(4);
                make.centerY.mas_equalTo(weakSelf.nameLabel).offset(0);
                make.width.mas_equalTo(16);
                make.height.mas_equalTo(16);
            }];
//        }
        
        _editImageView = [UIImageView new];
        _editImageView.image = [UIImage imageNamed:@"zone_edit_icon"];
        [self addSubview:_editImageView];
        [_editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.signatureLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(weakSelf.signatureLabel).offset(0);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
        
        _editSignatureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editSignatureButton.frame = CGRectMake(_editImageView.left, _editImageView.top,
                _editImageView.width + _signatureLabel.width, _editImageView.height);
        [self addSubview:_editSignatureButton];
        [_editSignatureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.editImageView);
            make.width.mas_equalTo(280);
            make.centerX.equalTo(weakSelf);
            make.height.mas_equalTo(30.f);
        }];
        [_editSignatureButton addTarget:self action:@selector(clickUpdateSignature) forControlEvents:UIControlEventTouchUpInside];
        
        _editTextTF = [[YZInputView alloc]initWithFrame:CGRectZero];
        _editTextTF.backgroundColor = [UIColor whiteColor];
        _editTextTF.font = [UIFont systemFontOfSize:11.f];
        _editTextTF.placeholder = @"个性签名";
        _editTextTF.textColor = HEXRGBCOLOR(0x272727);
        _editTextTF.delegate = self;
        _editTextTF.hidden = YES;
        _editTextTF.cornerRadius = 2.f;
        _editTextTF.returnKeyType = UIReturnKeySend;
        _editTextTF.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
            weakSelf.editTextTF.height = textHeight;
        };
        _editTextTF.maxNumberOfLines = 2;
        [self addSubview:_editTextTF];
        _editTextTF.frame = CGRectMake((self.width - 280) / 2, _signatureLabel.top, 280, 30);
        
        //nickName editer
        _editNickNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editNickNameButton.frame = CGRectMake(_nameLabel.left, _nameLabel.top,
                                                280, _nameLabel.height);
        [self addSubview:_editNickNameButton];
        [_editNickNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel);
            make.width.mas_equalTo(300);
            make.centerX.equalTo(weakSelf);
            make.height.mas_equalTo(weakSelf.nameLabel);
        }];
        [_editNickNameButton addTarget:self action:@selector(clickUpdateNickName) forControlEvents:UIControlEventTouchUpInside];
        
        _editEngNameView = [[HSGHZoneEditEngNameView alloc]initWithFrame:_editTextTF.bounds];
        _editEngNameView.centerX = self.width / 2;
        _editEngNameView.hidden = YES;
        
        _editEngNameView.doUpdateEngNameBlock = ^(BOOL status) {
            if (status) {
                if ([HSGHUserInf shareManager].middleNameEn.length == 0) {
                    weakSelf.name = [NSString stringWithFormat:@"%@ %@", UN_NIL_STR([HSGHUserInf shareManager].firstNameEn),
                                     UN_NIL_STR([HSGHUserInf shareManager].lastNameEn)];
                } else {
                    weakSelf.name = [NSString stringWithFormat:@"%@ %@ %@", UN_NIL_STR([HSGHUserInf shareManager].firstNameEn),
                                      UN_NIL_STR([HSGHUserInf shareManager].middleNameEn), UN_NIL_STR([HSGHUserInf shareManager].lastNameEn)];
                }
            }
            
            if (weakSelf.doUpdateEngNameBlock) {
                weakSelf.doUpdateEngNameBlock(status);
            }
        };
        [self addSubview:_editEngNameView];
        
    }
    return _editImageView;
}

- (void)enterEditMode:(BOOL)isEdit isSingle:(BOOL)isSingle{
    if (isEdit) {
        if (isSingle) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:_editTextTF];
            _editTextTF.top = _signatureLabel.top;
            _signatureLabel.hidden = YES;
            _editImageView.hidden = YES;
            _editSignatureButton.enabled = NO;
            _editTextTF.text = UN_NIL_STR([HSGHUserInf shareManager].signature);
            _editTextTF.keyboardType = UIKeyboardTypeDefault;
            _editTextTF.hidden = NO;
            [_editTextTF becomeFirstResponder];
        } else {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:_editEngNameView];
            _editEngNameView.top = _editNickNameButton.top + 15;
            _editNickNameButton.enabled = NO;
            _nameLabel.hidden = YES;
            _editEngNameView.hidden = NO;
            [_editEngNameView updateDefaultName];
            [_editEngNameView toReponse];
        }
        
    } else {
        [_editTextTF removeFromSuperview];
        _editTextTF.hidden = YES;
        [_editEngNameView removeFromSuperview];
        _editEngNameView.hidden = YES;
        _signatureLabel.hidden = NO;
        _editImageView.hidden = NO;
        _editSignatureButton.enabled = YES;
        _editNickNameButton.enabled = YES;
        _nameLabel.hidden = NO;
        [self endEditing:YES];
    }
}

#pragma mark - YYTextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (_nameLabel.hidden) {
            NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
            if (![HSGHTools isValidateNickName:comcatstr]) {
                Toast* toast = [[Toast alloc]initWithText:@"昵称需要是8~20位小写字母或英文数字组合" delay:0 duration:1.f];
                [toast show];
                return NO;
            }
            [self updateNickName];
        }
        else {
            [self updateSignature];
        }
        return NO;
    }
    
    if (_signatureLabel.hidden) {
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSInteger caninputlen = 36 - comcatstr.length;
        
        if (caninputlen >= 0){
            return YES;
        }
        else
        {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = [text substringWithRange:rg];
                
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    }
    
    return true;
}

//
//- (void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length > 36) {
//        textView.text = [textView.text substringToIndex: 36];
//    }
//}

#pragma mark - do actions
- (void)updateSignature {
    [[AppDelegate instanceApplication] indicatorShow];
    __weak typeof(self) weakSelf = self;
    
    NSString *tmpString = [_editTextTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (tmpString.length < 1) {//输入为空
        [[AppDelegate instanceApplication] indicatorDismiss];
        _editTextTF.text = @"";
        Toast* toast = [[Toast alloc] initWithText:@"输入不能为空" delay:0 duration:1.f];
        [toast show];
        return ;
    }
    
    [HSGHSettingsModel ModifyUserSignature:tmpString block:^(BOOL status, NSString* errDes) {
        [[AppDelegate instanceApplication] indicatorDismiss];
        if (status) {
            weakSelf.signature = weakSelf.editTextTF.text;
            Toast* toast = [[Toast alloc]initWithText:@"更新签名成功" delay:0 duration:1.f];
            [toast show];
        } else {
            Toast* toast = [[Toast alloc]initWithText:@"更新签名失败，请稍后再试" delay:0 duration:1.f];
            [toast show];
        }
        if (weakSelf.doUpdateSignaturBlock) {
            HSLog(@"update signature");
            weakSelf.doUpdateSignaturBlock(status);
        }
    }];
}

- (void)updateNickName {
    [[AppDelegate instanceApplication] indicatorShow];
    __weak typeof(self) weakSelf = self;
    [HSGHZoneModel changeNickName:_editTextTF.text block:^(BOOL status) {
        [[AppDelegate instanceApplication] indicatorDismiss];
        if (status) {
            weakSelf.name = weakSelf.editTextTF.text;
            Toast* toast = [[Toast alloc]initWithText:@"更新昵称成功" delay:0 duration:1.f];
            [toast show];
        } else {
            Toast* toast = [[Toast alloc]initWithText:@"更新昵称失败，请稍后再试" delay:0 duration:1.f];
            [toast show];
        }
        if (weakSelf.doUpdateNickNameBlock) {
            HSLog(@"update nickName");
            weakSelf.doUpdateNickNameBlock(status);
        }
    }];
}


- (void)clickSetting {
    if (self.didClickSettingsBlock) {
        HSLog(@"click settings");
        self.didClickSettingsBlock();
    }
}

- (void)clickUpdateNickName {
    if (self.didClickEditNickNameBlock) {
        HSLog(@"click nickName");
        self.didClickEditNickNameBlock();
    }
}

- (void)clickUpdateSignature {
    if (self.didClickEditSignatureBlock) {
        HSLog(@"click signature");
        self.didClickEditSignatureBlock();
    }
}

- (void)clickHead {
    if (_isMine) {
        if (self.didClickChangeHeadPhotoBlock) {
            HSLog(@"click upload image");
            self.didClickChangeHeadPhotoBlock();
        }
    } else {
        if (self.didClickOtherZoneHeadPhotoBlock) {
            HSLog(@"click upload image");
            self.didClickOtherZoneHeadPhotoBlock();
        }
    }
}
- (void)clickBG {
    if (self.didClickChangeBGPhotoBlock) {
        HSLog(@"click bg image");
        self.didClickChangeBGPhotoBlock();
    }
}

#pragma mark- set info
- (void)setBgPath:(NSString *)bgPath {
    if (!bgPath || bgPath.length == 0) {
        return;
    }
    
    if (![_bgPath isEqualToString:bgPath]) {
        _bgPath = bgPath;
        __weak typeof(self) weakSelf = self;
        [_bgBlurImageView sd_setImageWithURL:[NSURL URLWithString:bgPath] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakSelf.bgBlurImageView.image = image;
            }
        }];
    }
}
- (void)setHeadPath:(NSString *)headPath {
    if (![_headPath isEqualToString:headPath]) {
        _headPath = headPath;
        __weak typeof(self) weakSelf = self;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.inputImage = image;
        }];
    }
}

- (void)setName:(NSString *)name {
    if (![_name isEqualToString:name]) {
        _name = name;
        _nameLabel.text = name;
        [_nameLabel sizeToFit];
        _nameLabel.centerX = self.centerX;
        
        if (_isMine) {
            if ([HSGHUserInf hasEngName] && [HSGHUserInf shareManager].displayNameMode == 2) {
                _editNameImageView.hidden = NO;
            }
            else {
                _editNameImageView.hidden = YES;
            }
        }
    }
}

- (void)setSexType:(NSString *)sexType {
    if (![_sexType isEqualToString:sexType]) {
        _sexType = sexType;
        if ([_sexType isEqualToString:@"1"]) {
            _sexImageView.image = [UIImage imageNamed:@"zone_head_sex_man"];
        } else {
            _sexImageView.image = [UIImage imageNamed:@"zone_head_sex_women"];
        }
    }
}

- (void)setSignature:(NSString *)signature {
    if (![_signature isEqualToString:signature]) {
        _signature = signature;
        _signatureLabel.text = _signature;
        [self recalcSignaturePosition];
    }
    
    if (_signature == nil && _isMine) {
        _signatureLabel.text = @"编辑个性签名";
        [self recalcSignaturePosition];
    }
}

- (void)recalcSignaturePosition {
    [_signatureLabel sizeToFit];
    _signatureLabel.left =(self.width - _signatureLabel.width - 4 - _editImageView.width) / 2;
    _signatureLabel.height = 12;
}

- (void)updateHeadIconImage:(UIImage*)image {
    _headImageView.image = image;
}

- (void)updateBGImage:(UIImage*)image {
    _bgBlurImageView.image = image;
}

- (NSString*)fetchEditedText {
    return _editTextTF.text;
}

- (UIImage*)fetchCurrentHeadImage {
    return _inputImage;
}

@end
