//
// Created by FlyingPuPu on 08/01/2017.
// Copyright (c) 2017 FlyingPuPu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (FPPBlockSupport)
+ (NSTimer *)fpp_scheduledTimerWithTimeInterval:(NSTimeInterval)intervel
                                        repeats:(BOOL)repeats
                                          block:(void (^)(NSTimer *timer))block;
@end