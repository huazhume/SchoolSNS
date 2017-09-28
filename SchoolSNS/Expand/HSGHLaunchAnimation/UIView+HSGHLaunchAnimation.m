

#import "UIView+HSGHLaunchAnimation.h"

//current window
#define tyCurrentWindow [[UIApplication sharedApplication].windows firstObject]

@implementation UIView (HSGHLaunchAnimation)

- (void)showInView:(UIView *)superView animation:(id<HSGHLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion
{
    if (superView == nil) {
        NSLog(@"superView can't nil");
        return;
    }
    superView.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    self.frame = superView.bounds;
    
    if (animation && [animation respondsToSelector:@selector(configureAnimationWithView:completion:)]) {
        [animation configureAnimationWithView:self completion:completion];
    }else {
        completion(YES);
    }
}

- (void)showInWindowWithAnimation:(id<HSGHLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion
{
    [self showInView:tyCurrentWindow animation:animation completion:completion];
}

@end
