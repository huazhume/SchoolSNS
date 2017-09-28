//
//  HSGHImageUpLoadManager.m
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/30.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHImageUpLoadManager.h"
//#import "QiniuUploader.h"
//#import "HSGHImgModel.h"
//#import "MJExtension.h"
#import "NSString+BFSExt.h"



@implementation HSGHImageUpLoadManager
//+(void)upLoadPicToServerWithImages:(NSArray *)array compleBlock:(upLoadCompleteBlock)block
//{
//    
//    NSMutableArray * tmpArray = [NSMutableArray array];
//    QiniuUploader * uploader = [[QiniuUploader alloc] init];
//    for (int i =0; i < array.count; i++) {
//        UIImage * image =array[i];
//        NSData *imageData = UIImageJPEGRepresentation(image, 1);
//        
//        QiniuFile *file = [[QiniuFile alloc] initWithFileData:imageData];
//        [uploader addFile:file];
//        //图片加载成功
//        [uploader setUploadOneFileSucceeded:^(NSInteger index, NSString *key, NSDictionary *info){
//            NSLog(@"index: %ld key: %@ info: %@",(long)index, key, info);
//            
//            NSString * urlStr = [NSString stringWithFormat:@"%@/%@",KRequestPicQiNiuURL,key];
//   
//            HSGHImgModel * imgModel = [[HSGHImgModel alloc]init];
//            imgModel.imgUrl = urlStr;
//            imgModel.imgWidth = 1;
//            imgModel.imgHeight = 1;
//            [tmpArray addObject:imgModel];
//            
//            
//        }];
//        
//        [uploader setUploadOneFileProgress:^(NSInteger index, NSProgress *process){
//            NSLog(@"index:%ld percent:%@",(long)index, process);
//            
//        }];
//        [uploader setUploadOneFileFailed:^(NSInteger index, NSError * _Nullable error){
//            NSLog(@"error: %@",error);
//            
//        }];
//        
//    }
//    [uploader setUploadAllFilesComplete:^(void){
//        NSLog(@"complete");
//        NSArray *dictArray = [HSGHImgModel mj_keyValuesArrayWithObjectArray:tmpArray];
//        NSString * str = [NSString modelTurnToJsonStr:dictArray];
//        
//        !block?:block(str);
//    }];
//    [uploader startUploadWithAccessToken:[[QiniuToken sharedQiniuToken] uploadToken]];
//    
//    
//}
//
//+(void)upLoadVideoToServerWithVideo:(NSData *)data compleBlock:(upLoadCompleteBlock)block
//{
//    QiniuUploader * uploader = [[QiniuUploader alloc] init];
//    QiniuFile *file = [[QiniuFile alloc] initWithFileData:data];
//    NSMutableArray * tmpArray = [NSMutableArray array];
//    [uploader addFile:file];
//    
//    [uploader setUploadOneFileSucceeded:^(NSInteger index, NSString *key, NSDictionary *info){
//        NSLog(@"index: %ld key: %@ info: %@",(long)index, key, info);
//        [tmpArray addObject:[NSString stringWithFormat:@"%@/%@",KRequestPicQiNiuURL,key]];
//
//
//        }];
//    [uploader setUploadOneFileProgress:^(NSInteger index, NSProgress *process){
//        NSLog(@"index:%ld percent:%@",(long)index, process);
//        
//    }];
//    [uploader setUploadOneFileFailed:^(NSInteger index, NSError * _Nullable error){
//        NSLog(@"error: %@",error);
//        
//    }];
//    [uploader setUploadAllFilesComplete:^(void){
//        NSLog(@"complete");
//        
//        !block?:block(tmpArray.firstObject);
//    }];
//    [uploader startUploadWithAccessToken:[[QiniuToken sharedQiniuToken] uploadToken]];
//    
//
//
//}

@end
