
//
//  HSGHLaunchHideView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHLaunchHideView.h"

@implementation HSGHLaunchHideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)hideBtn:(id)sender {
    if(_block){
        self.block((UIButton *)sender);
    }
}

@end
