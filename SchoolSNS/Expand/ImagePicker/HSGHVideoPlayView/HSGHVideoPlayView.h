//
//  HSGHCropCoverView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"


//Support: 1. Local url  2. SCRecordSession  3. Net url

@interface HSGHVideoPlayView : UIView

@property (nonatomic, copy) NSString* albumImagePath;
@property (nonatomic, copy) UIImage* albumImage;

@property (nonatomic, copy) NSString* playPath;
@property (nonatomic, strong) AVAsset* avasset;


- (instancetype)initWithFrame:(CGRect)frame path:(NSString*)path;

- (instancetype)initWithFrame:(CGRect)frame recordSession:(SCRecordSession*)scRecordSession;

- (void)play;

- (void)pause;

- (void)resizeFrame;
@end
