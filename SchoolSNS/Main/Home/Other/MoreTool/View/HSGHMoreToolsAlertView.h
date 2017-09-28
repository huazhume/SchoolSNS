//
//  HSGHMoreToolsAlertView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSGHHomeModelFrame.h"

typedef void(^AlertViewBlock)(NSInteger type);

@interface HSGHMoreToolsAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *d;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstToSecond;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondToThird;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdToFourth;
@property (copy, nonatomic) AlertViewBlock block;


@property (nonatomic,strong)HSGHHomeQQianModel * model;

- (void)loadDataWithModel:(HSGHHomeQQianModelFrame *)modelF WithCellView:(UITableViewCell *)cellView ;

@end
