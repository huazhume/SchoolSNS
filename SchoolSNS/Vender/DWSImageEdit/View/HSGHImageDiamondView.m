//
//  HSGHImageDiamondView.m
//  ImageEdit
//
//  Created by hemdenry on 2017/9/12.
//  Copyright © 2017年 huaral. All rights reserved.
//

#import "HSGHImageDiamondView.h"

@implementation HSGHImageDiamondView

- (void)topClick:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.topMoveBtn];
    [pan setTranslation:CGPointMake(0, 0) inView:self.topMoveBtn];
    if (self.frame.size.height >= maxWidth && point.y <= 0) {
        //超过最大值
        return;
    } else if (self.frame.origin.y <= 53 && point.y <= 0) {
        //超过滑动顶部
        return;
    } else if (self.frame.size.height <= self.topMoveBtn.width && point.y >= 0) {
        //小于最小值
        return;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + point.y, self.frame.size.width, self.frame.size.height - point.y);
}

- (void)bottomClick:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.bottomMoveBtn];
    [pan setTranslation:CGPointMake(0, 0) inView:self.bottomMoveBtn];
    if (self.frame.size.height >= maxWidth && point.y >= 0) {
        //滑动超过最大值
        return;
    } else if (self.frame.origin.y + self.frame.size.height >= kScreenHeight-footSize && point.y >= 0) {
        //滑动超过底部
        return;
    } else if (self.frame.size.height <= self.topMoveBtn.width && point.y <= 0) {
        //小于最小值
        return;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + point.y);
}

- (void)leftClick:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.leftMoveBtn];
    [pan setTranslation:CGPointMake(0, 0) inView:self.leftMoveBtn];
    if (self.x + point.x <= 0) {
        return;
    }else if (self.x + point.x >= HSGH_SCREEN_WIDTH - self.topMoveBtn.width){
        return;
    }
    self.frame = CGRectMake(self.x + point.x, self.y, self.width - point.x, self.height);
}

- (void)rightClick:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.rightMoveBtn];
    [pan setTranslation:CGPointMake(0, 0) inView:self.rightMoveBtn];
    if (CGRectGetMaxX(self.frame) + point.x <= self.topMoveBtn.width) {
        return;
    }else if (CGRectGetMaxX(self.frame) + point.x >= HSGH_SCREEN_WIDTH){
        return;
    }
    self.frame = CGRectMake(self.x, self.y, self.width + point.x, self.height);
}

#pragma mark 初始化
- (void)setInit {
    self.backgroundColor = [UIColor clearColor];
    
    [self creatTop];
    [self creatBottom];
//    [self creatLeft];
//    [self createRight];
}

- (void)creatTop {
    self.topMoveBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamondTop"]];
    [self addSubview:self.topMoveBtn];
    [self.topMoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    self.topMoveBtn.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topClick:)];
    [self.topMoveBtn addGestureRecognizer:pan];
}

- (void)creatBottom {
    self.bottomMoveBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamondBottom"]];
    [self addSubview:self.bottomMoveBtn];
    [self.bottomMoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self.topMoveBtn);
        make.height.equalTo(self.topMoveBtn);
    }];
    self.bottomMoveBtn.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bottomClick:)];
    [self.bottomMoveBtn addGestureRecognizer:pan];
}

- (void)creatLeft {
    self.leftMoveBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamondLeft"]];
    [self addSubview:self.leftMoveBtn];
    [self.leftMoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self.topMoveBtn.mas_height);
        make.height.equalTo(self.topMoveBtn.mas_width);
    }];
    self.leftMoveBtn.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftClick:)];
    [self.leftMoveBtn addGestureRecognizer:pan];
}

- (void)createRight {
    self.rightMoveBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamondRight"]];
    [self addSubview:self.rightMoveBtn];
    [self.rightMoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(self.topMoveBtn.mas_height);
        make.height.equalTo(self.topMoveBtn.mas_width);
    }];
    self.rightMoveBtn.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick:)];
    [self.rightMoveBtn addGestureRecognizer:pan];
}

#pragma mark 重载的系统方法
- (instancetype)init {
    if (self = [super init]) {
        [self setInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    
    //第一列
    CGContextMoveToPoint(currentContext, width/3, 0);
    CGContextAddLineToPoint(currentContext, width/3, height);
    //第二列
    CGContextMoveToPoint(currentContext, width/3*2, 0);
    CGContextAddLineToPoint(currentContext, width/3*2, height);
    //第一排
    CGContextMoveToPoint(currentContext, 0, height/3);
    CGContextAddLineToPoint(currentContext, width, height/3);
    //第二排
    CGContextMoveToPoint(currentContext, 0, height/3*2);
    CGContextAddLineToPoint(currentContext, width, height/3*2);
    
    
    //    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    //    CGFloat arr[] = {3,1};
    //    //下面最后一个参数“2”代表排列的个数。
    //    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}


@end
