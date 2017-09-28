//
//  HSGHHomeNavTagsView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  HOME_Friend_BTN = 1001,
  HOME_FriendRequest_BTN,
  HOME_FriendINTRO_BTN,
} HOME_BTN_TAGS;

//回调
typedef void (^HomeNavTagClickedBlock)(HOME_BTN_TAGS tag);

@interface HSGHHomeNavTagsView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

/**
 navBtn点击回调
 */
@property(nonatomic, copy) HomeNavTagClickedBlock tagBlock;

/**
 改变redLine的位置

 @param tag BtnTag
 */
- (void)moveRedLineFrame:(HOME_BTN_TAGS)tag;
- (void)moveLineWithTag:(NSInteger)page;
@end
