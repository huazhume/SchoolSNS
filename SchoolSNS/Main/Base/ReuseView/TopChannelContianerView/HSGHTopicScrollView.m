//
//  WYTopicScrollView.m
//  WYNews
//
//  Created by dai.fengyi on 15/5/27.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "HSGHTopicScrollView.h"
#import "HSGHCategoryButton.h"


#define kWidthMargin        0
#define kAddChannelWidth   21
#define kLineWidth   70

#define kTopicHeaderBgColor  [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]

@interface HSGHTopicScrollView ()<UIScrollViewDelegate>


@property (strong, nonatomic) UIView  *lineView;

@property (assign, nonatomic) NSInteger oldIndex;
@property (strong, nonatomic) NSMutableArray  *btnArray;

@property (strong, nonatomic) UIButton  * selectedBtn;

@end

@implementation HSGHTopicScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        _btnArray = [NSMutableArray array];
        [self setupUI];
        [self registerNotification];
        
    }
    return self;
}
#pragma mark - 初始化
- (void)setupUI
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, HSLFullScreenWidth, self.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor =RGBCOLOR(255, 255, 255);
    [self addSubview:_scrollView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = HEXRGBCOLOR(0xff520d);
//    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_add_shadow"]];
//    [self addSubview:shadowImageView];
//    [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_scrollView);
//        make.left.mas_equalTo(BFLFullScreenWidth - kAddChannelWidth - 60);
//        make.size.mas_equalTo(CGSizeMake(55,44));
//    }];
    
//    UIButton *addChannelButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    //self.addButton = addChannelButton;
//    [addChannelButton setImage:[UIImage imageNamed:@"home_header_add"] forState:UIControlStateNormal];
//    [addChannelButton setImage:[UIImage imageNamed:@"home_header_add_press"] forState:UIControlStateHighlighted];
//    addChannelButton.backgroundColor = [UIColor clearColor];
//    addChannelButton.frame = CGRectMake(BFLFullScreenWidth - kAddChannelWidth - 10, 11, kAddChannelWidth, kAddChannelWidth);
//    [addChannelButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:addChannelButton];

//    _redImageView = [[UIImageView alloc] init];
   // _redImageView.image = [UIImage imageNamed:@"icon_news_bubble"];
  //  _redImageView.backgroundColor = [UIColor clearColor];
   // [addChannelButton addSubview:_redImageView];
   // _redImageView.hidden = YES;
//   // [_redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(addChannelButton);
//        make.right.equalTo(addChannelButton.mas_right).offset(0);
//        make.size.mas_equalTo(CGSizeMake(5, 5));
//    }];
}

- (void)registerNotification
{
    [self addObserver:self forKeyPath:@"oldIndex" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIView *oldView = self.scrollView.subviews[_oldIndex];
    
    CGFloat offSetx = oldView.center.x - self.scrollView.frame.size.width * 0.5;
    if (offSetx < 0) {
        offSetx = 0;
    }
    CGFloat extraBtnW = 30;
    CGFloat maxOffSetX = self.scrollView.contentSize.width - (self.scrollView.frame.size.width - extraBtnW);
    
    if (maxOffSetX < 0) {
        maxOffSetX = 0;
    }
    
    if (offSetx > maxOffSetX) {
        offSetx = maxOffSetX;
    }
    
   // [self.scrollView setContentOffset:CGPointMake(offSetx, 0.0) animated:YES];

}

- (void)setTopicArray:(NSArray *)topicArray
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _topicArray = topicArray;
    for (int i = 0; i < _topicArray.count; i++) {
        HSGHCategoryButton *button = [[HSGHCategoryButton alloc] init];
        [button setTitle:topicArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(categoryButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i *HSLFullScreenWidth/topicArray.count, 0, HSLFullScreenWidth/topicArray.count, 34);
        
        if (self.scrollView.subviews.count == 0) {
//            button.frame = (CGRect){CGPointMake(kWidthMargin, 0), button.bounds.size};
        }else {
          //  button.frame = (CGRect){CGPointMake(CGRectGetMaxX([(UIView *)self.scrollView.subviews.lastObject frame]) + kWidthMargin, 0), button.bounds.size};
        }
        //显示hot小图标
        if (_hotArray.count && [[_hotArray objectAtIndex:i] isEqualToString:@"1"])
        {
            UIImage * hotImage = [UIImage imageNamed:@"home_channel_hot"];
            UIImageView * hotImageView = [[UIImageView alloc] initWithImage:hotImage];
            hotImageView.frame = (CGRect){CGPointMake(button.bounds.size.width-hotImage.size.width, 3), hotImageView.size};
            [button addSubview:hotImageView];
        }
        
        [self.scrollView addSubview:button];
        [self.btnArray addObject:button];
    }
   // self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([(UIView *)self.scrollView.subviews.lastObject frame]) + kWidthMargin, 0);
    self.scrollView.contentSize = CGSizeMake( HSLFullScreenWidth, 0);
    
    [_scrollView addSubview:_lineView];
    HSGHCategoryButton * btn = self.btnArray.firstObject;
    btn.selected= YES;
    self.selectedBtn = btn;

    btn.iconImageView.image = [UIImage imageNamed:@"xlk-tc-darh"];
    _lineView.frame = CGRectMake(0, _scrollView.height-2, kLineWidth, 2);
    _lineView.centerx = btn.centerx;
    
    
}


-(void)setOffsetX:(CGFloat)offsetX
{
    _offsetX = offsetX;
    if (!_topicArray) {
        return;
    }
    float abc_offsetX = ABS(_offsetX);
    int index = (int)abc_offsetX;
    float delta = abc_offsetX - index;
    HSGHCategoryButton *oldButton = self.scrollView.subviews[index];
//    HSLog(@"old is %d , new is %d+1\n, index is %d", _oldIndex, _oldIndex + 1, index);
    oldButton.scale = 1 - delta;
    //最后一个
    if (index < _topicArray.count - 1) {
        HSGHCategoryButton *newbutton = self.scrollView.subviews[index + 1];
        newbutton.scale = delta;
    }
    //整数才赋值
    if (index == abc_offsetX) {
        self.oldIndex = index;
    }

}


#pragma mark - Button Action
- (void)categoryButtonSelected:(HSGHCategoryButton *)sender
{
    if ( self.selectedBtn == sender) {
        
        if (sender == self.btnArray.firstObject) {
            if ([self.topicDelegate respondsToSelector:@selector(firsTopicOnClickTwiceScrollViewDidSelectButton:)]) {
                [self.topicDelegate firsTopicOnClickTwiceScrollViewDidSelectButton:sender];

            }
        }
        return;
    }
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    //可优化,实现新旧按钮的变化
    _offsetX = [self.scrollView.subviews indexOfObject:sender];
    if (_offsetX != _oldIndex) {
        HSGHCategoryButton *oldButton = self.scrollView.subviews[_oldIndex];
        oldButton.scale = 0;
        sender.scale = 0;
        self.oldIndex = _offsetX;
        
//        [self.topicDelegate topicScrollViewDidSelectButton:_offsetX];
    }
    [self.topicDelegate topicScrollViewDidSelectButton:_offsetX];
    
    
    
    WS(ws);
    
    [UIView animateWithDuration:0.25 animations:^{
        ws.lineView.centerx = sender.centerx;
        
    }];

}


-(void)lineViewScrollWithindex:(NSInteger)index
{
    HSGHCategoryButton *sender = self.btnArray[index];
    
    WS(ws);
    
    [UIView animateWithDuration:0.25 animations:^{
        ws.lineView.centerx = sender.centerx;
        
    }];

    
}
#pragma mark 点击addButton,展示或隐藏添加channel的View
- (void)clickAddButton:(UIButton *)button{
   // self.redImageView.hidden = YES;
    if ([self.topicDelegate respondsToSelector:@selector(showOrHiddenAddChannelsCollectionView:)]) {
        [self.topicDelegate showOrHiddenAddChannelsCollectionView:button];
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"oldIndex" context:nil];
}


@end
