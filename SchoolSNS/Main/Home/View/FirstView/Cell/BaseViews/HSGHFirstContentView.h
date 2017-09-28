//
//  HSGHHomeMainCellContentView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeModelFrame.h"
#import "YYLabel.h"
#import <UIKit/UIKit.h>
#ifdef OPEN_VIDEO
#endif

//回调
typedef void (^MoreBtnClickedBlock)();
typedef void (^UpClickedBlock)(int type);
typedef void (^DoubleClickImgBlock)();//双击内容图片，触发工具条点赞动画

@interface HSGHFirstContentView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@property(nonatomic, strong) IBOutlet UIView *view;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *textHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *moreHeight;
@property(assign, nonatomic) CGFloat contentHeight;

@property(nonatomic, copy) MoreBtnClickedBlock block;
@property(nonatomic, copy) UpClickedBlock upBlock;

@property(nonatomic, copy) DoubleClickImgBlock dcimgBlock;
// 控件
@property(weak, nonatomic) IBOutlet UIImageView *image;
@property(weak, nonatomic) IBOutlet UITextView *textLabel;
@property(weak, nonatomic) IBOutlet UIButton *moreBtn;
@property(assign, nonatomic) BOOL isMore;
@property(nonatomic, strong) HSGHHomeQQianModelFrame *Cframe;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *textTopToImage;
- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF;
@property(weak, nonatomic) IBOutlet UITextField *textField;

@property(strong, nonatomic) YYLabel *yylabel;
@property(weak, nonatomic) IBOutlet UIView *yylabelBg;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
