//
//  HSGHMoreCommentsLabel.h
//  SchoolSNS
//
//  Created by Murloc on 14/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHMoreCommentsHelp.h"
#import "HSGHMoreCommentsModel.h"


@interface HSGHMoreCommentsLabel : UIView

//- (void)setContent:(NSAttributedString*)string;
- (void)setContent:(HSGHMoreCommentsLayoutModel*)layoutModel;

@end
