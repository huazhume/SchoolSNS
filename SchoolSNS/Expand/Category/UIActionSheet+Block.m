//
//  UIActionSheet+Block.m
//  BFSports
//
//  Created by JokerAtBaoFeng on 16/5/5.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import "UIActionSheet+Block.h"

static char key;

@implementation UIActionSheet(Block)

- (void)showActionSheetInView:(nonnull UIView *)view withOperationBlock:(OperationBlock)block  {
    //首先判断这个block是否存在
    if(block) {
        //这里用到了runtime中绑定对象，将这个block对象绑定alertview上
        objc_setAssociatedObject(self, &key,block,OBJC_ASSOCIATION_COPY);
        //设置delegate
        self.delegate=self;
    }
    //弹出提示框
    [self showInView:view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //拿到之前绑定的block对象
    OperationBlock block =objc_getAssociatedObject(self, &key);
    //移除所有关联
    objc_removeAssociatedObjects(self);
    if(block) {
        //调用block 传入此时点击的按钮index
        block(buttonIndex);
    }
}
@end
