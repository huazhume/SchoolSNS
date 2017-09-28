//
//  UIImage+BFLExt.m
//  BFLive
//
//  Created by BaoFeng on 15/7/16.
//  Copyright (c) 2015年 BF. All rights reserved.
//

#import "UIImage+BFSExt.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

#import <objc/runtime.h>

#pragma mark - 根据color获得纯色image
@implementation UIImage (UIColor)

+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end



#pragma mark - //对当前控件进行截图
@implementation UIView (Snapshot)

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}

@end



#pragma mark - //压缩图片
@implementation UIImage (ScaledToSize)

- (UIImage *)scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

#pragma mark - //根据url获得image
@implementation UIImage (UrlString)

+ (UIImage *)imageWithUrl:(NSString *)url
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}


#pragma mark -- square image
- (UIImage *)cropToSquare{
    //Crop the image to a square
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        UIGraphicsBeginImageContext(CGSizeMake(newDimension, newDimension));
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        [self drawAtPoint:CGPointMake(-widthOffset, -heightOffset)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    return self;
}


@end
