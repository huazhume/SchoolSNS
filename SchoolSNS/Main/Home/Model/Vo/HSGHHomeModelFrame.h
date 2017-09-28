//
//  HSGHHomeVoFrame.h
//  SchoolSNS
//
//  Created by Huaral on 2017/5/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModel.h"
#import "HSGHFriendBaseView.h"


typedef enum {
    QQIAN_HOME = 10001,
    QQIAN_FRIEND,
    QQIAN_MSG,
    
}QQIAN_MODE;


@interface HSGHHomeModelFrame : NSObject


@end



@interface HSGHHomeVOCommentFrame : NSObject

@property(nonatomic, assign) CGFloat commentTextHeight;
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) BOOL isMore;
@property(nonatomic, assign) CGFloat timeHeight;


@end


@interface HSGHDetailVOCommmentFrame : NSObject
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) BOOL isTime;

@end

@interface HSGHHomeQQianModelFrame : NSObject

@property (nonatomic, assign) CGFloat headNameLabelHeight;//头部 高度
@property (nonatomic, assign) CGFloat headUnivLabelHeight;//头部 高度
@property (nonatomic, assign) CGFloat contntViewImageVHeight;//内容 图片高度
@property (nonatomic, assign) CGFloat contntViewImageVX;//内容 图片左侧空白
@property (nonatomic, assign) CGFloat contntViewTextVHeight;//内容 文字高度
@property (nonatomic, assign) CGFloat contntViewTextVHeightAll;//内容全部显示时的文字高度
@property (nonatomic, assign) CGFloat commentViewVHeight;//评论区高度
@property(nonatomic, assign) CGFloat cellHeightUPCmt;//评论区以上的高度，不需重新计算
@property(nonatomic, strong) NSArray *mReplayAtt;//评论的属性字符串
@property(nonatomic, strong) NSArray *mReplayAttRow;//评论的属性字符串的行数，最多3行
@property(nonatomic, assign) CGFloat addressViewHeight;//地址栏高度
@property(nonatomic, assign) CGFloat cellAllHeight;//cell 总高度

@property(nonatomic, assign) CGFloat fstCreatorViewW;//转发时的原作者
@property(nonatomic, assign) CGFloat fstCreatorViewH;//

@property(nonatomic, assign) CGFloat secCreatorViewW;//转发时的原作者
@property(nonatomic, assign) CGFloat secCreatorViewH;//


//model
//header
@property(nonatomic, assign) CGFloat headerHeight;
//content
@property(nonatomic, assign) CGFloat contentHeight;
@property(nonatomic, assign) CGFloat contentImageH;
@property(nonatomic, assign) CGFloat contentTextH;//显示的行高，小于等于 contentTextHAll
@property(nonatomic, assign) CGFloat contentTextHAll;//文字全部显示时的高度
@property(nonatomic, assign) CGFloat contentMoreH;
@property(nonatomic, assign) CGFloat contentTextMaxH;
@property(nonatomic, assign) CGFloat contentTextToImage;
@property(nonatomic,assign) CGFloat  cellWidth;
@property(nonatomic, assign)BOOL contentIsMore;
//tools
@property(nonatomic, assign) CGFloat toolHeight;

@property(nonatomic, assign) CGFloat timeHeight;
//comment
@property(nonatomic, assign) CGFloat commentHeight;
@property(nonatomic, strong) HSGHHomeQQianModel *model;
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) BOOL isMore;
@property(nonatomic, assign) QQIAN_MODE mode;
@property(nonatomic, assign) FRINED_CATE_MODE friendMode;//好友的列表拦
@property(nonatomic, strong) NSArray <HSGHHomeVOCommentFrame *> * commentFrameArr;
- (instancetype)initWithCellWidth:(CGFloat)width WithMode:(QQIAN_MODE)mode;
- (instancetype)initWithCellWidth:(CGFloat)width WithFriendMode:(FRINED_CATE_MODE)mode ;

- (void)setQQModel:(HSGHHomeQQianModel*)qqModel;

@end


