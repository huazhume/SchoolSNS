//
//  HSGHPublishViewModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSGHPublishUploadModel : NSObject

@property (copy, nonatomic)  NSString *key;
@property (copy, nonatomic)  NSString *name;
@property (copy, nonatomic)  NSString *qqianId;
@end

@interface HSGHPublishViewModel : NSObject
@property (copy, nonatomic) NSString* qqianId;
@property (copy, nonatomic)  NSString *userId;
@property (copy, nonatomic)  NSString *qqAllotTime;
@property (strong, nonatomic)  NSNumber *defaultAnonymTimes;
@property (strong, nonatomic)  NSNumber *qqResidueDegree;
//发布
+ (void)fetchPublishWithParams:(NSDictionary *)params :(void (^)(BOOL success , id response))fetchBlock ;
//上传
+ (void)uploadVideoFile:(NSData *)videoData imageData:(NSData *)imageData block:(void (^)(BOOL, NSString *))fetchBlock; //Video
+ (void)uploadFile:(NSData*)imageData block:(void (^)(BOOL success,NSString * key))fetchBlock;
+ (void)uploadFile:(NSData *)data isVideo:(BOOL)isVideo block:(void (^)(BOOL, NSString *))fetchBlock; //上传视频

+ (void)fetchPublishAnonymtimes:(void (^)(BOOL success ,id reponse))fetchBlock ;

@end
