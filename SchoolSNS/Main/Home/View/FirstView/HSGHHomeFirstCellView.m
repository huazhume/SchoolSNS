//
//  HSGHHomeFirstCellView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeFirstCellView.h"

@implementation HSGHHomeFirstCellView



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"HSGHHomeFirstCellView"
                                  owner:self
                                options:nil];
    self.view.frame =
    CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.view];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //  UILongPressGestureRecognizer * gersture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    //  gersture.minimumPressDuration = 2;
    //  [self addGestureRecognizer:gersture];
    // Initialization code
}
- (void)setContentFrame:(HSGHHomeQQianModelFrame *)frame WithIsFriend:(BOOL)isFriend {

    self.toolsHeight.constant = frame.toolHeight;
    self.commentHeight.constant = frame.commentHeight;
    self.contentHeight.constant = frame.contentHeight;
    self.forwordViewHeight.constant = 0;
    self.ContentView.hidden = NO;
    self.forwardView.hidden = YES;
    [self.ToolView setIsFriend:isFriend];
    [self.ContentView setModelFrame:frame];
    [self.ToolView setModelFrame:frame];
    [self.CommentView setModelFrame:frame];
}
- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"语言粗鲁下流" otherButtonTitles:@"政治敏感",@"版权问题",@"色情",@"儿童色情" ,nil];
    [sheet showInView:self];
}


@end
