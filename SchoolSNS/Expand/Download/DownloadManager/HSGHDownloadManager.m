//
//  HSGHDownloadManager.m
//  SchoolSNS
//
//  Created by Huaral on 2017/4/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHDownloadManager.h"
#import "HSGHDownloadModel.h"
#import "HSGHResumeManager.h"

@implementation HSGHDownloadManager
//单例操作
static HSGHDownloadManager *_sharedManager;

+ (HSGHDownloadManager *)defaultDBManager {
  if (!_sharedManager) {
    _sharedManager = [[HSGHDownloadManager alloc] init];
    //数组初始化
    _sharedManager.resumeTasksArray = [NSMutableArray array];
  }
  return _sharedManager;
}

/**
 *  download
 *
 *  @param model downloadModel
 */

- (void)downloadWithModel:(HSGHDownloadModel *)model {

  HSGHResumeManager *resumeManager =
      [[HSGHResumeManager alloc] initWithModel:model];
  //加入队列中
  [_sharedManager.resumeTasksArray addObject:resumeManager];

  [resumeManager resumeManagerWithURL:[NSURL URLWithString:model.url]
      targetPath:model.targetPath
      success:^{
        // success
        model.isSuccess = @1;

      }
      failure:^(NSError *error) {
        // fail
        model.isSuccess = @0;
        model.failErrorInfo = error;

      }
      progress:^(long long totalReceivedContentLength,
                 long long totalContentLength) {
        // downloading
        model.totalContentLength = totalContentLength;
        model.totalReceivedContentLength = totalReceivedContentLength;

      }];
  [resumeManager start];
}

@end
