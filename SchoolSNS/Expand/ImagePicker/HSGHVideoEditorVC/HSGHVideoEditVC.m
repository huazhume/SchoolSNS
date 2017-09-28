//
//  HSGHVideoEditVC.m
//  SchoolSNS
//
//  Created by Murloc on 05/08/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHVideoEditVC.h"
#import "ICGVideoTrimmerView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NSTimer+FPPBlockSupport.h"
#import "AppDelegate.h"
#import "SchoolSNS-Swift.h"
#import "HSGHPublishMsgVC.h"
#import "SCRecorder.h"
#import "HSGHVideoStatus.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HSGHVideoEditVC ()<ICGVideoTrimmerDelegate>
@property (nonatomic, strong) UIView* navigationView;
@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) UIButton* nextButton;


@property (nonatomic, strong) UIView*  videoLayer;
@property (strong, nonatomic) ICGVideoTrimmerView *trimmerView;
@property (nonatomic, strong) UIImageView* playImageView;

//Video Control
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (assign, nonatomic) CGFloat videoPlaybackPosition;
@property (assign, nonatomic) BOOL restartOnPlay;


//Export
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;
@property (strong, nonatomic) AVAssetExportSession *exportSession;

@property (copy, nonatomic) NSString* savePath;
@end

@implementation HSGHVideoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    _startTime = 0;
    _stopTime = kMaxVideoTime;
}

- (void)dealloc {
    [_player pause];
    _player = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.fd_interactivePopDisabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigation];
    [self.view addSubview:_navigationView];
    
    [self setupTrimView];
    [self.view addSubview:_trimmerView];

    [self setupAVPlayerView];
    [self.view addSubview:_videoLayer];
    

    _videoLayer.top = _navigationView.bottom;
    _trimmerView.top = (self.view.height - _videoLayer.bottom - _trimmerView.height) / 2 + _videoLayer.bottom;
}

- (void)setupNavigation {
    CGFloat navHeight = 44.f;
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), navHeight);
    _navigationView = [[UIView alloc] initWithFrame:rect];
    _navigationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _navigationView.backgroundColor = [UIColor whiteColor];
    _navigationView.clipsToBounds = YES;

    rect = CGRectMake(0, 0, 60, CGRectGetHeight(_navigationView.bounds));
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = rect;
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:backBtn];
    _cancelButton = backBtn;
    
    rect = CGRectMake((CGRectGetWidth(_navigationView.bounds) - 100) / 2, 0, 100, CGRectGetHeight(_navigationView.bounds));
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
    titleLabel.text = @"裁剪";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = HEXRGBCOLOR(0x272727);
    [titleLabel sizeToFit];
    titleLabel.center = _navigationView.center;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_navigationView addSubview:titleLabel];

    rect = CGRectMake(CGRectGetWidth(_navigationView.bounds) - 80, 0, 80, CGRectGetHeight(_navigationView.bounds));
    UIButton *cropBtn = [[UIButton alloc] initWithFrame:rect];
    [cropBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [cropBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [cropBtn setTitleColor:HEXRGBCOLOR(0x3978f0) forState:UIControlStateNormal];
    [cropBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [cropBtn addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:cropBtn];
    _nextButton = cropBtn;
}

- (void)setupAVPlayerView {
    _videoLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    _videoLayer.backgroundColor = [UIColor blackColor];
    
    if (_asset) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:_asset];
        _player = [AVPlayer playerWithPlayerItem:item];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        [self.videoLayer.layer addSublayer:_playerLayer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
        [self.videoLayer addGestureRecognizer:tap];
        self.videoPlaybackPosition = 0;
        [self tapOnVideoLayer:tap];
        
        [self trimmerView:_trimmerView didChangeLeftPosition:0 rightPosition:CMTimeGetSeconds(_asset.duration)];
    }
    
    _playImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play"]];
    _playImageView.frame = CGRectMake(0, 0, 80, 80);
    _playImageView.centerX = _videoLayer.size.width / 2;
    _playImageView.centerY = _videoLayer.size.height / 2;
    [self.videoLayer.layer addSublayer:_playImageView.layer];
}

- (void)setupTrimView {
    _trimmerView = [[ICGVideoTrimmerView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) asset:_asset];
    // set properties for trimmer view
    [self.trimmerView setThemeColor:[UIColor lightGrayColor]];
    [self.trimmerView setAsset:self.asset];
    [self.trimmerView setShowsRulerView:YES];
    self.trimmerView.maxLength = CMTimeGetSeconds(self.asset.duration);//60;
    self.trimmerView.rulerLabelInterval = 5;//15;
    [self.trimmerView setTrackerColor:[UIColor cyanColor]];
    [self.trimmerView setDelegate:self];
    
    // important: reset subviews
    [self.trimmerView resetSubviews];
}

- (void)viewDidLayoutSubviews{
    self.playerLayer.frame = CGRectMake(0, 0, self.videoLayer.frame.size.width, self.videoLayer.frame.size.height);
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    _playImageView.hidden = isPlaying;
}


#pragma mark - player actions
- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap{
    if (self.isPlaying) {
        [self.player pause];
        [self stopPlaybackTimeChecker];
    }else {
        if (_restartOnPlay){
            [self seekVideoToPos: self.startTime];
            [self.trimmerView seekToTime:self.startTime];
            _restartOnPlay = NO;
        }
        [self.player play];
        [self startPlaybackTimeChecker];
    }
    self.isPlaying = !self.isPlaying;
    [self.trimmerView hideTracker:!self.isPlaying];
}


- (void)startPlaybackTimeChecker{
    [self stopPlaybackTimeChecker];
    __weak typeof(self) weakSelf = self;
    self.playbackTimeCheckerTimer = [NSTimer fpp_scheduledTimerWithTimeInterval:0.1f repeats:YES block:^(NSTimer *timer) {
        [weakSelf onPlaybackTimeCheckerTimer];
    }];
}

- (void)stopPlaybackTimeChecker{
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}

#pragma mark - ICGVideoTrimmerDelegate

- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime{
    _restartOnPlay = YES;
    [self.player pause];
    self.isPlaying = NO;
    [self stopPlaybackTimeChecker];
    
    [self.trimmerView hideTracker:true];
    
    if (startTime != self.startTime) {
        //then it moved the left position, we should rearrange the bar
        [self seekVideoToPos:startTime];
    }
    else{ // right has changed
        [self seekVideoToPos:endTime];
    }
    self.startTime = startTime;
    self.stopTime = endTime;
    
}


#pragma mark - PlaybackTimeCheckerTimer
- (void)onPlaybackTimeCheckerTimer {
    CMTime curTime = [self.player currentTime];
    Float64 seconds = CMTimeGetSeconds(curTime);
    if (seconds < 0){
        seconds = 0; // this happens! dont know why.
    }
    self.videoPlaybackPosition = seconds;
    
    [self.trimmerView seekToTime:seconds];
    
    if (self.videoPlaybackPosition >= self.stopTime) {
        self.videoPlaybackPosition = self.startTime;
        [self seekVideoToPos: self.startTime];
        [self.trimmerView seekToTime:self.startTime];
    }
}

- (void)seekVideoToPos:(CGFloat)pos{
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
    //HSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}


#pragma mark - nav actions
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cropAction {
//    [self saveVideo];
    
    __weak typeof(self) weakSelf = self;
    if (self.stopTime - self.startTime >= kMaxVideoTime +1) {
        
        Toast* toast = [[Toast alloc]initWithText:[NSString stringWithFormat:@"视频最大长度为%d秒",kMaxVideoTime] delay:0 duration:1.f];
        [toast show];
        return ;
    }
    
//    [[AppDelegate instanceApplication] indicatorShow];
//    [self saveVideo:^(BOOL success, NSString* outputPath) {
//        [[AppDelegate instanceApplication] indicatorDismiss];
//        if (success) {
//            HSGHPublishMsgVC *vc = [HSGHPublishMsgVC new];
//            vc.publishType = @1;
//            vc.image = weakSelf.image;
//#ifdef OPEN_VIDEO
//            vc.localVideoPath = outputPath;
//#endif
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }
//        else {
//            Toast* toast = [[Toast alloc]initWithText:@"出错啦，请重试" delay:0 duration:1.f];
//            [toast show];
//        }
//    }];
    
    
    [[AppDelegate instanceApplication] indicatorShow];
    [self saveVideo_Me:^(BOOL success, NSString* outputPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate instanceApplication] indicatorDismiss];
            if (success) {
                [[AppDelegate instanceApplication] indicatorDismiss];
                
                //获取第一张截图
                AVAsset *pressAset = [AVAsset assetWithURL:[NSURL URLWithString:outputPath]];
                AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:pressAset];
                assetGen.appliesPreferredTrackTransform = YES;
                CMTime time = CMTimeMakeWithSeconds(0, 1);
                NSError *error = nil;
                CMTime actualTime;
                CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
                UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
                CGImageRelease(image);
                
                
                HSLog(@"---videoImage.size=%@",NSStringFromCGSize(videoImage.size));
                
                HSGHPublishMsgVC *vc = [HSGHPublishMsgVC new];
                vc.publishType = @1;
                vc.image = videoImage;//weakSelf.image;
                vc.localVideoPath = outputPath;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            } else {
                Toast* toast = [[Toast alloc]initWithText:@"出错啦，请重试" delay:0 duration:1.f];
                [toast show];
            }
        });
    }];
}


- (void)saveVideo_Me:(void (^)(BOOL success, NSString* urlPath))handler {
    [self.player pause];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", @(time)]];
    NSURL *outputURL = [NSURL fileURLWithPath:outputFilePath];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:_asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    //exportSession.videoComposition = [self getVideoComposition:_asset];
    
    CMTime start = CMTimeMakeWithSeconds(self.startTime, _asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(self.stopTime - self.startTime,_asset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;
    
    [[AppDelegate instanceApplication] indicatorShow];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed:{
                handler(NO, nil);
                break;
                
            } case AVAssetExportSessionStatusCancelled:{
                HSLog(@"Export canceled");
                handler(NO, nil);
                break;
                
            } case AVAssetExportSessionStatusCompleted: {
                NSLog(@"Completed---compressionVideoURL %f MB",[self fileSize:exportSession.outputURL]);
                NSLog(@"压缩完毕,压缩后大小 %f MB",[self fileSize:exportSession.outputURL]);
                NSLog(@"压缩完毕,%@",exportSession.outputURL);
                handler(YES,exportSession.outputURL.absoluteString);
                break;
                
            } default:
                handler(NO, nil);
                break;
                
        }
    }];
}


#pragma mark - deal and save video
+ (NSString*)getTempFile {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", @(time)]];
}

//获取视频的方向
+ (UIImageOrientation)getVideoOrientationFromAsset:(AVAsset *)asset {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIImageOrientationLeft; //return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIImageOrientationRight; //return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIImageOrientationDown; //return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIImageOrientationUp;  //return UIInterfaceOrientationPortrait;
}





/*  裁剪视频相关接口，目前还不完善 --------------------------------- start   */

//如果rect 宽度大于高度，则直接导出， 如果高度大于宽度，则按照rect 的位置裁剪为正方形
+ (AVVideoComposition*)creatCropComposition:(AVAsset *)asset cropRect:(CGRect)cropRect timeRange:(CMTimeRange)timeRange{
    //create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //create a video composition and preset some settings
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    CGFloat rate = clipVideoTrack.naturalSize.height / cropRect.size.height;
    
    CGFloat cropOffX = cropRect.origin.x * rate;
    CGFloat cropOffY = cropRect.origin.y * rate;
    CGFloat cropWidth = cropRect.size.width * rate;
    CGFloat cropHeight = cropRect.size.height * rate;
    
    videoComposition.renderSize = CGSizeMake(cropWidth, cropHeight);

    //create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = timeRange;

    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    UIImageOrientation videoOrientation = [HSGHVideoEditVC getVideoOrientationFromAsset:asset];
    CGAffineTransform t1 = CGAffineTransformIdentity;
    CGAffineTransform t2 = CGAffineTransformIdentity;
    switch (videoOrientation) {
        case UIImageOrientationUp:
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height - cropOffX, 0 - cropOffY );
            t2 = CGAffineTransformRotate(t1, M_PI_2 );
            break;
        case UIImageOrientationDown:
            t1 = CGAffineTransformMakeTranslation(0 - cropOffX, clipVideoTrack.naturalSize.width - cropOffY ); // not fixed width is the real height in upside down
            t2 = CGAffineTransformRotate(t1, - M_PI_2 );
            break;
        case UIImageOrientationRight:
            t1 = CGAffineTransformMakeTranslation(0 - cropOffX, 0 - cropOffY );
            t2 = CGAffineTransformRotate(t1, 0 );
            break;
        case UIImageOrientationLeft:
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width - cropOffX, clipVideoTrack.naturalSize.height - cropOffY );
            t2 = CGAffineTransformRotate(t1, M_PI  );
            break;
        default:
            HSLog(@"no supported orientation has been found in this video");
            break;
    }
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];

    return videoComposition;
}

//裁剪接口，目前还有问题
+ (void)applyCropToVideoWithAsset:(CGRect)cropRect avasset:(AVAsset*)avasset block:(void(^)(BOOL success, NSString* urlPath))block{
    
    //create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[avasset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //create a video composition and preset some settings
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    CGFloat rate = clipVideoTrack.naturalSize.height / cropRect.size.height;
    CGFloat cropOffX = cropRect.origin.x * rate;
    CGFloat cropOffY = cropRect.origin.y * rate;
    CGFloat cropWidth = cropRect.size.width * rate;
    CGFloat cropHeight = cropRect.size.height * rate;
    
    videoComposition.renderSize = CGSizeMake(cropWidth, cropHeight);
    
    //create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    CMTime start = CMTimeMakeWithSeconds(0, avasset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, avasset.duration);
    instruction.timeRange = range;
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    UIImageOrientation videoOrientation = [HSGHVideoEditVC getVideoOrientationFromAsset:avasset];
    
    CGAffineTransform t1 = CGAffineTransformIdentity;
    CGAffineTransform t2 = CGAffineTransformIdentity;
    
    switch (videoOrientation) {
        case UIImageOrientationUp:
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height - cropOffX, 0 - cropOffY );
            t2 = CGAffineTransformRotate(t1, M_PI_2 );
            break;
        case UIImageOrientationDown:
            t1 = CGAffineTransformMakeTranslation(0 - cropOffX, clipVideoTrack.naturalSize.width - cropOffY ); // not fixed width is the real height in upside down
            t2 = CGAffineTransformRotate(t1, - M_PI_2 );
            break;
        case UIImageOrientationRight:
            t1 = CGAffineTransformMakeTranslation(0 - cropOffX, 0 - cropOffY );
            t2 = CGAffineTransformRotate(t1, 0 );
            break;
        case UIImageOrientationLeft:
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width - cropOffX, clipVideoTrack.naturalSize.height - cropOffY );
            t2 = CGAffineTransformRotate(t1, M_PI  );
            break;
        default:
            HSLog(@"no supported orientation has been found in this video");
            break;
    }
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    AVAssetExportSession*  exporter = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:AVAssetExportPresetMediumQuality] ;

    
    // assign all instruction for the video processing (in this case the transformation for cropping the video
    exporter.videoComposition = videoComposition;
    exporter.outputFileType = AVFileTypeMPEG4;
    
    exporter.outputURL = [NSURL fileURLWithPath:[HSGHVideoEditVC getTempFile]];
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                    HSLog(@"crop Export failed: %@", [[exporter error] localizedDescription]);
                    if (block){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(NO, nil);
                        });
                        return;
                    }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    HSLog(@"crop Export canceled");
                    if (block){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(NO, nil);
                        });
                        return;
                    }
                    break;
                default:
                    break;
            }
            
            if (block){
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES, exporter.outputURL.absoluteString);
                });
            }
            
        }];
}
    



+ (void)cropVideo:(CGRect)rect avasset:(AVAsset*)avasset block:(void(^)(BOOL success, NSString* urlPath))block {
    NSString *preset = SCPresetMediumQuality;
    NSURL *videoUrl = [NSURL fileURLWithPath:[HSGHVideoEditVC getTempFile]];
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:avasset];
    exportSession.videoConfiguration.preset = preset;
    exportSession.audioConfiguration.preset = preset;
    exportSession.videoConfiguration.maxFrameRate = FrameRate;
    CMTime start = CMTimeMakeWithSeconds(0, avasset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, avasset.duration);
    exportSession.videoConfiguration.composition = [HSGHVideoEditVC creatCropComposition:avasset cropRect:rect timeRange:range];
    exportSession.outputUrl = videoUrl;
    exportSession.outputFileType = VideoType;

    exportSession.timeRange = range;
    
    CFTimeInterval time = CACurrentMediaTime();
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (!exportSession.cancelled) {
            HSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            HSLog(@"Export was cancelled");
        } else if (error == nil) {
            if (block) {
                block(true, exportSession.outputUrl.absoluteString);
                return;
            }
        }
        
        if (block) {
            block(false, nil);
        }
    }];
}
/*  裁剪视频相关接口，目前还不完善 --------------------------------- end   */



//SCAssetExportSession save
- (void)saveVideo2:(void(^)(BOOL success, NSString* urlPath))block {
    [self.player pause];
    
    [HSGHVideoEditVC getVideoOrientationFromAsset:_asset];
    
    NSString *preset = SCPresetMediumQuality;
    NSURL *videoUrl = [NSURL fileURLWithPath:[HSGHVideoEditVC getTempFile]];
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_asset];
    exportSession.videoConfiguration.preset = preset;
    exportSession.audioConfiguration.preset = preset;
    exportSession.videoConfiguration.maxFrameRate = FrameRate;
    exportSession.outputUrl = videoUrl;
    exportSession.outputFileType = VideoType;
    CMTime start = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
    CGFloat spaceTime = ((self.stopTime - self.startTime) > kMaxVideoTime) ? kMaxVideoTime : (self.stopTime - self.startTime);
    CMTime duration = CMTimeMakeWithSeconds(spaceTime, self.asset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;

    CFTimeInterval time = CACurrentMediaTime();
    
    exportSession.videoConfiguration.composition = [self getVideoComposition:_asset];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (!exportSession.cancelled) {
            HSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            HSLog(@"Export was cancelled");
        } else if (error == nil) {
//                [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
//                    if (error) {
//                        NSLog(@"Failed to save %@", error.localizedDescription);
//                    }
//                }];
            if (block) {
                block(true, exportSession.outputUrl.absoluteString);
                return;
            }
        }
        
        if (block) {
            block(false, nil);
        }
    }];
}


//用于调整视频的方向信息
- (AVMutableVideoComposition *)getVideoComposition:(AVAsset *)asset {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    CGSize videoSize = videoTrack.naturalSize;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
           (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)){
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
    }
    composition.naturalSize    = videoSize;
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMakeWithSeconds( 1 / videoTrack.nominalFrameRate, 600);
    
    AVMutableCompositionTrack *compositionVideoTrack;
    compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *layerInst;
    layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInst setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    return videoComposition;
}


//AVAssetExportSession save
- (void)saveVideo:(void (^)(BOOL success, NSString* urlPath))handler {
    [self.player pause];

//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:_asset presetName:AVAssetExportPreset960x540];
    
    
    //Save path
#if 0
    NSString *path = [NSString stringWithFormat:@"%@VideoCompression/",NSTemporaryDirectory()];
    
    NSFileManager *fileManage = [[NSFileManager alloc] init];    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:path]){
            [fileManage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    if([fileManage fileExistsAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]]){
        [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path] error:nil];
    }
    
    NSURL *compressionVideoURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]];
#else 
    NSFileManager *fileManage = [[NSFileManager alloc] init];
    if([fileManage fileExistsAtPath:[HSGHVideoEditVC getTempFile]]){
        [fileManage removeItemAtPath:[HSGHVideoEditVC getTempFile] error:nil];
    }
    
    NSURL *compressionVideoURL = [NSURL fileURLWithPath:[HSGHVideoEditVC getTempFile]];
#endif
    
    session.outputURL = compressionVideoURL;
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    session.videoComposition = [self getVideoComposition:_asset];
    
    //Time range
    CMTime start = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
    CGFloat spaceTime = ((self.stopTime - self.startTime) > kMaxVideoTime) ? kMaxVideoTime : (self.stopTime - self.startTime);
    CMTime duration = CMTimeMakeWithSeconds(spaceTime, self.asset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    session.timeRange = range;
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            switch ([session status]) {
                case AVAssetExportSessionStatusFailed:{
                    HSLog(@"Export failed: %@ : %@", [[session error] localizedDescription], [session error]);
                    handler(session, nil);
                    break;
                }case AVAssetExportSessionStatusCancelled:{
                    HSLog(@"Export canceled");
                    handler(session, nil);
                    break;
                }default:
                    handler(true,compressionVideoURL.absoluteString);
                    break;
            }
        });
    }];
}

- (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}



@end
