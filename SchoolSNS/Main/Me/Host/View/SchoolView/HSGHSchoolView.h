//
// Created by FlyingPuPu on 08/05/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHUserInf.h"


@interface HSGHSchoolView : UIView

@property (weak, nonatomic) IBOutlet UIView *schoolContainsView;

@property (nonatomic, copy) NSString *city;
@property (weak, nonatomic) IBOutlet UIButton *changeCityBtn;

@property void(^modifyAddress)();

- (void)updateIsMineInfo:(BOOL)isMine;

- (void)updateContainsView:(BachelorUniversity*)bachelorUniv masterUnvi:(BachelorUniversity*)masterUniv highSchool:(BachelorUniversity*)highSchool;


+ (CGFloat)calcWholeHeight:(BachelorUniversity*)bachelorUniv masterUnvi:(BachelorUniversity*)masterUniv highSchool:(BachelorUniversity*)highSchool;
@end
