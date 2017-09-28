//
//  HSGHDetailCommentCell.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHDetailCommentCell.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+YYText.h"
#import "YYText.h"
#import "NSAttributedString+YYText.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHHomeViewModel.h"





@implementation HSGHDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconbgView.layer.cornerRadius = 14.5;
    self.iconbgView.layer.masksToBounds = YES;
    self.iconbgView.layer.borderWidth = 0.5;
    self.iconbgView.layer.borderColor = [[UIColor colorWithRed:188 / 255.0 green:188 / 255.0 blue:188 / 255.0 alpha:1] CGColor];
    self.icon.layer.cornerRadius = 12.5;
    self.icon.layer.masksToBounds = YES;
    // Initialization code
    
    _textLab = [[YYLabel alloc]init];
    [self.textViewLab addSubview:self.textLab];
    _textLab.numberOfLines = 0;
    _textLab.textAlignment = NSTextAlignmentLeft;
    
    [_textLab mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_textViewLab);
        make.top.mas_equalTo(_textViewLab);
        make.bottom.mas_equalTo(_textViewLab);
        make.right.mas_equalTo(_textViewLab);
    }];
    [self addSeeMoreButton];
     _textLab.textParser = [YYTextMatchBindingParser new];
}



- (void)addSeeMoreButton {
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...更多"];
//    
//    YYTextHighlight *hi = [YYTextHighlight new];
//    [hi setColor:HEXRGBCOLOR(0x272727)];
//    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        //        [_textLab sizeToFit];
//    };
//    [text yy_setFont:[UIFont systemFontOfSize:14]range:[text.string rangeOfString:@"更多"]];
//    [text yy_setColor:HEXRGBCOLOR(0x272727) range:[text.string rangeOfString:@"更多"]];
//    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"更多"]];
//    YYLabel *seeMore = [YYLabel new];
//    seeMore.attributedText = text;
//    [seeMore sizeToFit];
//    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeBottomRight attachmentSize:seeMore.size alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentBottom];
//    _textLab.truncationToken = truncationToken;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
