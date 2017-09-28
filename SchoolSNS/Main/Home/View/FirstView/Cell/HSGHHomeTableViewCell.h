//
//  HSGHHomeTableViewCell.h
//  SchoolSNS
//
//  Created by 陈位 on 2017/8/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WebVideoCache.h"

typedef void (^MoreBtnClickedBlock)();
typedef void (^CommonBtnClickBlock)();
typedef void (^ForwardBtnClickBlock)();
typedef void (^UpBtnClickBlock)(CGRect);
typedef void (^HeadShareBtnClickBlock)();
typedef void (^ToolIconsViewClickBlock)();


typedef NS_OPTIONS(NSInteger, JPPlayUnreachCellStyle) {
    JPPlayUnreachCellStyleNone = 1 << 0,  // normal 播放滑动可及cell
    JPPlayUnreachCellStyleUp = 1 << 1,    // top 顶部不可及
    JPPlayUnreachCellStyleDown = 1<< 2    // bottom 底部不可及
};


@class HSGHHomeQQianModelFrame;
@interface HSGHHomeTableViewCell : UITableViewCell 

/** head分享 */
@property(nonatomic, copy) HeadShareBtnClickBlock headShareBtnClickBlock;
/** 查看更多 */
@property(nonatomic, copy) MoreBtnClickedBlock moreBtnClickedBlock;
/** 点击评论 */
@property(nonatomic, copy) CommonBtnClickBlock commonBtnClickBlock;
/** 点击转发 */
@property(nonatomic, copy) ForwardBtnClickBlock forwardBtnClickBlock;
/** 点赞 */  /** 双击图片 或者 文字内容 */
@property(nonatomic, copy) UpBtnClickBlock upBtnClickBlock;
/** 点击点赞人员列表 */
@property(nonatomic, copy) ToolIconsViewClickBlock toolIconsViewClickBlock;


@property (weak, nonatomic) IBOutlet UIImageView *cntImageView;
/** videoPath */
@property(nonatomic, strong)NSString *videoPath;

/** indexPath */
//@property(nonatomic, strong)NSIndexPath *indexPath;

/** cell类型 */
@property(nonatomic, assign)JPPlayUnreachCellStyle cellStyle;

@property(nonatomic, strong) UIButton* muteButton;

//model
@property (nonatomic, strong) HSGHHomeQQianModelFrame* modelF;

@property (weak, nonatomic) IBOutlet UIView *contentViewImage;//cntImage的父视图

//- (void)setModelF:(HSGHHomeQQianModelFrame *)modelF;
- (void)setModelF:(HSGHHomeQQianModelFrame *)modelF showDistance:(BOOL)showDistance;//是否显示距离
- (IBAction)fstCreatorAddBtnClick:(id)sender;
- (IBAction)secCreatorAddBtnClick:(id)sender;

- (void)refreshDianzan;
@end
