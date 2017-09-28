//
//  HSGHMediaFileManager.h
//  SchoolSNS
//
//  Created by Huaral on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 多媒体类型
typedef enum {
  FILE_IMAGE_TYPE = 1006, // image 图片
  FILE_VIDEO_TYPE,        // video 视频
  FILE_AUDIO_TYPE,        // audio 语音
  FILE_DB_TYPE,           // db  数据库
  FILE_OFFLINE_TYPE,      // offline data 离线数据
  FILE_OTHER_TYPE,        // other 其它
} FILE_MEDIA_MODE;

/// 沙盒目录类型
typedef enum {
  SANBOX_DOCUMNET_TYPE, // document
  SANBOX_LIBRARY_TYPE,  // library
  SANBOX_TAMP_TYPE,     // tamp
  SANBOX_CACHE_TYPE,    // cache
} SANBOX_FILE_TYPEMODE;

@interface HSGHMediaFileManager : NSObject

//管理者
+ (HSGHMediaFileManager *)sharedManager;

//获取资源路径
- (NSString *)getMediaFilePathWithAndSanBoxType:(SANBOX_FILE_TYPEMODE)sanboxType
                                   AndMediaType:(FILE_MEDIA_MODE)mediaType;

@end
