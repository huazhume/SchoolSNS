//
//  HSGHFriendVoToPo.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHFriendPo.h"
#import "HSGHFriendViewModel.h"
#import "HSGHHomeVoToPo.h"
#import "HSGHFriendBaseView.h"


@interface HSGHFriendVoToPo : NSObject

+ (HSGHFriendPo *)friendVoToPo:(HSGHFriendSingleModel *)vo WithType:(FRINED_CATE_TYPE)mode;


@end
