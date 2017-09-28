//
//  HSGHCropCoverView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHPhotoControlView.h"
#import "HSGHVideoControlView.h"
#import "HSGHVideoStatus.h"

typedef void(^ScrollBlock)(BOOL isVideo);

@interface HSGHVideoScrollBottomView : UIView

@property (nonatomic, strong) UIScrollView* contentScrollView;
@property (nonatomic, strong) HSGHPhotoControlView* leftView;
@property (nonatomic, strong) HSGHVideoControlView* rightView;

@property (nonatomic, copy) ScrollBlock scrollBlock;

- (void)refreshUI:(TakePhotoType)type;

@end
