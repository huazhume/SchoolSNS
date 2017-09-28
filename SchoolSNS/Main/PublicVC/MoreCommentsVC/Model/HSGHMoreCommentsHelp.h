//
//  HSGHMoreCommentsHelp.h
//  SchoolSNS
//
//  Created by Murloc on 14/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModel.h"
#import "HSGHMoreCommentsModel.h"


@interface HSGHMoreCommentsHelp : NSObject
+ (NSAttributedString *)generateAttrStringWithFrom:(HSGHHomeReplay *)model;
+ (NSAttributedString *)generateAttrString:(HSGHHomeReplay *)model;
+ (CGFloat)calcHeight:(NSAttributedString*)str width:(CGFloat)width limitLines:(NSUInteger)limitLines;

+ (HSGHMoreCommentsLayoutModel*)convertToLayoutModel:(HSGHHomeReplay *)model;

@end
