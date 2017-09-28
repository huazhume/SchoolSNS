//
//  DWSRecordManager.m
//  DWSRecordScreen
//
//  Created by 戴旺胜 on 2017/6/29.
//  Copyright © 2017年 dws. All rights reserved.
//

#import "DWSRecordManager.h"

#import <AudioToolbox/AudioToolbox.h>

//系统版本号
//#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//能否开启录屏功能
#define CanRecord [RPScreenRecorder sharedRecorder].available

@interface DWSRecordManager ()


@property (nonatomic,strong) RPPreviewViewController * previewVC;

@end

@implementation DWSRecordManager {
    BOOL isSave;
    NSInteger time;
    NSTimer *timer;
}

+ (instancetype)shareInstance {
    static DWSRecordManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!obj) {
            obj = [[DWSRecordManager alloc] init];
            obj.recorder.microphoneEnabled = YES;
        }
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            if (self.isRecording) {
                [self.recorder stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *  error){
                    if (!isSave) {
                        self.previewVC = previewViewController;
                    }
                }];
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            if (self.previewVC && isSave == 0) {
                [self.previewVC setPreviewControllerDelegate:self];
                [[self getCurrentVC] presentViewController:self.previewVC animated:YES completion:nil];
            }
        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (RPScreenRecorder *)recorder {
    if (!_recorder) {
        _recorder = [RPScreenRecorder sharedRecorder];
        _recorder.delegate = self;
        //在此可以设置是否允许麦克风（传YES即是使用麦克风，传NO则不是用麦克风）
        _recorder.microphoneEnabled = YES;
       // _recorder.cameraEnabled = YES;
    }
    return _recorder;
}

- (BOOL)isRecording {
    return self.recorder.recording;
}

- (UIViewController *)getCurrentVC {
    if (self.vc) {
        return self.vc;
    }
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *Curvc = (UITabBarController *)vc;
        return  [Curvc.selectedViewController topViewController];
    }
    return vc;
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)message {
    if (!title) {
        title = @"";
    }
    if (!message) {
        message = @"";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *size = [DWSFileManager leftSize];
//        if (![size containsString:@"GB"]) {
//            [self showAlert:nil andMessage:@"您的手机内存不足1G，无法使用此功能"];
//            return ;
//        }
        
        if (CanRecord && IOS9_Later) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            //开起录屏功能
            _previewVC = nil;
            [self.recorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
                
                if (error) {
                    [self showAlert:@"开启失败" andMessage:@"开启录屏失败，请重试"];
                } else {
                    if (_recorder.recording) {
            //            [DWSRecordMovie insertWith:[NSDate date]];
//                        timer = nil;
//                        time = 900;
//                        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
//                        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                    }
                }
            }];
            
//            [self.recorder startRecordingWithHandler:^(NSError * _Nullable error) {
//                _recorder.microphoneEnabled = YES;
//                [hud hide:YES];
//                if (error) {
//                    [self showAlert:@"开启失败" andMessage:@"开启录屏失败，请重试"];
//                } else {
//                    if (_recorder.recording) {
//                        [DWSRecordMovie insertWith:[NSDate date]];
//                        timer = nil;
//                        time = 900;
//                        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
//                        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//                    }
//                }
//            }];
        }else {
            [self showAlert:@"当前设备不支持录制" andMessage:@"升级ios9以上系统并关闭AirPlay"];
            return;
        }
    });
    
}

- (void)stop {
    [self.recorder stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *  error){
  //      [timer invalidate];
        if (error) {
            NSLog(@"这里关闭有误%@",error.description);
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.previewVC = previewViewController;
            [previewViewController setPreviewControllerDelegate:self];
            [[self getCurrentVC] presentViewController:previewViewController animated:YES completion:^(){
                
            }];
        }
    }];
}

- (void)timerClick {
    if (--time <= 0) {
        [self stop];
    }
}

#pragma mark -RPPreviewViewControllerDelegate
//关闭的回调
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    if (isSave == 1) {
        //这个地方我添加了一个延时,我发现这样保存不到系统相册的情况好多了
        [previewController dismissViewControllerAnimated:YES completion:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [previewController dismissViewControllerAnimated:YES completion:nil];
//        });
//        
        isSave = 0;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertAction *queding = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [previewController dismissViewControllerAnimated:YES completion:nil];
                isSave = 0;
                _previewVC = nil;
            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"录制未保存\n确定要取消吗" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:actionCancel];
            [alert addAction:queding];
            [previewController presentViewController:alert animated:NO completion:nil];
        });
    }
}
//选择了某些功能的回调（如分享和保存）
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        isSave = 1;
        _previewVC = nil;
        return;
    }else if ([activityTypes containsObject:@"com.apple.UIKit.activity.Cancel"]) {
        NSLog(@"com.apple.UIKit.activity.Cancel");
    }
//    if ([activityTypes containsObject:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf showAlert:@"复制成功" andMessage:@"已经复制到粘贴板"];
//        });
//    }
}

#pragma mark ====RPScreenDelegate===
- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder {
    //    [screenRecorder addObserver:self forKeyPath:@"recording" options:NSKeyValueObservingOptionNew context:nil];
    //    [screenRecorder setValue:@"1" forKey:@"recording"];
    NSLog(@" delegate ======%@",screenRecorder);
    // screenRecorder.saveVideoToCameraRollCompletionBlock
}

- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController {
    if (previewViewController) {
        _previewVC = previewViewController;
        [previewViewController setPreviewControllerDelegate:self];
        [[self getCurrentVC] presentViewController:previewViewController animated:YES completion:nil];
    }
}




@end
