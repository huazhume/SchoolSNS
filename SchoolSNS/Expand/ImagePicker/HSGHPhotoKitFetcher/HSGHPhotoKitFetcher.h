//
//  CTAlbumModel.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PhotoKitType) {
    PhotoKitPhotos = 0,
    PhotoKitVideos,
    PhotoKitVideosAndPhotos,
    PhotoKitUnknown
};


@interface HSGHPhotoKitFetcher : NSObject


@end
