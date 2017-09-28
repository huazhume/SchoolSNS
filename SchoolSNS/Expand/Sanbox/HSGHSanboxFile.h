//
//  HSGHSanboxFile.h
//  SchoolSNS
//
//  Created by Huaral on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSGHSanboxFile : NSObject

//获取程序的Home目录路径
+ (NSString *)getHomeDirectoryPath;

//获取document目录路径
+ (NSString *)getDocumentPath;

//获取Cache目录路径
+ (NSString *)getCachePath;

//获取Library目录路径
+ (NSString *)getLibraryPath;

//获取Tmp目录路径
+ (NSString *)getTmpPath;

//创建目录文件夹
+ (NSString *)createList:(NSString *)List ListName:(NSString *)Name;

//写入NsArray文件
+ (BOOL)writeFileArray:(NSArray *)ArrarObject SpecifiedFile:(NSString *)path;

//写入NSDictionary文件
+ (BOOL)writeFileDictionary:(NSMutableDictionary *)DictionaryObject
              SpecifiedFile:(NSString *)path;

//是否存在该文件
+(BOOL)isFileExists:(NSString *)filepath;

//删除指定文件
+(void)deleteFile:(NSString*)filepath;

@end
