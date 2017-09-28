//
//  HSGHShareImageView.h
//  SchoolSNS
//
//  Created by huaral on 2017/7/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGHShareImageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fistHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdHeight;

@end
