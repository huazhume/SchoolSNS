//
//  HSGHTextField.m
//  SchoolSNS
//
//  Created by huaral on 2017/7/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHTextField.h"

@implementation HSGHTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 2, 1);
    
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
    
}

@end
