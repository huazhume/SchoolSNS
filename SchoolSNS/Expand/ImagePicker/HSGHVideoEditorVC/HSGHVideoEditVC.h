//
//  HSGHVideoEditVC.h
//  SchoolSNS
//
//  Created by Murloc on 05/08/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HSGHVideoEditVC : HSGHBaseViewController

+ (void)cropVideo:(CGRect)rect avasset:(AVAsset*)avasset block:(void(^)(BOOL success, NSString* urlPath))block;

+ (void)applyCropToVideoWithAsset:(CGRect)cropRect avasset:(AVAsset*)avasset block:(void(^)(BOOL success, NSString* urlPath))block;

@property (nonatomic, strong) AVAsset*  asset;

@property (nonatomic, strong) UIImage*  image;
@end
