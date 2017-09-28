//
//  HSGHFriendNavTagsView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
  FRIEND_Friend_BTN = 1001,
  FRIEND_FriendRequest_BTN,
  FRIEND_FriendINTRO_BTN,
  FRIEND_FiendFORTH_BTN,
} FRINED_BTN_TAGS;
//回调
typedef void (^FriendNavTagClickedBlock)(FRINED_BTN_TAGS tag);


@interface HSGHFriendNavTagsView : UIView
@property(nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;

/**
 navBtn点击回调
 */
@property(nonatomic, copy) FriendNavTagClickedBlock tagBlock;

/**
 改变redLine的位置
 
 @param tag BtnTag
 */
- (void)moveRedLineFrame:(FRINED_BTN_TAGS)tag;
- (void)moveRedLineFrame:(FRINED_BTN_TAGS)tag animated:(BOOL)animated;
@end
