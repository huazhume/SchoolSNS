//
// Created by FlyingPuPu on 28/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
// Unused , maybe do at future.

#import "HSGHNetReturnBase.h"


@implementation HSGHNetReturnBase {

}
- (BOOL)isSuccess {
    return (self.resultCode == 1 // Success
            || self.resultCode == 205 // No more data
            || self.resultCode == 200);
}
@end