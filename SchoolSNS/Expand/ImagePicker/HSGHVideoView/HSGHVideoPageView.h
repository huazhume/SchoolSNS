//
//  HSGHCropCoverView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 29/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHVideoScrollBottomView.h"
#import "HSGHHomeModel.h"

typedef void(^DidTakePhotoBlock)(UIImage* image);

typedef void(^DidVideoStart)();
typedef void(^DidVideoPause)();
typedef void(^DidVideoStop)(NSString* outPutUrl);
typedef void(^DidCanSave)(BOOL canSave);  //是否能保存的标识


@interface HSGHVideoPageView : UIView

@property (nonatomic, strong) HSGHVideoScrollBottomView* bottomScrollView;
@property (nonatomic, copy) DidTakePhotoBlock photoBlock;

@property (nonatomic, copy) DidVideoStart videoStartBlock;
@property (nonatomic, copy) DidVideoPause videoPauseBlock;
@property (nonatomic, copy) DidVideoStop videoFinishedBlock;

@property (nonatomic, copy) DidCanSave didCanSaveBlock;


-(void)startCamera;
- (void)cancelAction;
- (void)deleteLastSession;
- (BOOL)hasSession;

- (void)saveVideo:(void(^)(BOOL success, UIImage* albumImage, NSString* outputURL))block;

- (BOOL)canSave;

- (void)stopSession;

+ (void)fixesVideoResource:(HSGHHomeQQianModel*)model;
@end
