//
//  HSGHImageDiamondViewController.m
//  ImageEdit
//
//  Created by hemdenry on 2017/9/12.
//  Copyright © 2017年 huaral. All rights reserved.
//

#import "HSGHImageDiamondViewController.h"
#import "HSGHImageDiamondView.h"
#define inscHeight (kScreenHeight-53-footSize)
#define reduceHeight ((footSize-53)/2)


@interface HSGHImageDiamondViewController ()

/**
 被裁剪的图片所在
 */
@property (nonatomic,strong) UIImageView *diamondImageView;

/**
 顶部黑条
 */
@property (nonatomic,strong) UIView *topBackView;

/**
 底部黑条
 */
@property (nonatomic,strong) UIView *bottomBackView;

/**
 左边黑条
 */
@property (nonatomic,strong) UIView *leftBackView;

/**
 右边黑条
 */
@property (nonatomic,strong) UIView *rightBackView;

/**
 裁剪框
 */
@property (nonatomic,strong) HSGHImageDiamondView *diamondView;

/**
 最底部页面
 */
@property (nonatomic,strong) UIView *footView;

/**
 全尺寸按钮
 */
@property (nonatomic,strong) UIButton *allSizeBtn;

/**
 裁剪按钮
 */
@property (nonatomic,strong) UIButton *diamondBtn;

///**
// 红色星星
// */
//@property (nonatomic,strong) UILabel *leftStar;
//
///**
// 红色星星
// */
//@property (nonatomic,strong) UILabel *rightStar;

/**
 复位按钮
 */
@property (nonatomic,strong) UIButton *resetBtn;

@end

@implementation HSGHImageDiamondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = diamondBackColor;
    [self diamondImageView];
    [self.view sendSubviewToBack:self.diamondImageView];
    
    self.title = @"图片裁剪";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark 初始化
- (instancetype)initWithDiamondImage:(UIImage *)diamondImage {
    if (self = [super init]) {
        self.diamondImage = diamondImage;
    }
    return self;
}

- (void)setDiamondImage:(UIImage *)diamondImage {
    NSLog(@"归位之前w:%f,h:%f",diamondImage.size.width,diamondImage.size.height);
    _diamondImage = [DWSImageHandle fixOrientation:diamondImage];
    NSLog(@"归位之后w:%f,h:%f",_diamondImage.size.width,_diamondImage.size.height);
    self.allSizeBtn.userInteractionEnabled = YES;
    if (_diamondImage.size.height >= _diamondImage.size.width * 2) {
        self.allSizeBtn.userInteractionEnabled= NO;
   //     [self changeToDiamond];
    }else if (_diamondImage.size.width > _diamondImage.size.height) {
    //    [self changeToAllSize];
    }else{
    //    [self changeToAllSize];
    }
    [self changeToDiamond];
}

#pragma mark 懒加载
- (HSGHImageDiamondView *)diamondView {
    if (!_diamondView) {
        _diamondView = [[HSGHImageDiamondView alloc] init];
        [self.view addSubview:_diamondView];
        _diamondView.frame = CGRectMake((kScreenWidth-maxWidth)/2, (kScreenHeight-maxWidth)/2-reduceHeight, maxWidth, maxWidth);
    }
    return _diamondView;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [UIView new];
        _topBackView.backgroundColor = [UIColor blackColor];
        _topBackView.alpha = 0.7;
        [self.view addSubview:_topBackView];
        [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.diamondView.mas_top);
            make.top.equalTo(self.view);
        }];
    }
    return _topBackView;
}

- (UIView *)bottomBackView {
    if (!_bottomBackView) {
        _bottomBackView = [UIView new];
        _bottomBackView.backgroundColor = _topBackView.backgroundColor;
        _bottomBackView.alpha = _topBackView.alpha;
        [self.view addSubview:_bottomBackView];
        [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.footView.mas_top);
            make.top.equalTo(self.diamondView.mas_bottom);
        }];
    }
    return _bottomBackView;
}

- (UIView *)leftBackView {
    if (!_leftBackView) {
        _leftBackView = [UIView new];
        _leftBackView.backgroundColor = _topBackView.backgroundColor;
        _leftBackView.alpha = _topBackView.alpha;
        [self.view addSubview:_leftBackView];
        [_leftBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.diamondView);
            make.top.equalTo(self.diamondView);
            make.left.equalTo(self.view);
            make.right.equalTo(self.diamondView.mas_left);
        }];
    }
    return _leftBackView;
}

- (UIView *)rightBackView {
    if (!_rightBackView) {
        _rightBackView = [UIView new];
        _rightBackView.backgroundColor = _topBackView.backgroundColor;
        _rightBackView.alpha = _topBackView.alpha;
        [self.view addSubview:_rightBackView];
        [_rightBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.diamondView);
            make.top.equalTo(self.diamondView);
            make.right.equalTo(self.view);
            make.left.equalTo(self.diamondView.mas_right);
        }];
    }
    return _rightBackView;
}

- (UIImageView *)diamondImageView {
    if (!_diamondImageView) {
        _diamondImageView = [[UIImageView alloc] initWithImage:self.diamondImage];
        [self.view addSubview:_diamondImageView];
        _diamondImageView.userInteractionEnabled = YES;
        _diamondImageView.multipleTouchEnabled = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
        [self.view addGestureRecognizer:pan];
        
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
        [self.view addGestureRecognizer:pinch];
        
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationImage:)];
        [self.view addGestureRecognizer:rotation];
        
        [self.view sendSubviewToBack:_diamondImageView];
        
    }
    return _diamondImageView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [UIView new];
        _footView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_footView];
        [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(footSize);
        }];
        [self.resetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

- (UIButton *)allSizeBtn {
    if (!_allSizeBtn) {
        _allSizeBtn = [UIButton new];
        [self.footView addSubview:_allSizeBtn];
        [_allSizeBtn addTarget:self action:@selector(changeToAllSize) forControlEvents:UIControlEventTouchUpInside];
        [_allSizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.footView);
            make.height.mas_equalTo(kFit(50));
            make.centerX.equalTo(self.footView).offset(-kScreenWidth/6);
       //     make.width.mas_equalTo([DWSImageHandle getSTRWidth:@"全尺寸" andSize:17]);
        }];
     //   [_allSizeBtn setTitle:@"*全尺寸" forState:UIControlStateSelected];
        [_allSizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_allSizeBtn setTitle:@"全尺寸" forState:UIControlStateNormal];
        [_allSizeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _allSizeBtn;
}

- (UIButton *)diamondBtn {
    if (!_diamondBtn) {
        _diamondBtn = [UIButton new];
        [self.footView addSubview:_diamondBtn];
        [_diamondBtn addTarget:self action:@selector(changeToDiamond) forControlEvents:UIControlEventTouchUpInside];
        [_diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.footView);
            make.height.equalTo(self.allSizeBtn);
            make.centerX.equalTo(self.footView).offset(kScreenWidth/6);
    //        make.width.mas_equalTo([DWSImageHandle getSTRWidth:@"裁剪" andSize:17]);
        }];
        
     //   [_diamondBtn setTitle:@"*裁剪" forState:UIControlStateSelected];
        [_diamondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_diamondBtn setTitle:@"裁剪" forState:UIControlStateNormal];
        [_diamondBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _diamondBtn;
}

//- (UILabel *)leftStar {
//    if (!_leftStar) {
//        _leftStar = [[UILabel alloc] init];
//        _leftStar.text = @"*";
//        _leftStar.textColor = [UIColor redColor];
//        _leftStar.textAlignment = NSTextAlignmentRight;
//        [self.footView addSubview:_leftStar];
//        [_leftStar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.footView);
//            make.height.equalTo(self.allSizeBtn);
//            make.width.mas_equalTo(10);
//            make.right.equalTo(self.allSizeBtn.mas_left);
//        }];
//    }
//    return _leftStar;
//}
//
//- (UILabel *)rightStar {
//    if (!_rightStar) {
//        _rightStar = [[UILabel alloc] init];
//        _rightStar.text = @"*";
//        _rightStar.textColor = [UIColor redColor];
//        _rightStar.textAlignment = NSTextAlignmentRight;
//        [self.footView addSubview:_rightStar];
//        [_rightStar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.footView);
//            make.height.equalTo(self.allSizeBtn);
//            make.width.mas_equalTo(10);
//            make.right.equalTo(self.diamondBtn.mas_left);
//        }];
//    }
//    return _rightStar;
//}

- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [UIButton new];
        [self.footView addSubview:_resetBtn];
        [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.footView);
            make.right.equalTo(self.footView).offset(-kFit(30));
        }];
        [_resetBtn setImage:[UIImage imageNamed:@"resetImage"] forState:UIControlStateNormal];
    }
    return _resetBtn;
}

#pragma mark 加载子控件  全尺寸和裁剪切换
- (void)changeToDiamond {
    self.diamondView.hidden = NO;
    self.topBackView.hidden = NO;
    self.leftBackView.hidden = NO;
    self.rightBackView.hidden = NO;
    self.bottomBackView.hidden = NO;
    
    self.allSizeBtn.selected = NO;
    self.diamondBtn.selected = !self.allSizeBtn.selected;
//    self.leftStar.hidden = self.diamondBtn.selected;
//    self.rightStar.hidden = self.allSizeBtn.selected;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.diamondImageView.transform = CGAffineTransformIdentity;
        CGFloat imwh = self.diamondImage.size.width/self.diamondImage.size.height;
        if (imwh <= 0.5) {
            self.allSizeBtn.hidden = YES;
            [self.diamondBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.footView);
            }];
            self.diamondImageView.frame = CGRectMake(kScreenWidth/2-self.diamondImage.size.width/2, kScreenHeight/2-reduceHeight-self.diamondImage.size.height/2, self.diamondImage.size.width, self.diamondImage.size.height);
            return ;
        }
        CGFloat wh = kScreenWidth/inscHeight;
        if (imwh <= wh) {//竖向对齐
            CGFloat height = 1.0*kScreenWidth*self.diamondImage.size.height/self.diamondImage.size.width;
            self.diamondImageView.frame = CGRectMake(kScreenWidth/2-kScreenWidth/2, kScreenHeight/2-reduceHeight-height/2, kScreenWidth, height);
        } else {//横向对齐
            CGFloat width = 1.0*inscHeight*self.diamondImage.size.width/self.diamondImage.size.height;
            self.diamondImageView.frame = CGRectMake(kScreenWidth/2-width/2, kScreenHeight/2-reduceHeight-inscHeight/2, width, inscHeight);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeToAllSize {
    if (_diamondView) {
        self.diamondView.hidden = YES;
        self.topBackView.hidden = YES;
        self.leftBackView.hidden = YES;
        self.rightBackView.hidden = YES;
        self.bottomBackView.hidden = YES;
    }
    self.allSizeBtn.selected = YES;
    self.diamondBtn.selected = !self.allSizeBtn.selected;
//    self.leftStar.hidden = self.diamondBtn.selected;
//    self.rightStar.hidden = self.allSizeBtn.selected;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.diamondImageView.transform = CGAffineTransformIdentity;
        CGFloat imwh = self.diamondImage.size.width/self.diamondImage.size.height;
        if (imwh <= 0.5) {
            return ;
        }
        self.allSizeBtn.hidden = NO;
        [self.diamondBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.footView).offset(kScreenWidth/6);
        }];
        CGFloat wh = kScreenWidth/inscHeight;
        if (imwh <= wh) {//竖向对齐
            double width = inscHeight*self.diamondImage.size.width/self.diamondImage.size.height;
            self.diamondImageView.frame = CGRectMake(kScreenWidth/2-width/2, kScreenHeight/2-reduceHeight-inscHeight/2, width, inscHeight);
        } else {//横向对齐
            double height = kScreenWidth*self.diamondImage.size.height/self.diamondImage.size.width;
            self.diamondImageView.frame = CGRectMake(kScreenWidth/2-kScreenWidth/2, kScreenHeight/2-reduceHeight-height/2, kScreenWidth, height);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 手势相关
/**
 单指移动图片
 
 @param pan 上下移动
 */
- (void)panImage:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    [pan setTranslation:CGPointMake(0, 0) inView:self.diamondImageView];
    if (self.allSizeBtn.selected) {
        return;
    }
    if (pan.numberOfTouches == 1) {
        point.x = 0;
        
        float zoomScale = [[self.diamondImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        float rotate = [[self.diamondImageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
        
        if (rotate == 0 && self.diamondBtn.selected) {
            if (point.y > 0) {
                if (self.diamondImageView.frame.origin.y + point.y > self.diamondView.frame.origin.y) {
                    point.y = 0;
                }
            }else{
                if (CGRectGetMaxY(self.diamondImageView.frame) + point.y < CGRectGetMaxY(self.diamondView.frame)) {
                    point.y = 0;
                }
            }
        }
    }
    
    
    
//    if (point.x >= 0) {
//        if (self.diamondImageView.frame.origin.x + point.x > self.diamondView.frame.origin.x) {
//            point.x = 0;
//        }
//    }else{
//        if (CGRectGetMaxX(self.diamondImageView.frame) + point.x < CGRectGetMaxX(self.diamondView.frame)) {
//            point.x = 0;
//        }
//    }
//    

    
    self.diamondImageView.center = CGPointMake(self.diamondImageView.center.x + point.x, self.diamondImageView.center.y + point.y);
}


/**
 缩放图片
 
 @param pinch 缩放
 */
- (void)pinchImage:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = pinch.scale;
    pinch.scale = 1;
    if (self.allSizeBtn.selected) {
        return;
    }
//    CGFloat w = self.diamondImageView.frame.size.width * scale;
//    CGFloat h = self.diamondImageView.frame.size.height * scale;
//    
//    CGFloat minx = self.diamondImageView.center.x - w/2;
//    CGFloat maxx = self.diamondImageView.center.x + w/2;
//    CGFloat miny = self.diamondImageView.center.y - h/2;
//    CGFloat maxy = self.diamondImageView.center.y + h/2;
//    
//    if (minx > self.diamondView.frame.origin.x || miny > self.diamondView.frame.origin.y || maxx < self.diamondView.frame.size.width || maxy < self.diamondView.frame.size.height) {
//        return;
//    }
    
    self.diamondImageView.transform = CGAffineTransformScale(self.diamondImageView.transform, scale, scale);
}

/**
 旋转图片
 
 @param rotation 旋转
 */
- (void)rotationImage:(UIRotationGestureRecognizer *)rotation {
    if (self.allSizeBtn.selected) {
        return;
    }
    self.diamondImageView.transform = CGAffineTransformRotate(self.diamondImageView.transform, rotation.rotation);
    [rotation setRotation:0];
}

#pragma mark 取消和下一步
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextStep {
    if (self.diamondBtn.selected) {
        UIImage *finally = [self crop];
        
        _diamondImage = finally;
        if (_diamondImageView) {
            [self.diamondImageView removeFromSuperview];
            self.diamondImageView = nil;
        }
        
        [self diamondImageView];
        [self changeToAllSize];
    }
    if (self.nextStepClick) {
        self.nextStepClick(self.diamondImage);
    }
}

- (void)resetClick {
    if (self.diamondBtn.selected) {
        [self changeToDiamond];
    }else{
        [self changeToAllSize];
    }
}

- (void)removeDiamond {
    [self.diamondView removeFromSuperview];
    [self.leftBackView removeFromSuperview];
    [self.rightBackView removeFromSuperview];
    [self.topBackView removeFromSuperview];
    [self.bottomBackView removeFromSuperview];
    self.diamondView = nil;
    self.leftBackView = nil;
    self.topBackView = nil;
    self.rightBackView = nil;
    self.bottomBackView = nil;
}

- (UIImage *)crop {
    
    CGRect frame = self.diamondView.frame;
    
    float imgScale = self.diamondImage.size.width / self.diamondImageView.frame.size.width;
    
    float rotate = [[self.diamondImageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    UIImage *image = self.diamondImage;
    if (rotate != 0) {
        image = [DWSImageHandle imageRotated:image radians:rotate];
        imgScale = image.size.width / self.diamondImageView.frame.size.width;
    }
    
    CGFloat moveX = self.diamondView.center.x - self.diamondImageView.center.x;
    CGFloat moveY = self.diamondView.center.y - self.diamondImageView.center.y;
    CGFloat centerX = image.size.width/2 + moveX * imgScale;
    CGFloat centerY = image.size.height/2 + moveY * imgScale;
    CGFloat cropW = frame.size.width * imgScale;
    CGFloat cropH = frame.size.height * imgScale;
    CGRect rect = CGRectMake(centerX-cropW/2, centerY-cropH/2, cropW, cropH);
    
    
    CGImageRef tmp = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *result = [UIImage imageWithCGImage:tmp scale:self.diamondImage.scale orientation:self.diamondImage.imageOrientation];
    CGImageRelease(tmp);
    
    return  result;
}


@end
