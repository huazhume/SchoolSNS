//
//  HSGHCropCoverView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHPhotoControlView.h"

@interface HSGHPhotoControlView()
@property (nonatomic, strong) UIButton* captureButton;

@end


@implementation HSGHPhotoControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}



- (void)setupView {
    CGRect rect = CGRectMake((self.width - 76) / 2,
                      (self.height - 76) / 2, 76, 76);
    _captureButton = [[UIButton alloc] initWithFrame:rect];
    [_captureButton setImage:[UIImage imageNamed:@"ImagePickerCapture"] forState:UIControlStateNormal];
    [_captureButton addTarget:self action:@selector(takeCapture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_captureButton];
}


- (void)takeCapture {
    if (_didTakeCapture) {
        _didTakeCapture();
    }
}

@end
