//
//  DWSRecordManager.h
//  DWSRecordScreen
//
//  Created by 戴旺胜 on 2017/6/29.
//  Copyright © 2017年 dws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>


@interface DWSRecordManager : NSObject <RPScreenRecorderDelegate,RPPreviewViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,getter=isRecording) BOOL recording;
@property (nonatomic,strong) RPScreenRecorder *recorder;

@property (nonatomic,strong) UIViewController *vc;

/**
 单例，用这个对象来执行之后的操作

 @return 单例对象
 */
+ (instancetype)shareInstance;

- (void)start;
- (void)stop;
@end
