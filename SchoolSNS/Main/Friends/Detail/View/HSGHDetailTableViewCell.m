//
//  HSGHDetailTableViewCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHDetailTableViewCell.h"
#import "HSGHTools.h"


@implementation HSGHDetailTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setcellFrame:(HSGHHomeQQianModelFrame *)frame WithSingleModel:(HSGHFriendSingleModel *)singleModel {
    
    [self.HeaderView setModelFrame:frame];
    [self.ContentView setModelFrame:frame];
    [self.ToolView setModelFrame:frame];
    [self.CommentView setModelFrame:frame];
    self.headerHeight.constant = frame.headerHeight;
    
    if(frame.toolHeight < 30){
        self.ContentView.yylabel.userInteractionEnabled = NO;
    }else{
          self.ContentView.yylabel.userInteractionEnabled = YES;
    }
    self.toolsHeight.constant = frame.toolHeight;
    self.commentHeight.constant = frame.commentHeight;
    self.contentHeight.constant = frame.contentHeight;
    if(frame.friendMode == FRIEND_CATE_SECOND && frame.mode == QQIAN_FRIEND){
       
          self.timeView.timeLab.text = [NSString stringWithFormat:@"于%@成为好友",[HSGHTools getDateString:frame.model.friendAddTime]];
        self.timeHeight.constant = 29;
        self.timeView.width.constant = 17 + [HSGHTools widthOfLab:self.timeView.timeLab] + 12;
        self.timeView.hidden = NO;
        self.timeView.timeFriendAllBtn.hidden = NO;
        self.timeView.timeLab.hidden = NO;
    }else {
        self.timeHeight.constant = 0;
        self.timeView.hidden = YES;
        self.timeView.timeFriendAllBtn.hidden = YES;
        self.timeView.timeLab.hidden = YES;
    }
    self.forwordViewHeight.constant = 0;
    self.ContentView.hidden = NO;
    self.forwardView.hidden = YES;
    self.CommentView.singleModel = singleModel;
    
}


- (void)setcellFrame:(HSGHHomeQQianModelFrame *)frame  {
    
    [self.HeaderView setModelFrame:frame];
    [self.ContentView setModelFrame:frame];
    [self.ToolView setModelFrame:frame];
    [self.CommentView setModelFrame:frame];
    self.headerHeight.constant = frame.headerHeight;
    self.toolsHeight.constant = frame.toolHeight;
    self.commentHeight.constant = frame.commentHeight;
    self.contentHeight.constant = frame.contentHeight;
    if([frame.model.friendAddMode integerValue] == 1){
        self.timeHeight.constant = 29;
        self.timeView.timeLab.text = [HSGHTools getLocalDateFormateUTCDate:frame.model.friendAddTime];;
    }else{
        self.timeHeight.constant = 0;
    }
    self.forwordViewHeight.constant = 0;
    self.ContentView.hidden = NO;
    self.forwardView.hidden = YES;
    
    if (frame.model.mediaType == 2 && frame.model.image.srcUrl.length) {
        [self.ContentView.image jp_playVideoHiddenStatusViewWithURL:[NSURL URLWithString:frame.model.image.srcUrl]];
    }
}

@end
