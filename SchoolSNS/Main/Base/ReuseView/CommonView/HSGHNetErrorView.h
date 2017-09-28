//
//  BFSWvErrorView.h
//  BFSports
//
//  Created by baofeng on 16/3/23.
//  Copyright © 2016年 BaoFeng. All rights reserved.
//  网络连接异常视图

#import <UIKit/UIKit.h>

@protocol HSGHNetErrorViewDelegate <NSObject>

- (void)netErrorViewClicked;

@end

@interface HSGHNetErrorView : UIView

@property (nonatomic, weak)   id<HSGHNetErrorViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

// imageView hidden
@property (nonatomic, assign) BOOL    imageViewisHidden;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content fraem:(CGRect)fraem delegate:(id<HSGHNetErrorViewDelegate>)delegate;;

@end
