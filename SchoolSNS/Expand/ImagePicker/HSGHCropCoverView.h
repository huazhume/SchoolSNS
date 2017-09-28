//
//  HSGHCropCoverView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CorpShowMode) {
    CropShowTop = 0,
    CropShowBottom = 1
};


#define CropCoverViewHeight        27
typedef void (^StartDragBlock)();
typedef void (^EndDragBlock)();


@interface HSGHCropCoverView : UIView
@property (nonatomic, assign) CGFloat normalBottom;
@property (nonatomic, assign) CGFloat normalTop;
@property (nonatomic, assign) CorpShowMode showMode;
- (void)updateTop: (CGFloat)top;
- (void)updateBottom: (CGFloat)bottom;
@property (nonatomic, assign) CGFloat limitedHeight;

@property (nonatomic, copy) StartDragBlock startBlock;
@property (nonatomic, copy) EndDragBlock endBlock;

@end
