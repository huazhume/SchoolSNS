//
//  HSGHLocationCoder.m
//  MapDemo
//
//  Created by Huaral on 2017/5/2.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import "HSGHLocationCoder.h"
#import <CoreLocation/CoreLocation.h>

#define PI 3.141592653

@interface HSGHLocationCoder ()

@property(nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation HSGHLocationCoder
- (CLGeocoder *)geocoder {
  if (!_geocoder) {
    _geocoder = [[CLGeocoder alloc] init];
  }
  return _geocoder;
}

#pragma mark - 地理编码
- (void)geocode:(NSString *)address
        success:(void (^)(CLPlacemark *pm))success
        failure:(void (^)())failure {
  [self.geocoder geocodeAddressString:address
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                      if (error) {
                        if (failure) {
                          failure();
                        }
                      } else { // 编码成功
                        //取出最前面的地址
                        CLPlacemark *pm = [placemarks firstObject];
                        if (success) {
                          success(pm);
                        }
                      }
                    }];
}

#pragma mark - 反地理编码
- (void)reverseGeocodeWithlocation:(CLLocation *)location
                           success:(void (^)(CLPlacemark *pm))success
                           failure:(void (^)())failure {
  
  [self.geocoder reverseGeocodeLocation:location
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error) {
                          HSLog(@"%@", error.description);
                          if (failure) {
                            failure();
                          }
                        } else {
                          CLPlacemark *pm = [placemarks firstObject];
                          if (success) {
                            success(pm);
                          }
                        }
                      }];
}




@end
