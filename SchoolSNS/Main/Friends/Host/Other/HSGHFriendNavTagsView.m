//
//  HSGHFriendNavTagsView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendNavTagsView.h"

@interface HSGHFriendNavTagsView ()
@property(weak, nonatomic) IBOutlet UIView *redLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneToSecond;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoToThird;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdToFourth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;

@end

@implementation HSGHFriendNavTagsView
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//  self = [super initWithCoder:aDecoder];
//  if (self) {
//    [self setup];
//  }
//  return self;
//}
//
//- (void)setup {
//  [[NSBundle mainBundle] loadNibNamed:@"HSGHFriendNavTagsView"
//                                owner:self
//                              options:nil];
//  self.view.frame =
//  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//  [self addSubview:self.view];
//}

- (void)layoutSubviews{
//    _firstWidth.constant = [self widthString:_firstBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    _secondWidth.constant = [self widthString:_secondBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    _thirdWidth.constant = [self widthString:_thirdBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    _fourthWidth.constant = [self widthString:_fourthBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    
//    CGFloat space = (HSGH_SCREEN_WIDTH  - _fourthWidth.constant - _firstWidth.constant - _secondWidth.constant - _thirdWidth.constant)/4.0;
//    _left.constant = 0;
//    
//    _firstWidth.constant = [self widthString:_firstBtn.titleLabel.text Height:37 andFont:14].width + 10 + space;
//    _secondWidth.constant = [self widthString:_secondBtn.titleLabel.text Height:37 andFont:14].width + 10 + space;
//    _thirdWidth.constant = [self widthString:_thirdBtn.titleLabel.text Height:37 andFont:14].width + 10 + space;
//    _fourthWidth.constant = [self widthString:_fourthBtn.titleLabel.text Height:37 andFont:14].width + 10 + space;
//    _oneToSecond.constant = 0;
//    _twoToThird.constant = 0;
//    _thirdToFourth.constant = 0;
//    self.redLineView.frame = CGRectMake(0, self.redLineView.frame.origin.y, _firstBtn.frame.origin.x + _firstBtn.frame.size.width + (_secondBtn.frame.origin.x - (_firstBtn.frame.origin.x + _firstBtn.frame.size.width)/2.0), self.redLineView.frame.size.height);
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
//    self.redLineView.frame = CGRectMake(0, self.redLineView.frame.origin.y, _firstBtn.frame.origin.x + _firstBtn.frame.size.width + (_secondBtn.frame.origin.x - (_firstBtn.frame.origin.x + _firstBtn.frame.size.width)/2.0), self.redLineView.frame.size.height);

//    _firstWidth.constant = [self widthString:_firstBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    _secondWidth.constant = [self widthString:_secondBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    _thirdWidth.constant = [self widthString:_thirdBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    _fourthWidth.constant = [self widthString:_fourthBtn.titleLabel.text Height:37 andFont:14].width + 10;
//    
//    CGFloat space = (HSGH_SCREEN_WIDTH  - _fourthWidth.constant - _firstWidth.constant - _secondWidth.constant - _thirdWidth.constant)/4.0;
//    _left.constant = space/2.0;
//    _oneToSecond.constant = space;
//    _twoToThird.constant = space;
//    _thirdToFourth.constant = space;
//    self.redLineView.frame = CGRectMake(_firstBtn.frame.origin.x, self.redLineView.frame.origin.y, _firstBtn.frame.size.width, self.redLineView.frame.size.height);
    
}

/**
 btnClicked
 
 @param sender 导航按钮
 */
- (IBAction)homeTagsBtnClicked:(id)sender {
  UIButton *btn = sender;
//  __block HSGHFriendNavTagsView *weakSelf = self;
  self.tagBlock((int)btn.tag);
  [self moveRedLineFrame:(int)btn.tag];
    
    //发送通知 停止编辑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendNav_2_FriendVC_EndEdit" object:nil];
}


/**
 移动红色线
 
 @param tag btnTag
 */
- (void)moveRedLineFrame:(FRINED_BTN_TAGS)tag {
  int start = 1001;
  int end = 1004;
  for (int i = start; i < end; i++) {
      UIButton *btn = [self viewWithTag:i];
      [btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
//      btn.titleLabel.font = [UIFont systemFontOfSize:15];
      
      if (i == tag) {
          // move line
          [btn setTitleColor:[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1] forState:UIControlStateNormal];
//          btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];

      // move line
//      CGFloat width = [self widthString:btn.titleLabel.text Height:37 andFont:14].width + 10;
      CGRect rect = CGRectMake(
                               btn.frame.origin.x ,
                               self.redLineView.frame.origin.y,  self.redLineView.frame.size.width,
                               self.redLineView.frame.size.height);
        if(btn == _firstBtn){
           
        }else if (btn == _secondBtn){
           
        }
      [UIView animateWithDuration:0.2
                       animations:^{
                         self.redLineView.frame = rect;
                       }];
    }
  }
}

- (void)moveRedLineFrame:(FRINED_BTN_TAGS)tag animated:(BOOL)animated {
    int start = 1001;
    int end = 1004;
    for (int i = start; i < end; i++) {
        UIButton *btn = [self viewWithTag:i];
        [btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        
        if (i == tag) {
            // move line
            [btn setTitleColor:[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1] forState:UIControlStateNormal];
            //btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
            // move line
            //CGFloat width = [self widthString:btn.titleLabel.text Height:37 andFont:14].width + 10;
            CGRect rect = CGRectMake(
                                     btn.frame.origin.x ,
                                     self.redLineView.frame.origin.y,  self.redLineView.frame.size.width,
                                     self.redLineView.frame.size.height);
            if(btn == _firstBtn){
                
            }else if (btn == _secondBtn){
                
            }
            
            if (animated) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.redLineView.frame = rect;
                }];
            } else {
                self.redLineView.frame = rect;
            }
        }
    }
    
}

- (CGSize)widthString:(NSString *)string Height:(CGFloat)height andFont:(CGFloat)font {
  NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
  CGSize  size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)   attributes:attribute context:nil].size;
  return size;
}

@end
