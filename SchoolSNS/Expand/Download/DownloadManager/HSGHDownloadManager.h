//
//  HSGHDownloadManager.h
//  SchoolSNS
//
//  Created by Huaral on 2017/4/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSGHDownloadModel;
@class HSGHResumeManager;

@interface HSGHDownloadManager : NSObject
//下载队列组
@property(nonatomic, strong) NSMutableArray *resumeTasksArray;

/**
 单例

 @return self
 */
+ (HSGHDownloadManager *)defaultDBManager;

/**
 *  download
 *
 *  @param model download
 */
- (void)downloadWithModel:(HSGHDownloadModel *)model;
@end
