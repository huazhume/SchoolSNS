//
//  HSGHPhoto.m


#import "HSGHPhoto.h"
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/ALAsset.h>
#import <AVFoundation/AVFoundation.h>


@implementation HSGHPhoto

- (UIImage *)thumbnailImage {
    return [UIImage imageWithCGImage:self.asset.thumbnail];
}

- (UIImage *)originalImage {
    return [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullResolutionImage
                               scale:self.asset.defaultRepresentation.scale
                         orientation:(UIImageOrientation)self.asset.defaultRepresentation.orientation];
}


- (NSURL*)videoURL {
    return self.asset.defaultRepresentation.url;
}

- (BOOL)isVideo {
    return [[self.asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
}


- (Float64)videoTime {
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    AVAsset* avAssert = [AVAsset assetWithURL:rep.url];
    
    return CMTimeGetSeconds(avAssert.duration);
}

@end
