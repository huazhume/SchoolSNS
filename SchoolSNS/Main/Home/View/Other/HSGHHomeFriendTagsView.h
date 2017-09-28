//
//  HSGHHomeFriendTagsView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CloseFriendTags)();

typedef void(^SelectFriendTags)(NSString * title);

@interface HSGHHomeFriendTagsView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertHeight;
@property (weak, nonatomic) IBOutlet UIView *alert;
@property (copy, nonatomic) CloseFriendTags block;
@property (copy, nonatomic) SelectFriendTags selectblock;
@end
