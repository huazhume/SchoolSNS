//
//  HSGHZoneEditEngNameView.h
//  SchoolSNS
//
//  Created by FlyingPuPu on 28/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputKit.h"

@interface HSGHZoneEditEngNameView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) TXLimitedTextField* firstNameTF;
@property (nonatomic, strong) TXLimitedTextField* middleNameTF;
@property (nonatomic, strong) TXLimitedTextField* lastNameTF;
@property (nonatomic, strong) UILabel* lastNameLabel;
@property (nonatomic, copy) void (^doUpdateEngNameBlock)(BOOL status);

- (BOOL)hasChange;
- (void)toReponse;
- (void)updateDefaultName;
@end
