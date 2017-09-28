

#import <Foundation/Foundation.h>
#import "HSGHLaunchAnimationProtocol.h"

@interface HSGHLaunchBaseAnimation : NSObject<HSGHLaunchAnimationProtocol>

@property (nonatomic, assign) CGFloat duration;// duration time
@property (nonatomic, assign) CGFloat delay;   // delay hide
@property (nonatomic, assign) UIViewAnimationOptions options;

@end
