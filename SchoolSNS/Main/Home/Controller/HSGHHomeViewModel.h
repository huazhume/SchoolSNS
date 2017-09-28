//
//  HSGHHomeViewModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModelFrame.h"
#import "HSGHHomeBaseView.h"

typedef enum{
    HSGH_NONETWORK_MODE = 0,
    HSGH_YESWAN_MODE,
    HSGH_YESWIFT_MODE
}HSGH_NetworkType_MODE;



@interface HSGHHomeViewModel : NSObject
@property (nonatomic,strong) NSArray * qqians;

@property (nonatomic,copy) NSString * replyId;
+(HSGH_NetworkType_MODE)inspectNetwork ;

//评论
+ (void)fetchCommentWithParams:(NSDictionary *)params :(void (^)(BOOL success, NSString * replayId))fetchBlock ;
+ (void)fetchForwardWithParams:(NSDictionary *)params :(void (^)(BOOL success,NSString * replayId ))fetchBlock;
//取消转发
+ (void)forwardCancelWithParams:(NSDictionary *)params :(void (^)(BOOL success,NSString * replayId ))fetchBlock;
//回复
+ (void)fetchReplayWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock;

//首页数据
+ (void)fetchTestModelArr:(void (^)(BOOL success, NSArray *array))fetchBlock;

+ (void)fetchRemoveWithParams:(NSDictionary *)params :(void (^)(BOOL success))fetchBlock;

//首页分页数据
+ (void)fetchFistViewModelArrWithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock ;
//附近数据分页
+ (void)fetchSecondViewModelArrWithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock ;
//全网数据分页
+ (void)fetchThirdViewModelArrWithPage:(NSInteger) pageNumber :(void (^)(BOOL success, NSArray *array))fetchBlock ;


+ (HSGHHomeQQianModelFrame *)commentQQianModel:(HSGHHomeQQianModel *)model WithText:(NSString *)text Mode :(EDIT_MODE)editMode;
+ (HSGHHomeQQianModelFrame *)upQQianModel:(HSGHHomeQQianModel *)model ;

//save 
+ (void)saveData:(NSArray<HSGHHomeQQianModel *> *)datas WithType:(HOME_MODE)mode ;

+ (NSArray *)fetchDataWithType:(HOME_MODE)mode ;

+ (NSMutableArray *)transToHomeViewFrameWithHomeModel:(NSArray *)modelArr;

//search
+ (void)fetchSearchQQiansModelArrWitQQiansID :(NSString *)qqiansId :(void (^)(BOOL success, NSArray *array))fetchBlock ;
+ (void)cancelUpQqians:(NSString *)userID :(NSString*)qqianID replyID:(NSString*)replyID block:(void(^)(BOOL success))fetchBlock;

@end
