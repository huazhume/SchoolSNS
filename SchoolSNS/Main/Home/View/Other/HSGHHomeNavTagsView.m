//
//  HSGHHomeNavTagsView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeNavTagsView.h"

@interface HSGHHomeNavTagsView ()
{
    NSArray * _btnArray;
    
}
@property(weak, nonatomic) IBOutlet UIView *redLineView;

@end
@implementation HSGHHomeNavTagsView


- (void)awakeFromNib {
    [super awakeFromNib];
//    _btnArray = @[_firstBtn,_secondBtn,_thirdBtn];
}


/**
 btnClicked

 @param sender 导航按钮
 */
- (IBAction)homeTagsBtnClicked:(id)sender {
  UIButton *btn = sender;
  __block HSGHHomeNavTagsView *weakSelf = self;
  weakSelf.tagBlock((int)btn.tag);
    for(int i = 0; i< 3;i++){
        if(_btnArray[i] == btn){
            
        }
    }
  [self moveRedLineFrame:(int)btn.tag];
}


/**
 移动红色线

 @param tag btnTag
 */
- (void)moveRedLineFrame:(HOME_BTN_TAGS)tag {
  int start = 1001;
  int end;
  if((int)tag > 2000){
    end = 2004;
  }else{
    end = 1004;
  }
  for (int i = start; i < end; i++) {
    UIButton *btn = [self viewWithTag:i];
    [btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];

    if (i == tag) {
      // move line
        [btn setTitleColor:[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
      CGRect rect = CGRectMake(
          btn.frame.origin.x,
          self.redLineView.frame.origin.y, self.redLineView.frame.size.width,
          self.redLineView.frame.size.height);
      [UIView animateWithDuration:0.2
                       animations:^{
                         self.redLineView.frame = rect;
                       }];
    }
  }
}

- (void)moveLineWithTag:(NSInteger)page {
    UIButton *btn = [self viewWithTag:page + 1001];
    CGRect rect = CGRectMake(
                             btn.frame.origin.x,
                             self.redLineView.frame.origin.y, self.redLineView.frame.size.width,
                             self.redLineView.frame.size.height);
    self.redLineView.frame = rect;
}






@end
