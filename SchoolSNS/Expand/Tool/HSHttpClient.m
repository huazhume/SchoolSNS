//
//  HSHttpClient.m
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/6.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSHttpClient.h"
#import "AFNetworking.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"

@interface HSHttpClient()
@property(nonatomic,assign) BOOL isConnect;
@end
@implementation HSHttpClient

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        //请求参数序列化类型
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //响应结果序列化类型
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.manager.requestSerializer.timeoutInterval = 10.f;
        [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}

+ (HSHttpClient *)defaultClient
{
    static HSHttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //请求的URL
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        if (prepareExecute) {
            prepareExecute();
        }
        
        switch (method) {
            case HttpRequestGet:
            {
                
                [self.manager GET:url parameters:parameters progress:nil success:success failure:failure];
            }
                break;
            case HttpRequestPost:
            {
                [self.manager POST:url parameters:parameters progress:nil success:success failure:failure];
            }
                break;
            case HttpRequestDelete:
            {
                [self.manager DELETE:url parameters:parameters  success:success failure:failure];
            }
                break;
            case HttpRequestPut:
            {
                [self.manager PUT:url parameters:parameters success:success failure:false];
            }
                break;
            default:
                break;
        }
    }else{
        //网络错误咯
        [self showExceptionDialog];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
    
}

- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([self isConnectionAvailable]) {
        [self.manager HEAD:url parameters:parameters success:success failure:failure];
    }else{
        [self showExceptionDialog];
    }
}

- (void)requestWithPath:(NSString *)url
             parameters:(NSDictionary *)parameters
                  thumb:(NSData *)thumb
              thumbName:(NSString *)thumbName
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    if ([self isConnectionAvailable]) {
        
        if (prepare) {
            prepare();
        }
        [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:thumb name:thumbName fileName:@"1.png" mimeType:@"image/png"];
        } progress:nil success:success failure:failure];
        
        
    }else{
        [self showExceptionDialog];
    }
}


//看看网络是不是给力
- (BOOL)isConnectionAvailable{
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.baidu.com/"];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                self.isConnect = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                self.isConnect = YES;
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return !self.isConnect;
}
- (BOOL)isWifi{
    BOOL isWifi = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch([reach currentReachabilityStatus])
    {
        case NotReachable:  //没有连接上
            //do something
            break;
        case ReachableViaWiFi:  isWifi = YES;//通过wifi连接
            //do something
            break;
        case ReachableViaWWAN:  [self showExceptionDialog];//通过GPRS连接
            //do something
            break;
        default:   // <span style="white-space:pre">    </span>//未知情况
            //do something
            break;
    }
    
    
    return isWifi;
}

//弹出网络错误提示框
- (void)showExceptionDialog
{
    //    [[[UIAlertView alloc] initWithTitle:@"提示"
    //                                message:@"网络异常，请检查网络连接"
    //                               delegate:self
    //                      cancelButtonTitle:@"好的"
    //                      otherButtonTitles:nil, nil] show];
}
- (void)cancelHttpRequest{
    [self.manager.operationQueue cancelAllOperations];
}



@end
