//
// Created by FlyingPuPu on 26/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHCompress.h"
#import <AVFoundation/AVFoundation.h>
#import "HSGHMediaFileManager.h"
#import "HSGHTools.h"
#import "SDAVAssetExportSession.h"

@implementation HSGHCompress {
}

static const NSString *compressFolderName = @"compress";

+ (NSURL *)compressedURL:(NSString *)name type:(FILE_MEDIA_MODE)mode {
    NSString *videoPath = [[HSGHMediaFileManager sharedManager]
            getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
                                 AndMediaType:mode];
    // creat folder
    NSString *createFolder =
            [videoPath stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%@", compressFolderName]];
    // 判断文件夹是否存在，如果不存在，则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![[NSFileManager defaultManager] fileExistsAtPath:createFolder]) {
        [fileManager createDirectoryAtPath:createFolder
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }

    return [NSURL fileURLWithPath:[createFolder stringByAppendingPathComponent:name]];
}

/*
 *
 *  Compress image by decreasing the resolution.
 * */
+ (UIImage *)compressImageResolution:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;

    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    CGFloat targetHeight = (targetWidth / width) * height;

    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

/* The compress of pictures:
 * 1. UIImageJPEGRepresentation or UIImagePNGRepresentation.
 * 2. Change the resolution of UIImage.
 * 3. Save image to url.
*/
+ (void)compressPic:(NSString *)path isChangeResolution:(BOOL)change block:(ReturnBlock)block {
    NSURL *url = [NSURL fileURLWithPath:path];
    UIImage *originImage = [UIImage imageWithContentsOfFile:path];
    NSData *imageOriginData = [NSData dataWithContentsOfURL:url];
    CGFloat currentScreenWidth = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    NSData *compressData = nil;

    //Step two
    if (change) {
        currentScreenWidth = 960;
        if (originImage.size.width > currentScreenWidth) {
            originImage = [self compressImageResolution:originImage toTargetWidth:currentScreenWidth];
        }
    }

    //Step one
    if ([HSGHTools ImageDataHasPNGPrefix:imageOriginData]) {
        compressData = UIImagePNGRepresentation(originImage);
    } else {
        compressData = UIImageJPEGRepresentation(originImage, 0.6);
    }

    //Save
    if (compressData) {
        NSURL *outURL = [self compressedURL:[url.path lastPathComponent] type:FILE_IMAGE_TYPE];
        [[NSFileManager defaultManager] createFileAtPath:[outURL path] contents:compressData attributes:nil];

        if (block) {
            block(YES, outURL.absoluteString);
        }
        return;
    }

    if (block) {
        block(NO, @"");
    }
}

+ (void)customCompressVideo:(NSString *)path block:(ReturnBlock)block {
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *anAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSURL *outURL = [self compressedURL:[url.path lastPathComponent] type:FILE_VIDEO_TYPE];
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:anAsset];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = outURL;
    encoder.videoSettings = @
    {
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: @540,
            AVVideoHeightKey: @960,
            AVVideoCompressionPropertiesKey: @
            {
                    AVVideoAverageBitRateKey: @(540*960*3.5), //@6000000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
            },
    };
    encoder.audioSettings = @
    {
            AVFormatIDKey: @(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: @2,
            AVSampleRateKey: @44100,
            AVEncoderBitRateKey: @128000,
    };

    [encoder exportAsynchronouslyWithCompletionHandler:^
    {
        if (encoder.status == AVAssetExportSessionStatusCompleted)
        {
            HSLog(@"Video export succeeded");
        }
        else if (encoder.status == AVAssetExportSessionStatusCancelled)
        {
            HSLog(@"Video export cancelled");
        }
        else
        {
            HSLog(@"Video export failed with error: %@ (%@)", encoder.error.localizedDescription, @(encoder.error.code));
        }
    }];
}


//The compress of Video just use the system API.
+ (void)compressVideo:(NSString *)path block:(ReturnBlock)block {
    NSURL *url = [NSURL fileURLWithPath:path];
    //不压缩分辨率
    //        AVF_EXPORT NSString *const AVAssetExportPresetLowQuality
    //        NS_AVAILABLE(10_11, 4_0);
    //        AVF_EXPORT NSString *const AVAssetExportPresetMediumQuality
    //        NS_AVAILABLE(10_11, 4_0);
    //        AVF_EXPORT NSString *const AVAssetExportPresetHighestQuality
    //        NS_AVAILABLE(10_11, 4_0);
    //压缩分辨率
    //        AVF_EXPORT NSString *const AVAssetExportPreset640x480
    //        NS_AVAILABLE(10_7, 4_0);
    //        AVF_EXPORT NSString *const AVAssetExportPreset960x540
    //        NS_AVAILABLE(10_7, 4_0);
    //        AVF_EXPORT NSString *const AVAssetExportPreset1280x720
    //        NS_AVAILABLE(10_7, 4_0);
    //        AVF_EXPORT NSString *const AVAssetExportPreset1920x1080
    //        NS_AVAILABLE(10_7, 5_0);
    //        AVF_EXPORT NSString *const AVAssetExportPreset3840x2160
    //        NS_AVAILABLE(10_10, 9_0);

    NSURL *outURL = [self compressedURL:[url.path lastPathComponent] type:FILE_VIDEO_TYPE];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets =
            [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                               presetName:AVAssetExportPreset1280x720];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = outURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            int exportStatus = exportSession.status;
            switch (exportStatus) {
                case AVAssetExportSessionStatusFailed: {
                    NSError *exportError = exportSession.error;
                    HSLog(@"AVAssetExportSessionStatusFailed: %@", exportError);
                    block(NO, outURL.absoluteString);
                    break;
                }
                case AVAssetExportSessionStatusCompleted: {
                    if (block) {
                        block(YES, outURL.absoluteString);
                    }
                    break;
                }

                default:
                    break;
            }
        }];

    } else if (block) {
        block(NO, @"");
    }
}

@end
