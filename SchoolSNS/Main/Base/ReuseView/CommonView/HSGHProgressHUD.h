//
//  BFProgressHUD.h
//  BFSports
//
//  Created by 刘传良 on 16/8/19.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LoadingColor) {
    LoadingColorWhite = 0,  //无背景色，白色菊花
    LoadingColorGray,       //无背景色，灰色菊花
    LoadingBlackBG,         //黑色背景，白色菊花
};

static const NSTimeInterval KToastTime = 1.5;

@interface HSGHProgressHUD : NSObject

#pragma mark - Show Text
+ (void)showToastText:(NSString *)text;
+ (void)showToastText:(NSString *)text offsetY:(CGFloat)offsetY;

#pragma mark - Show Loading
+ (void)showLoadingInView:(UIView *)parentView;//default:模态,无背景色,灰色菊花
+ (void)showLoadingInView:(UIView *)parentView color:(LoadingColor)color;//菊花的颜色
+ (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView;
+ (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView offsetY:(CGFloat)offsetY;
+ (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView offsetY:(CGFloat)offsetY color:(LoadingColor)color;
+ (void)hideLoadingHUD;
+ (void)setModalState:(BOOL)modal;//默认为模态，设置NO为非模态

#pragma mark - Show AlertView
+ (void)showWiFiAlertSettingBlock:(void(^)())settingBlock continueBlock:(void(^)())continueBlock inController:(UIViewController *)controller;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg leftTitle:(NSString *)leftTitle leftBlock:(void(^)())leftBlock rightTitle:(NSString *)rightTitle rightBlock:(void(^)())rightBlock inController:(UIViewController *)controller;

@end
