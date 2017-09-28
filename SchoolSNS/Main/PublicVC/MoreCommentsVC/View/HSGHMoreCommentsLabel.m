//
//  HSGHMoreCommentsLabel.m
//  SchoolSNS
//
//  Created by Murloc on 14/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHMoreCommentsLabel.h"
#import "YYLabel.h"
#import "HSGHCommentsCallFriendViewModel.h"

@interface HSGHMoreCommentsLabel() {
    @private int maxCount;
}

@property (nonatomic, strong) YYLabel* yylabel;
@property (nonatomic, strong) UIButton* moreExtendedButton;

@end

@implementation HSGHMoreCommentsLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    
    if (self) {
        maxCount = 10;
        [self setupViews];
        [self setupFrames];
    }
    
    return self;
}


- (void)setupViews {
    _yylabel = [YYLabel new];
    _yylabel.userInteractionEnabled = YES;
    _yylabel.textColor = HEXRGBCOLOR(0x272727);
    _yylabel.textAlignment = NSTextAlignmentLeft;
    _yylabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _yylabel.numberOfLines = 0;
    _yylabel.textParser = [YYTextMatchBindingParser new];
    [self addSubview:_yylabel];
    
//    _moreExtendedButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_moreExtendedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _moreExtendedButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    [_moreExtendedButton setTitle: @"显示更多" forState: UIControlStateNormal];
//    [_moreExtendedButton setTitle: @"收起" forState: UIControlStateSelected];
//    _moreExtendedButton.width = 100;
//    _moreExtendedButton.height = 20;
//    [_moreExtendedButton addTarget:self action:@selector(clickExtended) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview: _moreExtendedButton];
}


- (void)setupFrames {
    _yylabel.width = self.width;
    _yylabel.height = 30;
}

- (void)clickExtended {
    _moreExtendedButton.selected = !_moreExtendedButton.selected;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}


- (void)setContent:(HSGHMoreCommentsLayoutModel*)layoutModel {
    _yylabel.attributedText = [[NSAttributedString alloc] initWithString:layoutModel.cellReplay.content];
    
    _yylabel.width = self.width;
    _yylabel.height = layoutModel.layout.normalLabelHeight;
    [_yylabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
//    _moreExtendedButton.top = _yylabel.bottom;
//    _moreExtendedButton.hidden = YES; //!layoutModel.layout.isShowMore;
//    _moreExtendedButton.left = self.width - _moreExtendedButton.width;
}

//- (void)setContent:(NSAttributedString*)string {
//    _yylabel.attributedText = string;
//}

@end
