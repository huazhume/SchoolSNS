//
//  HSGHCropCoverView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHVideoPageView.h"
#import "SCRecorder.h"
#import "HSGHVideoStatus.h"
#import "UIImage+LFCamera_Orientation.h"
#import "SchoolSNS-Swift.h"


@interface HSGHVideoPageView() <SCRecorderDelegate>
/** 录制神器 */
@property (strong, nonatomic) SCRecorder *recorder;

@property (nonatomic, strong) UIView* camerConentView;

@end


@implementation HSGHVideoPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
        [self setupRecorder];
    }
    
    return self;
}


- (void)dealloc {
    [self stopSession];
}

- (void)setupView {
    _camerConentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    _camerConentView.backgroundColor = [UIColor blackColor];
    [self addSubview:_camerConentView];
    
    _bottomScrollView = [[HSGHVideoScrollBottomView alloc]initWithFrame:CGRectMake(0, _camerConentView.bottom, self.width, self.height - _camerConentView.bottom)];
    [self addSubview:_bottomScrollView];
    
    
    __weak typeof(self) weakSelf = self;
    _bottomScrollView.leftView.didTakeCapture = ^{
        [weakSelf takePhoto];
    };

    _bottomScrollView.rightView.longPressStart = ^{
        [weakSelf.recorder record];
        if (weakSelf.videoStartBlock) {
            weakSelf.videoStartBlock();
        }
    };
   
    _bottomScrollView.rightView.longPressing = ^{

    };
    
    _bottomScrollView.rightView.longPressEnd = ^{
        [weakSelf.recorder pause];
        if (weakSelf.videoStartBlock) {
            weakSelf.videoPauseBlock();
        }
    };
    
    //operation
    UIButton *flipCameraButton = nil;
    flipCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flipCameraButton.frame = CGRectMake(self.width - 45, self.width - 50, 45, 45);
    [flipCameraButton setImage:[UIImage imageNamed:@"ImagePickerSwapCamera"] forState:UIControlStateNormal];
    [flipCameraButton addTarget:self action:@selector(flipCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:flipCameraButton];
}


- (void)setupRecorder {
#if !TARGET_OS_SIMULATOR
    if (!_recorder) {
        _recorder = [SCRecorder recorder];
        _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
        _recorder.maxRecordDuration = CMTimeMake(FrameRate * kMaxVideoTime, FrameRate);
        _recorder.device = AVCaptureDevicePositionBack;
        _recorder.flashMode = AVCaptureFlashModeOff;
        _recorder.delegate = self;
        _recorder.previewView = _camerConentView;
//        _recorder.fastRecordMethodEnabled = true;
        _recorder.initializeSessionLazily = NO;
        _recorder.videoConfiguration.size = CGSizeMake(RecordSizeWidth, RecordSizeWidth);
        NSError *error;
        if (![_recorder prepare:&error]) {
            HSLog(@"Prepare error: %@", error.localizedDescription);
        }
    }
#endif

}


- (void)flipCameraAction{
    [_recorder switchCaptureDevices];
}

#pragma mark - actions

- (void)takePhoto {
    __weak typeof(self) weakSelf = self;
    [self.recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (image != nil) {
            if (weakSelf.photoBlock) {
                weakSelf.photoBlock([image easyFixDeviceOrientation]);
            }
        } else {
            if (weakSelf.photoBlock) {
                weakSelf.photoBlock(nil);
            }
        }
    }];
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = VideoType;

        _recorder.session = session;
    }
    
    [self updateTimeRecorded];
}

- (void)updateTimeRecorded {
    CMTime currentCMTime = kCMTimeZero;
    CMTime totalCMTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentCMTime =_recorder.session.currentSegmentDuration;
        totalCMTime = _recorder.session.duration;
    }
    
    CGFloat time = CMTimeGetSeconds(currentCMTime);
    CGFloat totalTime = CMTimeGetSeconds(totalCMTime);
    [self.bottomScrollView.rightView.timeView updateTime:totalTime];
    [self.bottomScrollView.rightView.progressView longPressWithTime:time];
    
    if (_didCanSaveBlock) {
        _didCanSaveBlock([self canSave]);
    }
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
//    LFCameraPickerController *cameraPicker = (LFCameraPickerController *)self.navigationController;
//    /** 非暂停模式才启用最小限制 */
//    if (!cameraPicker.canPause && CMTimeGetSeconds(recordSession.duration) < cameraPicker.minRecordSeconds) {
//        [self takePhoto];
//    } else {
//        [self showVideoView];
//    }
//    /** 重置录制按钮 */
//    [self.recordButton reset];
    
}

- (void)retakeRecordSession {
    SCRecordSession *recordSession = _recorder.session;
    
    if (recordSession != nil) {
        _recorder.session = nil;
        [recordSession cancelSession:nil];
    }
    
    [self prepareSession];
}

- (void)stopSession {
    [_recorder stopRunning];
    _recorder.delegate = nil;
    _recorder.previewView = nil;
    [_recorder.session removeAllSegments];
    _recorder.session = nil;
    _recorder = nil;
}

#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    HSLog(@"Skipped video buffer");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    HSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    HSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    HSLog(@"didCompleteSession:");
    Toast* toast = [[Toast alloc]initWithText:@"轻触下一步保存" delay:0 duration:1.f];
    [toast show];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        HSLog(@"Initialized audio in record session");
    } else {
        HSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        HSLog(@"Initialized video in record session");
    } else {
        HSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    HSLog(@"Began record segment: %@", error);
}


- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    [self updateTimeRecorded];
}


- (void)startCamera {
    [self prepareSession];
    [_recorder previewViewFrameChanged];
    
    [_recorder startRunning];
}

- (void)cancelAction {
    [self retakeRecordSession];
}

- (void)deleteLastSession {
    [_recorder.session removeLastSegment];
    
    if (_didCanSaveBlock) {
        _didCanSaveBlock([self canSave]);
    }
}

- (BOOL)hasSession {
    return _recorder.session.segments.count > 0;
}


- (void)saveVideo:(void(^)(BOOL success, UIImage* albumImage, NSString* outputURL))block {
    SCRecordSession* recordSession = self.recorder.session;
    if (recordSession) {
        NSString *preset = SCPresetMediumQuality;
        NSURL *videoUrl = recordSession.outputUrl;
        SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:recordSession.assetRepresentingSegments];
        exportSession.videoConfiguration.preset = preset;
        exportSession.audioConfiguration.preset = preset;
        exportSession.videoConfiguration.maxFrameRate = FrameRate;
        exportSession.outputUrl = videoUrl;
        exportSession.outputFileType = VideoType;
        
        CFTimeInterval time = CACurrentMediaTime();
        __weak typeof(self) weakSelf = self;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (!exportSession.cancelled) {
                HSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
                if (block) {
                    SCRecordSessionSegment* segment = weakSelf.recorder.session.segments.firstObject;
                    
                    block(true, segment ? segment.thumbnail : nil, exportSession.outputUrl.absoluteString);
                }
                return;
            }
            
            NSError *error = exportSession.error;
            if (exportSession.cancelled) {
                HSLog(@"Export was cancelled");
                [weakSelf cancelAction];
            } else if (error == nil) {
                
            } else {
            }
            
            if (block) {
                block(false, nil, @"");
            }
        }];
    }
}

- (BOOL)canSave {
    CMTime totalCMTime = kCMTimeZero;
    totalCMTime = _recorder.session.duration;
    CGFloat totalTime = CMTimeGetSeconds(totalCMTime);
    
    return (totalTime > 0);
    //return (totalTime > MinVideoLength);
}

- (BOOL)hasEnded {
    CMTime totalCMTime = kCMTimeZero;
    totalCMTime = _recorder.session.duration;
    CGFloat totalTime = CMTimeGetSeconds(totalCMTime);
    
    return (totalTime >= kMaxVideoTime);
}


+ (void)fixesVideoResource:(HSGHHomeQQianModel*)model {
    if (model.mediaType == 2) {
        if (model.image.srcWidth.integerValue == 0) {
            model.image.srcWidth = @(RecordSizeWidth);
        }
        if (model.image.srcHeight.integerValue == 0) {
            model.image.srcHeight = @(RecordSizeWidth);
        }
    }
}


@end
