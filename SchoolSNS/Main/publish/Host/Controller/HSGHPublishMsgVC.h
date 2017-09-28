//
//  HSGHPublishMsgVC.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeBaseViewController.h"
#import "SchoolSNS-Swift.h"
#import "HSGHFirstHeaderView.h"
#import "HSGHFirstContentView.h"
#import "YYTextView.h"

@interface HSGHPublishMsgVC : HSGHHomeBaseViewController

//数据源
@property (strong, nonatomic)  YYTextView *textView;

@property (strong, nonatomic) NSNumber  * publishType;
@property (strong, nonatomic) UIImage * image;
@property (assign, nonatomic) BOOL  isLauncher;

@property (copy, nonatomic) NSString *localVideoPath;


@property (weak, nonatomic) IBOutlet HSGHFirstHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anonymSign;

// 自动发送一个东西
+ (void)sendSomethingNewWithImageData:(UIImage *)image WithImageKey:(NSString *)imageKey WithText:(NSString *)text;

@end
