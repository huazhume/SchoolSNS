//
//  BFProgressHUD.m
//  BFSports
//
//  Created by 刘传良 on 16/8/19.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import "HSGHProgressHUD.h"
#import "MBProgressHUD.h"

@interface HSGHProgressHUD()
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) MBProgressHUD * loadingHUD;
@property (nonatomic, strong) UIView * parentView;
@property (nonatomic, weak) UIViewController * parentController;
@property (nonatomic, copy) void(^leftBlock)();
@property (nonatomic, copy) void(^rightBlock)();
@end
@implementation HSGHProgressHUD

+ (HSGHProgressHUD *)sharedInstance
{
    static dispatch_once_t once;
    static HSGHProgressHUD * sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Show Text
+ (void)showToastText:(NSString *)text
{
    [HSGHProgressHUD showToastText:text offsetY:0];
}
+ (void)showToastText:(NSString *)text offsetY:(CGFloat)offsetY
{
    [[self sharedInstance] showToastText:text offsetY:offsetY];
}
- (void)showToastText:(NSString *)text offsetY:(CGFloat)offsetY
{
    if (_hud)
    {
        [_hud hideAnimated:NO];
        _hud = nil;
    }
    UIView * parentView = [self getFrontWindow];
    _hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.removeFromSuperViewOnHide = YES;
    _hud.offset = CGPointMake(0.f, offsetY);
    _hud.label.text = text;
    _hud.label.textColor = [UIColor whiteColor];
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    _hud.bezelView.layer.cornerRadius = 0;
    _hud.userInteractionEnabled = NO;
    [_hud hideAnimated:YES afterDelay:KToastTime];
}

#pragma mark - Show Loading
+ (void)showLoadingInView:(UIView *)parentView
{
    [[self sharedInstance] showLoadingWithText:nil inView:parentView offsetY:0 color:LoadingColorGray];
}
+ (void)showLoadingInView:(UIView *)parentView color:(LoadingColor)color
{
    [[self sharedInstance] showLoadingWithText:nil inView:parentView offsetY:0 color:color];
}
+ (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView
{
    [[self sharedInstance] showLoadingWithText:title inView:parentView offsetY:0 color:LoadingColorGray];
}
+ (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView offsetY:(CGFloat)offsetY
{
    [[self sharedInstance] showLoadingWithText:title inView:parentView offsetY:offsetY color:LoadingColorGray];
}
+ (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView offsetY:(CGFloat)offsetY color:(LoadingColor)color
{
    [[self sharedInstance] showLoadingWithText:title inView:parentView offsetY:offsetY color:color];
}
+ (void)hideLoadingHUD
{
    [[self sharedInstance] hideLoadingHUD];
}
+ (void)setModalState:(BOOL)modal
{
    [[self sharedInstance] setModalState:(BOOL)modal];
}
- (void)showLoadingWithText:(NSString *)title inView:(UIView *)parentView offsetY:(CGFloat)offsetY color:(LoadingColor)color
{
    if (_loadingHUD)
    {
        [_loadingHUD hideAnimated:NO];
        _loadingHUD = nil;
    }
//    UIView * parentView = [self getFrontWindow];
    _loadingHUD = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
//    _loadingHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    _loadingHUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    _loadingHUD.mode = MBProgressHUDModeCustomView;
    _loadingHUD.removeFromSuperViewOnHide = YES;
    _loadingHUD.offset = CGPointMake(0.f, offsetY);
    _loadingHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    if(color == LoadingBlackBG)
    {
        _loadingHUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.8f];
    }
    else
    {
        _loadingHUD.bezelView.color = [UIColor clearColor];
    }
    
    _loadingHUD.label.textColor = RGBCOLOR(60, 60, 60);
    _loadingHUD.label.font = HSLFontSize(15.0f);
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (color==LoadingColorGray) {
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }else if (color == LoadingColorWhite || color == LoadingBlackBG){
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _loadingHUD.contentColor = [UIColor whiteColor];
    }
    [indicator startAnimating];
    
    _loadingHUD.customView = indicator;
    
    if (title) {
        _loadingHUD.label.text = title;
    }
    [_loadingHUD showAnimated:YES];
}
- (void)hideLoadingHUD
{
    if (_loadingHUD)
    {
        [_loadingHUD hideAnimated:NO];
        _loadingHUD = nil;
    }
}
- (void)setModalState:(BOOL)modal
{
    if (_loadingHUD)
    {
        _loadingHUD.userInteractionEnabled = modal;
    }
}
#pragma mark - Show Alert
+ (void)showWiFiAlertSettingBlock:(void(^)())settingBlock continueBlock:(void(^)())continueBlock inController:(UIViewController *)controller
{
    [self sharedInstance].parentController = controller;
    [[self sharedInstance] showAlertWithTitle:@"提示" message:@"当前位于Wi-Fi环境下继续浏览将产生流量" leftTitle:@"设置" leftBlock:settingBlock rightTitle:@"继续浏览" rightBlock:continueBlock];
}
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg leftTitle:(NSString *)leftTitle leftBlock:(void(^)())leftBlock rightTitle:(NSString *)rightTitle rightBlock:(void(^)())rightBlock inController:(UIViewController *)controller
{
    [self sharedInstance].parentController = controller;
    [[self sharedInstance] showAlertWithTitle:title message:msg leftTitle:leftTitle leftBlock:leftBlock rightTitle:rightTitle rightBlock:rightBlock];
}
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg leftTitle:(NSString *)leftTitle leftBlock:(void(^)())leftBlock rightTitle:(NSString *)rightTitle rightBlock:(void(^)())rightBlock
{
    if (IOS8_Later)
    {
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (leftBlock) {
                leftBlock();
            }
        }];
        UIAlertAction * rightAction;
        if (rightTitle)
        {
            rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (rightBlock) {
                    rightBlock();
                }
            }];
        }
        
        [alertCtr addAction:leftAction];
        if (rightAction) {
            [alertCtr addAction:rightAction];
        }
        
        
        [self.parentController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        _leftBlock = leftBlock;
        _rightBlock = rightBlock;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg  delegate:self cancelButtonTitle:leftTitle otherButtonTitles:rightTitle,nil];
        alertView.delegate = self;
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (_leftBlock) {
            _leftBlock();
        }
    }
    else if(buttonIndex == 1)
    {
        if (_rightBlock) {
            _rightBlock();
        }
    }
}

- (UIView *)getFrontWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}
@end
