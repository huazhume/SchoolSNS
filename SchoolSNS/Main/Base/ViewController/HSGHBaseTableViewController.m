//
//  HSGHRootViewController.m
//  HSGHNBC
//
//  Created by Qianqian li on 2017/2/13.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//


#import "HSGHBaseTableViewController.h"
#import "AppDelegate.h"

#define NAVITITLE_TAG 989899988
#define NAVLEFTBTN_TAG 789437829
#define NAVRIGHTBTN_TAG 42342342
#define NAVGATION_TAG 4234233432



@interface HSGHBaseTableViewController ()
@property (nonatomic ,strong)UIButton * leftBtn;
@property (nonatomic ,strong)UIButton * rightBtn;
@property (nonatomic , strong)UILabel * navTitle;
@property (nonatomic , strong)UIView * navgationBar;

@end

@implementation HSGHBaseTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabBarController.tabBar.frame = CGRectMake(0,HSGH_SCREEN_HEIGHT - 44 , HSGH_SCREEN_WIDTH, 49);
    self.navigationController.navigationBar.frame = CGRectMake(0,9, HSGH_SCREEN_WIDTH, 44);
    [self configNavigationBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[AppDelegate instanceApplication] indicatorDismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:_navgationBar];
}


- (void)setTitle:(NSString *)title {
    self.navTitle.text = title;
    title = @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 导航左按钮设置
 */
- (void)configNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    //
    //    self.navigationItem.hidesBackButton = YES;
    //    if([self.navigationController.navigationBar viewWithTag:NAVITITLE_TAG] != nil){
    //        [[self.navigationController.navigationBar viewWithTag:NAVITITLE_TAG] removeFromSuperview];
    //    }
    //    if([self.navigationController.navigationBar viewWithTag:NAVLEFTBTN_TAG] != nil){
    //        [[self.navigationController.navigationBar viewWithTag:NAVLEFTBTN_TAG] removeFromSuperview];
    //    }
    //    if([self.navigationController.navigationBar viewWithTag:NAVRIGHTBTN_TAG] != nil){
    //        [[self.navigationController.navigationBar viewWithTag:NAVRIGHTBTN_TAG] removeFromSuperview];
    //    }
    //    [self.navigationController.navigationBar addSubview:self.leftBtn];
    //    [self.navigationController.navigationBar addSubview:self.navTitle];
    //    [self.navigationController.navigationBar addSubview:self.rightBtn];
    
    self.navgationBar.tag = NAVGATION_TAG;
    if([self.view viewWithTag:NAVRIGHTBTN_TAG] != nil){
        [[self.view viewWithTag:NAVGATION_TAG] removeFromSuperview];
    }
    
    [self.view addSubview:self.navgationBar];
    [self.navgationBar addSubview:self.leftBtn];
    [self.navgationBar addSubview:self.navTitle];
    [self.navgationBar addSubview:self.rightBtn];
    self.view.backgroundColor = HEXRGBCOLOR(0xFAFAFA);
}

- (void)setNavigationBarIsHidden:(BOOL)isHidden {
    self.navgationBar.hidden = isHidden;
}

- (void)addLeftNavigationBarBtnWithString:(NSString *)string {
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.leftBtn setTitle:string forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)leftBarItemBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)addRightNavigationBarBtnWithString:(NSString *)string {
    self.rightBtn.hidden = NO;
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(5.5, 12, 5.5, 32);
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:string forState:UIControlStateNormal];
}

- (void)addRightNavigationBarImage:(NSString *)string{
    self.rightBtn.hidden = NO;
    [self.rightBtn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(1.5, 16, 1.5, 16);
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
}

- (void)rightBarItemBtnClicked:(UIButton *)btn {
    
}
- (UIButton *)leftBtn {
    if(!_leftBtn){
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 9, 66, 33);
        [leftBtn setImage:[UIImage imageNamed:@"common_nav_btn_back_n"] forState:UIControlStateNormal];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5.5, 12, 5.5, 32);
        [leftBtn addTarget:self action:@selector(leftBarItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [leftBtn setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
        _leftBtn = leftBtn;
        _leftBtn.tag = NAVLEFTBTN_TAG;
    }
    return _leftBtn;
}
- (UIButton *)rightBtn {
    if(!_rightBtn){
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(HSGH_SCREEN_WIDTH - 66, 9, 66, 33);
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5.5, 12, 5.5, 32);
        [leftBtn addTarget:self action:@selector(rightBarItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [leftBtn setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
        _rightBtn = leftBtn;
        _rightBtn.hidden = YES;
        _rightBtn.tag = NAVRIGHTBTN_TAG;
    }
    return _rightBtn;
}
- (UILabel *)navTitle {
    if(!_navTitle){
        _navTitle = [[UILabel alloc]initWithFrame:CGRectMake(44, 9, HSGH_SCREEN_WIDTH - 88, 34)];
        _navTitle.font = [UIFont boldSystemFontOfSize:14];
        _navTitle.textColor = HEXRGBCOLOR(0x272727);
        _navTitle.textAlignment = NSTextAlignmentCenter;
        _navTitle.tag = NAVITITLE_TAG;
    }
    return _navTitle;
}

- (UIView *)navgationBar {
    if(!_navgationBar){
        _navgationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 9, HSGH_SCREEN_WIDTH, 44)];
        _navgationBar.backgroundColor = HEXRGBCOLOR(0xfafafa);
    }
    return _navgationBar;
}


@end
