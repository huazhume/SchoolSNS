//
//  HSGHCommentsCallFriendViewModel.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 18/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTextView.h"
@interface YYTextMatchBindingParser :NSObject <YYTextParser>
@end


@interface HSGHCommentsCallFriendViewModel : NSObject

+ (void)addOneFriend:(NSString*)name userId:(NSString*)userId location:(NSUInteger)location yyTextView:(YYTextView*)textView;
+ (NSString*)convertToMatchedTextBindings:(YYTextView*)textView;

@end
