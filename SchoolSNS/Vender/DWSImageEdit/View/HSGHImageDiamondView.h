//
//  HSGHImageDiamondView.h
//  ImageEdit
//
//  Created by hemdenry on 2017/9/12.
//  Copyright © 2017年 huaral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "DWSImageHandle.h"


#define diamondBackColor RGBCOLOR(239,239,239)
#define maxWidth kScreenWidth
#define footSize (kScreenHeight-53-kFit(500))

@interface HSGHImageDiamondView : UIView

@property (nonatomic,strong) UIImageView *topMoveBtn;
@property (nonatomic,strong) UIImageView *bottomMoveBtn;
@property (nonatomic,strong) UIImageView *leftMoveBtn;
@property (nonatomic,strong) UIImageView *rightMoveBtn;

@end
