

#import <UIKit/UIKit.h>

@protocol HSGHLaunchAnimationProtocol <NSObject>

- (void)configureAnimationWithView:(UIView *)view completion:(void (^)(BOOL finished))completion;

@end
