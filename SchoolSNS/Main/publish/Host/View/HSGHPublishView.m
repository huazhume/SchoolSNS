//
//  HSGHPublishView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHPublishView.h"

@interface HSGHPublishView ()

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *left;

@end

@implementation HSGHPublishView

- (void)awakeFromNib {
  [super awakeFromNib];
#ifdef OPEN_VIDEO
    self.left.constant = (HSGH_SCREEN_WIDTH - 56 * 3) / 4;
    self.right.constant = self.left.constant;
#else
    self.videoTextLab.hidden = true;
    self.videoBtn.hidden = true;
  self.left.constant = HSGH_SCREEN_WIDTH * 2/ 9;
  self.right.constant = HSGH_SCREEN_WIDTH * 2 / 9;
#endif
  [self layoutIfNeeded];
  [self photoBtnAnimation];
  [self textBtnAnimation];
  [self videoBtnAnimation];
  [self textLabAnimation];
  [self photoLabAnimation];
    [self videoLabAnimation];
  [self closeBtnAnimation];

  UIBlurEffect *beffect =
      [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
  UIVisualEffectView *viewa =
      [[UIVisualEffectView alloc] initWithEffect:beffect];
  viewa.frame = CGRectMake(0, 0, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT);
  [self.bgView addSubview:viewa];
  self.bgView.backgroundColor = [UIColor clearColor];
}

- (void)photoBtnAnimation {
  CGRect frame = self.photoBtn.frame;
  frame.origin.y = HSGH_SCREEN_HEIGHT;
  self.photoBtn.frame = frame;
  [UIView animateWithDuration:0.2 // 动画时长
                        delay:0.0 // 动画延迟
       usingSpringWithDamping:0.6 // 类似弹簧振动效果 0~1
        initialSpringVelocity:0.0 // 初始速度
                      options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                   animations:^{
                     CGRect frame = self.photoBtn.frame;
                     frame.origin.y = HSGH_SCREEN_HEIGHT - 180;
                     self.photoBtn.frame = frame;
                     [self layoutIfNeeded];

                   }
                   completion:^(BOOL finished){
    }];
}





- (void)photoLabAnimation {
  CGRect frame = self.photoLab.frame;
  frame.origin.y = HSGH_SCREEN_HEIGHT;
  self.photoLab.frame = frame;
  [UIView animateWithDuration:0.2 // 动画时长
                        delay:0.0 // 动画延迟
       usingSpringWithDamping:0.6 // 类似弹簧振动效果 0~1
        initialSpringVelocity:0.0 // 初始速度
                      options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                   animations:^{
                     CGRect frame = self.photoLab.frame;
                     frame.origin.y = HSGH_SCREEN_HEIGHT - 146;
                     self.photoLab.frame = frame;
                     [self layoutIfNeeded];

                   }
                   completion:^(BOOL finished){

                   }];
}

- (void)textBtnAnimation {
  CGRect frame = self.textBtn.frame;
  frame.origin.y = HSGH_SCREEN_HEIGHT;
  self.textBtn.frame = frame;
  [UIView animateWithDuration:0.2 // 动画时长
                        delay:0.1 // 动画延迟
       usingSpringWithDamping:0.6 // 类似弹簧振动效果 0~1
        initialSpringVelocity:0.0 // 初始速度
                      options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                   animations:^{
                     CGRect frame = self.textBtn.frame;
                     frame.origin.y = HSGH_SCREEN_HEIGHT - 180;
                     self.textBtn.frame = frame;
                     [self layoutIfNeeded];

                   }
                   completion:^(BOOL finished){

                   }];
}

- (void)textLabAnimation {
  CGRect frame = self.textLab.frame;
  frame.origin.y = HSGH_SCREEN_HEIGHT;
  self.textLab.frame = frame;
  [UIView animateWithDuration:0.2 // 动画时长
                        delay:0.1 // 动画延迟
       usingSpringWithDamping:0.6 // 类似弹簧振动效果 0~1
        initialSpringVelocity:0.0 // 初始速度
                      options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                   animations:^{
                     CGRect frame = self.textBtn.frame;
                     frame.origin.y = HSGH_SCREEN_HEIGHT - 146;
                     self.textLab.frame = frame;
                     [self layoutIfNeeded];

                   }
                   completion:^(BOOL finished){

                   }];
}

- (void)videoBtnAnimation {
    CGRect frame = self.videoBtn.frame;
    frame.origin.y = HSGH_SCREEN_HEIGHT;
    self.videoBtn.frame = frame;
    [UIView animateWithDuration:0.2 // 动画时长
                          delay:0.1 // 动画延迟
         usingSpringWithDamping:0.6 // 类似弹簧振动效果 0~1
          initialSpringVelocity:0.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         CGRect frame = self.videoBtn.frame;
                         frame.origin.y = HSGH_SCREEN_HEIGHT - 180;
                         self.videoBtn.frame = frame;
                         [self layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)videoLabAnimation {
    CGRect frame = self.videoTextLab.frame;
    frame.origin.y = HSGH_SCREEN_HEIGHT;
    self.videoTextLab.frame = frame;
    [UIView animateWithDuration:0.2 // 动画时长
                          delay:0.1 // 动画延迟
         usingSpringWithDamping:0.6 // 类似弹簧振动效果 0~1
          initialSpringVelocity:0.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         CGRect frame = self.videoTextLab.frame;
                         frame.origin.y = HSGH_SCREEN_HEIGHT - 146;
                         self.videoTextLab.frame = frame;
                         [self layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


- (void)closeBtnAnimation {
  self.closeBtn.transform =
      CGAffineTransformRotate(self.closeBtn.transform, M_PI / 4);
  self.closeBtn.alpha = 0;
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.closeBtn.transform = CGAffineTransformRotate(
                         self.closeBtn.transform, -M_PI / 4);
                     self.closeBtn.alpha = 1;
                   }];
}

- (void)closeViewsAnimation {

  [UIView animateWithDuration:0.2              // 动画时长
      delay:0.0                                // 动画延迟
      usingSpringWithDamping:1                  // 类似弹簧振动效果 0~1
      initialSpringVelocity:0.0                // 初始速度
      options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
      animations:^{
        CGRect frame1 = self.textBtn.frame;
        frame1.origin.y = HSGH_SCREEN_HEIGHT;
        self.textBtn.frame = frame1;
        CGRect frame2 = self.photoBtn.frame;
        frame2.origin.y = HSGH_SCREEN_HEIGHT;
        self.photoBtn.frame = frame2;
          CGRect frame4 = self.videoBtn.frame;
          frame4.origin.y = HSGH_SCREEN_HEIGHT;
          self.videoBtn.frame = frame4;

        CGRect frame3 = self.photoLab.frame;
        frame3.origin.y = HSGH_SCREEN_HEIGHT;
        self.photoLab.frame = frame3;

        CGRect frame = self.textLab.frame;
        frame.origin.y = HSGH_SCREEN_HEIGHT;
        self.textLab.frame = frame;
          
          CGRect frame5 = self.videoTextLab.frame;
          frame5.origin.y = HSGH_SCREEN_HEIGHT;
          self.videoTextLab.frame = frame5;
          
          
        self.closeBtn.alpha = 0;
        self.closeBtn.transform =
            CGAffineTransformRotate(self.closeBtn.transform, M_PI / 4);
        [self layoutIfNeeded];

      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
}



- (IBAction)closeBtnClicked:(id)sender {
  [self closeViewsAnimation];
}
- (IBAction)textBtnClicked:(id)sender {
  self.block(0);
}

- (IBAction)photoBtnClicked:(id)sender {
  self.block(1);
}
- (IBAction)videoBtnClicked:(id)sender {
    self.block(2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   [self closeViewsAnimation]; 
}



@end
