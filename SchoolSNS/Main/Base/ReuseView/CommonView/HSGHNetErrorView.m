//
//  BFSWvErrorView.m
//  BFSports
//
//  Created by baofeng on 16/3/23.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import "HSGHNetErrorView.h"
#define kIconOriginY   ((202-HSLNavBarHeight) * (HSLFullScreenHeight/667))
#define kIconSizeWidth   83
#define kIconSizeHeight  83

@interface HSGHNetErrorView()

@property(nonatomic,strong)  UIImageView  *imageView;
@property(nonatomic,strong)  UILabel      *titleLabel;
@property(nonatomic,strong)  UILabel      *contentLabel;
@property(nonatomic,strong)  UIButton     *button;

@end

@implementation HSGHNetErrorView


- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content fraem:(CGRect)fraem delegate:(id<HSGHNetErrorViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBCOLOR(240, 240, 240);
        self.frame =fraem;
        //CGRectMake(0, BFLNavBarHeight, BFLFullScreenWidth, BFLFullScreenHeight - BFLNavBarHeight);
       
        _delegate = delegate;
        _title = title;
        _content = content;

        [self addSubview:self.imageView];
        
        [self addSubview:self.titleLabel];

        [self addSubview:self.contentLabel];

        [self addSubview:self.button];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = content;
}

-(UIImageView *)imageView
{
   if(!_imageView)
   {
       _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_no_net"]];
       _imageView.frame = CGRectMake((self.width - kIconSizeWidth)/2, kIconOriginY, kIconSizeWidth, kIconSizeHeight);
   }
    return  _imageView;
}
-(UILabel *)titleLabel
{
   if(!_titleLabel)
   {
       _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)+30, self.width, 15)];
       _titleLabel.backgroundColor = [UIColor clearColor];
       _titleLabel.textColor = RGBCOLOR(40, 40, 04);
       _titleLabel.numberOfLines = 1;
       _titleLabel.font = HSLFontSize(15.0f);
       _titleLabel.text = self.title;
       _titleLabel.textAlignment = NSTextAlignmentCenter;

   }
    return  _titleLabel;
}

-(UILabel *)contentLabel
{
   if(!_contentLabel)
   {
       _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+8, self.width, 15)];
       _contentLabel.backgroundColor = [UIColor clearColor];
       _contentLabel.textColor = RGBCOLOR(40, 40, 04);
       _contentLabel.numberOfLines = 1;
       _contentLabel.font = HSLFontSize(15.0f);
       _contentLabel.text = self.content;
       _contentLabel.textAlignment = NSTextAlignmentCenter;
   }
    return  _contentLabel;
}

-(UIButton *)button
{
   if(!_button)
   {
       _button =[UIButton buttonWithType:UIButtonTypeCustom];
       _button.frame = self.bounds;
       _button.backgroundColor = [UIColor clearColor];
       [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

   }
    return _button;
}

-(void)setImageViewisHidden:(BOOL)imageViewisHidden
{
    _imageViewisHidden = imageViewisHidden;
    self.imageView.hidden = imageViewisHidden;
}

- (void)buttonClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(netErrorViewClicked)]) {
        [_delegate netErrorViewClicked];
    }
}
@end
