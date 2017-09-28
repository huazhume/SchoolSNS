//
//  HSGHBaseNavigationView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NavigationBtnBlock)();

@interface HSGHBaseNavigationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (copy, nonatomic) NavigationBtnBlock block;


@end
