//
//  UIScrollView+Category.m
//  BFSports
//
//  Created by wayne on 16/7/5.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import "UIScrollView+Category.h"
#import <objc/runtime.h>

@implementation UIScrollView (Category)

- (void)placeholderImage:(UIImage *)image title:(NSString *)title
{
    [self placeholderImage:image title:title offsetY:0];
}
- (void)placeholderImage:(UIImage *)image title:(NSString *)title offsetY:(CGFloat)offsetY
{
    if (!self.didSetup)
    {
        self.didSetup = YES;
        self.placeholderView = [[UITableViewPlaceholderView alloc] initWithImage:image title:title offsetY:offsetY];
        [self addSubview:self.placeholderView];
    } else {
        self.placeholderView.placeholderImageView.image = image;
        self.placeholderView.placeholderLabel.text = title;
    }
    
    self.placeholderView.frame = self.bounds;
}
- (void)removePlaceholder
{
    self.didSetup = NO;
    [self.placeholderView removeFromSuperview];
}
- (void)setDidSetup:(BOOL)didSetup
{
    objc_setAssociatedObject(self, @"didSetup", @(didSetup), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)didSetup
{
    return [objc_getAssociatedObject(self, @"didSetup") boolValue];
}

// placeholder view
- (void)setPlaceholderView:(UITableViewPlaceholderView *)placeholderView
{
    objc_setAssociatedObject(self, @"placeholderView", placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewPlaceholderView *)placeholderView
{
    return objc_getAssociatedObject(self, @"placeholderView");
}
@end

@implementation UITableViewPlaceholderView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title offsetY:(CGFloat)offsetY
{
    self = [super init];
    if (self) {
        self.placeholderImageView = [[UIImageView alloc] initWithImage:image];
        self.placeholderLabel     = [UILabel new];
        self.placeholderLabel.textColor = RGBCOLOR(150, 150, 150);
        self.placeholderLabel.font = [UIFont systemFontOfSize:15];
        self.placeholderLabel.text = title;
        self.offsetY = offsetY;
        [self addSubview:_placeholderImageView];
        [self addSubview:_placeholderLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maxHeight = 0;
    if (_placeholderImageView.image) {
        maxHeight += _placeholderImageView.image.size.height;
    }
    
    CGSize textSize = CGSizeZero;
    if (_placeholderLabel.text.length) {
        NSString *text = _placeholderLabel.text;
        textSize = [text sizeWithAttributes:@{NSFontAttributeName:_placeholderLabel.font}];
        maxHeight += textSize.height;
    }
    
    CGFloat offset = 0;
    if (_placeholderImageView.image && _placeholderLabel.text.length) {
        offset = 15;
    }
    maxHeight += offset;
    
    _placeholderImageView.frame = CGRectMake((CGRectGetMaxX(self.frame)-_placeholderImageView.image.size.width)/2,
                                             (CGRectGetMaxY(self.frame)-maxHeight)/2 + _offsetY,
                                             _placeholderImageView.image.size.width,
                                             _placeholderImageView.image.size.height);
    _placeholderLabel.frame = CGRectMake(0,
                                         CGRectGetMaxY(_placeholderImageView.frame) + offset,
                                         textSize.width,
                                         textSize.height);
    CGPoint center = _placeholderLabel.center;
    center.x = self.center.x;
    _placeholderLabel.center = center;
}
@end
