//
// Created by FlyingPuPu on 28/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetResStatus){
    NetResUnknown = -1,
    NetResSuccess = 0,      //
    NetResServerError = 1,  //服务器错误，status非0
    NetResFailed  = 2,       //其他错误，超时或网络错误
    NetResUserExisted  = 3,      //2001 用户已存在
};

@interface HSGHNetworkSession : NSObject

typedef void(^NetResponseBlock)(id obj, NetResStatus status, NSString *errorDes);

/*
 * Http Method: post
 * url: service url
 * paramsDic: appended dic {"page":"1", "name":"hello"}
 * returnClass: the class of returnObj
 * block: async return the response obj model and response status
 * */
+ (void)postReq:(NSString *)url appendParams:(NSDictionary *)paramsDic returnClass:(Class)returnClass block:(NetResponseBlock)block;

+ (void)getReq:(NSString *)url appendParams:(NSDictionary *)paramsDic returnClass:(Class)returnClass block:(NetResponseBlock)block;
@end
