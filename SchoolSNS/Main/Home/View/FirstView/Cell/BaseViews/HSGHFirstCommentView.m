//
//  HSGHHomeMainCellCommentView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFirstCommentView.h"
#import "HSGHCommentViewCell.h"
#import "HSGHHomeModel.h"
#import "HSGHCommentHeaderView.h"
#import "YYText.h"

@interface HSGHFirstCommentView () <UITableViewDataSource, UITableViewDelegate>

{
//    UILabel *label;
    
}
@property(strong, nonatomic) IBOutlet HSGHCommentHeaderView *commentHeaderView;
@property(strong, nonatomic) IBOutlet UIView *commentFooterView;
@property(strong, nonatomic) NSArray<HSGHHomeReplay *> *datalist;
@property (strong,nonatomic) NSArray<HSGHHomeVOCommentFrame *> * cellFrame;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HSGHFirstCommentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"HSGHFirstCommentView"
                                  owner:self
                                options:nil];
    self.view.frame =
    CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.view];
}

- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF {
    _qqianVo = modelF.model;
    self.datalist = modelF.model.partReplay;
    _cellFrame = modelF.commentFrameArr;
    [self.tableView reloadData];
    self.commentHeaderView.textLab.text = [NSString stringWithFormat:@"%ld条评论", [_qqianVo.replyCount integerValue] + [_qqianVo.forwardCount integerValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _datalist = [NSArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HSGHCommentViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MainCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(moreBtnClicked:)];
    [self.tableView addGestureRecognizer:gesture];
     self.tableView.userInteractionEnabled = YES;
}

- (void)moreBtnClicked:(UIGestureRecognizer *)gecognizer {
    if( [_qqianVo.replyCount integerValue] + [_qqianVo.forwardCount integerValue] != 0){
         self.oprationBlock (1000,nil);
    }
    
}

#pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
  
    return self.commentHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(self.datalist.count > 3){
        return 3;
    }
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_cellFrame[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHHomeReplay *replay = _datalist[indexPath.row];
    HSGHCommentViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    NSMutableAttributedString *string =
    [self generateAttributedStringWithCommentItemModel:replay];
    
    if (string != nil) {
        cell.textLab.attributedText = string;
    }
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    
    return self.commentFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    if ([_qqianVo.replyCount integerValue] + [_qqianVo.forwardCount integerValue] > 3) {
        return 5;
    }
    return 5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.oprationBlock (2000,indexPath);
}


//- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(HSGHHomeReplay *)model {
//    NSString *text = @"";
//    NSRange range;
//    if (model.toUser.nickName.length) {
//        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.toUser.nickName]];
//        text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
//    } else {
//        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.content]];
//    }
//    
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
//    attString.yy_color = HEXRGBCOLOR(0x272727);
//    attString.yy_font = [UIFont systemFontOfSize:14];
//    if (model.toUser.nickName) {
//        range = NSMakeRange(2, model.toUser.nickName.length);
//        [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:range];
//    }
//    
//    attString.yy_lineSpacing = 8;
//    return attString;
//}


//wanquanbun
#pragma mark - private actions
- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:
(HSGHHomeReplay *)model {
    NSString *text = model.fromUser.displayName;
    if (model.toUser.displayName.length) {
        text = [text
                stringByAppendingString:[NSString
                                         stringWithFormat:@"回复 %@",
                                         model.toUser.displayName]];
    }
    text =
    [text stringByAppendingString:[NSString stringWithFormat:@"：%@",
                                   model.content]];
    NSMutableAttributedString *attString;
    
    if (text != nil) {
        attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
     attString.yy_font = [UIFont systemFontOfSize:14];
    if (attString != nil) {
        [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:[text rangeOfString:model.fromUser.displayName]];
        if (model.toUser.displayName) {
            [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:[text rangeOfString:model.toUser.displayName]];
        }
    }
    attString.yy_lineSpacing = 2;
    attString.yy_color = HEXRGBCOLOR(0x272727);
    return attString;
}



- (UIView *)commentHeaderView {
    if (!_commentHeaderView) {
        _commentHeaderView =  [[[NSBundle mainBundle] loadNibNamed:@"HSGHCommentHeaderView"
                                                             owner:self
                                                           options:nil] lastObject];
    }
    return _commentHeaderView;
}
- (UIView *)commentFooterView {
    if (!_commentFooterView) {
//        _commentFooterView =
//        [[[NSBundle mainBundle] loadNibNamed:@"HSGHCommentMoreView"
//                                       owner:self
//                                     options:nil] lastObject];
        _commentFooterView = [UIView new];
    }
    return _commentFooterView;
}


@end
