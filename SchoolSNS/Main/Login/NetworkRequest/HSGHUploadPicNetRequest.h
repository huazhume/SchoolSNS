//
//  HSGHUploadPicNetRequest.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 25/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHUploadResponse : NSObject
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *name;

@end

@interface HSGHUploadPicNetRequest : NSObject
@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) HSGHUploadResponse *data;

+ (NSData *)convertToNSData:(UIImage *)image;

+ (void)upload:(NSData *)rawData block:(void (^)(BOOL success, NSString *key, NSString *name))fetchBlock;

+ (void)upload:(NSData *)rawData isVideo:(BOOL)isVideo block:(void (^)(BOOL success, NSString *key, NSString *name))fetchBlock;

+ (void)uploadAlbum:(NSData *)rawData key:(NSString*)key block:(void (^)(BOOL, NSString *, NSString *))fetchBlock;

@end
