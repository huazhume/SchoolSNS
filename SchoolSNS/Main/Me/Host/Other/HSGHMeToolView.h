//
//  HSGHMeToolView.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHHomeModelFrame.h"

typedef void (^ToolBtnClickedBlock)(NSInteger tag);

@interface HSGHMeToolView : UIView


//@property (nonatomic,copy)ToolBtnClickedBlock block;
@property(nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic,copy)ToolBtnClickedBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionWidth;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *utcLab;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;

@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UILabel *forwardLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *utcWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationWidth;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *upLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (assign ,nonatomic) BOOL isFriend;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdToFourth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTosecond;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondToThird;

@property (weak, nonatomic) IBOutlet UIButton *upBtn;




- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF;
@end
