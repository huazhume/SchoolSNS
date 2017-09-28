//
//  HSGHHomeVoFrame.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#define contentFont [UIFont systemFontOfSize:14]
#define contentFont2 [UIFont systemFontOfSize:12]
#define universityFont [UIFont systemFontOfSize:10]
#define contentWidth [AppDelegate instanceApplication].homeContentWidth

#define max_image_contentHeight [UIFont systemFontOfSize:14].lineHeight * 2 + 4
#define max_text_contentHeight \
    [UIFont systemFontOfSize:14].lineHeight * 4 + 6.028000

#define max_imageHeight 150
#define UILABEL_LINE_SPACE 2
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

//最大高度
#define MAX_IMAGE_HEIGHT \
    [[UIScreen mainScreen] bounds].size.height - 98 - 64 - 49 - 20
#define moreToTextBottom 8
#define space 10
#define textRowHeightFloat -6


#define more_height 0

#import "NSAttributedString+YYText.h"
#import "HSGHHomeModelFrame.h"
#import "YYLabel.h"

#import "HSGHDetailCommentView.h"
#import "HSGHFriendDetailViewModel.h"
#import "HSGHVideoPageView.h"


#define HEADER_HEIGHT 104

@implementation HSGHHomeModelFrame
@end
@implementation HSGHHomeVOCommentFrame
@end

@implementation HSGHDetailVOCommmentFrame
@end

@implementation HSGHHomeQQianModelFrame
- (instancetype)initWithCellWidth:(CGFloat)width WithMode:(QQIAN_MODE)mode
{
    self = [super init];
    if (self) {
        self.cellWidth = width;
        self.mode = mode;
    }
    return self;
}
- (instancetype)initWithCellWidth:(CGFloat)width WithFriendMode:(FRINED_CATE_MODE)mode {
    self = [super init];
    if (self) {
        self.cellWidth = width;
        self.mode = QQIAN_FRIEND;
        self.friendMode = mode;
    }
    return self;
}
- (instancetype)initWithQQianModel:(HSGHHomeQQianModel*)homeQQianModel {
    self = [super init];
    if (self) {
        self.model = homeQQianModel;
    }
    return self;
}

- (CGFloat)cellAllHeight {
    if (_cellAllHeight == 0) {
        CGFloat headHeight = 98;//10+34+8+16+5+27+8;
        _headNameLabelHeight = 16;
        _headUnivLabelHeight = 27;
        if([self.model.creator.userId isEqualToString:@""]||self.model.creator.userId == nil){//匿名
            if ([self.model.forward intValue]==0) {//原创
                headHeight = 55;
                _headNameLabelHeight = 6;
                _headUnivLabelHeight = 0;
            }
        }
        _cellAllHeight += headHeight;
        
        //connent----------------------------------------------
        //内容图片
        int maxRow = 10;//文字显示最大10行，但是有图片是最大5行
        if (self.model.image != nil && self.model.image.srcUrl != nil) {
            CGFloat srcW = [self.model.image.srcWidth floatValue];
            CGFloat srcH = [self.model.image.srcHeight floatValue];
            CGFloat srcWH = srcW/srcH;
            CGFloat showW = HSGH_SCREEN_WIDTH;
            CGFloat showH = kFit(500);//竖拍图全展示的高度
            CGFloat showWH = showW/showH;
            if (srcWH > showWH) { //横图，以横向为基准计算图片大小
                showW = MIN(showW, srcW);
                showH = showW / srcWH;
            }else{//竖图，以纵向为基准计算大小
                showH = MIN(showH, srcH);
                showW = showH * srcWH;
            }
            
            if (showW<HSGH_SCREEN_WIDTH) {
                _contntViewImageVX = (HSGH_SCREEN_WIDTH-showW)/2;
            } else {
                _contntViewImageVX = 0;
            }
            
            _contntViewImageVHeight = showH;
            maxRow = 5;
            
        } else {
            _contntViewImageVHeight = 0;
        }
        _cellAllHeight += _contntViewImageVHeight;
        
        _cellAllHeight += 5;//图片下面的间距
        
        
        //是转发 Creator
        if ([self.model.forward intValue]==1) {
            CGFloat creatorW;
            
            UILabel *nuNamelbl = [[UILabel alloc] init];
            nuNamelbl.font = [UIFont systemFontOfSize:10];
            nuNamelbl.text = self.model.creator.unvi.name;
            [nuNamelbl sizeToFit];
            //HSLog(@"unvi.name=%@,nuLbl.size.width=%f",self.model.creator.unvi.name,nuNamelbl.size.width);
            CGFloat nuNamelblW = nuNamelbl.size.width;
            
            CGFloat namelblW = 0.0f;
            int tmpV = [self.model.friendStatus intValue];
            if (tmpV==FRIEND_NONE || tmpV==FRIEND_TO) {//显示加好友按钮
                UILabel *namelbl = [[UILabel alloc] init];
                namelbl.font = [UIFont systemFontOfSize:13];
                namelbl.text = self.model.creator.unvi.name;
                [namelbl sizeToFit];
                //HSLog(@"creator.displayName=%@,nuLbl.size.width=%f",self.model.creator.displayName,namelbl.size.width);
                namelblW = namelbl.size.width;
                
                if (namelblW+30+33 > 30+nuNamelblW) {
                    creatorW = namelblW+30+33;
                } else {
                    creatorW = 30+nuNamelblW;
                }
            
            } else {
                if (namelblW+30 > 30+nuNamelblW) {
                    creatorW = namelblW+30;
                } else {
                    creatorW = 30+nuNamelblW;
                }
            }
            
            
            if (creatorW>HSGH_SCREEN_WIDTH*0.67) {
                creatorW = HSGH_SCREEN_WIDTH*0.67;
            }
            
            if (_contntViewImageVHeight > 0) {// 图片
                _fstCreatorViewW = creatorW;
                _fstCreatorViewH = 49;
                
                _secCreatorViewW = 200;
                _secCreatorViewH = 0;
                
            } else {// 文字
                _fstCreatorViewW = 200;
                _fstCreatorViewH = 0;
                
                _secCreatorViewW = creatorW;
                _secCreatorViewH = 49;
                
                _cellAllHeight += 49;
            }
            
        }
//        else {
//            _fstCreatorViewW = 200;
//            _fstCreatorViewH = 0;
//            _secCreatorViewW = 200;
//            _secCreatorViewH = 0;
//        }
        
        
        //内容文字
        //_cellAllHeight += 5;
        if (self.model.content != nil && ![self.model.content isEqualToString:@""]) {
            //_contntViewTextVHeight = 50;
            //计算文字高度
            _contntViewTextVHeight = [self yylabelHieght:self.model.content Width:(HSGH_SCREEN_WIDTH - 20) maxRow:maxRow];
            
        } else {
            _contntViewTextVHeight = 0;
        }
        
        _cellAllHeight += _contntViewTextVHeight;
        _cellAllHeight += 5;
        
        
        _cellAllHeight += 3;//address到内容区的间隙
        //address
        _addressViewHeight = 0;//
        if (_model.address != nil && _model.address.address!= nil&& ![@"" isEqualToString:_model.address.address]) {
            //addressHeight = 14;  addressViewHeight
            CGSize textMaxSize = CGSizeMake(HSGH_SCREEN_WIDTH-24-8, MAXFLOAT);
            _addressViewHeight = [_model.address.address boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.height;
        }
        _cellAllHeight += _addressViewHeight;
        
        
        //tool
        CGFloat toolHeight = 62;
        _cellAllHeight += toolHeight;
        
        //NSLog(@"----计算高度---------评论区以上");
        
        //comment评论
        _commentViewVHeight = 0;
        if (self.model.partReplay != nil && self.model.partReplay.count > 0) {
            
            NSMutableArray *tmpReplayAtt = [NSMutableArray array];
            NSMutableArray *tmpReplayAttRow = [NSMutableArray array];
            for (int i=0; i<self.model.partReplay.count; i++) {
                if (i>2) {
                    break;
                }
                HSGHHomeReplay *tmpReplay = self.model.partReplay[i];
                NSMutableAttributedString *attString = [self generateAttributedStringWithCommentItemModel:tmpReplay];
                
                YYTextContainer *container = [YYTextContainer new];
                container.size = CGSizeMake(HSGH_SCREEN_WIDTH-20, CGFLOAT_MAX);
                YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
                int rows = (int)layout.rowCount;
                if (rows > 3) {
                    rows = 3;
                }
                
                [tmpReplayAtt addObject:attString];
                [tmpReplayAttRow addObject:@(rows)];
                
                _commentViewVHeight += HSGH_REPLAY_LINEHEIGHT*rows;
                _commentViewVHeight += HSGH_REPLAY_LINESPACE;//多条评论之间的间距
            }
            _mReplayAtt = [tmpReplayAtt copy];
            _mReplayAttRow = [tmpReplayAttRow copy];
            
        } else {
            _commentViewVHeight = 0;
        }
        
        //NSLog(@"----计算高度---------评论区----%f",_commentViewVHeight);
        _cellAllHeight += _commentViewVHeight;
        
        
        //底部分割线
        _cellAllHeight += 11;
    }
    
    return _cellAllHeight;
}


- (CGFloat)BF_cellAllHeight {
    /** cellHeight = cellHeightUPCmt + 评论区 + 底部分割线 */
    
    if (_cellHeightUPCmt == 0) {
        CGFloat headHeight = 108;//10+34+8+16+5+27+8;
        _headNameLabelHeight = 16;
        _headUnivLabelHeight = 27;
        if([self.model.creator.userId isEqualToString:@""]||self.model.creator.userId == nil){//匿名
            headHeight = 65;
            _headNameLabelHeight = 0;
            _headUnivLabelHeight = 0;
        }
        _cellHeightUPCmt += headHeight;
        
        //connent----------------------------------------------
        //内容图片
        int maxRow = 10;//文字显示最大10行，但是有图片是最大5行
        if (self.model.image != nil && self.model.image.srcUrl != nil) {
            int srcW = [self.model.image.srcWidth intValue];
            int srcH = [self.model.image.srcHeight intValue];
            
            int showH = (int)(HSGH_SCREEN_WIDTH * srcH * 1.0 / srcW);
            
            int maxH = HSGH_SCREEN_HEIGHT - 205;
            if (showH > maxH) {
                showH = maxH;
            }
            _contntViewImageVHeight = showH;
            maxRow = 5;
            
        } else {
            _contntViewImageVHeight = 0;
        }
        _cellHeightUPCmt += _contntViewImageVHeight;
        
        
        //内容文字
        _cellHeightUPCmt += 5;
        if (self.model.content != nil && ![self.model.content isEqualToString:@""]) {
            //_contntViewTextVHeight = 50;
            //计算文字高度
            _contntViewTextVHeight = [self yylabelHieght:self.model.content Width:(HSGH_SCREEN_WIDTH - 20) maxRow:maxRow];
            
        } else {
            _contntViewTextVHeight = 0;
        }
        
        _cellHeightUPCmt += _contntViewTextVHeight;
        _cellHeightUPCmt += 5;
        
        
        //time
        CGFloat timeHeight = 14;
        _cellHeightUPCmt += timeHeight;
        
        
        //tool
        CGFloat toolHeight = 62;
        _cellHeightUPCmt += toolHeight;
        
        //NSLog(@"----计算高度---------评论区以上");
    }
    _cellAllHeight = _cellHeightUPCmt;
    
    
    //comment评论
    _commentViewVHeight = 0;
    if (self.model.partReplay != nil && self.model.partReplay.count > 0) {
        
        NSMutableArray *tmpReplayAtt = [NSMutableArray array];
        NSMutableArray *tmpReplayAttRow = [NSMutableArray array];
        for (int i=0; i<self.model.partReplay.count; i++) {
            if (i>2) {
                break;
            }
            HSGHHomeReplay *tmpReplay = self.model.partReplay[i];
            NSMutableAttributedString *attString = [self generateAttributedStringWithCommentItemModel:tmpReplay];
            
            
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(HSGH_SCREEN_WIDTH-20, CGFLOAT_MAX);
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
            int rows = (int)layout.rowCount;
            if (rows > 3) {
                rows = 3;
            }
            
            [tmpReplayAtt addObject:attString];
            [tmpReplayAttRow addObject:@(rows)];
            
            _commentViewVHeight += HSGH_REPLAY_LINEHEIGHT*rows;
            _commentViewVHeight += HSGH_REPLAY_LINESPACE;//多条评论之间的间距
        }
        _mReplayAtt = [tmpReplayAtt copy];
        _mReplayAttRow = [tmpReplayAttRow copy];
        
    } else {
        _commentViewVHeight = 0;
    }
    
    //NSLog(@"----计算高度---------评论区----%f",_commentViewVHeight);
    _cellAllHeight += _commentViewVHeight;
    
    
    //底部分割线
    _cellAllHeight += 11;
    
    return _cellAllHeight;
}


- (void)setModel:(HSGHHomeQQianModel*)model
{
    _model = model;
    // header
    if(model.creator.userId == nil || [model.creator.userId isEqualToString:@""]){
        _headerHeight = 58 ;
    }else{
        CGFloat maxWidth = HSGH_SCREEN_WIDTH - 60;
        CGFloat nomalWidth = [self widthOfString:model.creator.unvi.name font:[UIFont systemFontOfSize:11] height:20] + 17 + 5 + 3;
        if(maxWidth < nomalWidth){
            CGFloat nomalHeight = [self getLabelHeightString:model.creator.unvi.name font:[UIFont systemFontOfSize:11] width:maxWidth -22];
            _headerHeight = HEADER_HEIGHT - 20 + nomalHeight;
            
        }else{
            _headerHeight = HEADER_HEIGHT;
        }
    }
    _headerHeight +=7;
    
    // content
    [self setContentFrame:model];
    // tools
    //    if([model.up integerValue] == 1 || _mode == QQIAN_MSG || _mode == QQIAN_FRIEND){
    _toolHeight = 64;
    //    }else{
    //        _toolHeight = 54;
    //    }
    if(_mode == QQIAN_FRIEND && (_friendMode == FRIEND_CATE_THIRD || _friendMode == FRIEND_CATE_SECOND)){
        _toolHeight = 17;
    }else{
        _toolHeight = 64;
    }
    //comment
    if (_mode == QQIAN_HOME) {
        __block CGFloat commentHeight = 0;
        if ([model.replyCount integerValue] + [model.forwardCount integerValue] > 3) {
            commentHeight = 10 + 0;
        } else {
            commentHeight = 10 + 0;
        }
        [self setCommentFrame:model];
        [self.commentFrameArr
         enumerateObjectsUsingBlock:^(HSGHHomeVOCommentFrame* _Nonnull obj,
                                      NSUInteger idx, BOOL* _Nonnull stop) {
             commentHeight += obj.cellHeight;
         }];
        _commentHeight = commentHeight;
        _timeHeight = 0;
        
    } else if(_mode == QQIAN_FRIEND){
        
        //详情评论
        
        if(self.friendMode == FRIEND_CATE_SECOND){
            _timeHeight = 29;
        }else{
            _timeHeight = 0;
        }
        __block CGFloat commentHeight = 0;
        if ([model.replyCount integerValue] + [model.forwardCount integerValue] > 3) {
            commentHeight = 30;
        } else {
            commentHeight = 30;
        }
        [self setDetailCommentFrame:model];
        [self.commentFrameArr
         enumerateObjectsUsingBlock:^(HSGHHomeVOCommentFrame* _Nonnull obj,
                                      NSUInteger idx, BOOL* _Nonnull stop) {
             
             commentHeight += obj.cellHeight;
         }];
        _commentHeight = commentHeight ;
        //加我
        if(self.friendMode == FRIEND_CATE_THIRD && [model.friendStatus integerValue] == 4){
            _commentHeight = 0;
        }
        
    }else if (_mode == QQIAN_MSG){
        //详情评论
        _timeHeight = 0;
        __block CGFloat commentHeight = 0;
        if ([model.replyCount integerValue] + [model.forwardCount integerValue] > 3) {
            commentHeight = 30;
        } else {
            commentHeight = 30;
        }
        [self setDetailCommentFrame:model];
        [self.commentFrameArr
         enumerateObjectsUsingBlock:^(HSGHHomeVOCommentFrame* _Nonnull obj,
                                      NSUInteger idx, BOOL* _Nonnull stop) {
             commentHeight += obj.cellHeight;
         }];
        _commentHeight = commentHeight;
    }
    _cellHeight = _headerHeight + _contentHeight + _toolHeight + _commentHeight +_timeHeight;
}

/** 新的set方法  */
- (void)setQQModel:(HSGHHomeQQianModel*)qqModel {
//#ifdef OPEN_VIDEO
//    [HSGHVideoPageView fixesVideoResource:qqModel];
//#endif
    _model = qqModel;
    _fstCreatorViewW = 200;
    _fstCreatorViewH = 0;
    _secCreatorViewW = 200;
    _secCreatorViewH = 0;
    return;
}

- (void)setDetailCommentFrame:(HSGHHomeQQianModel*)model
{
    NSArray* arr = model.partReplay;
    NSMutableArray* farr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        HSGHHomeReplay* repaly = arr[i];
        NSMutableAttributedString * string =
        [HSGHFriendDetailViewModel generateAttributedStringWithCommentItemModel:repaly];
        CGFloat height  =
        [self yylabelHieght:[string string] Width:HSGH_SCREEN_WIDTH -63];
        HSGHHomeVOCommentFrame* frame = [HSGHHomeVOCommentFrame new];
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(HSGH_SCREEN_WIDTH -24, CGFLOAT_MAX);
        
//        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:string];
//        if(textLayout.rowCount > 2){
//            container.maximumNumberOfRows = 2;
//            YYTextLayout *closedTextLayout = [YYTextLayout layoutWithContainer:container text:string];
//            height = closedTextLayout.textBoundingSize.height;
//        }
        
        if(i == 0 && [model.friendAddMode integerValue] == 2){
            frame.cellHeight = 94 + height - 29;
            frame.timeHeight = 0;
        }else{
            frame.cellHeight = 94 + height - 29;
            frame.timeHeight = 0;
        }
        [farr addObject:frame];
    }
    self.commentFrameArr = [NSArray arrayWithArray:farr];
}




- (void)setCommentFrame:(HSGHHomeQQianModel*)model
{
    NSArray* arr = model.partReplay;
    NSMutableArray* farr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        if (i > 2) {
            break;
        }
        HSGHHomeReplay* repaly = arr[i];
        NSMutableAttributedString * string =
            [self generateAttributedStringWithCommentItemModel:repaly];
        CGFloat height  =
            [self yylabelHieght:[string string] Width:HSGH_SCREEN_WIDTH -24];
        HSGHHomeVOCommentFrame* frame = [HSGHHomeVOCommentFrame new];
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(HSGH_SCREEN_WIDTH -24, CGFLOAT_MAX);
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:string];
        if(textLayout.rowCount > 2){
            container.maximumNumberOfRows = 2;
            YYTextLayout *closedTextLayout = [YYTextLayout layoutWithContainer:container text:string];
            height = closedTextLayout.textBoundingSize.height;
        }
        frame.commentTextHeight = height;
        frame.cellHeight = 8 + height;
        [farr addObject:frame];
    }
    self.commentFrameArr = [NSArray arrayWithArray:farr];
}





- (void)setContentFrame:(HSGHHomeQQianModel*)model
{

    //  CGFloat max_image_contentHeight = [self
    //  getTextViewHeightWithText:model.content WithLines:2];
    //  CGFloat max_text_contentHeight = [self
    //  getTextViewHeightWithText:model.content WithLines:4];

    if ([model.content isEqualToString:@""] || model.content == nil) { //内容为空 则有可能是图片
        if (![model.image.srcUrl isEqualToString:@""] && model.image.srcUrl != nil) { //确保只是图片
            _contentTextH = 0;
            _contentMoreH = 0;
            CGSize imageSize = CGSizeMake([_model.image.srcWidth integerValue],
                [_model.image.srcHeight integerValue]);
            _contentImageH = [self getImageHeightWithSize:imageSize];
            _contentHeight = _contentImageH + space;
        }
    } else { //图文
        if (![model.image.srcUrl isEqualToString:@""] && model.image.srcUrl != nil) { //确保只是图片
            //图文
            //_contentTextH = [self yylabelHieght:model.content Width:self.cellWidth - 24];
            CGSize imageSize = CGSizeMake([_model.image.srcWidth integerValue],
                [_model.image.srcHeight integerValue]);
            _contentImageH = [self getImageHeightWithSize:imageSize];
            
            _contentTextH = [self yylabelHieght:model.content Width:self.cellWidth - 24 maxRow:5];
            
            _contentTextMaxH = _contentTextH;
            //_contentMoreH = more_height;
            _contentTextToImage = 10;
            _contentHeight = _contentTextH + _contentImageH + _contentTextToImage + moreToTextBottom;
            
//            if (_contentTextH > max_image_contentHeight) {
//                //大于
//                if ([_model.contentIsMore integerValue] == 1) {
//                    _contentTextMaxH = _contentTextH;
//                    _contentMoreH = more_height;
//                    _contentTextToImage = 10;
//                    _contentHeight = _contentImageH + _contentTextToImage + _contentTextH + _contentMoreH + moreToTextBottom;
//                } else {
//
//                    _contentTextMaxH = _contentTextH;
//                    _contentTextH = max_image_contentHeight;
//                    _contentMoreH = more_height;
//                    _contentTextToImage = 10;
//                    _contentHeight = _contentImageH + _contentTextToImage + max_image_contentHeight + _contentMoreH + moreToTextBottom;
//                }
//            } else {
//
//                _contentTextMaxH = _contentTextH;
//                _contentMoreH = 0;
//                _contentTextToImage = 10;
//                _contentHeight = _contentTextH + _contentImageH + _contentTextToImage + moreToTextBottom;
//            }
        } else {
            //文字
            _contentImageH = 0;
            //_contentTextH = [self yylabelHieght:model.content Width:self.cellWidth - 24];
            //NSLog(@"----qqianId=%@",self.model.qqianId);
            _contentTextH = [self yylabelHieght:model.content Width:(self.cellWidth - 24) maxRow:10];
            
            _contentTextMaxH = _contentTextH;
            _contentMoreH = 0;
            _contentHeight = _contentTextH + moreToTextBottom;
            
            
//            if (_contentTextH > max_text_contentHeight) {
//
//                //大于
//                if ([_model.contentIsMore integerValue] == 1) {
//                    _contentTextMaxH = _contentTextH;
//                    //             _contentTextH = _contentTextH;
//                    _contentMoreH = more_height;
//                    _contentHeight = _contentTextH + _contentMoreH + moreToTextBottom;
//
//                } else {
//                    _contentTextMaxH = _contentTextH;
//                    _contentTextH = max_text_contentHeight;
//                    _contentMoreH = more_height;
//                    _contentHeight = max_text_contentHeight + _contentMoreH + moreToTextBottom;
//                }
//            } else {
//                _contentTextMaxH = _contentTextH;
//                _contentMoreH = 0;
//                _contentHeight = _contentTextH + moreToTextBottom;
//            }
        }
    }
}

//计算yylabel的文字显示高度，最后一个参数为最大行数
- (CGFloat)yylabelHieght:(NSString*)string Width:(CGFloat)width maxRow:(int)maxrow {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_minimumLineHeight = 16.0f;
    text.yy_maximumLineHeight = 16.0f;
    text.yy_lineSpacing = 2.0f;
    text.yy_lineBreakMode = NSLineBreakByWordWrapping;
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = HEXRGBCOLOR(0x272727);
    
    self.model.contentAtt = text;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    int rows = (int)layout.rowCount;
    //NSLog(@"计算的行数rowCount=%zd",rows);
    
    _contntViewTextVHeightAll = rows*18.0 + 2;
    
    if (rows > maxrow) {
        rows = maxrow;
    }
    
    return rows*18.0 + 2;
}


//YYlabel String
- (NSMutableAttributedString*)generateAttributedStringWithString:(NSString*)content
{
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:UN_NIL_STR(content)];
    attString.yy_color = HEXRGBCOLOR(0x272727);
    attString.yy_font = [UIFont systemFontOfSize:14];
    attString.yy_lineSpacing = UILABEL_LINE_SPACE;
    return attString;
}

//YYlabel layout
- (CGFloat)yylabelHieght:(NSString*)attriString Width:(CGFloat)width
{
    YYTextContainer* container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout* textLayout = [YYTextLayout layoutWithContainer:container text:[self generateAttributedStringWithString:attriString]];
    //    container.maximumNumberOfRows = 2;
    //    YYTextLayout *closedTextLayout = [YYTextLayout layoutWithContainer:container text:[self generateAttributedStringWithString:attriString]];

    return textLayout.textBoundingSize.height;
}

#pragma mark - common
//计算UILabel的高度(带有行间距的情况)

- (CGFloat)getSpaceLabelHeight:(NSString*)str
                      withFont:(UIFont*)font
                     withWidth:(CGFloat)width
{
    NSMutableParagraphStyle* paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary* dic =
        @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paraStyle };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width - 16, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil]
                      .size;
    return size.height + 16;
}

//- (CGFloat)getTextViewHeightWithText:(NSString *)text
//WithLines:(NSInteger)lines {
//    BOOL isLimitedToLines = NO;
//    CGSize textSize = [text textSizeWithFont:contentFont numberOfLines:lines
//    lineSpacing:UILABEL_LINE_SPACE constrainedWidth:self.cellWidth - 20 - 16
//    isLimitedToLines:&isLimitedToLines];
//    return textSize.height + 16;
//}

- (CGFloat)getImageHeightWithSize:(CGSize)size
{
    int scale = size.width / (size.height * 1.0);
    CGFloat expectHeight = (self.cellWidth / size.width) * size.height;
    if (scale >= 1) {
        //宽度大于高度
    }
    //  //  CGFloat endImageHight;

    CGFloat max = [[UIScreen mainScreen] bounds].size.height - 98 - 64 - 49 - 20;

    if (expectHeight > max) {

        //大于最大图片的高度
        expectHeight = max;
//            self.model.mode = UIViewContentModeScaleAspectFit;

    } else {
        //小于最大图片的高度
        //    self.model.mode = UIViewContentModeScaleToFill;
    }
    return expectHeight;
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(HSGHHomeReplay *)model {
    NSString *text = model.fromUser.displayName;
    if (model.toUser.displayName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复 %@", model.toUser.displayName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
    NSMutableAttributedString *attString;
    
    if (text != nil) {
        attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
    attString.yy_minimumLineHeight = 14.0f;
    attString.yy_maximumLineHeight = 14.0f;
    attString.yy_lineBreakMode = NSLineBreakByWordWrapping;
    attString.yy_font = [UIFont systemFontOfSize:14];
    if (attString != nil) {
        if(model.fromUser.displayName){
            [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:[text rangeOfString:model.fromUser.displayName]];
        }
        if (model.toUser.displayName) {
            [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:[text rangeOfString:model.toUser.displayName]];
        }
    }
    attString.yy_lineSpacing = 2;
    attString.yy_color = HEXRGBCOLOR(0x272727);
    return attString;
}

//详情评论
//         __block CGFloat commentHeight = 0;
//        if ([model.replyCount integerValue] + [model.forwardCount integerValue] > 3) {
//            commentHeight = 5 + 30;
//        } else {
//            commentHeight = 5 + 20;
//        }
//        [self setDetailCommentFrame:model];
//        [self.commentFrameArr
//         enumerateObjectsUsingBlock:^(HSGHHomeVOCommentFrame* _Nonnull obj,
//                                      NSUInteger idx, BOOL* _Nonnull stop) {
//             commentHeight += obj.cellHeight;
//         }];
//        _commentHeight = commentHeight;
- (CGFloat)getLabelHeightString:(NSString*)text font:(UIFont*)font width:(CGFloat)width
{
    CGSize contentSize = [text
                          sizeWithFont:font
                          constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize.height ;
}

- (CGFloat)widthOfString:(NSString*)string
                    font:(UIFont*)font
                  height:(CGFloat)height
{
    NSDictionary* dict =
    [NSDictionary dictionaryWithObject:font
                                forKey:NSFontAttributeName];
    CGRect rect =
    [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                      attributes:dict
                         context:nil];
    return rect.size.width;
}
@end
