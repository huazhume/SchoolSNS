//
//  UIActionSheet+Block.h
//  BFSports
//
//  Created by JokerAtBaoFeng on 16/5/5.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void (^OperationBlock)(NSInteger buttonIndex);

@interface UIActionSheet(Block)<UIActionSheetDelegate>
- (void)showActionSheetInView:(nonnull UIView *)view withOperationBlock:(_Nonnull OperationBlock)block;
@end
