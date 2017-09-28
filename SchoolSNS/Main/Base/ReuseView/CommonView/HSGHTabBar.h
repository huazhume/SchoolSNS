//
//  DWTabBar.h
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSTabbarBarDelegate <NSObject>

@optional
// 显示或者隐藏分类现实的View
-(void)showTopicCategorySelectedView;

@end


@interface HSGHTabBar : UITabBar
@property (nonatomic, weak) id<HSTabbarBarDelegate> publishdelegate;

@end
