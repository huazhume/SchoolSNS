//
//  HSGHMoreCommentsExternView.m
//  SchoolSNS
//
//  Created by Murloc on 14/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHMoreCommentsExternView.h"
#import "YYLabel.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHHomeModel.h"
#import "HSGHMoreCommentsHelp.h"

/**
 // View stack
 Reply line
 Reply line 
 More Reply
 **/

@interface HSGHMoreCommentsExternView() {
    int maxCount;
}

@property (nonatomic, strong) NSMutableArray* replyViews;
@property (nonatomic, strong) UIButton* moreDetailsButton;

@end


@implementation HSGHMoreCommentsExternView

#define InnerInsert     8

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        maxCount = 2;
        self.backgroundColor = HEXRGBCOLOR(0xF5F5F5);
        self.layer.borderWidth = .5f;
        self.layer.borderColor = HEXRGBCOLOR(0xe0e0e0).CGColor;
        self.layer.cornerRadius = 3.f;
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (!_replyViews) {
        _replyViews = [NSMutableArray array];
    }
    
    [_replyViews removeAllObjects];
    
    
    _moreDetailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreDetailsButton setTitle:@"查看全部回复" forState: UIControlStateNormal];
    _moreDetailsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _moreDetailsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_moreDetailsButton setTitleColor:HEXRGBCOLOR(0x272727) forState:UIControlStateNormal];
    [self addSubview: _moreDetailsButton];
}


- (void)updateDataArray:(HSGHMoreCommentsLayoutModel*)layoutModel {
    for (YYLabel* label in _replyViews) {
        [label removeFromSuperview];
    }
    [_replyViews removeAllObjects];
    
    NSUInteger dataCount = layoutModel.conversationArray.count > maxCount ? maxCount : layoutModel.conversationArray.count;
    
    CGFloat labelWidth = self.width - InnerInsert * 2;
    NSUInteger index = 0;
    for (HSGHHomeReplay* replay in layoutModel.conversationArray) {
        if (index >= dataCount) {
            break;
        }
        
        YYLabel* label = [YYLabel new];
        label.textColor = HEXRGBCOLOR(0x272727);
        label.textAlignment = NSTextAlignmentLeft;
        label.textVerticalAlignment = YYTextVerticalAlignmentTop;
        label.numberOfLines = 0;
        label.textParser = [YYTextMatchBindingParser new];
        
        //Frame
        NSAttributedString* str = [HSGHMoreCommentsHelp generateAttrStringWithFrom:replay];
        label.attributedText = str;
        
        HSGHSubCommentsLayout* subLayout = layoutModel.layout.conversationLayoutArray[index];
        label.frame = CGRectMake(InnerInsert, subLayout.top, labelWidth, subLayout.normalLabelHeight);
        [self addSubview:label];
        [_replyViews addObject:label];
        index++ ;
    }
    
    _moreDetailsButton.hidden = layoutModel.conversationArray.count < maxCount;
    if (!_moreDetailsButton.hidden) {
        _moreDetailsButton.frame = CGRectMake(InnerInsert, layoutModel.layout.cellsHeight - 20 - 2, labelWidth, 20);
    }
}
@end
