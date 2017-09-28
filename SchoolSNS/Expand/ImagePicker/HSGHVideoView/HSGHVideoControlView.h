//
//  HSGHCropCoverView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHVideoProgressView.h"


typedef void(^DidLongPressStart)();
typedef void(^DidLongPressing)();
typedef void(^DidLongPressEnd)();


@interface TimeView : UIView

@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIImageView*  redPointImageView;
@property (nonatomic, strong) NSTimer* timer;

- (void)updateTime:(CGFloat)time;

- (void)stopTimer;

@end

@interface HSGHVideoControlView : UIView
@property (nonatomic, strong) HSGHVideoProgressView* progressView;
@property (nonatomic, strong) TimeView*  timeView;

@property (nonatomic, copy) DidLongPressStart longPressStart;
@property (nonatomic, copy) DidLongPressing longPressing;
@property (nonatomic, copy) DidLongPressEnd longPressEnd;

@end
