//
//  BFLNavigationBarView.m
//  BFLive
//
//  Created by BaoFeng on 15/11/26.
//  Copyright © 2015年 BF. All rights reserved.
//

#import "HSGHNavigationBarView.h"

@interface HSGHNavigationBarView ()
@property (nonatomic, weak) UIButton * leftBtn;

@end
@implementation HSGHNavigationBarView

+ (instancetype)navigationBarWithTarget:(id)target
{
    HSGHNavigationBarView *navBarView = [[HSGHNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, HSLFullScreenWidth, HSLNavBarHeight)  target:target];
    return navBarView;
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        WS(ws);

        self.backgroundColor = HEXRGBCOLOR(0x212c4c);
        
        _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, HSLNavBarHeight-0.5, HSLFullScreenWidth, 0.5)];
        _bottomLine.backgroundColor = RGBCOLOR(220, 220, 220);
//        [self addSubview:_bottomLine];

       
        CGFloat maxTitleWidth = HSLFullScreenWidth * 5 / 7;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(HSLFullScreenWidth/7, HSLStatusBarHeight, maxTitleWidth, HSLNavBarHeight - HSLStatusBarHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = HSLFontSize(16.0f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"";
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:maxTitleWidth]);
            make.height.mas_equalTo(HSLNavBarHeight - HSLStatusBarHeight);
            make.bottom.equalTo(ws.mas_bottom);
            make.centerX.equalTo(ws);
        }];
        
        self.target = target;
        
    }
    return self;
}

- (void)setNavTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setNavTitle:(NSString *)title backAction:(SEL)action
{
    _titleLabel.text = title;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (action == nil) {
        action = @selector(backButtonClicked);
    }
    //给button增加点击区域，图标居中显示
    backButton.frame = CGRectMake(15-15, 33-12, 11+30, 19+24);
    [[backButton imageView] setContentMode:UIViewContentModeCenter];
    [backButton setImage:[UIImage imageNamed:@"icon_back_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_press"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
}

- (UIButton *)setItemTitle:(NSString *)title action:(SEL)action isLeft:(BOOL)isLeft
{
    WS(ws);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = HSLFontSize(15.0f);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:HEXRGBCOLOR(0xbcbcbc) forState:UIControlStateDisabled];

    [button setTitle:title forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self.target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    if(isLeft){
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_titleLabel);
            make.right.lessThanOrEqualTo(_titleLabel.mas_left).with.offset(-10);
            make.top.equalTo(_titleLabel.mas_top);
            make.left.equalTo(ws.mas_left).with.offset(15);
        }];
    }else{
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_titleLabel);
            make.left.greaterThanOrEqualTo(_titleLabel.mas_right).with.offset(10);
            make.top.equalTo(_titleLabel.mas_top);
            make.right.equalTo(ws.mas_right).with.offset(-15);
        }];
    }
    
    self.leftBtn = button;
    return button;
}

- (void)setItemImage:(UIImage *)image
             selectImage:(UIImage *)selectImage
                  action:(SEL)action
                  isLeft:(BOOL)isLeft
{
    
    WS(ws);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateHighlighted];
    [button addTarget:self.target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    if (isLeft) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_titleLabel);
            make.right.lessThanOrEqualTo(_titleLabel.mas_left).with.offset(-10);
            make.top.equalTo(_titleLabel.mas_top);
            make.left.equalTo(ws.mas_left).with.offset(15);
        }];
    }else{
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(41);
            make.height.equalTo(_titleLabel);
            make.left.greaterThanOrEqualTo(_titleLabel.mas_right).with.offset(10);
            make.top.equalTo(_titleLabel.mas_top);
            make.right.equalTo(ws.mas_right).with.offset(-10);
        }];
    }
}

-(void)setLeftTitleColor:(UIColor *)color
{
    [self.leftBtn setTitleColor:color forState:UIControlStateNormal];
    
}
@end
