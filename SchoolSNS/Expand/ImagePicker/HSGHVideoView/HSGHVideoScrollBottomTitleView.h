//
//  HSGHVideoScrollBottomTitleView.h
//  SchoolSNS
//
//  Created by Murloc on 31/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGHVideoStatus.h"

typedef void(^SelectedTitleBlock)(NSUInteger index);
typedef void(^DeleteBlock)();
typedef void(^WillDeleteBlock)();

@interface HSGHVideoScrollBottomTitleView : UIView

@property (nonatomic, copy) SelectedTitleBlock selectedBlock;

@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, copy) WillDeleteBlock willDeleteBlock;

- (void)updateUIState:(VideoBottomUIType)type;

- (void)refreshUI:(TakePhotoType)type;

- (void)enterVideo;

@end
