//
//  HSGHHomeVoToPo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomePo.h"
#import "HSGHHomeModel.h"
#import "HSGHHomeBaseView.h"

@interface HSGHHomeVoToPo : NSObject
// voToPo
+ (HSGHHomeQQianPo*)qqianVoToPo:(HSGHHomeQQianModel*)vo WithType:(HOME_MODE)mode ;
+ (HSGHHomeUniversityPo*)universityVoToPo:(HSGHHomeUniversity*)vo;
+ (HSGHHomeImagePo*)imageVoToPo:(HSGHHomeImage*)vo;

@end
