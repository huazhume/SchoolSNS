//
//  HSGHImageDiamondViewController.h
//  ImageEdit
//
//  Created by hemdenry on 2017/9/12.
//  Copyright © 2017年 huaral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHBaseViewController.h"


@interface HSGHImageDiamondViewController : HSGHBaseViewController

@property void(^nextStepClick)(UIImage *image);
/**
 被裁剪的图片
 */
@property (nonatomic,strong) UIImage *diamondImage;


/**
 用图片初始化
 
 @param diamondImage 图片对象
 @return 初始化对象
 */
- (instancetype)initWithDiamondImage:(UIImage *)diamondImage;

@end
