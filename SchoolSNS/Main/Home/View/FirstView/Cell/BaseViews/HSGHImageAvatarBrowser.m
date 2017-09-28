//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by lenservice on 16/2/19.
//  Copyright © 2016年 lenservice. All rights reserved.
//

#import "HSGHImageAvatarBrowser.h"

static UIImageView *orginImageView;
@implementation HSGHImageAvatarBrowser : NSObject

+ (void)show:(UIImage *)image andImageView:(UIImageView *)avatarImageView {

  orginImageView.alpha = 0;
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  UIView *backgroundView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                               [UIScreen mainScreen].bounds.size.height)];
  CGRect oldframe =
      [avatarImageView convertRect:avatarImageView.bounds toView:window];

  backgroundView.backgroundColor =
      [[UIColor blackColor] colorWithAlphaComponent:0.7];
  backgroundView.alpha = 1;
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];

  imageView.image = image;
  imageView.tag = 1;
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.clipsToBounds = YES;
  [backgroundView addSubview:imageView];
  [window addSubview:backgroundView];
  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(hideImage:)];
  [backgroundView addGestureRecognizer:tap];

  [UIView animateWithDuration:0.3
                   animations:^{
                     imageView.frame =
                         CGRectMake((HSGH_SCREEN_WIDTH - image.size.width) / 2.0,
                                    (HSGH_SCREEN_HEIGHT - image.size.height) / 2.0,
                                    image.size.width, image.size.width);
                     backgroundView.alpha = 1;
                   }
                   completion:^(BOOL finished){

                   }];
}

+ (void)showImage:(UIImageView *)avatarImageView {
  UIImage *image = avatarImageView.image;
  orginImageView = avatarImageView;
  orginImageView.alpha = 0;
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  UIView *backgroundView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                               [UIScreen mainScreen].bounds.size.height)];
  CGRect oldframe =
      [avatarImageView convertRect:avatarImageView.bounds toView:window];

  backgroundView.backgroundColor =
      [[UIColor blackColor] colorWithAlphaComponent:0.7];
  backgroundView.alpha = 1;
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
  imageView.image = image;
  imageView.tag = 1;
  imageView.contentMode = UIViewContentModeScaleAspectFill;

  // imageView.contentMode = uiv

  imageView.clipsToBounds = YES;
  [backgroundView addSubview:imageView];
  [window addSubview:backgroundView];

  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(hideImage:)];
  [backgroundView addGestureRecognizer:tap];

  [UIView animateWithDuration:0.3
                   animations:^{
                     imageView.frame = CGRectMake(
                         0, ([UIScreen mainScreen].bounds.size.height -
                             image.size.height *
                                 [UIScreen mainScreen].bounds.size.width /
                                 image.size.width) /
                                2,
                         [UIScreen mainScreen].bounds.size.width,
                         image.size.height *
                             [UIScreen mainScreen].bounds.size.width /
                             image.size.width);
                     backgroundView.alpha = 1;
                   }
                   completion:^(BOOL finished){

                   }];
}
+ (void)hideImage:(UITapGestureRecognizer *)tap {
  UIView *backgroundView = tap.view;
  UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
  [UIView animateWithDuration:0.3
      animations:^{
        imageView.frame = [orginImageView
            convertRect:orginImageView.bounds
                 toView:[UIApplication sharedApplication].keyWindow];
      }
      completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        orginImageView.alpha = 1;
        backgroundView.alpha = 0;
      }];
}
@end
