//
// Created by FlyingPuPu on 28/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHNetworkSession.h"
#import "AFHTTPSessionManager.h"
#import "HSGHTools.h"
#import "YYModel.h"
//#import "HSGHNetReturnBase.h"
#import "HSGHUserInf.h"
#import "HSGHLoginNetRequest.h"
#import "AppDelegate.h"
#import "SchoolSNS-Swift.h"


@implementation HSGHNetworkSession {

}

//Write default values
static NSDictionary *creatDefaultReqDic() {
    return @{};
    NSString *osVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    return @{@"osVersion": osVersion, @"osType": @"0", @"width": [NSString stringWithFormat:@"%@", @(width)],
            @"height": [NSString stringWithFormat:@"%@", @(height)]};
}


//Response
// "code": 200,
//"message": "OK"
//"data": {}

+ (void)requst:(NSString *)url method:(NSString *)method appendParams:(NSDictionary *)paramsDic returnClass:(Class)returnClass block:(NetResponseBlock)block {
    NSMutableDictionary *paramsMulDic = [NSMutableDictionary dictionaryWithDictionary:creatDefaultReqDic()];
    if (paramsDic) {
        [paramsMulDic addEntriesFromDictionary:paramsDic];
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //添加签名
    if (![HSGHServerInterfaceUrl isSignatureBlackList:url]) {
        if ([HSGHUserInf shareManager].token) {
            [manager.requestSerializer setValue:[HSGHUserInf shareManager].token forHTTPHeaderField:@"token"];
            
//            paramsMulDic[@"token"] = [HSGHUserInf shareManager].token;
            NSString* subUrl = [HSGHServerInterfaceUrl deleteHost:url];
            NSString *signature = [NSString stringWithFormat:@"%@%@%@", subUrl, [paramsMulDic yy_modelToJSONString], [HSGHUserInf shareManager].secret];
//            NSLog(@"--before is %@", signature);
            signature = [HSGHTools getmd5WithString:signature];
//            paramsMulDic[@"signature"] = signature;
            
//            NSLog(@"--- token is %@, %@", [HSGHUserInf shareManager].token, signature);
            [manager.requestSerializer setValue:signature forHTTPHeaderField:@"signature"];

        }
    }

//    NSString *jsonString = [paramsMulDic yy_modelToJSONString]; 
    if ([method isEqualToString:@"Post"]) {
        [manager POST:url parameters:paramsMulDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //code  and message
            NSDictionary *retDic = (NSDictionary *) responseObject;
            //HSLog(@"<<<<<<<<<<<<%@",responseObject);
            if (retDic) {
                id key = retDic[@"code"];
                if (key) {
                    if (([key isKindOfClass:[NSString class]] && [key isEqualToString:@"200"]) ||
                            ([key isKindOfClass:[NSNumber class]] && ((NSNumber *) key).intValue == 200)) {
                        id parseObj = responseObject[@"data"];
                        if (parseObj) {
                            id obj = [returnClass yy_modelWithDictionary:(NSDictionary *) parseObj];
                            block(obj, NetResSuccess, nil);
                        } else {
                            block(nil, NetResSuccess, nil);
                        }
                    } else if (([key isKindOfClass:[NSString class]] && [key isEqualToString:@"2001"]) ||
                               ([key isKindOfClass:[NSNumber class]] && ((NSNumber *) key).intValue == 2001)) {
                        block(nil, NetResUserExisted, nil);
                    }
                    else if (([key isKindOfClass:[NSString class]] && [key isEqualToString:@"1002"]) ||     //Token is outdate
                             ([key isKindOfClass:[NSNumber class]] && ((NSNumber *) key).intValue == 1002)) {
                        [HSGHLoginNetRequest renewTicket:nil];
                        block(nil, NetResServerError, @"出了一点小问题，请稍后再试");
                    }
                    else if (([key isKindOfClass:[NSString class]] && [key isEqualToString:@"1005"]) ||     //Ticket Timeout must relogin
                             ([key isKindOfClass:[NSNumber class]] && ((NSNumber *) key).intValue == 1005)) {
                        if ([[HSGHUserInf shareManager]logined]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                Toast *toast = [[Toast alloc] initWithText:@"账户授权失效，请重新登入!" delay:0 duration:1.f];
                                [toast show];
                                [[AppDelegate instanceApplication] enterLogin];
                                [HSGHUserInf emptyUserDefault];
                            });
                        }
                        block(nil, NetResServerError, @"Ticket 失效，请重新登入");
                    }
                    else {
                        block(nil, NetResServerError, retDic[@"message"]);
                    }
                } else {
                    block(nil, NetResServerError, @"");
                }
            } else {
                block(nil, NetResServerError, @"");
            }
        }     failure:^(NSURLSessionDataTask *task, id responseObject) {
            if (block) {
                block(nil, NetResFailed, @"");
            }
        }];
    } else if ([method isEqualToString:@"Get"]) {
        [manager GET:url parameters:paramsMulDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            id obj = [returnClass yy_modelWithDictionary:(NSDictionary *) responseObject];
            block(obj, NetResSuccess, obj);
        }    failure:^(NSURLSessionDataTask *task, id responseObject) {
            if (block) {
                block(nil, NetResFailed, @"");
            }
        }];
    }
}

+ (void)postReq:(NSString *)url appendParams:(NSDictionary *)paramsDic returnClass:(Class)returnClass block:(NetResponseBlock)block {
    [self requst:url method:@"Post" appendParams:paramsDic returnClass:returnClass block:^(id obj, NetResStatus status, NSString *errorDes) {
        if (block) {
            block(obj, status, errorDes);
        }
    }];
}

+ (void)getReq:(NSString *)url appendParams:(NSDictionary *)paramsDic returnClass:(Class)returnClass block:(NetResponseBlock)block {
    [self requst:url method:@"Get" appendParams:paramsDic returnClass:returnClass block:^(id obj, NetResStatus status, NSString *errorDes) {
        if (block) {
            block(obj, status, errorDes);
        }
    }];
}

@end
