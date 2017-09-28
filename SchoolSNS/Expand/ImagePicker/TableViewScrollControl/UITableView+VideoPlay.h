//
//  UITableView+VideoPlay.h
//  JPVideoPlayerDemo
//
//  Created by lava on 2017/3/20.
//  Copyright © 2017年 NewPan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSGHHomeTableViewCell;

typedef NS_ENUM(NSUInteger, JPVideoPlayerDemoScrollDerection) {
    JPVideoPlayerDemoScrollDerectionNone = 0,
    JPVideoPlayerDemoScrollDerectionUp = 1, // 向上滚动
    JPVideoPlayerDemoScrollDerectionDown = 2 // 向下滚动
};


@interface UITableView (VideoPlay)

//@property(nonatomic, nullable)UITableViewCell *playingCell;


/**
 * The cell of playing video.
 * 正在播放视频的cell.
 */
@property(nonatomic, nullable)HSGHHomeTableViewCell *playingCell;

/**
 * The number of cells cannot stop in screen center.
 * 滑动不可及cell个数.
 */
@property(nonatomic)NSUInteger maxNumCannotPlayVideoCells;

/**
 * The scroll derection of tableview now.
 * 当前滚动方向类型.
 */
@property(nonatomic)JPVideoPlayerDemoScrollDerection currentDerection;

/**
 * The dictionary of record the number of cells that cannot stop in screen center.
 * 滑动不可及cell字典.
 */
//@property(nonatomic, nonnull)NSDictionary *dictOfVisiableAndNotPlayCells;

- (void)playVideoInVisiableCells;

- (void)handleScrollStop;

- (void)handleQuickScroll;

- (void)stopPlay;

@end
