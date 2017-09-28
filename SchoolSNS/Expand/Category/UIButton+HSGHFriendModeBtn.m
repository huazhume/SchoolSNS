//
//  UIButton+HSGHFriendModeBtn.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIButton+HSGHFriendModeBtn.h"
#import <objc/runtime.h>
static const void *modeManagerKey = &modeManagerKey;

@implementation UIButton (HSGHFriendModeBtn)

// 添加属性和方法
- (HSGHFriendStateManager *)modeManager {
    return objc_getAssociatedObject(self, modeManagerKey);
}

- (void)setModeManager:(HSGHFriendStateManager *)modeManager {
    objc_setAssociatedObject(self, modeManagerKey, modeManager, OBJC_ASSOCIATION_RETAIN);
//    [self setImage:modeManager.friendModeImage forState:UIControlStateNormal];
}
@end
