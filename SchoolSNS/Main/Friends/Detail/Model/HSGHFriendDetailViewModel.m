//
//  HSGHFriendDetailViewModel.m
//  SchoolSNS
//
//  Created by Huaral on 2017/6/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendDetailViewModel.h"
#import "HSGHHomeModel.h"
#import "HSGHNetworkSession.h"
#import "HSGHHomeModelFrame.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"



@implementation HSGHFriendDetailViewModel



+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"qqians" : [HSGHHomeQQianModel class] };
}

//成为好友的新鲜事儿
+ (void)fetchFriendDetailWithUserID:(NSString *)userID WithMode:(FRINED_CATE_MODE)mode :(void (^)(BOOL success, NSArray *array))fetchBlock {
    
    NSString * url = @"";
    NSDictionary *dic = [NSDictionary dictionary];
    
    if(mode == FRIEND_CATE_FRIST){//search
        url = HSGHHomeFriendPersonMostHotDetailURL;
        dic = @{@"userId":userID,@"type":@2};
    }else if (mode == FRIEND_CATE_SECOND){ //好友
        url = HSGHHomeQQiansFriendDetailURL;
         dic = @{@"userId":userID};
    }else if (mode == FRIEND_CATE_THIRD){ //加我
        url = HSGHHomeFriendReceiveDetailURL;
         dic = @{@"userId":userID};
    }else if (mode == FRIEND_CATE_FORTH){ //加他
        url = HSGHHomeFriendSendDetailURL;
         dic = @{@"userId":userID};
    }
    [HSGHNetworkSession postReq:url
                   appendParams:dic
                    returnClass:[self class]
                          block:^(HSGHFriendDetailViewModel *obj, NetResStatus status,
                                  NSString *errorDes) {
                              if (status == NetResSuccess) {
                                  if (fetchBlock) {
                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians WithMode:mode]);
                                  }
                              } else {
                                  if (fetchBlock) {
                                      fetchBlock(NO, nil);
                                  }
                              }
                              
                          }];
    
}

/*
 #define HSGHHomeFriendReceiveDetailURL [HSGHServerLoginHost stringByAppendingPathComponent: @"/web/friendApply/user/receive/query"]
 #define HSGHHomeFriendSendDetailURL [HSGHServerLoginHost stringByAppendingPathComponent: @"/web/friendApply/user/receive/query"]
 ///web/qqian/query/personMostHot
 #define HSGHHomeFriendPersonMostHotDetailURL [HSGHServerLoginHost stringByAppendingPathComponent: @"/web/qqian/query/personMostHot"]
 */



+ (NSMutableArray *)transToHomeViewFrameWithHomeModel:(NSArray *)modelArr WithMode:(FRINED_CATE_MODE)mode{
    NSMutableArray *muArr = [NSMutableArray array];
    [modelArr enumerateObjectsUsingBlock:^(HSGHHomeQQianModel *obj, NSUInteger idx,
                                      BOOL *_Nonnull stop) {
        HSGHHomeQQianModelFrame *modelF =
        [[HSGHHomeQQianModelFrame alloc] initWithCellWidth:HSGH_SCREEN_WIDTH WithFriendMode:mode];
        modelF.model = obj;
        [muArr addObject:modelF];
    }];
    return muArr;
}
//首页数据
//+ (void)fetchFistViewModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock {
//    [HSGHNetworkSession postReq:HSGHHomeTestURL
//                   appendParams:@{@"from":@0,@"size":@10,@"type":@3}
//                    returnClass:[self class]
//                          block:^(HSGHFriendDetailViewModel *obj, NetResStatus status,
//                                  NSString *errorDes) {
//                              if (status == NetResSuccess) {
//                                  if (fetchBlock) {
//                                      fetchBlock(YES,[self transToHomeViewFrameWithHomeModel:obj.qqians]);
//                                      
//                                  }
//                              } else {
//                                  if (fetchBlock) {
//                                      fetchBlock(NO, nil);
//                                  }
//                              }
//                              
//                          }];
//    
//
//}
//



+ (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:
(HSGHHomeReplay *)model {
    NSString *text = @"";
    if (model.toUser.displayName.length) {
        text = [text
                stringByAppendingString:[NSString
                                         stringWithFormat:@"回复 %@",
                                         model.toUser.displayName]];
        text =
        [text stringByAppendingString:[NSString stringWithFormat:@"：%@",
                                       model.content]];

    }else{
        text =
        [text stringByAppendingString:[NSString stringWithFormat:@"%@",
                                       model.content]];
    }
    NSMutableAttributedString *attString;
    
    if (text != nil) {
        attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
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

@end
