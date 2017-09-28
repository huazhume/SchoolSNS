//
//  HSGHForwardView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHForwardView.h"


@implementation HSGHForwardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}
- (void)setup {
  [[NSBundle mainBundle] loadNibNamed:@"HSGHForwardView"
                                owner:self
                              options:nil];
  self.view.frame =
  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  [self addSubview:self.view];
    self.iconBtn.layer.cornerRadius = 17;
    self.iconBtn.layer.masksToBounds = YES;
}

//- (void)setFrames:(HSGHHomeForWardContentModelFrame *)frame {
//  self.topTextHeight.constant = frame.topTextHeight;
//  self.leftImageWidth.constant = frame.leftImageWidth;
//  self.universityHeight.constant = frame.universityHeight;
//  self.contentHeight.constant = frame.contentHeight;
//  self.BackgroundViewHeight.constant = frame.backgroundViewHeight;
//
//}
@end
