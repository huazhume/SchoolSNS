//
//  HSGHMsgNavTagsView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  MSG_Comment_BTN = 1001,
  MSG_ANTA_BTN,
  MSG_UP_BTN,
} MSG_BTN_TAGS;

//回调
typedef void (^MsgNavTagClickedBlock)(MSG_BTN_TAGS tag);

@interface HSGHMsgNavTagsView: UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

/**
 navBtn点击回调
 */
@property(nonatomic, copy) MsgNavTagClickedBlock tagBlock;

/**
 改变redLine的位置
 
 @param tag BtnTag
 */
- (void)moveRedLineFrame:(MSG_BTN_TAGS)tag;

- (void)moveRedLineFrame:(MSG_BTN_TAGS)tag animated:(BOOL)animated;
@end
