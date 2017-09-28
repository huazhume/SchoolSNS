//
//  HSGHSharedModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
 SHARED_WECHAT_MODE,
 SHARED_WECHATFRIEND_MODE,
 SHARED_QQFRIEND_MODE,
 SHARED_QQ_MODE,
 SHARED_REPORT_MODE,
 SHARED_DELETE_MODE,
 SHARED_HEI_MODE,
}HSGH_SHARED_MODE;

@interface HSGHSharedModel : NSObject
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * imageName;
@property (nonatomic, assign) HSGH_SHARED_MODE type;
+ (void)fetchReportWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock;
+ (void)reportAndDeleteWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock;

@end
