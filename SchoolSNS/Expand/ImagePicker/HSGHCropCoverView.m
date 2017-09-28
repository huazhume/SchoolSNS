//
//  HSGHCropCoverView.m
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHCropCoverView.h"

@interface HSGHCropCoverView()
@property (nonatomic, strong) UIView*      arrowView;
@property (nonatomic, strong) UIImageView* arrowImageView;
@property (nonatomic, strong) UIView*     coverBlackView;
@end

#define CornerSize    5

@implementation HSGHCropCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}



- (void)setupView {
    _arrowView = [UIView new];
    
    _arrowView.frame = CGRectMake((self.width - 60) / 2, 0, 60, CropCoverViewHeight);
    _arrowView.backgroundColor = HEXRGBACOLOR(0x000000, 0.5);
    _arrowView.clipsToBounds = YES;
    
    _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImagePickerDrop"]];
    _arrowImageView.frame = CGRectMake((_arrowView.width - 39) / 2, (_arrowView.height - 14) / 2, 39, 14);
    
    [_arrowView addSubview:_arrowImageView];
    
    [self addSubview:_arrowView];
    
    _coverBlackView = [UIView new];
    _coverBlackView.backgroundColor = HEXRGBACOLOR(0x000000, 0.5);
    _coverBlackView.frame = CGRectMake(0, 0, self.width, 0);
    [self addSubview:_coverBlackView];

    
    if (_showMode == CropShowTop) {
        _arrowView.bottom = self.bottom;
        _coverBlackView.height = self.height - CropCoverViewHeight;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_arrowView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(CornerSize, CornerSize)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _arrowView.bounds;
        maskLayer.path = maskPath.CGPath;
        _arrowView.layer.mask = maskLayer;
    }
    
    if (_showMode == CropShowBottom) {
        _arrowView.top = 0;
        _coverBlackView.top = CropCoverViewHeight;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_arrowView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(CornerSize, CornerSize)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _arrowView.bounds;
        maskLayer.path = maskPath.CGPath;
        _arrowView.layer.mask = maskLayer;
    }
    

    //Darg Ges
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:panGesture];
    
    _normalBottom = self.bottom;
    _normalTop = self.top;
}

- (void)setShowMode:(CorpShowMode)showMode {
    if (_showMode != showMode) {
        _showMode = showMode;
        
        if (_showMode == CropShowTop) {
            _arrowView.bottom = self.bottom;
            _coverBlackView.height = self.height - CropCoverViewHeight;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_arrowView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(CornerSize, CornerSize)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _arrowView.bounds;
            maskLayer.path = maskPath.CGPath;
            _arrowView.layer.mask = maskLayer;
        }
        
        if (_showMode == CropShowBottom) {
            _arrowView.top = 0;
            _coverBlackView.top = CropCoverViewHeight;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_arrowView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(CornerSize, CornerSize)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _arrowView.bounds;
            maskLayer.path = maskPath.CGPath;
            _arrowView.layer.mask = maskLayer;
        }
        
        if (_showMode == CropShowBottom) {
            CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
            _arrowImageView.transform = transform;
        }
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (_endBlock) {
                self.endBlock();
            }
            break;
        }
            
        case UIGestureRecognizerStateBegan: {
            if (_startBlock) {
                self.startBlock();
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGesture locationInView:self.superview];
            HSLog(@"drag y is %@", @(translation.y));
            
            [self changeTopView:translation.y];
            break;
        }
        default:
            break;
    }
}


- (void)changeTopView:(CGFloat)offset {
    if (offset < 0 || offset > self.superview.width) return;
    
    if (_showMode == CropShowTop) {
        if (offset < _normalTop) return;
        
        self.height = offset - _normalTop;
        
        if (self.height < CropCoverViewHeight) {
            self.height = CropCoverViewHeight;
        }
        
        if (self.height > _limitedHeight) {
            self.height = _limitedHeight;
        }
        
        self.top = _normalTop;
    }
    
    if (_showMode == CropShowBottom) {
        if (offset > _normalBottom) return;

        
        self.height = self.superview.width - offset - (self.superview.width - _normalBottom);
        
        if (self.height < CropCoverViewHeight) {
            self.height = CropCoverViewHeight;
        }
        
        if (self.height > _limitedHeight) {
            self.height = _limitedHeight;
        }
        
        self.bottom = _normalBottom;
    }
    [self resizeSubViews];
}

- (void)updateTop: (CGFloat)top {
    _normalTop = top;
    self.height = CropCoverViewHeight;
    self.top = _normalTop;
    [self resizeSubViews];
}

- (void)updateBottom: (CGFloat)bottom {
    _normalBottom = bottom;
    self.height = CropCoverViewHeight;
    self.bottom = _normalBottom;
    [self resizeSubViews];
}


- (void)resizeSubViews {
    if (_showMode == CropShowTop) {
        _arrowView.bottom = self.bottom - _normalTop;
        _coverBlackView.height = self.height - CropCoverViewHeight;
    }
    
    if (_showMode == CropShowBottom) {
        _coverBlackView.height = self.height - CropCoverViewHeight;
    }
}

@end
