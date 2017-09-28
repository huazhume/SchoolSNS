//
//  HSGHZoneAreaBHeadView.h
//  SchoolSNS
//
//  Created by Murloc on 15/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SectionBlock)(BOOL isFirstSection);

@interface HSGHZoneAreaBHeadView : UITableViewHeaderFooterView

@property (nonatomic, copy) SectionBlock sectionBlock;

- (BOOL)isSecond;
- (void)clickSelection:(BOOL)isMine;

+ (CGSize)shouldSize;
@end
