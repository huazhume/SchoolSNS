//
//  TXLimitedTextField.m
//  InputKit
//
//  Created by tingxins on 04/05/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXLimitedTextField.h"
#import "TXDynamicDelegate.h"
#import "TXMatchManager.h"

@interface TXLimitedTextField (){
    NSRange _selectionRange;
}

@property (copy, nonatomic) NSString *historyText;

@end

@implementation TXLimitedTextField

@synthesize limitedNumber = _limitedNumber;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)load {
    @autoreleasepool {
        [self tx_registerDynamicDelegate];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addNotifications];
        [self addConfigs];
        if (!self.delegate) { [self addDelegate]; }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addNotifications];
    [self addConfigs];
    if (!self.delegate) { [self addDelegate]; }
}

#pragma mark - Configs Methods

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self];
}

- (void)addDelegate {
    self.delegate = nil;
}

- (void)addConfigs {
    self.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)clearCache {
    self.text = @"";
    _historyText = nil;
}

#pragma mark - Setter + Getter Methods

- (void)setLimitedNumber:(NSInteger)limitedNumber {
    _limitedNumber = limitedNumber;
}

- (NSInteger)limitedNumber {
    if (_limitedNumber) return _limitedNumber;
    return _limitedNumber = MAX_INPUT;
}

- (void)setLimitedRegEx:(NSString *)limitedRegEx {
    self.limitedRegExs = @[limitedRegEx];
}

- (void)setLimitedRegExs:(NSArray *)limitedRegExs {
    NSString *realRegEx;
    NSMutableArray *realRegExs = [NSMutableArray array];
    for (NSString *regEx in limitedRegExs) {
        realRegEx = [regEx stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        if (realRegEx.length) {
            [realRegExs addObject:realRegEx];
        }
    }
    _limitedRegExs = realRegExs;
    
    [self clearCache];
}

#pragma mark - NSNotification

// 主要用于处理 高亮 文本
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification {
    if (self != notification.object) return;

    UITextField *textField = notification.object;
    
    NSString *currentText = textField.text;
    NSInteger maxLength = self.limitedNumber;
    //获取高亮部分
    UITextRange *markedTextRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:markedTextRange.start offset:0];
    
    BOOL isMatch = YES;
    switch (self.limitedType) {
        case TXLimitedTextFieldTypeDefault:
            break;
        case TXLimitedTextFieldTypePrice:
            isMatch = [TXMatchManager matchLimitedTextTypePriceWithComponent:textField value:currentText];
            break;
        case TXLimitedTextFieldTypeCustom:
         isMatch = [TXMatchManager matchLimitedTextTypeCustomWithRegExs:self.limitedRegExs component:textField value:currentText];
            break;
        default:break;
    }
    
    if (isMatch) {
        self.historyText = textField.text;
    }
    // 没有高亮选择的字，则对已输入的字符进行数量统计和限制
    if (!position) {
        BOOL flag = NO;
        if (currentText.length > maxLength) {
            textField.text = [currentText substringToIndex:maxLength];
            flag = YES;
        }
        
        if (self.isTextSelecting && !isMatch) {
            flag = YES;
            NSString *historyText = self.historyText;
            if (!historyText.length) {
                textField.text = @"";
            }else {
                if (self.historyText.length <= textField.text.length) {
                    textField.text = self.historyText;
                }
            }
        }
        if (_selectionRange.length && !isMatch && (_selectionRange.length + _selectionRange.location <= currentText.length)) {
            NSString *limitedText = [currentText substringWithRange:_selectionRange];
            textField.text = [textField.text stringByReplacingOccurrencesOfString:limitedText withString:@"" options:0 range:_selectionRange];
            _selectionRange = NSMakeRange(0, 0);
        }
        if (flag)
            [self sendIllegalMsgToObject];
    }else {
        _selectionRange = [self rangeFromTextRange:textField.markedTextRange];
    }
}

- (NSRange)rangeFromTextRange:(UITextRange *)textRange {
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.start];
    NSInteger length = [self offsetFromPosition:textRange.start toPosition:textRange.end];
    return NSMakeRange(location, length);
}

- (void)sendIllegalMsgToObject {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"// get rid of undeclared selector warning!
    SEL sel = @selector(inputKitDidLimitedIllegalInputText:);
#pragma clang diagnostic pop
    if (self.delegate && [self.delegate.class isSubclassOfClass:[TXDynamicDelegate class]]) {
        TXDynamicDelegate *dynamicDelegate = (TXDynamicDelegate *)self.delegate;
        [dynamicDelegate sendMsgToObject:dynamicDelegate.realDelegate with:self SEL:sel];
    }
}

@end

@interface TXDynamicTXLimitedTextFieldDelegate: TXDynamicDelegate

@end

@implementation TXDynamicTXLimitedTextFieldDelegate

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        flag = [realDelegate textFieldShouldBeginEditing:textField];
    return flag;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [realDelegate textFieldDidBeginEditing:textField];
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        flag = [realDelegate textFieldShouldEndEditing:textField];
    return flag;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [realDelegate textFieldDidEndEditing:textField];
}

// if implemented, called in place of textFieldDidEndEditing:
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)])
        [realDelegate textFieldDidEndEditing:textField reason:reason];
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        flag = [realDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    BOOL matchResult = YES;
    if ([textField isKindOfClass:[TXLimitedTextField class]]) {
        TXLimitedTextField *limitedTextField = (TXLimitedTextField *)textField;
        
        NSMutableString *matchStr = [NSMutableString stringWithString:textField.text];
        [matchStr insertString:string atIndex:range.location];
        
        BOOL isDeleteOperation = (range.length > 0 && string.length == 0) ? YES : NO;        
        switch (limitedTextField.limitedType) {
            case TXLimitedTextFieldTypeDefault:
                break;
                
            case TXLimitedTextFieldTypePrice: {
                matchResult = [TXMatchManager matchLimitedTextTypePriceWithComponent:limitedTextField value:matchStr];
            }
                break;
                
            case TXLimitedTextFieldTypeCustom: {
                if (limitedTextField.isTextSelecting) {// 高亮选中文本判断
                    matchResult = YES;
                }else {
                    matchResult = [TXMatchManager matchLimitedTextTypeCustomWithRegExs:limitedTextField.limitedRegExs component:limitedTextField value:matchStr];
                    
                    //添加首字母大写
                    if (limitedTextField.isFirstBig && matchResult && (textField.text == nil || textField.text.length == 0)) {
                        textField.text = string.capitalizedString;
                        return false;
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
        BOOL result = flag && (matchResult || isDeleteOperation);
        // Send limited msg.
        if (!result) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"// get rid of undeclared selector warning!
            SEL sel = @selector(inputKitDidLimitedIllegalInputText:);
#pragma clang diagnostic pop
            [self sendMsgToObject:self.realDelegate with:textField SEL:sel];
        }
        return result;
    }
    return matchResult && flag;
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldClear:)])
        flag = [realDelegate textFieldShouldClear:textField];
    return flag;
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL flag = YES;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
        flag = [realDelegate textFieldShouldReturn:textField];
    
    // Coding
    // TODO: Strings format
    
    return flag;
}

#pragma mark - Custom Methods (Remains) Unused

static bool (*tx_trigger0)(id, SEL, UITextField *);
- (BOOL)isResponseToSEL:(SEL)sel obj:(UITextField *)obj {
    if ([self.realDelegate respondsToSelector:sel]) {
        tx_trigger0 = (bool (*)(id, SEL, UITextField *))[(NSObject *)self.realDelegate methodForSelector:sel];
        if (tx_trigger0) {
            return tx_trigger0(self, sel, obj);
        }
    }
    return YES;
}

static void (*tx_trigger1)(id, SEL, UITextField *);
- (void)isResponseToSELWithoutResult:(SEL)sel obj:(UITextField *)obj {
    if ([self.realDelegate respondsToSelector:sel]) {
        tx_trigger1 = (void (*)(id, SEL, UITextField *))[(NSObject *)self.realDelegate methodForSelector:sel];
        if (tx_trigger1) {
            tx_trigger1(self, sel, obj);
        }
    }
}

@end
