

#import <UIKit/UIKit.h>
#import "HSGHLaunchAnimationProtocol.h"

@interface UIView (HSGHLaunchAnimation)

- (void)showInWindowWithAnimation:(id<HSGHLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion;

//- (void)showInView:(UIView *)superView animation:(id<HSGHLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion;

@end
