//
//  HSGHImageLoader.h


#import <Foundation/Foundation.h>
#import "HSGHPhoto.h"

@interface HSGHPhotoLoader : NSObject

+ (void)loadAllPhotos:(void (^)(NSDictionary *photos, NSError *error))completion; //Only Photos
+ (void)loadAllVideos:(void (^)(NSDictionary *photos, NSError *error))completion; //Only Videos

+ (void)loadAllTreePhotos:(BOOL)containsVideo block:(void (^)(NSDictionary *photos, NSError *error))completion; //Videos and Photos

+ (void)clearPhotoArr;

@end
