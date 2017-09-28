//
//  HSGHImageScrollView.m


#import "HSGHImageScrollView.h"
#import "HSGHTools.h"
#import "HSGHVideoPlayView.h"

#define rad(angle) ((angle) / 180.0 * M_PI)

@interface HSGHImageScrollView () <UIScrollViewDelegate> {
    CGSize _imageSize;
}
@property(strong, nonatomic) UIImageView *imageView;

@property(nonatomic, strong) HSGHVideoPlayView* videoPlayView;
@end

@implementation HSGHImageScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;

    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;

    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;

    self.imageView.frame = frameToCenter;
    _videoPlayView.frame = self.imageView.frame;
}

/**
 *  cropping image not just snapshot , inpired by https://github.com/gekitz/GKImagePicker
 *
 *  @return image cropped
 */
- (UIImage *)capture {

    CGRect visibleRect = [self _calcVisibleRectForCropArea];//caculate visible rect for crop
    CGAffineTransform rectTransform = [self _orientationTransformedRectOfImage:self.imageView.image];//if need rotate caculate
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);

    CGImageRef ref = CGImageCreateWithImageInRect([self.imageView.image CGImage], visibleRect);//crop
//    NSData* data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.imageView.image, 0.5)];
//    [HSGHTools writeNSDataToFile:data name:@"wanliming_before.jpg"];
    
    UIImage *cropped = [[UIImage alloc] initWithCGImage:ref scale:self.imageView.image.scale orientation:self.imageView.image.imageOrientation];
//    NSData* data2 = [[NSData alloc] initWithData:UIImageJPEGRepresentation(cropped, 0.5)];
//    [HSGHTools writeNSDataToFile:data2 name:@"wanliming_after.jpg"];
    
    CGImageRelease(ref);
    ref = NULL;
    return cropped;
}


- (UIImage*)captureWithRect:(CGRect)rect {
    
    CGRect visibleRect = [self _calcVisibleRectForCropArea:rect];//caculate visible rect for crop
    CGAffineTransform rectTransform = [self _orientationTransformedRectOfImage:self.imageView.image];//if need rotate caculate
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    CGImageRef ref = CGImageCreateWithImageInRect([self.imageView.image CGImage], visibleRect);//cro
    
    UIImage *cropped = [[UIImage alloc] initWithCGImage:ref scale:self.imageView.image.scale orientation:self.imageView.image.imageOrientation];
    
    CGImageRelease(ref);
    ref = NULL;
    return cropped;
}


static CGRect TWScaleRect(CGRect rect, CGFloat scale) {
    return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}


- (CGRect)_calcVisibleRectForCropArea:(CGRect)rect {
    CGRect visibleRect = [self convertRect:self.bounds toView:self.imageView];
    CGFloat rate = visibleRect.size.width / rect.size.width;
    visibleRect = CGRectMake(visibleRect.origin.x, visibleRect.origin.y + rect.origin.y * rate
                             , visibleRect.size.width, rect.size.height * rate);
    
    CGFloat sizeScale = self.imageView.image.size.width / self.imageView.frame.size.width;
    sizeScale *= self.zoomScale;
    return visibleRect = TWScaleRect(visibleRect, sizeScale);
}


- (CGRect)_calcVisibleRectForCropArea {

    CGFloat sizeScale = self.imageView.image.size.width / self.imageView.frame.size.width;
    sizeScale *= self.zoomScale;
    CGRect visibleRect = [self convertRect:self.bounds toView:self.imageView];
    return visibleRect = TWScaleRect(visibleRect, sizeScale);
}

- (CGAffineTransform)_orientationTransformedRectOfImage:(UIImage *)img {
    CGAffineTransform rectTransform;
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };

    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}


- (void)displayImage:(UIImage *)image {
    // clear the previous image
    [self.imageView removeFromSuperview];
    self.imageView = nil;

    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;

    // make a new UIImageView for the new image
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.clipsToBounds = NO;
    [self addSubview:self.imageView];

    CGRect frame = self.imageView.frame;
    CGFloat curretRate = self.bounds.size.height / self.bounds.size.width;
    CGFloat rate = image.size.height / image.size.width;
    if (rate > curretRate) {
        frame.size.width = self.bounds.size.width;
        frame.size.height = (self.bounds.size.width / image.size.width) * image.size.height;
    } else {
        frame.size.height = self.bounds.size.height;
        frame.size.width = (self.bounds.size.height / image.size.height) * image.size.width;
    }
    self.imageView.frame = frame;

//    UIImageView *maskView = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
//    maskView.image = [UIImage imageNamed:@"ImagePicker/straighten-grid" inBundle:nil compatibleWithTraitCollection:nil];
//    [self.imageView addSubview:maskView];

    [self configureForImageSize:self.imageView.bounds.size];
    
//Video
    if (_videoPlayView) {
        [_videoPlayView pause];
        _videoPlayView.hidden = YES;
    }
    self.imageView.hidden = NO;
}


- (CGRect)fetchImageViewFrame {
    return self.imageView.frame;
}


- (void)configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    //to center
    if (imageSize.width > imageSize.height) {
        if (_isPersonalMode || _isChangeRate) {
            if (_isChangeRate) {
                self.contentOffset = CGPointZero;
            }
            else {
                self.contentOffset = CGPointMake((imageSize.width - imageSize.height)/ 2, 0);
            }
            self.zoomScale = 1.0;
        }
        else {
            self.contentOffset = CGPointZero;
            self.minimumZoomScale = (imageSize.height / imageSize.width) >= 0.4 ? (imageSize.height / imageSize.width) : 0.4;
            self.zoomScale = self.minimumZoomScale;
            
            //非截取头像，非选择背景的情况下，如果宽度大于高度，则限制不能放大
            if (!_isChangeRate && !_isPersonalMode) {
                if (self.zoomScale <= 1) {
                    self.maximumZoomScale = self.zoomScale;
                }
            }
        }
    } else if (imageSize.width < imageSize.height) {
//        self.contentOffset = CGPointMake(0, imageSize.height / 4);
        self.zoomScale = 1.0;
    }
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    if (_isPersonalMode || _isChangeRate) {
        self.minimumZoomScale = 1.0;
    }
    else {
        self.minimumZoomScale = 1.0;
    }
    self.maximumZoomScale = 2.0;
}

- (void)resizeAction {
    if (self.zoomScale < 1.0) {
        self.zoomScale = 1.0;
    } else {
        self.zoomScale = self.minimumZoomScale;
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - VideoPlay
- (void)displayVideo:(AVAsset*)avasset {
    self.imageView.hidden = YES;
    if (!_videoPlayView) {
        _videoPlayView = [[HSGHVideoPlayView alloc]initWithFrame:[self bounds]];
        [self addSubview:_videoPlayView];
    }
    
    _videoPlayView.hidden = NO;
    _videoPlayView.frame = self.imageView.frame;
//    [_videoPlayView resizeFrame];
    [_videoPlayView setAvasset:avasset];
    [_videoPlayView play];
    self.maximumZoomScale = 1.0;
}

- (CGRect)fetchVideoRect {
    return  CGRectMake(0, self.contentOffset.y, _videoPlayView.width, _videoPlayView.height);
}

@end
