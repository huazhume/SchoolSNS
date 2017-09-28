//
//  HSGHCropCoverView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHVideoScrollBottomView.h"


@interface HSGHVideoScrollBottomView()<UIScrollViewDelegate>





@end


@implementation HSGHVideoScrollBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}



- (void)setupView {
    //ScrollView
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _contentScrollView.contentSize = CGSizeMake(self.width * 2, 0);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.directionalLockEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.clipsToBounds = NO;
    [self addSubview:_contentScrollView];
    
#if 0
    //PhotoView
    _leftView = [[HSGHPhotoControlView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [_contentScrollView addSubview:_leftView];
    
    //VideoView
    _rightView = [[HSGHVideoControlView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    [_contentScrollView addSubview:_rightView];
#else 
    //VideoView
    _rightView = [[HSGHVideoControlView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [_contentScrollView addSubview:_rightView];
    _contentScrollView.scrollEnabled = false;
#endif
}



#pragma mark - ContentScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        if (_scrollBlock) {
            _scrollBlock(_contentScrollView.contentOffset.x >= scrollView.width);
        }
    }
}


#pragma mark - actions
//因为这个界面默认是包含了拍照和视频，现在调整为只能视频，所以做了保留处理，限制不能滚动，同时更新图片的模式的时候也是到了video
- (void)refreshUI:(TakePhotoType)type {
#if 0
    switch (type) {
        case SelectedPhoto:
            [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            
            break;
        case TakePhoto:
            [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            break;
            
        case TakeVideo:
            [self.contentScrollView setContentOffset:CGPointMake(_contentScrollView.width, 0) animated:NO];
            break;
            
        default:
            break;
    }
#else
    [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
#endif

}


@end
