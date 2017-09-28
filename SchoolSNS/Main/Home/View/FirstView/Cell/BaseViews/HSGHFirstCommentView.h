//
//  HSGHHomeMainCellCommentView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"



typedef  void(^CommentMore)();

typedef void(^CommentBlock)(NSIndexPath * indexPath);



// new
typedef void(^OprationBlock)(NSInteger type , NSIndexPath * indexPath);


@interface HSGHFirstCommentView : UIView
@property(nonatomic, strong) IBOutlet UIView *view;
@property(nonatomic, strong) HSGHHomeQQianModel * qqianVo;
- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF;
@property (nonatomic ,copy) CommentBlock block;
@property (nonatomic ,copy) CommentMore moreBlock;

//new
@property(nonatomic,copy) OprationBlock oprationBlock;

@end
