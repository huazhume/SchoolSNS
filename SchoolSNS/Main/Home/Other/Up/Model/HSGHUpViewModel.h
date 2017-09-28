//
//  HSGHUpViewModel.h
//  SchoolSNS
//
//  Created by Huaral on 2017/6/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGHHomeModel.h"

@interface HSGHUpViewModel : NSObject
@property (nonatomic, strong) NSArray * upUserVos;
+ (void)fetchUpViewModelArrWithPage:(NSInteger) pageNumber WithQqianId:(NSString *)qqianID :(void (^)(BOOL success, NSArray *array))fetchBlock ;


@end

