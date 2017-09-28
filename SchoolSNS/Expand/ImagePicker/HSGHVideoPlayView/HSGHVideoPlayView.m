//
//  HSGHCropCoverView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHVideoPlayView.h"
#import "HSGHVideoStatus.h"


@interface HSGHVideoPlayView()<SCPlayerDelegate>

//Resource
@property (strong, nonatomic) SCRecordSession *recordSession;
@property (strong, nonatomic) NSURL *playURL;

//Play
@property (strong, nonatomic) UIImageView* albumBgImageView;
@property (weak, nonatomic) SCVideoPlayerView *playerView;
@property (strong, nonatomic) SCPlayer *player;

//Export
@property (strong, nonatomic) SCAssetExportSession *exportSession;

@end


@implementation HSGHVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame path:@"" recordSession:nil];
}


- (instancetype)initWithFrame:(CGRect)frame path:(NSString*)path {
    return [self initWithFrame:frame path:path recordSession:nil];
}


- (instancetype)initWithFrame:(CGRect)frame recordSession:(SCRecordSession*)scRecordSession {
    return [self initWithFrame:frame path:nil recordSession:scRecordSession];
}


- (instancetype)initWithFrame:(CGRect)frame path:(NSString*)path recordSession:(SCRecordSession*)scRecordSession{
    self = [super initWithFrame:frame];
    if (self) {
        if (UN_NIL_STR(path).length > 0) {
            if ([path hasPrefix:@"http"]) { //Net
                _playURL = [NSURL URLWithString: path];
            }
            else {  //Local
                _playURL = [NSURL URLWithString: path]; //fileURLWithPath: UN_NIL_STR(path)];
            }
        }
        
        if (scRecordSession) {
            _recordSession = scRecordSession;
        }
        
        [self setupView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
//    if (newSuperview) { //Add
//        [self play];
//    }
//    else { //Remove
//        [self pause];
//    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self play];
    }
    else {
        [self pause];
    }
}

- (void)dealloc {
    [self cancelSaveToCameraRoll];
    [_player pause];
    _player.delegate = nil;
    _player = nil;
}

- (void)setupView {
    _albumBgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:_albumBgImageView];

    _player = [SCPlayer player];
    _player.loopEnabled = YES;
    _player.delegate = self;
    
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerView.frame = self.bounds;
    [self insertSubview:playerView aboveSubview:_albumBgImageView];
    self.playerView = playerView;
}

- (void)play {
    if (_recordSession) {
        AVAsset *asset = _recordSession.assetRepresentingSegments;
        if (asset) {
            [_player pause];
            [_player setItemByAsset:asset];
            [_player play];
        }
    }
    else if (_playURL) {
        [_player pause];
        [_player setItemByUrl:_playURL];
        [_player play];
    }
    else if (_avasset) {
        [_player pause];
        [_player setItemByAsset:_avasset];
        [_player play];
    }
}

- (void)pause {
    [_player pause];
}

- (void)destory {
    [_player pause];
    _player = nil;
    [self cancelSaveToCameraRoll];
}

- (void)setPlayPath:(NSString *)playPath {
    if (UN_NIL_STR(playPath).length == 0) { return; }
    
    if ([playPath hasPrefix:@"http"]) { //Net
        _playURL = [NSURL URLWithString: playPath];
    }
    else {  //Local
        _playURL = [NSURL URLWithString: playPath]; //[NSURL fileURLWithPath: playPath];
    }
}

- (void)setAvasset:(AVAsset *)avasset {
    _avasset = avasset;
}

- (void)resizeFrame {
    _playerView.frame = self.bounds;
}


#pragma mark - Build albumImage
- (void)setAlbumImage:(UIImage *)albumImage {
    _albumBgImageView.image = albumImage;
}

- (void)setAlbumImagePath:(NSString *)albumImagePath {
    if (UN_NIL_STR(albumImagePath).length > 0) {
        if ([albumImagePath hasPrefix:@"http"]) { //Net
            [_albumBgImageView sd_setImageWithURL:[NSURL URLWithString:albumImagePath] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        }
        else {  //Local
            _albumBgImageView.image = [UIImage imageWithContentsOfFile:albumImagePath];
        }
    }
}

#pragma mark - SCPlayerDelegate
- (void)player:(SCPlayer *__nonnull)player itemReadyToPlay:(AVPlayerItem *__nonnull)item {
    [self.albumBgImageView removeFromSuperview];
}

#pragma Export 
///if recordSession not nil, can do this.
- (void)cancelSaveToCameraRoll {
    [_exportSession cancelExport];
}

@end
