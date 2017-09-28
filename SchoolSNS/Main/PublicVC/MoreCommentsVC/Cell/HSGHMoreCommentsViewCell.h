//
//  MyView.h
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

#import "HSGHHomeModel.h"
#import "HSGHMoreCommentsModel.h"
#import "YYLabel.h"
#import <UIKit/UIKit.h>
#import "SchoolSNS-Swift.h"



@protocol HSGHMoreCommentsViewCellProtocol <NSObject>
@optional
- (void)clickExtended:(NSIndexPath *)indexPath
     refreshIndexPath:(NSIndexPath *)refreshIndexPath;
- (void)clickUP:(NSIndexPath *)indexPath block:(void (^)(BOOL success))block;
- (void)clickWholeButton:(NSIndexPath *)indexPath;
- (void)clickEnterDetails:(NSIndexPath *)indexPath;
- (void)cancelUP:(NSIndexPath *)indexPath block:(void (^)(BOOL success))block;

@end

@interface HSGHMoreCommentsViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIButton *friendButton;
@property(weak, nonatomic) IBOutlet UILabel *numberLabel;
@property(weak, nonatomic) IBOutlet UIButton *praiseButton;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UIImageView *schoolImageView;
@property(weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet AnimatableButton *headIconButton;
@property (weak, nonatomic) IBOutlet AnimatableView *headIconBackgroundView;

@property(strong, nonatomic) NSIndexPath *indexPath;
@property(strong, nonatomic) NSIndexPath *refreshIndexPath;

@property(nonatomic, copy) void(^block)(NSString *userId,NSIndexPath *indexPath);
@property(nonatomic, weak) id<HSGHMoreCommentsViewCellProtocol> delegate;

@property (nonatomic, copy) NSString *qqianId;

+ (CGFloat)getLabelWidth;

- (void)updateUPState:(BOOL)up;

- (void)updateInfo:(HSGHMoreCommentsLayoutModel *)layoutModel
           indexPath:(NSIndexPath *)indexPath
       needClickMore:(BOOL)needClickMore
    refreshIndexPath:(NSIndexPath *)refreshIndexPath;

- (void)setToDetail:(BOOL)isDetail;
//- (void)updateInfo:(HSGHHomeReplay *)data indexPath:(NSIndexPath *)indexPath
// needClickMore:(BOOL)needClickMore
// refreshIndexPath:(NSIndexPath*)refreshIndexPath;
@end
