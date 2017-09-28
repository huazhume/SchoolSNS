

#import "HSGHLaunchBaseAnimation.h"

@interface HSGHLaunchFadeScaleAnimation : HSGHLaunchBaseAnimation

// super property
// duration default 0.6
// delay default 0.2
// options default UIViewAnimationCurveEaseOut

@property (nonatomic, assign) CGFloat scale;   // scale ratio default 1.6

+ (instancetype)fadeAnimation;

+ (instancetype)fadeScaleAnimation; // default

+ (instancetype)fadeAnimationWithDelay:(CGFloat)delay;

@end
