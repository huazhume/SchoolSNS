//
//  HSGHLocationCoder.h
//  MapDemo
//
//  Created by Huaral on 2017/5/2.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HSGHLocationCoder: NSObject
/**
 *  地理编码 （通过地址获取经纬度）
 *
 *  @param address       输入的地址
 *  @param success       成功block，返回pm
 *  @param failure       失败block
 */
- (void)geocode:(NSString *)address
        success:(void (^)(CLPlacemark *pm))success
        failure:(void (^)())failure;

/**
 *  反地理编码 （通过经纬度获取地址）
 *
 *  @param location      位置
 *  @param success       成功block，返回pm
 *  @param failure       失败block
 */
- (void)reverseGeocodeWithlocation:(CLLocation *)location
                           success:(void (^)(CLPlacemark *pm))success
                           failure:(void (^)())failure;




@end
