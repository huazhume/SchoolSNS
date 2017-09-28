//
//  HSGHImageLoader.m


#import "HSGHPhotoLoader.h"
#import "SchoolSNS-Swift.h"


@interface HSGHPhotoLoader ()
@property (strong, nonatomic) NSMutableDictionary *allTreePhotos;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (copy, nonatomic) void(^loadTreeBlock)(NSDictionary *subPhotos, NSError *error); //Tree photos : key: "QQ" value: array
@end



@implementation HSGHPhotoLoader

+ (HSGHPhotoLoader *)sharedLoader {
    static HSGHPhotoLoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[HSGHPhotoLoader alloc] init];
    });
    return loader;
}

+ (void)loadAllPhotos:(void (^)(NSDictionary *photos, NSError *error))completion {
    [HSGHPhotoLoader loadAllTreePhotos:false block:^(NSDictionary *photos, NSError *error) {
        if (completion) {
            completion(photos, error);
        }
    }];
}

+ (void)loadAllVideos:(void (^)(NSDictionary *photos, NSError *error))completion {
    [HSGHPhotoLoader loadAllTreePhotos:true block:^(NSDictionary *photos, NSError *error) {
        if (completion) {
            completion(photos, error);
        }
    }];
}

+ (void)loadAllTreePhotos:(BOOL)containsVideo block:(void (^)(NSDictionary *photos, NSError *error))completion {
    int author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        Toast* toast = [[Toast alloc]initWithText:@"无相册访问权限，请在iPhone的\"设置-隐私-照片\"中允许访问照片。" delay:0 duration:1.f];
        [toast show];
        return;
    }
    
    [[HSGHPhotoLoader sharedLoader].allTreePhotos removeAllObjects]; /* added this line to remove assets duplication*/
    [[HSGHPhotoLoader sharedLoader] setLoadTreeBlock:completion];
    [[HSGHPhotoLoader sharedLoader] startLoading:containsVideo];
}

- (void)startLoading:(BOOL)containsVideo {
    __weak typeof(self) weakSelf = self;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter;
        if (containsVideo) {
            onlyPhotosFilter = [ALAssetsFilter allVideos];
        }
        else {
            onlyPhotosFilter = [ALAssetsFilter allPhotos];
        }
        
        [group setAssetsFilter:onlyPhotosFilter];


        if ([group numberOfAssets] > 0) {

            if (weakSelf.loadTreeBlock) {
                NSString* name = [group valueForProperty:ALAssetsGroupPropertyName];
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                  if (result) {
                    HSGHPhoto *photo = [HSGHPhoto new];
                    photo.asset = result;
                    [weakSelf appendData:photo groupName:name];
                  }
                }];
            }

        }
        
        if (group == nil) {
          if (weakSelf.loadTreeBlock) {
            weakSelf.loadTreeBlock(weakSelf.allTreePhotos.copy, nil);
          }
        }
      
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {

    }];
}

- (void)appendData:(HSGHPhoto*)photo groupName:(NSString *)name{
    if (name == nil || name.length == 0 || photo == nil) return;
    if (self.allTreePhotos[name] == nil) {
      self.allTreePhotos[name] = [NSMutableArray array];
    }
    [self.allTreePhotos[name] addObject:photo];
}


- (NSMutableDictionary *)allTreePhotos {
    if (_allTreePhotos == nil) {
        _allTreePhotos = [NSMutableDictionary dictionary];
    }
    return _allTreePhotos;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

+ (void)clearPhotoArr {
    HSLog(@"clearPhotoArr");
    [[HSGHPhotoLoader sharedLoader].allTreePhotos removeAllObjects];
    [HSGHPhotoLoader sharedLoader].allTreePhotos = nil;
}

@end
