//
//  HSGHHomeMainTableViewCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHHomeMainTableViewCell.h"

@implementation HSGHHomeMainTableViewCell
- (void)prepareForReuse {
    [super prepareForReuse];
    //[self mutePlay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    UILongPressGestureRecognizer *gersture = [[UILongPressGestureRecognizer alloc]
//                                              initWithTarget:self
//                                              action:@selector(longPress:)];
//    gersture.minimumPressDuration = 2;
//    [self.contentView addGestureRecognizer:gersture];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    HSGHHomeMainTableViewCell *cell = [[[self class] allocWithZone:zone]init];
    cell = self;
    return cell;
}

- (void)setcellFrame:(HSGHHomeQQianModelFrame *)frame {
    [self.HeaderView setModelFrame:frame];
    [self.ContentView setModelFrame:frame];
    [self.ToolView setModelFrame:frame];
    [self.CommentView setModelFrame:frame];
    self.headerHeight.constant = frame.headerHeight;
    self.toolsHeight.constant = frame.toolHeight;
    self.commentHeight.constant = frame.commentHeight;
    self.contentHeight.constant = frame.contentHeight;
    self.forwordViewHeight.constant = 0;
    self.ContentView.hidden = NO;
    self.forwardView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    self.ContentView.dcimgBlock = ^(){
        [weakSelf.ToolView contentViewPriaseAction];
    };
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    UIActionSheet *sheet =
    [[UIActionSheet alloc] initWithTitle:@""
                                delegate:nil
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"语言粗鲁下流"
                       otherButtonTitles:@"政治敏感", @"版权问题",
     @"色情", @"儿童色情", nil];
    [sheet showInView:self];
}


@end
