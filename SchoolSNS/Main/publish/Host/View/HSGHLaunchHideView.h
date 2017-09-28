//
//  HSGHLaunchHideView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LaunchHideBlock)(UIButton * btn);

@interface HSGHLaunchHideView : UIView

@property (copy, nonatomic)  LaunchHideBlock block;

@end
