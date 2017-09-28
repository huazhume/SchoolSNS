//
//  HSGHImageScrollView.h
//  InstagramPhotoPicker

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HSGHImageScrollView : UIScrollView
@property (nonatomic, assign) BOOL isPersonalMode;
@property (nonatomic, assign) BOOL isChangeRate;

- (void)displayImage:(UIImage *)image;

- (void)resizeAction;

- (UIImage *)capture;

- (UIImage*)captureWithRect:(CGRect)rect;

- (CGRect)fetchImageViewFrame;

//Video
- (void)displayVideo:(AVAsset*)avasset;
- (CGRect)fetchVideoRect;
@end
