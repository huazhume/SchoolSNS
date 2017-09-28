//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSGHHeadView : UIView
@property (nonatomic, copy)NSString *bgPath;
@property (nonatomic, copy)NSString *headPath;
@property (nonatomic, copy)NSString *sexType;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *signature;
@property(nonatomic, strong) UIImageView *headImageView; //contain the headImage

@property (nonatomic, copy) void (^didClickSettingsBlock)();
@property (nonatomic, copy) void (^didClickEditNickNameBlock)();
@property (nonatomic, copy) void (^didClickEditSignatureBlock)();
@property (nonatomic, copy) void (^didClickChangeHeadPhotoBlock)();
@property (nonatomic, copy) void (^didClickChangeBGPhotoBlock)();
@property (nonatomic, copy) void (^doUpdateSignaturBlock)(BOOL status);
@property (nonatomic, copy) void (^doUpdateNickNameBlock)(BOOL status);
@property (nonatomic, copy) void (^doUpdateEngNameBlock)(BOOL status);
//otherZoneVC
@property (nonatomic, copy) void (^didClickOtherZoneHeadPhotoBlock)();



- (void)updateBGImage:(UIImage*)image;
- (void)updateHeadIconImage:(UIImage*)image;
- (instancetype)initWithFrame:(CGRect)frame isMine:(BOOL)isMine;
- (void)enterEditMode:(BOOL)isEdit isSingle:(BOOL)isSingle;
- (NSString*)fetchEditedText;
- (void)updateSignature;
- (UIImage*)fetchCurrentHeadImage;
@end
