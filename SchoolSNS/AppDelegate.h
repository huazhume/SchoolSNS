/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) CGFloat homeContentWidth;

- (void)enterMainUI;
- (void)enterLogin;
- (void)enterCompleteInfo;
- (void)enterFixesCNName;
- (void)enterCompleteSchool;

+ (AppDelegate *)instanceApplication;
- (UINavigationController *)fetchCurrentNav;


- (UIViewController *)fetchCurrentVC;

- (void)indicatorShow;
- (void)indicatorDismiss;
- (void)indicatorShowWithFull;

- (void)clearPushAlias;


- (void)umSocialType:(UMSOCIAL_MODE )mode WithTitle:(NSString *)title description:(NSString *)description ImageUrl:(NSString *)imageUrl webUrl:(NSString *)webUrl image:(UIImage *)image;
@end
