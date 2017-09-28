//
//  UIImage+BFSExt.h
//  BFLive
//
//  Created by BaoFeng on 15/7/16.
//  Copyright (c) 2015年 BF. All rights reserved.
//

//根据color获得纯色image
@interface UIImage (UIColor)


/**
 *  @param color          颜色值
 *  @param rect           图片大小
 *  @return UIImage       纯色图片size{1,1}
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;




@end

//对当前控件进行截图
@interface UIView (Snapshot)

- (UIImage *)snapshot;

@end



//压缩图片
@interface UIImage (ScaledToSize)

- (UIImage *)scaledToSize:(CGSize)newSize;

@end



//根据url获得image
@interface UIImage (UrlString)

+ (UIImage *)imageWithUrl:(NSString *)url;
- (UIImage *)cropToSquare;
@end
