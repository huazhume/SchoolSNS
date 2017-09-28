//
//  HSGHCropCoverView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHVideoControlView.h"
#import "HSGHVideoStatus.h"
#import "NSTimer+FPPBlockSupport.h"


@implementation TimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)dealloc {
    HSLog(@"== dealloc TimeView");
}

- (void)flash {
    _redPointImageView.alpha = (_redPointImageView.alpha == 1) ? 0 : 1;
}

- (void)setupViews {
    _redPointImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redPoint"]];
    _redPointImageView.frame = CGRectMake(0, 0, 4, 4);
    _redPointImageView.centerY = self.centerY;
    [self addSubview:_redPointImageView];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, 30, 15)];
    _timeLabel.textColor = HEXRGBCOLOR(0x272727);
    _timeLabel.font = [UIFont boldSystemFontOfSize:13.f];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.text = @"0:00 ";
    [_timeLabel sizeToFit];
    _timeLabel.left = 6;
    [self addSubview:_timeLabel];
    
    self.width = 4 + 2 + _timeLabel.width;
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer fpp_scheduledTimerWithTimeInterval:0.6 repeats:YES block:^(NSTimer *timer) {
        [weakSelf flash];
    }];
}

- (void)updateTime:(CGFloat)time {
    NSUInteger timeInt = (NSUInteger)time;
    if (timeInt < 10) {
        _timeLabel.text = [NSString stringWithFormat:@"0:0%@", @(timeInt)];
    }
    else {
        _timeLabel.text = [NSString stringWithFormat:@"0:%@", @(timeInt)];
    }
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

@end


@interface HSGHVideoControlView()

@property (nonatomic, strong) UIImageView* captureImageView;

@property (nonatomic, assign) VideoBottomUIType type;

@end


@implementation HSGHVideoControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
        _type = VideoNotStarted;
    }
    
    return self;
}


- (void)setupView {
    _progressView = [[HSGHVideoProgressView alloc]initWithFrame:CGRectMake(0, 0.5, self.width, 4)];
    [self addSubview: _progressView];
    
    CGRect rect = CGRectMake((self.width - 76) / 2,
                             (self.height - 76) / 2, 76, 76);
    _captureImageView = [[UIImageView alloc] initWithFrame:rect];
    _captureImageView.image = [UIImage imageNamed:@"ImagePickerCapture"];
    _captureImageView.userInteractionEnabled = YES;
    [self addSubview:_captureImageView];
    
    _timeView = [[TimeView alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    [self addSubview:_timeView];
    _timeView.centerY = _captureImageView.top / 2;
    _timeView.centerX = self.width / 2 - 2;
    _timeView.hidden = YES;
    
    
    UILongPressGestureRecognizer* longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [_captureImageView addGestureRecognizer:longPressGR];
}

- (void)longAction:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [_progressView longPressDidStart];
            _timeView.hidden = NO;
            
            if (_longPressStart) {
                _longPressStart();
            }
            
            break;
        case UIGestureRecognizerStateChanged:
            _timeView.hidden = NO;
            if (_longPressing) {
                _longPressing();
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            [_progressView longPressDidEnd];
            _timeView.hidden = YES;
            if (_longPressEnd) {
                _longPressEnd();
            }
            
            break;
        default:
            break;
    }
}


@end
