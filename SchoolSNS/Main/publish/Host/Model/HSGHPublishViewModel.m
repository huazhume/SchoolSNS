//
//  HSGHPublishViewModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHPublishViewModel.h"
#import "HSGHNetworkSession.h"

#import "HSGHUploadPicNetRequest.h"

@implementation HSGHPublishUploadModel



@end

@implementation HSGHPublishViewModel
//发布
+ (void)fetchPublishWithParams:(NSDictionary *)params :(void (^)(BOOL success ,id reponse))fetchBlock {
   
    [HSGHNetworkSession postReq:HSGHHomePublishURL
                   appendParams:params
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES , obj);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO , obj);
                                  }
                              }
                              
                          }];
}

//上传
+ (void)uploadVideoFile:(NSData *)videoData imageData:(NSData *)imageData block:(void (^)(BOOL, NSString *))fetchBlock {
    [HSGHPublishViewModel uploadFile:videoData isVideo:true block:^(BOOL success , NSString * videoKey) {
        if (success) {
            if (fetchBlock) {
                fetchBlock(YES, videoKey);
            }
            
        } else {
            if (fetchBlock) {
                fetchBlock(NO, nil);
            }
        }
    }];
}


+ (void)uploadFile:(NSData *)data isVideo:(BOOL)isVideo block:(void (^)(BOOL, NSString *))fetchBlock {
    [HSGHUploadPicNetRequest
     upload:data isVideo:isVideo
     block:^(BOOL success, NSString *key, NSString *name) {
         
         if (success) {
             fetchBlock(YES, key);
         } else {
             //             [[[UIAlertView alloc] initWithTitle:@""
             //                                         message:@"图片上传失败，请重新发布"
             //                                        delegate:nil
             //                               cancelButtonTitle:@"确定"
             //                               otherButtonTitles:nil] show];
         }
     }];}


+ (void)uploadFile:(NSData*)imageData block:(void (^)(BOOL success,NSString * key))fetchBlock {
    [HSGHUploadPicNetRequest upload:imageData isVideo:false block:^(BOOL success, NSString *key, NSString *name) {
        if (fetchBlock) {
            fetchBlock(success, key);
        }
    }];
}

//// YYModel
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{ @"data" : HSGHPublishUploadModel.class};
//}

//#define HSGHAnonymStatusURL
+ (void)fetchPublishAnonymtimes:(void (^)(BOOL success ,id reponse))fetchBlock {
    
    [HSGHNetworkSession postReq:HSGHAnonymStatusURL
                   appendParams:nil
                    returnClass:[self class]
                          block:^(id obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES , obj);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO , obj);
                                  }
                              }
                              
                          }];
}


@end
