

#import "HSGHAdLaunchImageView.h"

@interface HSGHAdLaunchImageView ()
@property (nonatomic, weak) UIImageView *adImageView;
@property (nonatomic, weak) UIButton *judgeBtn;
@end

@implementation HSGHAdLaunchImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addAdImageView];
        
        [self addSingleTapGesture];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        
        [self addAdImageView];
        
        [self addSingleTapGesture];
    }
    return self;
}

- (void)addAdImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _adImageView = imageView;
    
    UIButton * judgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [judgeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [judgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    judgeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    judgeBtn.frame = CGRectMake(375 - 60, 20, 40, 20);
    //[judgeBtn addTarget:self action:@selector(judgeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    judgeBtn.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:0.5];
    [self addSubview:judgeBtn];
    _judgeBtn = judgeBtn;
    
}

- (void)addSingleTapGesture {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:singleTap];
}

#pragma maek - setter

- (void)setImageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程更新
            _adImageView.alpha = 0.0;
            _judgeBtn.alpha = 0.0;
            _adImageView.image = [UIImage imageNamed:imageName];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _adImageView.alpha = 1.0;
                _judgeBtn.alpha = 1.0;
            } completion:nil];
        });
    });
    
}


#pragma mark - action

- (void)singleTapGesture:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (CGRectContainsPoint(_judgeBtn.frame, point)) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden == NO && _adImageView.alpha > 0 && CGRectContainsPoint(_adImageView.frame, point)) {
        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _adImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*0.78);
    _adImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
