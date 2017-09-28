//
//  HSGHCommentViewCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHCommentViewCell.h"
#import "YYText.h"
#import "NSAttributedString+YYText.h"
#import "HSGHCommentsCallFriendViewModel.h"


@implementation HSGHCommentViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
    _textLab = [[YYLabel alloc]init];
    [self.textBgView addSubview:self.textLab];
    _textLab.numberOfLines = 0;
    _textLab.textAlignment = NSTextAlignmentLeft;

    [_textLab mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_textBgView);
        make.top.mas_equalTo(_textBgView);
        make.bottom.mas_equalTo(_textBgView);
        make.right.mas_equalTo(_textBgView);
    }];
    [self addSeeMoreButton];
    _textLab.textParser = [YYTextMatchBindingParser new];
}



- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...更多"];

    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:HEXRGBCOLOR(0x272727)];
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [_textLab sizeToFit];
    };
    [text yy_setFont:[UIFont systemFontOfSize:13]range:[text.string rangeOfString:@"更多"]];
    [text yy_setColor:HEXRGBCOLOR(0x272727) range:[text.string rangeOfString:@"更多"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"更多"]];
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeBottom attachmentSize:seeMore.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentBottom];
    _textLab.truncationToken = truncationToken;
}


- (void)longPress {
//    self.block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
