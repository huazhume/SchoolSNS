//
//  HSHttpClient.h
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/6.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, HttpRequestType) {
    HttpRequestGet,
    HttpRequestPost,
    HttpRequestDelete,
    HttpRequestPut,
};

/**
 *  请求开始前预处理Block
 */
typedef void(^PrepareExecuteBlock)(void);

@interface HSHttpClient : NSObject
@property(nonatomic,strong) AFHTTPSessionManager *manager;

//取消请求
- (void)cancelHttpRequest;
+(HSHttpClient *)defaultClient;

/*
   HTTP请求（GET、POST、DELETE、PUT）
 
  @param url
  @param method     RESTFul请求类型
  @param parameters 请求参数
  @param prepare    请求前预处理块
  @param success    请求成功处理块
  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/*
   HTTP请求（HEAD）
   @param url
   @param parameters
   @param success
   @param failure
 */
- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/*
  HTTP请求 上传图片
 
  @param url
  @param parameters
  @param thumb      图片NSData
  @param success
  @param failure
 */
- (void)requestWithPath:(NSString *)url
             parameters:(NSDictionary *)parameters
                  thumb:(NSData *)thumb
              thumbName:(NSString *)thumbName
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//判断当前网络状态
- (BOOL)isConnectionAvailable;
//判断是不是Wi-Fi
- (BOOL)isWifi;


@end
