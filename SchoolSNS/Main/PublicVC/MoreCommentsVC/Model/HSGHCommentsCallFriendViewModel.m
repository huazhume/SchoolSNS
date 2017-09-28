//
//  HSGHCommentsCallFriendViewModel.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 18/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHCommentsCallFriendViewModel.h"
#import "NSAttributedString+YYText.h"
#import "HSGHZoneVC.h"

@interface YYTextMatchBindingParser()
@property (nonatomic, strong) NSRegularExpression *regex;
@end

@implementation YYTextMatchBindingParser
- (instancetype)init {
    self = [super init];
    NSString *pattern = @"@([^<>]*)<([^<>]*)>";//(.)* 任意字符
    self.regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    __block BOOL changed = NO;
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithAttributedString:text];
    
    __block NSInteger increaseLength = 0;
    [_regex enumerateMatchesInString:changeText.string options:NSMatchingWithoutAnchoringBounds range:changeText.yy_rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result) {
            NSRange innerRange = result.range;
            if (innerRange.location == NSNotFound || innerRange.length < 1) return;
            
            //Find
            NSString* subStr = [changeText.string substringWithRange: innerRange];
            NSRange subRange = [subStr rangeOfString:@"<"];
            if (subRange.location != NSNotFound) {
                NSString* userId = [subStr substringWithRange:NSMakeRange(subRange.location + 1, subStr.length - subRange.location - 1 - 1)];
                
                
                [text replaceCharactersInRange:NSMakeRange(innerRange.location + increaseLength + subRange.location, subStr.length - subRange.location) withString:@" "];
                
                NSRange changeRange = NSMakeRange(innerRange.location + increaseLength, subRange.location);
                
//                [text yy_setTextHighlightRange:changeRange
//                                         color:HEXRGBCOLOR(0x3897f0)
//                               backgroundColor:text.yy_color
//                                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//                                         [HSGHZoneVC enterOtherZone:userId];
//                                     }];
//                [text yy_setFont:[UIFont boldSystemFontOfSize:14.f] range:changeRange];
                
                [text yy_setTextHighlightRange:changeRange
                                         color:HEXRGBCOLOR(0x3897f5)
                               backgroundColor:text.yy_color
                                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                         [HSGHZoneVC enterOtherZone:userId];
                                     }];
                [text yy_setFont:[UIFont systemFontOfSize:14.f] range:changeRange];
                
                increaseLength -= subStr.length - subRange.location - 1;
                changed = YES;
            }
        }
    }];
    
//    if (changed) {
//        text = changeText;
//    }
    return changed;
}

@end




@interface HSGHCommentsCallFriendViewModel()
@end


@implementation HSGHCommentsCallFriendViewModel
+ (void)addOneFriend:(NSString*)name userId:(NSString*)userId location:(NSUInteger)location yyTextView:(YYTextView*)textView{
    
    if(![userId isEqualToString:@""]){
        NSMutableAttributedString* mutableStr = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:@""];
        [tagText yy_appendString:[NSString stringWithFormat:@"@%@ ", name]];
        tagText.yy_font = textView.font;
        tagText.yy_color = textView.textColor;
        YYTextBinding* textBinding = [YYTextBinding bindingWithDeleteConfirm:NO];
        textBinding.bindingDescription = UN_NIL_STR(userId);
        [tagText yy_setTextBinding:textBinding range:tagText.yy_rangeOfAll];
        [mutableStr insertAttributedString:tagText atIndex:location];
        textView.attributedText = mutableStr;
        //Set point range
        NSRange range;
        range.location = location + tagText.length;
        range.length = 0;
        textView.selectedRange = range;
    }
}

//From "@name " ==> @"name<userId>"
+ (NSString*)convertToMatchedTextBindings:(YYTextView*)textView {
    NSMutableString* serverStr = [textView.attributedText.string mutableCopy];
    __block NSUInteger startIndex = 0;
    __block NSUInteger increaseLength = 0;
    [textView.attributedText enumerateAttribute:YYTextBindingAttributeName inRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (range.length > 0 && value) {
            startIndex = range.location + range.length;
            NSString* addedStr = [NSString stringWithFormat:@"<%@>", ((YYTextBinding*)value).bindingDescription];
            [serverStr replaceCharactersInRange:NSMakeRange(range.location + increaseLength + range.length - 1 , 1) withString:addedStr];
            increaseLength += addedStr.length - 1;
            HSLog(@"replace is %@", serverStr);
        }
    }];
    
    return serverStr.copy;
}

@end
