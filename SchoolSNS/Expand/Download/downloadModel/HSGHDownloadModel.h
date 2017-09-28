//
//  HSGHDownloadModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/4/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHDownloadModel : NSObject

@property(nonatomic, strong) NSNumber *isSuccess;
@property(nonatomic, copy) NSString *url;            //文件资源地址
@property(nonatomic, strong) NSString *targetPath;   //文件存放路径
@property long long totalContentLength;              //文件总大小
@property long long totalReceivedContentLength;      //已下载大小
@property(nonatomic, strong) NSError *failErrorInfo; //错误信息

@end
