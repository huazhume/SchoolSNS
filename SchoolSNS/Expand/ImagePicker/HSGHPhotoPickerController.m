//
//  HSGHPhotoPickerController.m
//  PhotoPicker


#import "HSGHPhotoPickerController.h"
#import "HSGHPhotoCollectionViewCell.h"
#import "HSGHImageScrollView.h"
#import "HSGHPhotoLoader.h"
#import "HSGHPublishMsgVC.h"
#import "UIScrollView+MJRefresh.h"
#import "HSGHCameraPickerView.h"
#import "UIImage+BFSExt.h"
#import "HSGHCropCoverView.h"
#import "PopoverView.h"
#import "HSGHVideoPageView.h"
#import "HSGHVideoScrollBottomTitleView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <AVFoundation/AVFoundation.h>
#import "HSGHVideoEditVC.h"
#import <CoreMedia/CoreMedia.h>

@interface HSGHPhotoPickerController () <UICollectionViewDataSource, UICollectionViewDelegate, HSGHCameraPickerViewDelegate, UIGestureRecognizerDelegate> {
    CGFloat beginOriginY;
}
@property(strong, nonatomic) UIView *topView;
@property(strong, nonatomic) UIButton *rightButton;
@property(strong, nonatomic) UILabel *titleLabel;
//title dropView
@property(strong, nonatomic) NSMutableArray *actionsArray;
@property(nonatomic, copy)   NSString*  currentTitle;
@property(nonatomic, strong) UIImageView*  arrowImageView;



@property(strong, nonatomic) UIScrollView *contentScrollView;
@property(nonatomic, assign) BOOL isCameraPage;

//FirstView
@property(strong, nonatomic) UIView *firstContainerView;
@property(strong, nonatomic) UIView *firstContainerHalfTopView; //Contains imageScrollView +  dragView + coverBlackView + maskView, for easy to control
@property(strong, nonatomic) HSGHImageScrollView *imageScrollView;
@property(strong, nonatomic) UIView *dragView;
@property(strong, nonatomic) UIView *coverBlackView;  //Alpha 1 ==> 0.5
@property(strong, nonatomic) UIImageView *maskView; //Table cover
@property(strong, nonatomic) UIButton *resizeButton;

//Personal Cover
@property(strong, nonatomic) UIImageView* personalCoverImageView;

//Photo CollectionView
@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) NSArray *allPhotos;
@property(strong, nonatomic) NSDictionary *allPhotosDictionary;
@property(assign, nonatomic) BOOL isSelectedVideo;
@property(strong, nonatomic) AVAsset* selectedAVAsset;
@property(strong, nonatomic) HSGHPhoto* selectedPhoto;




//SecondView
//If contains the video page, should add the videoView
@property(strong, nonatomic) HSGHVideoPageView *videoPageView;
@property(strong, nonatomic) HSGHVideoScrollBottomTitleView *bottomTitleView;

//Else no video
@property(strong, nonatomic) HSGHCameraPickerView *secondContainerView;
@property(strong, nonatomic) UIView *bottomView;


//Ges Control
@property(strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property(strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property(assign, nonatomic) BOOL isMiddleMode; //normal ui mode
@property(assign, nonatomic) CGFloat maxOffset;
@property (assign, nonatomic) CGFloat maxAlpha;


//CropCoverView
@property (nonatomic, strong) HSGHCropCoverView* topCropView;
@property (nonatomic, strong) HSGHCropCoverView* bottomCropView;

@end

@implementation HSGHPhotoPickerController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:HEXRGBCOLOR(0xefefef)];
    [self.view addSubview:self.topView];
    if (_isContainsVideo) {
        [self.view addSubview:self.bottomTitleView];
    }
    else {
        [self.view addSubview:self.bottomView];
    }
    
    [self setupContentScrollView];
    [self setupPersonalCoverView];
    
    _rightButton.enabled = false;
    
    [self loadPhotos];
    
    [self setupCropCoverView];
    
    if (_isContainsVideo && _isEnterVideo) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_bottomTitleView enterVideo];
        });
    }
}

- (void)dealloc {
    [_videoPageView stopSession];
    [_videoPageView.bottomScrollView.rightView.timeView stopTimer];
    _videoPageView.bottomScrollView.rightView.timeView = nil;
    [_videoPageView.bottomScrollView.rightView.progressView stopTimer];
    _videoPageView.bottomScrollView.rightView.progressView = nil;
    
    [HSGHPhotoLoader clearPhotoArr];

    HSLog(@"---HSGHPhotoPickerController---dealloc---leave image pick");
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isContainsVideo) {
        [_videoPageView startCamera];
    }
    else {
        [_secondContainerView startShowCamera];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.fd_interactivePopDisabled = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.fd_interactivePopDisabled = NO;

}

- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44 * 2)];
    _contentScrollView.contentSize = CGSizeMake(self.view.width * 2, 0);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.directionalLockEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.clipsToBounds = NO;
    [self.view addSubview:_contentScrollView];

    [_contentScrollView addSubview:self.firstContainerView];
    [_contentScrollView addSubview: _isContainsVideo ? self.videoPageView : self.secondContainerView];

    _maxOffset = _firstContainerHalfTopView.height - _dragView.height + _topView.height;
    _maxAlpha = 0.5f;
    _isMiddleMode = true;
}

- (void)setupPersonalCoverView {
    if (_isPersonalMode) {
        NSBundle *mainBundle = [NSBundle bundleForClass:[HSGHCameraPickerView class]];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"ImagePicker" ofType:@"bundle"]];
        _personalCoverImageView = [[UIImageView alloc]initWithFrame:_firstContainerHalfTopView.bounds];
        _personalCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _personalCoverImageView.image = [UIImage imageNamed:@"MaskLayer" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        [_firstContainerView addSubview:_personalCoverImageView];
        _resizeButton.hidden = YES;
    }
}


- (void)setupCropCoverView {
    if (!_isPersonalMode && !_isChangeRate && !_isContainsVideo) {
        CGFloat maxSpace = _firstContainerView.width / 2.f ;
        __weak typeof(self) weakSelf = self;

        _topCropView = [[HSGHCropCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, CropCoverViewHeight)];
        _topCropView.showMode = CropShowTop;
        _topCropView.startBlock = ^(){
            CGFloat realMaxSpace = maxSpace - (weakSelf.topCropView.normalTop + weakSelf.view.width - weakSelf.bottomCropView.normalBottom);
            if (realMaxSpace < 0) {weakSelf.topCropView.limitedHeight = CropCoverViewHeight; return;}
            
            CGFloat bottomHeight = weakSelf.bottomCropView.height - CropCoverViewHeight;
            weakSelf.topCropView.limitedHeight = realMaxSpace - bottomHeight + CropCoverViewHeight;
            
        };
        _bottomCropView = [[HSGHCropCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, CropCoverViewHeight)];
        _bottomCropView.showMode = CropShowBottom;
        _bottomCropView.startBlock = ^(){
            CGFloat realMaxSpace = maxSpace - (weakSelf.topCropView.normalTop + weakSelf.view.width - weakSelf.bottomCropView.normalBottom);
            if (realMaxSpace < 0) {weakSelf.bottomCropView.limitedHeight = CropCoverViewHeight; return;}
            
            CGFloat topHeight = weakSelf.topCropView.height - CropCoverViewHeight;
            weakSelf.bottomCropView.limitedHeight = realMaxSpace - topHeight + CropCoverViewHeight;
        };
        [_firstContainerHalfTopView addSubview:_topCropView];
        [_firstContainerHalfTopView addSubview:_bottomCropView];
//        _dragView.hidden = YES;
        [_firstContainerHalfTopView bringSubviewToFront:_resizeButton];
        
        _topCropView.hidden = !_rightButton.enabled;
        _bottomCropView.hidden = !_rightButton.enabled;
    }
}

#pragma mark - CropCoverView
- (void)fixesCropCoverPositon {
    if (!_isPersonalMode && !_isChangeRate) {
        CGRect frame = [_imageScrollView fetchImageViewFrame];
        [_topCropView updateTop:((self.view.width - frame.size.height) / 2 < 0) ? 0 : (self.view.width - frame.size.height) / 2];
        
        CGFloat bottom = self.view.width - (self.view.width - frame.size.height) / 2;
        _bottomCropView.bottom = bottom > self.view.width ? self.view.width : bottom;
        
        [_bottomCropView updateBottom: bottom > self.view.width ? self.view.width : bottom];
        _topCropView.hidden = NO;
        _bottomCropView.hidden = NO;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.allPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HSGHPhotoCollectionViewCell";

    HSGHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    HSGHPhoto *photo = self.allPhotos[(NSUInteger) indexPath.row];
    cell.imageView.image = photo.thumbnailImage;
#ifdef OPEN_VIDEO
    [cell setIsVideo:[photo isVideo]];
    if ([photo isVideo]) {
        [cell setTime:[photo videoTime]];
    }
#endif

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGHPhoto *photo = self.allPhotos[(NSUInteger) indexPath.row];
    [self.imageScrollView displayImage:photo.originalImage];
    _rightButton.enabled = YES;
    [self fixesCropCoverPositon];
    if (self.topView.y != 0) {
        [self tapGestureAction:nil];
    }
    if (_isContainsVideo) {
        _isSelectedVideo = [photo isVideo];
        ALAssetRepresentation *rep = [photo.asset defaultRepresentation];
        _selectedAVAsset = [AVAsset assetWithURL:rep.url];
        _selectedPhoto = photo;
        
        if (_isSelectedVideo) {
            [self.imageScrollView displayVideo:_selectedAVAsset];
            _topCropView.hidden = YES;
            _bottomCropView.hidden = YES;
            _resizeButton.hidden = YES;
        }
        else {
            if (!_isPersonalMode && !_isChangeRate) {
                _topCropView.hidden = NO;
                _bottomCropView.hidden = NO;
            }
            _resizeButton.hidden = NO;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.collectionView && velocity.y < 0 && self.collectionView.contentOffset.y < 8) {
        [self tapGestureAction:nil];
    }
    
    if (scrollView == self.collectionView && velocity.y > 0 && self.collectionView.contentOffset.y > 10) {
        [self covertToUIMode:false];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        if (_isContainsVideo) {
            TakePhotoType type = _contentScrollView.contentOffset.x >= scrollView.width ? TakePhoto : SelectedPhoto;
            [self refreshUI:type];
            [_videoPageView.bottomScrollView refreshUI:type];
            [_bottomTitleView refreshUI:type];
        }
        else {
            _rightButton.hidden = (_contentScrollView.contentOffset.x >= scrollView.width);
            _titleLabel.text = (_contentScrollView.contentOffset.x >= scrollView.width) ? @"照片" : UN_NIL_STR(_currentTitle);
            [self.titleLabel sizeToFit];
            self.titleLabel.centerY = 22.f;
            self.titleLabel.centerX = self.view.width / 2;
            self.arrowImageView.left = self.titleLabel.right + 2;
            self.arrowImageView.hidden = (_contentScrollView.contentOffset.x >= scrollView.width);
        }
        
        if (_contentScrollView.contentOffset.x >= scrollView.width) {
            _topView.top = 0;
        } else {
            [self covertToUIMode:_isMiddleMode];
        }
    }
}

//capture from camera
- (void)didCaptureImage:(UIImage *)image {
    [[AppDelegate instanceApplication] indicatorShow];
    UIImage* compressImage = [self compressImage: image isCamera:YES];
//    compressImage = [compressImage cropToSquare];
    [[AppDelegate instanceApplication] indicatorDismiss];
    if (self.cropBlock) {
        self.cropBlock(compressImage);
    }
    if (_isPush) {
        HSGHPublishMsgVC *vc = [HSGHPublishMsgVC new];
        vc.publishType = @1;
        vc.image = compressImage;
        vc.isLauncher = _isLauncher;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self backAction];
    }
}

#pragma mark - event response
- (void)backAction {
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (UIImage*)compressImage:(UIImage*)image isCamera:(BOOL)isCamera{
    CGFloat width = 0;
    CGFloat height = 0;
    if (image.size.width > 1080) {
        width = 1080;
        height = 1080 / image.size.width * image.size.height;
    } else {
        width = image.size.width;
        height = image.size.height;
    }
    
    UIImage* resizeImage = [image scaledToSize: CGSizeMake(width, height)];
    if (!_isChangeRate && isCamera){
        resizeImage = [image cropToSquare];
    }
    return resizeImage;
}

- (void)cropAction {
    if (_isContainsVideo) {
        if (_contentScrollView.contentOffset.x == 0) {
            if (_isSelectedVideo) {
                Float64 time = CMTimeGetSeconds(_selectedAVAsset.duration);
                if (time < 1) {
//                    Toast* toast = [[Toast alloc]initWithText:@"视频不能小于1秒" delay:0 duration:1.f];
//                    [toast show];
//                    return;
                }
                else {
//                    CGRect rect =  _imageScrollView.fetchVideoRect;
//                    if ((int)(rect.size.height) > (int)(rect.size.width) + 1) { //1个像素内没必要转换
//                        [[AppDelegate instanceApplication] indicatorShow];
//                        __weak typeof(self) weakSelf = self;
//                        [HSGHVideoEditVC applyCropToVideoWithAsset:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.width)
//                                                           avasset:_selectedAVAsset block:^(BOOL success, NSString *urlPath) {
//                            [[AppDelegate instanceApplication] indicatorDismiss];
//                            if (success) {
//                                HSGHVideoEditVC* editVC = [[HSGHVideoEditVC alloc]init];
//                                editVC.asset = [AVAsset assetWithURL:[NSURL URLWithString:urlPath]];
//                                editVC.image = nil;
//                                [weakSelf.navigationController pushViewController:editVC animated:YES];
//                            }
//                            else {
//                                Toast* toast = [[Toast alloc]initWithText:@"出错啦，请重试" delay:0 duration:1.f];
//                                [toast show];
//                            }
//                        }];
//                    }
//                    else {
                        HSGHVideoEditVC* editVC = [[HSGHVideoEditVC alloc]init];
                        editVC.asset = _selectedAVAsset;
                        editVC.image = _selectedPhoto.originalImage;
                        [self.navigationController pushViewController:editVC animated:YES];
//                    }
                }
            }
            else {
                [self cropImageToNext];
            }
        }
        else {
            __weak typeof(self) weakSelf = self;
            [[AppDelegate instanceApplication] indicatorShow];
            [_videoPageView saveVideo:^(BOOL success, UIImage *albumImage, NSString* outputPath) {
                [[AppDelegate instanceApplication] indicatorDismiss];
                if (success) {
                    UIImage* compressImage = nil;
                    compressImage = [weakSelf compressImage: albumImage isCamera:YES];
                    if (weakSelf.isPush) {
                        HSGHPublishMsgVC *vc = [HSGHPublishMsgVC new];
                        vc.publishType = @1;
                        vc.isLauncher = weakSelf.isLauncher;
                        vc.image = compressImage;
#ifdef OPEN_VIDEO
                        vc.localVideoPath = outputPath;
#endif
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } else {
                        [weakSelf backAction];
                    }
                }
                else {
                    Toast* toast = [[Toast alloc]initWithText:@"出错啦，请重试" delay:0 duration:1.f];
                    [toast show];
                }
            }];
        }
    }
    else {
        [self cropImageToNext];
    }
}

- (void)cropImageToNext {
    [[AppDelegate instanceApplication] indicatorShow];
    UIImage* compressImage = nil;
    if (!_isChangeRate && !_isPersonalMode) {
        compressImage = [self compressImage: [self.imageScrollView captureWithRect:CGRectMake(0, _topCropView.bottom - CropCoverViewHeight,
                                                                                              self.view.width , _bottomCropView.top + CropCoverViewHeight * 2 - _topCropView.bottom)] isCamera:NO];
    }
    else {
        compressImage = [self compressImage: self.imageScrollView.capture isCamera:NO];
    }
    [[AppDelegate instanceApplication] indicatorDismiss];
    if (self.cropBlock) {
        self.cropBlock(compressImage);
    }
    
    if (_isPush) {
        HSGHPublishMsgVC *vc = [HSGHPublishMsgVC new];
        vc.publishType = @1;
        vc.isLauncher = _isLauncher;
        vc.image = compressImage;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self backAction];
    }
}

- (void)resizeAction {
    [_imageScrollView resizeAction];
}

- (void)switchPage:(BOOL)toCamera {
    if (!_isContainsVideo && toCamera == _isCameraPage) {
        return;
    }
    _isCameraPage = toCamera;
    if (_isCameraPage) {
        [self.contentScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    } else {
        [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            CGPoint translation = [panGesture translationInView:self.view];
            if (!_isMiddleMode && translation.y > beginOriginY + 30) {
                [self covertToUIMode:TRUE];
            } else if (_isMiddleMode && beginOriginY > translation.y + 30) {
                [self covertToUIMode:false];
            } else {
                [self covertToUIMode:_isMiddleMode];
            }
            break;
        }

        case UIGestureRecognizerStateBegan: {
            CGPoint translation = [panGesture translationInView:self.view];
            beginOriginY = translation.y;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGesture translationInView:self.view];
            [self movePosition:translation.y - beginOriginY isMiddleMode:_isMiddleMode];
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    //Restore to normal
    [self covertToUIMode:TRUE];
}

#pragma mark - gesture status

//Middle mode  <===> Top mode
//Top , _firstContainerHalfTopView,  collectionView
//dragView height = 35
- (void)covertToUIMode:(BOOL)isMiddleMode {
    _isMiddleMode = isMiddleMode;
    if (isMiddleMode) {
        _dragView.hidden = YES;
        _personalCoverImageView.hidden = NO;
        _tapGesture.enabled = NO;
        _dragView.top = _firstContainerHalfTopView.height + _topView.height;
        [UIView animateWithDuration:0.3f animations:^{
            _collectionView.top = _firstContainerHalfTopView.height;
            _collectionView.height = _firstContainerView.height - _firstContainerHalfTopView.height;

            _coverBlackView.alpha = .0f;
            _firstContainerHalfTopView.bottom = _collectionView.top;
            _topView.top = _firstContainerHalfTopView.top;
        }];
    } else {
        _dragView.hidden = NO;
        _tapGesture.enabled = YES;
        _dragView.top = 0;
        _personalCoverImageView.hidden = YES;
        [UIView animateWithDuration:0.3f animations:^{
            _collectionView.top = _dragView.height - _topView.height;
            _collectionView.height = _maxOffset + _firstContainerView.height - _firstContainerHalfTopView.height;

            _coverBlackView.alpha = _maxAlpha;
            _firstContainerHalfTopView.bottom = _collectionView.top;
            _topView.top = _firstContainerHalfTopView.top;
        }];
    }
}


//Form _dragView.height to _firstContainerHalfTopView.height + _topView.height
//Up offset is minus， down positive
//_topView.top = _firstContainerHalfTopView.top, _firstContainerHalfTopView.bottom = _collectionView.top
//Because the offset always is absolute，the top always from origin
- (void)movePosition:(CGFloat)offset isMiddleMode:(BOOL)isMiddleMode {
    CGFloat currentHeight = .0f;
    CGFloat currentTop = .0f;

    if (_isMiddleMode && [self isValidValue:offset + _firstContainerHalfTopView.height]) {
        currentHeight = _firstContainerView.height - _firstContainerHalfTopView.height;
        currentTop = _firstContainerHalfTopView.height;

        _collectionView.top = offset + currentTop;
        _collectionView.height = -offset + currentHeight;

        _coverBlackView.alpha = (CGFloat)(fabs(offset) / _maxOffset * _maxAlpha);
        _firstContainerHalfTopView.bottom = _collectionView.top;
        _topView.top = _firstContainerHalfTopView.top;
    }

    if (!_isMiddleMode && [self isValidValue:offset + _dragView.height - _topView.height]) {
        currentHeight = _maxOffset + _firstContainerView.height - _firstContainerHalfTopView.height;
        currentTop = _dragView.height - _topView.height;

        _collectionView.top = offset + currentTop;
        _collectionView.height = -offset + currentHeight;

        _coverBlackView.alpha = _maxAlpha - (CGFloat)(fabs(offset) / _maxOffset * _maxAlpha);
        _firstContainerHalfTopView.bottom = _collectionView.top;
        _topView.top = _firstContainerHalfTopView.top;
    }
}

- (BOOL)isValidValue:(CGFloat)top {
    CGFloat minValue = _dragView.height - _topView.height;
    CGFloat maxValue = _firstContainerHalfTopView.height;
    return (top >= minValue && top <= maxValue);
}

#pragma mark - private methods

- (void)loadPhotos {
     __weak typeof(self) weakSelf = self;
    //Todo
    //暂时去掉从照片中选取video ，因为还存在不少问题
    [HSGHPhotoLoader loadAllTreePhotos:_isContainsVideo block:^(NSDictionary *photos, NSError *error) {
        HSLog(@"Load Photos : %@", photos);
        if (photos && photos.count > 0 && !error) {
            weakSelf.allPhotosDictionary = photos;
            [weakSelf creatDropView:weakSelf.allPhotosDictionary];
            
            NSString* key;
            if (weakSelf.allPhotosDictionary[@"相机胶卷"]) {
                key = @"相机胶卷";
            }
            else {
                key = photos.allKeys.firstObject;
            }
            
            weakSelf.titleLabel.text = UN_NIL_STR(key);
            weakSelf.currentTitle = UN_NIL_STR(key);
            [weakSelf.titleLabel sizeToFit];
            weakSelf.titleLabel.centerY = 22.f;
            weakSelf.titleLabel.centerX = weakSelf.view.width / 2;
            weakSelf.arrowImageView.left = weakSelf.titleLabel.right + 2;

            [weakSelf refreshCurrentByKey:key];
        }
    }];
}


- (void)creatDropView:(NSDictionary*)photos {
    if (_actionsArray) {
        [_actionsArray removeAllObjects];
    }
    _actionsArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    for (NSString* key in photos.allKeys) {
        PopoverAction* action = [PopoverAction actionWithTitle:UN_NIL_STR(key) handler:^(PopoverAction *action) {
            [weakSelf refreshCurrentByKey:key];
        }];
        [weakSelf.actionsArray addObject:action];
    }
}

- (void)refreshCurrentByKey: (NSString*)key {
    self.allPhotos = _allPhotosDictionary[key];
    self.titleLabel.text = key;
    _currentTitle = key;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = 22.f;
    self.titleLabel.centerX = self.view.width / 2;
    self.arrowImageView.left = self.titleLabel.right + 2;
    
    if (self.allPhotos.count) {
        HSGHPhoto *firstPhoto = self.allPhotos.firstObject;
        [self.imageScrollView displayImage:firstPhoto.originalImage];
        _rightButton.enabled = true;
        [self fixesCropCoverPositon];
    }
    [self.collectionView reloadData];
    if (self.allPhotos.count) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - getters & setters
- (void)clickDrop:(UIButton*)sender {
    [[PopoverView popoverView] showToView:_titleLabel withActions:_actionsArray];
}

- (UIView *)topView {
    if (_topView == nil) {
        //Set to handle to zero
        CGFloat navHeight = 44.f;
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), navHeight);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor whiteColor];
        self.topView.clipsToBounds = YES;

        rect = CGRectMake(0, 0, CGRectGetWidth(self.topView.bounds), navHeight);
        UIView *navView = [[UIView alloc] initWithFrame:rect];//26 29 33
        navView.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:navView];

        rect = CGRectMake(0, 0, 60, CGRectGetHeight(navView.bounds));
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = rect;
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [backBtn setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        if (!_isLauncher) {
            [navView addSubview:backBtn];
        }
        

        rect = CGRectMake((CGRectGetWidth(navView.bounds) - 100) / 2, 0, 100, CGRectGetHeight(navView.bounds));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
        titleLabel.text = @"相机胶卷";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = HEXRGBCOLOR(0x272727);
        [titleLabel sizeToFit];
        titleLabel.centerX = navView.centerX;
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [navView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        _arrowImageView.image = [UIImage imageNamed:@"ImagePickerArrow"];
        _arrowImageView.centerY = navView.centerY;
        _arrowImageView.left = titleLabel.right + 2;
        [navView addSubview:_arrowImageView];
        
        UIButton* selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedButton.frame = _titleLabel.frame;
        selectedButton.width = 150;
        selectedButton.top = 0;
        selectedButton.height = 44.f;
        selectedButton.centerY = navView.centerY;
        [selectedButton addTarget:self action:@selector(clickDrop:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:selectedButton];
        

        rect = CGRectMake(CGRectGetWidth(navView.bounds) - 80, 0, 80, CGRectGetHeight(navView.bounds));
        UIButton *cropBtn = [[UIButton alloc] initWithFrame:rect];
        [cropBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [cropBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [cropBtn setTitleColor:HEXRGBCOLOR(0x3978f0) forState:UIControlStateNormal];
        [cropBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [cropBtn addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:cropBtn];
        _rightButton = cropBtn;

    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        CGFloat height = 44.f;
        CGRect rect = CGRectMake(0, self.view.height - height, self.view.width, height);
        _bottomView = [[UIView alloc] initWithFrame:rect];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];

        //图库
        rect = CGRectMake(0, 0, 120, _bottomView.height);
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = rect;
        [photoBtn setTitle:@"图库" forState:UIControlStateNormal];
        [photoBtn setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
        photoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        photoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [photoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [photoBtn addTarget:self action:@selector(clickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:photoBtn];

        //相机
        rect = CGRectMake(_bottomView.width - 120, 0, 120, CGRectGetHeight(_bottomView.bounds));
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = rect;
        [cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
        cameraBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cameraBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
        [cameraBtn setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
        cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [cameraBtn addTarget:self action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cameraBtn];
        
    }
    return _bottomView;
}

- (void)delayRefresh:(NSNumber *)index {
    [self refreshUI:index.integerValue];
    [self.videoPageView.bottomScrollView refreshUI:index.integerValue];
}

- (HSGHVideoScrollBottomTitleView*)bottomTitleView {
    if (!_bottomTitleView) {
        CGFloat height = 44.f;
        CGRect rect = CGRectMake(0, self.view.height - height, self.view.width, height);
        _bottomTitleView = [[HSGHVideoScrollBottomTitleView alloc] initWithFrame:rect];
        
        __weak typeof(self) weakSelf = self;
        _bottomTitleView.selectedBlock = ^(NSUInteger index) {
            [weakSelf delayRefresh:@(index)];
            if (index == 0) {//视频库
                weakSelf.isCameraPage = NO;
                weakSelf.contentScrollView.contentOffset =  CGPointMake(0, 0);
                //默认选中第一个
                if (weakSelf.allPhotos.count > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    [weakSelf collectionView:weakSelf.collectionView didSelectItemAtIndexPath:indexPath];
                }
            }
            else {
                weakSelf.isCameraPage = YES;
                weakSelf.contentScrollView.contentOffset =  CGPointMake(weakSelf.view.width, 0);
            }
            [weakSelf refreshUI:index];
            [weakSelf.videoPageView.bottomScrollView refreshUI:index];
        };
        
        _bottomTitleView.deleteBlock = ^{
            [weakSelf.videoPageView.bottomScrollView.rightView.progressView deleteLastSelected];
            [weakSelf.videoPageView deleteLastSession];
            if (![weakSelf.videoPageView hasSession]) {
                [weakSelf.bottomTitleView updateUIState:VideoNotStarted];
                weakSelf.contentScrollView.scrollEnabled = YES;
//                weakSelf.videoPageView.bottomScrollView.contentScrollView.scrollEnabled = YES;   //因为视频不再包含拍照，所以默认就是不能再滚动
            }
        };
        
        _bottomTitleView.willDeleteBlock = ^{
            [weakSelf.videoPageView.bottomScrollView.rightView.progressView setLastSelected];
        };
    }
    return _bottomTitleView;
}


- (void)clickPhoto {
    [self switchPage:NO];
}

- (void)clickCamera {
    [self switchPage:YES];
}

- (UIView *)firstContainerView {
    if (!_firstContainerView) {
        _firstContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, _contentScrollView.height)];

        CGRect rect = CGRectMake(0, 0, _firstContainerView.width, _firstContainerView.width);
        if (_isChangeRate) {
            rect = CGRectMake(0, 0, _firstContainerView.width, _firstContainerView.width / 750 * 456 );
        }
        _firstContainerHalfTopView = [[UIView alloc] initWithFrame:rect];
        _firstContainerHalfTopView.backgroundColor = HEXRGBCOLOR(0xefefef);
        [_firstContainerView addSubview:_firstContainerHalfTopView];

        self.imageScrollView = [[HSGHImageScrollView alloc] initWithFrame:rect];
        self.imageScrollView.isPersonalMode = _isPersonalMode;
        self.imageScrollView.isChangeRate = _isChangeRate;
        self.imageScrollView.clipsToBounds = YES;
        [_firstContainerHalfTopView addSubview:self.imageScrollView];

        rect = CGRectMake(CGRectGetWidth(_firstContainerView.bounds) - 25 - 10, _imageScrollView.height - 25 - 10, 25, 25);
        _resizeButton = [[UIButton alloc] initWithFrame:rect];
        [_resizeButton setImage:[UIImage imageNamed:@"ImagePickerResize"] forState:UIControlStateNormal];
        [_resizeButton addTarget:self action:@selector(resizeAction) forControlEvents:UIControlEventTouchUpInside];
        if (!_isContainsVideo) {
            [_firstContainerHalfTopView addSubview:_resizeButton];
        }

        //MaskView
        self.maskView = [[UIImageView alloc] initWithFrame:_imageScrollView.bounds];
        self.maskView.image = [UIImage imageNamed:@"ImagePicker/straighten-grid" inBundle:nil compatibleWithTraitCollection:nil];
        [_firstContainerHalfTopView insertSubview:self.maskView aboveSubview:self.imageScrollView];

        //blackView
        _coverBlackView = [[UIView alloc] initWithFrame:_firstContainerHalfTopView.bounds];
        _coverBlackView.backgroundColor = [UIColor blackColor];
        _coverBlackView.alpha = .0f;
        [_firstContainerHalfTopView addSubview:_coverBlackView];

        //Drag View
//        _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, _firstContainerHalfTopView.height + _topView.height - 25 - 10,
//                _contentScrollView.width - 35, 25 + 10)];
        _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, _firstContainerHalfTopView.height + _topView.height,
                                                             _contentScrollView.width, 35)];
        _dragView.backgroundColor = [UIColor clearColor];

//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
//        [_dragView addGestureRecognizer:_panGesture];

        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_dragView addGestureRecognizer:_tapGesture];
        [self.view addSubview:_dragView];

        [_firstContainerView addSubview:self.collectionView];
    }
    return _firstContainerView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat column = 4.0, spacing = 1.0;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (column - 1) * spacing) / column);

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(value, value);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = spacing;
        layout.minimumLineSpacing = spacing;

        CGRect rect = CGRectMake(0, _imageScrollView.height + 1,
                _firstContainerView.width, _firstContainerView.height - _imageScrollView.height - 1);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
        _collectionView.backgroundColor = HEXRGBCOLOR(0xefefef);
        _collectionView.alwaysBounceVertical = YES;

        [_collectionView registerClass:[HSGHPhotoCollectionViewCell class]
            forCellWithReuseIdentifier:@"HSGHPhotoCollectionViewCell"];
    }
    return _collectionView;
}

- (HSGHCameraPickerView *)secondContainerView {
    if (!_secondContainerView) {
        _secondContainerView = [[HSGHCameraPickerView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, _contentScrollView.height) isFront:_isPersonalMode];
        _secondContainerView.isChangeRate = _isChangeRate;
        _secondContainerView.isPersonalMode = _isPersonalMode;
        _secondContainerView.delegate = self;
    }
    return _secondContainerView;
}


- (HSGHVideoPageView *)videoPageView {
    if (!_videoPageView) {
        _videoPageView = [[HSGHVideoPageView alloc]initWithFrame:CGRectMake(self.view.width, 0, self.view.width, _contentScrollView.height)];
        __weak typeof(self) weakSelf = self;
        _videoPageView.photoBlock = ^(UIImage *image) {
            [weakSelf didCaptureImage:image];
        };
        
        _videoPageView.videoStartBlock = ^{
            [weakSelf.bottomTitleView updateUIState:VideoRecording];
            weakSelf.contentScrollView.scrollEnabled = false;
            weakSelf.videoPageView.bottomScrollView.contentScrollView.scrollEnabled = false;
        };
        
        _videoPageView.videoPauseBlock = ^{
            [weakSelf.bottomTitleView updateUIState:VideoDelete];
        };
        
        _videoPageView.videoFinishedBlock = ^(NSString* outputUrl){
            
        };
        
        _videoPageView.bottomScrollView.scrollBlock = ^(BOOL isVideo) {
            [weakSelf refreshUI:isVideo ? TakeVideo : TakePhoto];
            [weakSelf.bottomTitleView refreshUI:isVideo ? TakeVideo : TakePhoto];
        };
        
        _videoPageView.didCanSaveBlock = ^(BOOL canSave) {
            if (weakSelf.contentScrollView.contentOffset.x != 0) {
                weakSelf.rightButton.enabled = canSave;
            }
        };
    }
    return _videoPageView;
}

- (void)refreshUI:(TakePhotoType)type {
    //因为video 模式不再包含拍照，所以这里做了一个转换
    if (type == TakePhoto) {
        type = TakeVideo;
    }
    
    switch (type) {
        case SelectedPhoto:
            self.rightButton.hidden = false;
            self.rightButton.enabled = true;
            _titleLabel.text = UN_NIL_STR(_currentTitle);
            _arrowImageView.hidden = NO;
            break;
            
        case TakePhoto:
            self.rightButton.hidden = true;
            self.rightButton.enabled = false;
            self.titleLabel.text = @"照片";
            _arrowImageView.hidden = YES;
            
            break;
            
        case TakeVideo:
            self.rightButton.hidden = false;
            self.rightButton.enabled = false;
            self.titleLabel.text = @"视频";
            _arrowImageView.hidden = YES;
            break;
            
        default:
            break;
    }
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = 22.f;
    self.titleLabel.centerX = self.view.width / 2;
    self.arrowImageView.left = self.titleLabel.right + 2;
}


@end
