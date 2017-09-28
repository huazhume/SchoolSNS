//
//  HSGHCameraPickerView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 22/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol HSGHCameraPickerViewDelegate <NSObject>

@optional
- (void)didCaptureImage:(UIImage *)image;

@optional
- (void)didCaptureImageWithData:(NSData *)imageData;

@end

@interface HSGHCameraPickerView : UIView
@property(nonatomic, weak) id <HSGHCameraPickerViewDelegate> delegate;
@property(nonatomic, assign) BOOL isPersonalMode;
@property(nonatomic, assign) BOOL isChangeRate;

- (instancetype)initWithIsFrontCamera:(BOOL)isFrontCamera frame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame isFront:(BOOL)isFront;
- (void)startShowCamera;
@end
