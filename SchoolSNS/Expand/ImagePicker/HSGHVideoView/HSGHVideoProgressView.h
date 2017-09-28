//
//  HSGHVideoProgressView.h
//  SchoolSNS
//
//  Created by Murloc on 31/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView: UIView

@end

@interface HSGHVideoProgressView : UIView

- (BOOL)hasEnded;
- (void)longPressDidStart;
- (void)longPressWithTime:(CGFloat)second;
- (void)longPressDidEnd;

- (void)refreshFlashView:(BOOL)show;
- (void)setLastSelected;
- (void)deleteLastSelected;
- (void)restoreLastSelected;
- (void)stopTimer;
@end
