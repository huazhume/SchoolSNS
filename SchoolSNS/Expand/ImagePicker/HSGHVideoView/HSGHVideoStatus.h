//
//  HSGHVideoStatus.h
//  SchoolSNS
//
//  Created by Murloc on 31/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#ifndef HSGHVideoStatus_h
#define HSGHVideoStatus_h


typedef NS_ENUM(NSUInteger, VideoBottomUIType){
    VideoNotStarted = 0,
    VideoRecording,
    VideoDelete,
    VideoDeleteSelected,
    VideoUnkonwn
};

typedef NS_ENUM(NSUInteger, TakePhotoType){
    SelectedPhoto = 0,
    TakePhoto,
    TakeVideo,
    TakePhotoUnknown
};


#define SpaceVideoSecond    0.01 //0.1短分割线占据的时间


#define FrameRate           30
#define VideoType           AVFileTypeMPEG4
#define AutoSavePhotoAlbum  YES

#define RecordSizeWidth     1080

#endif /* HSGHVideoStatus_h */
