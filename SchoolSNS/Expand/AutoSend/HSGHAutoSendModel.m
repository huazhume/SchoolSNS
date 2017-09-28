//
//  HSGHDownloadModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/4/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHAutoSendModel.h"
#import "HSGHUserInf.h"
#import "HSGHPublishMsgVC.h"

@interface HSGHAutoSendModel()
@property (nonatomic, copy) NSString* currentSendHeadIconKey;
@property (nonatomic, copy) NSString* currentSendBGImageKey;
@property (nonatomic, copy) NSString* currentSendSignature;
@end


@implementation HSGHAutoSendModel

static HSGHAutoSendModel* model = nil;

+ (instancetype)singleInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [HSGHAutoSendModel new];
        }
    });
    
    return model;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _currentSendHeadIconKey = @"";
        _currentSendBGImageKey = @"";
        _currentSendSignature = @"";

    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)autoSend:(NSNotification*)notification {
    if (![[HSGHUserInf shareManager] logined]) {
        return;
    }
    
    if ([notification.name isEqualToString:HSGHAutoSendHeadIconNotification]) {
        if (![_currentSendHeadIconKey isEqualToString:[HSGHUserInf shareManager].headIconImageKey]){
            NSString* str = @"更新了头像"; //[NSString stringWithFormat:@"%@ 更新了头像", [HSGHUserInf shareManager].nickName];
            [HSGHPublishMsgVC sendSomethingNewWithImageData:[HSGHUserInf shareManager].headIconImage WithImageKey:[HSGHUserInf shareManager].headIconImageKey WithText: str];
            _currentSendHeadIconKey = [HSGHUserInf shareManager].headIconImageKey;
        }
        
    }
    else if ([notification.name isEqualToString:HSGHAutoSendBgImageNotification]) {
        if (![_currentSendBGImageKey isEqualToString:[HSGHUserInf shareManager].headBgImageKey]){
            NSString* str = @"更新了主页背景"; //[NSString stringWithFormat:@"%@ 更新了主页背景", [HSGHUserInf shareManager].nickName];
            [HSGHPublishMsgVC sendSomethingNewWithImageData:[HSGHUserInf shareManager].headBgImage WithImageKey:[HSGHUserInf shareManager].headBgImageKey WithText: str];
            _currentSendBGImageKey = [HSGHUserInf shareManager].headBgImageKey;
        }
        
    }
    else if ([notification.name isEqualToString:HSGHAutoSendSignatureNotification]) {
        if (![_currentSendSignature isEqualToString:[HSGHUserInf shareManager].signature]){
            [HSGHPublishMsgVC sendSomethingNewWithImageData:nil WithImageKey:nil WithText: [HSGHUserInf shareManager].signature];
            _currentSendSignature = [HSGHUserInf shareManager].signature;
        }
    }
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoSend:) name:HSGHAutoSendHeadIconNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoSend:) name:HSGHAutoSendBgImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoSend:) name:HSGHAutoSendSignatureNotification object:nil];
}

- (void)stop {
    model = nil;
}


@end
