//
//  HSGHFriendFirstHeaderView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TextFieldBlock)(NSString * text);

typedef void(^SearchBlock)(NSString * text);

@interface HSGHFriendFirstHeaderView : UIView
@property(nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (copy, nonatomic) TextFieldBlock block;
@property (copy, nonatomic) SearchBlock searchBlock;
@end
