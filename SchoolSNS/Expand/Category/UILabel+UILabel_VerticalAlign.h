//
//  UILabel+UILabel_VerticalAlign.h
//  RailWifi
//
//  Created by jack 163 on 6/27/16.
//  Copyright © 2016 cmmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel {
@private
    VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end

