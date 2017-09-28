//
//  DWSImageHandle.h
//  DWSImageHandle
//
//  Created by DaiWangsheng on 16/11/9.
//  Copyright © 2016年 DaiWangsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FONT(a)  [UIFont systemFontOfSize:a ]


@interface DWSImageHandle : NSObject
//+ (BOOL)isMovie:(NSURL *)url;

+ (NSString *)dateToString:(NSDate *)date;
+ (NSDate *)stringToDate:(NSString *)str;
+ (NSString *)iphoneType;

+ (NSString *)transformToPinyin:(NSString *)aString;

//+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
+ (NSArray *)arraySortUp:(NSArray *)array;
+ (NSArray *)arraySortDown:(NSArray *)array;

+ (UIViewController *)getCurrentVC;
+ (NSString *)changePhoneNumWithStar:(NSString *)num;
+ (CGSize)getSTRWidth:(NSString *)str andSize:(int) s;

//指定宽度按比例缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//将图片写入相册
+ (void)writeImageToAlbum:(UIImage *)image;

//普通截屏
+ (UIImage *)screenToUiImageLowForNormal;       //低清，正常状态下的截屏
+ (UIImage *)screenToUIImageHighForNormal;      //高清，正常状态下的截屏
+ (UIImage *)screenToUiImageLowForAnimation;    //低清，动画状态下的截屏
+ (UIImage *)screenToUiImageHighForAnimation;   //高清，动画状态下的截屏

//OpenGL截屏
+ (UIImage *)screenToUiImageByOpenGLForLow;     //低清，OpenGL截屏
+ (UIImage *)screenToUiImageByOpenGLForHigh;    //高清，OpenGL截屏

//自定义截图
//图片归位，不管是横平竖直全部归位竖直
+ (UIImage *)fixOrientation:(UIImage *)aImage;
//圆形裁剪
+ (UIImage *)circleToUiImage:(UIImageView *)oldImage centerPoint:(CGPoint)point andRadiu:(CGFloat)radiu;
//矩形裁剪
+ (UIImage *)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect;
//三角形裁剪
+ (UIImage *)triangleImage:(UIImageView *)oldImage point1:(CGPoint)point1 andPoint2:(CGPoint)point2 andPoint3:(CGPoint)point3;
//旋转图片
+ (UIImage *)imageRotated:(UIImage *)image radians:(CGFloat)radians;
@end
