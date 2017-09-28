//
//  HSGHUploadPicNetRequest.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 25/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHUploadPicNetRequest.h"
#import "AFNetworking.h"
#import "YYModel.h"

@implementation HSGHUploadResponse
@end

@implementation HSGHUploadPicNetRequest

+ (NSData *)convertToNSData:(UIImage *)image {
    return UIImageJPEGRepresentation(image, 0.7);
}

//补齐封面, rawData 封面的数据， key 对应的视频key
+ (void)uploadAlbum:(NSData *)rawData key:(NSString*)key block:(void (^)(BOOL, NSString *, NSString *))fetchBlock {
    NSDictionary *parameters = @{}; //other params
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.requestSerializer.timeoutInterval = 60;
    [requestManager.requestSerializer setValue:@"multipart/form-data;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [requestManager.requestSerializer setValue:@"album.jpg"forHTTPHeaderField:@"filename"];
    
    [requestManager POST:[NSString stringWithFormat:@"%@/%@", HSGHFileUploadURL, UN_NIL_STR(key)]
              parameters:parameters
constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
    /**
     *  appendPartWithFileURL   //  指定上传的文件
     *  name                    //  指定在服务器中获取对应文件或文本时的key
     *  fileName                //  指定上传文件的原始文件名
     *  mimeType                //  指定文件的MIME类型
     */
    [formData appendPartWithFileData:rawData name: @"image" fileName:@"album.jpg" mimeType:@"image/png"];
} progress:^(NSProgress *progress) {
    
}
                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                     if (responseObject) {
                         HSGHUploadPicNetRequest* obj = (HSGHUploadPicNetRequest*)[[self class] yy_modelWithDictionary:(NSDictionary *) responseObject];
                         if (fetchBlock) {
                             fetchBlock(YES, obj.data.key, obj.data.name);
                         }
                     } else {
                         if (fetchBlock) {
                             fetchBlock(NO, nil, nil);
                         }
                     }
                     
                 } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                     if (fetchBlock) {
                         fetchBlock(NO, nil, nil);
                     }
                 }];
}


+ (void)upload:(NSData *)rawData block:(void (^)(BOOL success, NSString *key, NSString *name))fetchBlock {
    [HSGHUploadPicNetRequest upload:rawData isVideo:false block:^(BOOL success, NSString *key, NSString *name) {
        if (fetchBlock) {
            fetchBlock(success, key, name);
        }
    }];
}

+ (void)upload:(NSData *)rawData isVideo:(BOOL)isVideo block:(void (^)(BOOL success, NSString *key, NSString *name))fetchBlock {
    NSDictionary *parameters = @{}; //other params
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.requestSerializer.timeoutInterval = 160;
    [requestManager.requestSerializer setValue:@"multipart/form-data;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    [requestManager.requestSerializer setValue:isVideo ? @"video.mp4" : @"head.jpg"forHTTPHeaderField:@"filename"];
 
    [requestManager POST:HSGHFileUploadURL
               parameters:parameters
constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
    /**
     *  appendPartWithFileURL   //  指定上传的文件
     *  name                    //  指定在服务器中获取对应文件或文本时的key
     *  fileName                //  指定上传文件的原始文件名
     *  mimeType                //  指定文件的MIME类型
     */
    [formData appendPartWithFileData:rawData name:isVideo ? @"video.mp4": @"image" fileName:isVideo ? @"video.mp4" : @"head.jpg" mimeType:isVideo ? @"video/mp4" : @"image/png"];
} progress:^(NSProgress *progress) {

            }
                  success:^(NSURLSessionDataTask *operation, id responseObject) {
                      if (responseObject) {
                          HSGHUploadPicNetRequest* obj = (HSGHUploadPicNetRequest*)[[self class] yy_modelWithDictionary:(NSDictionary *) responseObject];
                          if (fetchBlock) {
                              fetchBlock(YES, obj.data.key, obj.data.name);
                          }
                      } else {
                          if (fetchBlock) {
                              fetchBlock(NO, nil, nil);
                          }
                      }

                  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                if (fetchBlock) {
                    fetchBlock(NO, nil, nil);
                }
            }];
}

@end
