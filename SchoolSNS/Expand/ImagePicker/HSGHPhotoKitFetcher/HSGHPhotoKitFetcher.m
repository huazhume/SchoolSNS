//

#import "HSGHPhotoKitFetcher.h"
#import <Photos/Photos.h>

@implementation HSGHPhotoKitFetcher

+ (BOOL)authorizationStatusAuthorized {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}


+ (void)fetchAllAlbumsWithType:(PhotoKitType)type completion:(void(^_Nonnull)(NSArray *albums))completion {
    NSMutableArray *ablumArr = [NSMutableArray new];
    
    PHFetchOptions *option = [PHFetchOptions new];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    switch (type) {
        case PhotoKitPhotos: {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            break;
        }

        case PhotoKitVideos: {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            break;
        }
            
        case PhotoKitVideosAndPhotos: {
            break;
        }
            
        default:
            break;
    }
    
    PHFetchResult *smartAlbums;
    if (type == PhotoKitVideos) {
        smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    }
    else {
        smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    }
    
    
    
    
    
}








@end
