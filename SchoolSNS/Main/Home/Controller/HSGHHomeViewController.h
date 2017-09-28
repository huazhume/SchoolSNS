//
//  HSGHMessageViewController.h
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/6.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//

#import "HSGHBaseViewController.h"



@interface HSGHHomeViewController : HSGHBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToNavHeight;

@property (weak, nonatomic) IBOutlet UIView *navBgView;

- (void)moveToTopAndIsRefresh:(BOOL)isRefresh ;
@end
