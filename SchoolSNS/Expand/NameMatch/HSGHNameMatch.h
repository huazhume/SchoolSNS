//
//  HSGHNameMatch.h
//  SchoolSNS
//
//  Created by Murloc on 24/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHNameMatch : NSObject

+ (NSString *)pinyinOfString:(NSString*)nameStr;
+ (BOOL)isMatchName:(NSString*)name;

+ (NSString *)pinyinMultiOfString:(NSString*)nameStr;

@end
