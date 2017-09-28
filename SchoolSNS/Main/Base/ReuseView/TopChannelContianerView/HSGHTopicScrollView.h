//
//  WYTopicScrollView.h
//  WYNews
//
//  Created by dai.fengyi on 15/5/27.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicScrollViewDelegate <NSObject>

@optional
- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button;
- (void)topicScrollViewDidChanged:(NSArray *)selectedArray;
- (void)topicScrollViewDidSelectButton:(NSInteger)selectedButtonIndex;
- (void)firsTopicOnClickTwiceScrollViewDidSelectButton:(UIButton *)btn;

@end

@interface HSGHTopicScrollView : UIView

@property (nonatomic, weak) id<TopicScrollViewDelegate> topicDelegate;
@property (nonatomic, strong) NSArray *topicArray;
@property (nonatomic, strong) NSArray *hotArray;
@property (nonatomic, assign) CGFloat offsetX;  //两个scrollView靠offsetX联系起来
//@property (nonatomic, strong) UIImageView *redImageView;
@property (strong, nonatomic) UIScrollView  *scrollView;

//@property (weak,nonatomic) UIButton *addButton;

-(void)lineViewScrollWithindex:(NSInteger)index;
@end
