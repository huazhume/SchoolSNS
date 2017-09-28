//
//  HSGHHomePoToVo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomePo.h"
#import "HSGHHomeModel.h"

@interface HSGHHomePoToVo : NSObject
// poToVo
+ (HSGHHomeQQianModel *)qqianPoToVo:(HSGHHomeQQianPo *)po ;
+ (HSGHHomeUniversity*)universityPoToVo:(HSGHHomeUniversityPo*)po;
+ (HSGHHomeImage*)imagePoToVo:(HSGHHomeImagePo*)po;
@end
