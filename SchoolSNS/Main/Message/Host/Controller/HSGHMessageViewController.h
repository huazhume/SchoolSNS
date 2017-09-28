//
//  HSGHMessageViewController.h
//  HSGHSNS
//
//  Created by Qianqian li on 2017/3/6.
//  Copyright © 2017年 Qianqian li. All rights reserved.
//


#import "HSGHBaseViewController.h"

@interface HSGHMessageViewController : UIViewController
- (void)refreshRedCountWithIndex:(NSInteger )index WithHaveNewMessage:(NSInteger)has;
- (void)changeRedItemsSign;

@property (weak, nonatomic) IBOutlet UIView *navTagBgView;


@end
