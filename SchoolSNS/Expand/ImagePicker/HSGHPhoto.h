

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HSGHPhoto : NSObject

@property (nonatomic, readonly) UIImage *thumbnailImage;
@property (nonatomic, readonly) UIImage *originalImage;
@property (nonatomic, readonly) NSURL *videoURL;
@property (nonatomic, readonly) Float64 videoTime;

@property (nonatomic, strong) ALAsset *asset;

- (BOOL)isVideo;

@end
