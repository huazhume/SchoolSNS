//
// Created by FlyingPuPu on 26/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReturnBlock)(BOOL success, NSString *path);

@interface HSGHCompress : NSObject

+ (void)compressPic:(NSString *)path isChangeResolution:(BOOL)change block:(ReturnBlock)block;

+ (void)customCompressVideo:(NSString *)path block:(ReturnBlock)block;

+ (void)compressVideo:(NSString *)path block:(ReturnBlock)block;
@end
