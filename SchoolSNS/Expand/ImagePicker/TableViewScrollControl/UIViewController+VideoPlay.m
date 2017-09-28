//
//  UIViewController+VideoPlay.m
//  SchoolSNS
//
//  Created by Murloc on 08/08/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "UIViewController+VideoPlay.h"
#import "JPVideoPlayerSwizzle.h"
#import "UITableView+VideoPlay.h"

@implementation UIViewController (VideoPlay)
+(void)load{
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jp_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(jp_viewWillAppear:) error:nil];
        [self jp_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(jp_viewWillDisappear:) error:nil];
    });
}

- (void)jp_viewWillAppear:(BOOL)animated {
    [self jp_viewWillAppear:animated];
    
    //[[JPVideoPlayerManager sharedManager]resume];
}

- (void)jp_viewWillDisappear:(BOOL)animated {
    [self jp_viewWillDisappear:animated];
    
    //[[JPVideoPlayerManager sharedManager]stopPlay];
}

@end
