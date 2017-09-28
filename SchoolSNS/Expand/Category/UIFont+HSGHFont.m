//
//  UIFont+HSGHFont.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIFont+HSGHFont.h"
#import <objc/message.h>

@implementation UIFont (HSGHFont)
//
//+ (void)load {
//    //Normal
//    SEL systemSel = @selector(systemFontOfSize:);
//    SEL ZJSel = @selector(HSGHSystemFontOfSize:);
//    Method systemMethod = class_getClassMethod([self class], systemSel);
//    Method swizzMethod = class_getClassMethod([self class], ZJSel);
//    method_exchangeImplementations(systemMethod, swizzMethod);
//
//    //Bold
//    systemSel = @selector(boldSystemFontOfSize:);
//    ZJSel = @selector(HSGHSystemBoldFontOfSize:);
//    systemMethod = class_getClassMethod([self class], systemSel);
//    swizzMethod = class_getClassMethod([self class], ZJSel);
//    method_exchangeImplementations(systemMethod, swizzMethod);
//}
//
////被替换方法的实现
//+ (UIFont *)HSGHSystemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:@"SourceHanSerifSC-Regular" size:fontSize];
//}
//
//+ (UIFont *)HSGHSystemBoldFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:@"SourceHanSerifSC-Bold" size:fontSize];
//}
//
@end
