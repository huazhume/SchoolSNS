//
//  HSGHCameraPickerView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 22/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHCameraPickerView.h"
#import "CaptureSessionManager.h"

@interface HSGHCameraPickerView () <CaptureSessionManagerDelegate>

@property(nonatomic, strong) CaptureSessionManager *captureManager;

@property(nonatomic, strong) UIButton *swapButton;
@property(nonatomic, strong) UIButton *captureButton;

@property(nonatomic, assign) CameraType cameraType;
@property (nonatomic, strong) NSLock *lock;

//MaskLayer
@property(strong, nonatomic) UIImageView* personalCoverImageView;

@end

@implementation HSGHCameraPickerView
- (instancetype)initWithIsFrontCamera:(BOOL)isFrontCamera frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXRGBCOLOR(0xefefef);
        _lock = [NSLock new];
        _cameraType = isFrontCamera ? FrontFacingCamera : RearFacingCamera;
        [self setupButtons];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isFront:(BOOL)isFront{
    return [self initWithIsFrontCamera:isFront frame:frame];
}

- (void)dealloc {
    [_captureManager stop];
}

- (void)setupCamera:(CameraType)camera {
//    [_lock lock];
    // remove existing input
    if (_captureManager && _captureManager.captureSession.inputs.count > 0) {
        AVCaptureInput *currentCameraInput = self.captureManager.captureSession.inputs[0];
        [self.captureManager.captureSession removeInput:currentCameraInput];
        _captureManager = nil;
    }

    //Create and configure 'CaptureSessionManager' object
    _captureManager = [CaptureSessionManager new];

    // indicate that some changes will be made to the session
    [self.captureManager.captureSession beginConfiguration];

    if (_captureManager) {
        //Configure
        [_captureManager setDelegate:self];
        [_captureManager initiateCaptureSessionForCamera:camera];
        [_captureManager addStillImageOutput];
        [_captureManager addVideoPreviewLayer];
        [self.captureManager.captureSession commitConfiguration];

        //Preview Layer setup
        CGRect layerRect = CGRectMake(0, 0, self.layer.bounds.size.width, self.layer.bounds.size.width);
        if (_isChangeRate) {
            layerRect = CGRectMake(0, 0, self.layer.bounds.size.width, self.layer.bounds.size.width / 750 * 456);
        }
        [_captureManager.previewLayer setBounds:layerRect];
        [_captureManager.previewLayer setPosition:CGPointMake(self.layer.bounds.size.width/2, layerRect.size.height/2)];

        //Apply animation effect to the camera's preview layer
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.6];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [_captureManager.previewLayer addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];

        [self.layer addSublayer:_captureManager.previewLayer];
    }
//    [_lock unlock];
    [self setupPersonalCoverView];
}

- (void)setupPersonalCoverView {
    if (_isPersonalMode) {
        NSBundle *mainBundle = [NSBundle bundleForClass:[HSGHCameraPickerView class]];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"ImagePicker" ofType:@"bundle"]];
        _personalCoverImageView = [[UIImageView alloc]initWithFrame:_captureManager.previewLayer.bounds];
        _personalCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _personalCoverImageView.image = [UIImage imageNamed:@"MaskLayer" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        [self.layer addSublayer:_personalCoverImageView.layer];
    }
}

- (void)startShowCamera {
#if TARGET_OS_SIMULATOR
#else
    [self setupCamera:_cameraType];
    [[_captureManager captureSession] startRunning];
#endif
}
- (void)setIsChangeRate:(BOOL)isChangeRate {
    if (_isChangeRate != isChangeRate) {
        _isChangeRate = isChangeRate;
        if (_isChangeRate) {
            _swapButton.top = self.width / 750 * 456 - 3;
            _captureButton.top = (self.height + _swapButton.top - 76) / 2;
        }
    }
}

- (void)setupButtons {
    CGRect rect;
    rect = CGRectMake(self.width - 42,
                      self.width - 3, 45, 45);
    _swapButton = [[UIButton alloc] initWithFrame:rect];
    [_swapButton setImage:[UIImage imageNamed:@"ImagePickerSwapCamera"] forState:UIControlStateNormal];
    [_swapButton addTarget:self action:@selector(swapCamera) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(swapCamera)];
    if (singleTapGestureRecognizer) {
        [_swapButton addGestureRecognizer:singleTapGestureRecognizer];
    }
    [self addSubview:_swapButton];

    rect = CGRectMake((self.width - 76) / 2,
            (self.height - self.width - 76) / 2 + self.width, 76, 76);
    _captureButton = [[UIButton alloc] initWithFrame:rect];
    [_captureButton setImage:[UIImage imageNamed:@"ImagePickerCapture"] forState:UIControlStateNormal];
    [_captureButton addTarget:self action:@selector(takeCapture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_captureButton];
}

- (void)swapCamera {
    _cameraType =  (_cameraType == FrontFacingCamera) ? RearFacingCamera : FrontFacingCamera;
    [self setupCamera:_cameraType];
    [[_captureManager captureSession] startRunning];
}

- (void)takeCapture {
    [_captureManager captureStillImage];
}

#pragma mark - delegate

- (void)cameraSessionManagerDidCaptureImage {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didCaptureImage:)])
            [self.delegate didCaptureImage:[[self captureManager] stillImage]];

        if ([self.delegate respondsToSelector:@selector(didCaptureImageWithData:)])
            [self.delegate didCaptureImageWithData:[[self captureManager] stillImageData]];
    }
}

- (void)cameraSessionManagerFailedToCaptureImage {
}

- (void)cameraSessionManagerDidReportAvailability:(BOOL)deviceAvailability forCameraType:(CameraType)cameraType {
}

- (void)cameraSessionManagerDidReportDeviceStatistics:(CameraStatistics)deviceStatistics {
}

@end
