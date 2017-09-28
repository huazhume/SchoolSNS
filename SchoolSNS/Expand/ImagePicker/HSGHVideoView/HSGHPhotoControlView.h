//
//  HSGHCropCoverView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidTakeCapture)();

@interface HSGHPhotoControlView : UIView

@property (nonatomic, copy) DidTakeCapture didTakeCapture;

@end
