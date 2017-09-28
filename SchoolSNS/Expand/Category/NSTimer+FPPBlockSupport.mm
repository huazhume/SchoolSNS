//
// Created by FlyingPuPu on 08/01/2017.
// Copyright (c) 2017 FlyingPuPu. All rights reserved.
//

#import "NSTimer+FPPBlockSupport.h"
#import <UIKit/UIKit.h>


@implementation NSTimer (FPPBlockSupport)
//iOS系统的方法 scheduledTimerWithTimeInterval
+ (NSTimer *)fpp_scheduledTimerWithTimeInterval:(NSTimeInterval)intervel
                                        repeats:(BOOL)repeats
                                          block:(void (^)(NSTimer *))block {
    if ([[[UIDevice currentDevice]systemVersion]floatValue] > 10.0) {
        return [self scheduledTimerWithTimeInterval:intervel repeats:repeats block:block];
    }

    return [self scheduledTimerWithTimeInterval:intervel
                                         target:self
                                       selector:@selector(fpp_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)fpp_blockInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
