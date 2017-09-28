//
//  HSGHDetailTimeView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHDetailTimeView.h"

@implementation HSGHDetailTimeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"HSGHDetailTimeView"
                                  owner:self
                                options:nil];
    self.view.frame =
    CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.view];
}

- (void)setModelFrame:(HSGHHomeQQianModelFrame*)modelF {
    
}
@end
