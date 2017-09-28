//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
//TT_FIX_CATEGORY_BUG(UIViewAdditions)

@implementation UIView (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
  return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
  return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
  return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
  return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
  return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    //mdf by neil.libo  CALayer position contains NaN:一般和layer相关的也可能会有重复设值、刷新和释放的情况
    if (self.frame.size.width == width) {
        return;
    }
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
  return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
  CGFloat x = 0.0f;
  for (UIView* view = self; view; view = view.superview) {
    x += view.left;
  }
  return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
  CGFloat y = 0.0f;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;
  }
  return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
  CGFloat x = 0.0f;
  for (UIView* view = self; view; view = view.superview) {
      x += view.left;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      x -= scrollView.contentOffset.x;
    }
  }

  return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      y -= scrollView.contentOffset.y;
    }
  }
  return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
  return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
  return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
  return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls])
    return self;

  for (UIView* child in self.subviews) {
    UIView* it = [child descendantOrSelfWithClass:cls];
    if (it)
      return it;
  }

  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;

  } else if (self.superview) {
    return [self.superview ancestorOrSelfWithClass:cls];

  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
  while (self.subviews.count) {
    UIView* child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
  CGFloat x = 0.0f, y = 0.0f;
  for (UIView* view = self; view && view != otherView; view = view.superview) {
    x += view.left;
    y += view.top;
  }
  return CGPointMake(x, y);
}

- (UIView *)duplicate
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

//显示加载动画
- (void)showLoading
{
    
    for (UIView *view in [self subviews]) {
        if (view.tag == 0x48758) {
            return;
        }
    }
    /*
    UIImageView *backImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sysplay_load"]];
    backImgView.frame = CGRectMake(0, 0, 30, 38);
    backImgView.tag = 0x48758;
    backImgView.center = self.center;
    //[self addSubview:backImgView];
    */
    UIImageView *front = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sysplay_load"]];
    front.size = front.image.size;
    front.frame = CGRectMake((self.width-front.width)/2, (self.height-front.width)/2, front.width, front.height);
    front.tag = 0x48758;
    [self addSubview:front];
    [self animationWithimgView:front];
    
}



-(void)correctionLoadingCenterAuto{
    for (UIView *view in [self subviews]) {
        if (view.tag == 0x48758) {
            view.size = ((UIImageView*)view).image.size;
            view.frame = CGRectMake((self.width-view.width)/2, (self.height-view.width)/2, view.width, view.height);
            [self animationWithimgView:((UIImageView*)view)];
//            [view removeFromSuperview];
//            [self showLoading];
            return;
        }
    }
}


//去掉加载动画
-(void)hideLoading{
    for (UIView *view in [self subviews]) {
        if (view.tag == 0x48758) {
            [view.layer removeAllAnimations];
            [view removeFromSuperview];
            return;
        }
    }
}

-(void)animationWithimgView:(UIImageView *)imgView{
    /*__weak UIView *__self = self;
    [UIView animateWithDuration:2.0 animations:^{
        imgView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            imgView.alpha = 0;
        } completion:^(BOOL finished) {
            [__self animationWithimgView:imgView];
        }];
    }];*/
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2, 0.0, 0.0, 1.0)];
    animation.duration = 0.9;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    [imgView.layer addAnimation:animation forKey:@"transform"];
}

-(void)correctionLoadingCenter{
    
    for (UIView *view in [self subviews]) {
        if (view.tag == 0x48758) {
            [view removeFromSuperview];
            [self showLoading];
            return;
        }
    }
}

- (void)showUnreadIconWithTop:(CGFloat)top right:(CGFloat)right{
    [self removeUnreadIcon];
    
    UIImage *unreadImg = [UIImage imageNamed:@"p_xxzx_xxts"];
    UIImageView *unreadImgView = [[UIImageView alloc] initWithImage:unreadImg];
    unreadImgView.size = unreadImg.size;
    unreadImgView.top = top;
    unreadImgView.right = right;
    unreadImgView.tag = 1879;
    [self addSubview:unreadImgView];
}

- (void)showUnreadIconWithBottom:(CGFloat)bottom left:(CGFloat)left{
    [self removeUnreadIcon];
    
    UIImage *unreadImg = [UIImage imageNamed:@"p_xxzx_xxts"];
    UIImageView *unreadImgView = [[UIImageView alloc] initWithImage:unreadImg];
    unreadImgView.size = unreadImg.size;
    unreadImgView.bottom = bottom;
    unreadImgView.left = left;
    unreadImgView.tag = 1879;
    [self addSubview:unreadImgView];
}

- (void)removeUnreadIcon{

    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] && subView.tag == 1879) {
            [subView removeFromSuperview];
        }
    }
}

@end
