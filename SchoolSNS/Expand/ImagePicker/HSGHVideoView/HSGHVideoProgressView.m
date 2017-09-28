//
//  HSGHVideoProgressView.m
//  SchoolSNS
//
//  Created by Murloc on 31/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHVideoProgressView.h"
#import "HSGHVideoStatus.h"
#import "NSTimer+FPPBlockSupport.h"


@interface ProgressView()
- (void)setSelected:(BOOL)selected ;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXRGBCOLOR(0x272727);
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected {
    self.backgroundColor = selected ? [UIColor redColor] : HEXRGBCOLOR(0x272727);
}

@end



@interface HSGHVideoProgressView()

@property (nonatomic, strong) UIView  *flashView;
@property (nonatomic, strong) UIView  *separateView;

@property (nonatomic, assign) VideoBottomUIType type;


@property (nonatomic, strong) NSMutableArray *progressViews;
@property (nonatomic, strong) ProgressView *currentView;

@property (nonatomic, strong) NSTimer*  timer;
@end


@implementation HSGHVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _type = VideoNotStarted;
        _progressViews = [NSMutableArray new];
        [self setupViews];
    }
    return self;
}

- (void)dealloc {
    HSLog(@"== dealloc progressView");
}

- (void)flash {
    _flashView.alpha = (_flashView.alpha == 1) ? 0 : 1;
}

- (void)setupViews {
    _separateView = [[UIView alloc]initWithFrame:CGRectMake([self secondToWidth: kMinVideoTime], 0, [self secondToWidth:SpaceVideoSecond*2], self.height)];
    _separateView.backgroundColor = [UIColor blackColor];
    [self addSubview:_separateView];
    
    
    //_flashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self secondToWidth:0.8], self.height)];
    _flashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self secondToWidth:0.1], self.height)];
    _flashView.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_flashView];
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer fpp_scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
        [weakSelf flash];
    }];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}


//Find
- (CGFloat)shouldBeAddedPosition {
    ProgressView* view = _progressViews.lastObject;
    if (view) {
        return view.right;
    }
    return 0;
}

- (BOOL)hasEnded {
    ProgressView* view = _progressViews.lastObject;
    if (view && view.right >= self.width) {
        return true;
    }
    
    return false;
}


//Creat
- (void)longPressDidStart {
    if ([self hasEnded]) {
        return;
    }
    
    [self restoreLastSelected];
    
    _currentView = [[ProgressView alloc]initWithFrame:CGRectMake([self shouldBeAddedPosition], 0, 0.1, self.height)];
    if (_progressViews.count > 0) {
        _currentView.left += [self secondToWidth:SpaceVideoSecond];
    }
    
    [self addSubview:_currentView];
    [_progressViews addObject:_currentView];
    
    [self refreshFlashView:false];
}

- (void)longPressWithTime:(CGFloat)second {
    if (second == 0) {
        return;
    }
    CGFloat width = [self secondToWidth: (second - SpaceVideoSecond)];
    width = width < 0 ? 0 : width;
    _currentView.width = width;
}


- (void)longPressDidEnd {
    [self refreshFlashView: true];
}

//Modify
- (void)restoreLastSelected {
    ProgressView* view = _progressViews.lastObject;
    [view setSelected:NO];
}


- (void)setLastSelected {
    ProgressView* view = _progressViews.lastObject;
    [view setSelected:YES];
}

- (void)deleteLastSelected {
    ProgressView* view = _progressViews.lastObject;
    [view removeFromSuperview];
    [_progressViews removeLastObject];
    [self refreshFlashView:YES];
}

- (CGFloat)secondToWidth:(CGFloat)s {
    return self.width / kMaxVideoTime * s;
}


- (void)refreshFlashView:(BOOL)show {
    _flashView.hidden = !show;
    if (!_flashView.hidden) {
        [self performSelector:@selector(flash) withObject:nil afterDelay:0.5];
    }
    else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self ];
    }
    _flashView.left = [self shouldBeAddedPosition];
    if (_flashView.left + _flashView.width > self.width) {
        _flashView.left = self.width - _flashView.width;
    }
    [self bringSubviewToFront:_flashView];
}


@end
