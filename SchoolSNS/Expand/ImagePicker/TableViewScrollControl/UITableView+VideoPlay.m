//
//  UITableView+VideoPlay.m
//  JPVideoPlayerDemo
//
//  Created by lava on 2017/3/20.
//  Copyright © 2017年 NewPan. All rights reserved.
//

#import "UITableView+VideoPlay.h"
#import <objc/runtime.h>
#import "UIView+WebVideoCache.h"
#import "JPVideoPlayerSwizzle.h"
#import "HSGHHomeTableViewCell.h"
#import "HSGHHomeModelFrame.h"

@implementation UITableView (VideoPlay)

- (void)playVideoInVisiableCells{
    
    NSArray *visiableCells = [self visibleCells];
    HSGHHomeTableViewCell *videoCell = nil;
    
    for (HSGHHomeTableViewCell *cell in visiableCells) {
        if (cell.videoPath.length > 0) {
            videoCell = cell;
            break;
        }
    }
    
    if (videoCell) {
        self.playingCell = videoCell;
        NSURL *url = [NSURL URLWithString:self.playingCell.videoPath];
        //[bestCell.cntImageView jp_playVideoWithURL:url];
        [self.playingCell.cntImageView jp_playVideoMutedHiddenStatusViewWithURL:url];
        [self.playingCell.cntImageView bringSubviewToFront:self.playingCell.muteButton];
    }
}


#pragma mark - Video Play Events

- (void)handleScrollStop{
    HSGHHomeTableViewCell *bestCell = [self findTheBestToPlayVideoCell];
    
    if (bestCell==nil) {
        [self jp_stopPlay];
        [self stopPlay];
        return;
    }
    
    if (self.playingCell.hash != bestCell.hash && bestCell.hash != 0) {
        [self.playingCell.cntImageView jp_stopPlay];
        self.playingCell.muteButton.selected = YES;//关闭声音图标
        
        NSURL *url = [NSURL URLWithString:bestCell.videoPath];
        [bestCell.cntImageView jp_playVideoMutedHiddenStatusViewWithURL:url];
        bestCell.muteButton.hidden = NO;
        [bestCell.cntImageView bringSubviewToFront:bestCell.muteButton];
        
        self.playingCell = bestCell;
    }
}

- (void)handleQuickScroll{
    if (!self.playingCell) return;
    
    if (![self playingCellIsVisiable]) {
        [self stopPlay];
    }
}

- (void)stopPlay{
    [self.playingCell.cntImageView jp_stopPlay];
    self.playingCell.muteButton.selected = YES;//关闭声音图标
    self.playingCell = nil;
}


#pragma mark - Private

- (HSGHHomeTableViewCell *)findTheBestToPlayVideoCell{
    
    HSGHHomeTableViewCell *finnalCell = nil;
    NSArray *visiableCells = [self visibleCells];
    CGFloat gap = MAXFLOAT;
    
    CGRect windowRect = [UIScreen mainScreen].bounds;
    windowRect.origin.y = 53;//JPVideoPlayerDemoNavAndStatusTotalHei;
    //windowRect.size.height -= (JPVideoPlayerDemoNavAndStatusTotalHei + JPVideoPlayerDemoTabbarHei);
    windowRect.size.height -= (53 + 49);
    
    for (HSGHHomeTableViewCell *cell in visiableCells) {
        @autoreleasepool {
            if (cell.videoPath.length > 0) { // If need to play video, 如果这个cell有视频
                CGRect rectInTableView = [self rectForRowAtIndexPath:[self indexPathForCell:cell]];
                CGRect rect = [self convertRect:rectInTableView toView:[self superview]];
                if (HSGH_SCREEN_HEIGHT/2.0-100 < rect.origin.y+100+cell.modelF.contntViewImageVHeight &&
                    HSGH_SCREEN_HEIGHT/2.0+70 > rect.origin.y+100) {
                    finnalCell = cell;
                    break;
                }
                
            }
        }
    }
    
    return finnalCell;
}

- (BOOL)playingCellIsVisiable{
    CGRect windowRect = [UIScreen mainScreen].bounds;
    // because have UINavigationBar here.
    windowRect.origin.y = 53;
    //windowRect.size.height -= 53;
    windowRect.size.height -= 102;
    
    
    CGRect rectInTableView = [self rectForRowAtIndexPath:[self indexPathForCell:self.playingCell]];
    CGRect rect = [self convertRect:rectInTableView toView:[self superview]];
    if (HSGH_SCREEN_HEIGHT/2.0-100 < rect.origin.y+100+self.playingCell.modelF.contntViewImageVHeight &&
        HSGH_SCREEN_HEIGHT/2.0+70 > rect.origin.y+100) {
        return YES;
    }
    
    return NO;
}

- (void)setCurrentDerection:(JPVideoPlayerDemoScrollDerection)currentDerection{
    objc_setAssociatedObject(self, @selector(currentDerection), @(currentDerection), OBJC_ASSOCIATION_ASSIGN);
}

- (JPVideoPlayerDemoScrollDerection)currentDerection{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setMaxNumCannotPlayVideoCells:(NSUInteger)maxNumCannotPlayVideoCells{
    
}

- (NSUInteger)maxNumCannotPlayVideoCells{
    return 1;
}

- (void)setPlayingCell:(HSGHHomeTableViewCell *)playingCell{
    objc_setAssociatedObject(self, @selector(playingCell), playingCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HSGHHomeTableViewCell *)playingCell{
    return objc_getAssociatedObject(self, _cmd);
}

@end
