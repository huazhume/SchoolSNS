//
//  NSObject+HSGHMyFont.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/10.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+HSGHMyFont.h"
#import "HSGHTools.h"

//不同设备的屏幕比例(当然倍数可以自己控制)

@implementation UIButton (MyFont)

//+ (void)load {
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder *)aDecode {
//    [self myInitWithCoder:aDecode];
//    if (self) {
//
//        //部分不像改变字体的 把tag值设置成333跳过
//        if (self.titleLabel.tag != 333) {
//            CGFloat fontSize = self.titleLabel.font.pointSize;
//
//            if ([HSGHTools isBoldFont:self.titleLabel.font]) {
//                self.titleLabel.font = [UIFont fontWithName:@"SourceHanSerifSC-Bold" size:fontSize];
//            } else {
//                self.titleLabel.font = [UIFont fontWithName:@"SourceHanSerifSC-Regular" size:fontSize];
//            }
//        }
//    }
//    return self;
//}
//
//@end
//
//
//@implementation UILabel (myFont)
//
//+ (void)load {
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder *)aDecode {
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不像改变字体的 把tag值设置成333跳过
//        if (self.tag != 333) {
//            CGFloat fontSize = self.font.pointSize;
//            if ([HSGHTools isBoldFont:self.font]) {
//                self.font = [UIFont fontWithName:@"SourceHanSerifSC-Bold" size:fontSize];
//            } else {
//                self.font = [UIFont fontWithName:@"SourceHanSerifSC-Regular" size:fontSize];
//            }
//        }
//    }
//    return self;
//}
//
//@end
//
//@implementation UITextField (myFont)
//
//+ (void)load {
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder *)aDecode {
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不像改变字体的 把tag值设置成333跳过
//        if (self.tag != 333) {
//            CGFloat fontSize = self.font.pointSize;
//            if ([HSGHTools isBoldFont:self.font]) {
//                self.font = [UIFont fontWithName:@"SourceHanSerifSC-Bold" size:fontSize];
//            } else {
//                self.font = [UIFont fontWithName:@"SourceHanSerifSC-Regular" size:fontSize];
//            }
//        }
//    }
//    return self;
//}
//
//@end
//
//@implementation UITextView (myFont)
//
//+ (void)load {
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder *)aDecode {
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不像改变字体的 把tag值设置成333跳过
//        if (self.tag != 333) {
//            CGFloat fontSize = self.font.pointSize;
//            if ([HSGHTools isBoldFont:self.font]) {
//                self.font = [UIFont fontWithName:@"SourceHanSerifSC-Bold" size:fontSize];
//            } else {
//                self.font = [UIFont fontWithName:@"SourceHanSerifSC-Regular" size:fontSize];
//            }
//        }
//    }
//    return self;
//}

@end
