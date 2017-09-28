//
//  HSGHLocationManager.h
//  MapDemo
//
//  Created by Huaral on 2017/5/2.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <GooglePlaces/GooglePlaces.h>

#define kAMapSearchAPIPOISuccess @"AMapSearchAPIPOISuccess"//poi成功

@interface HSGHPOIInfo : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *subName;
@property(nonatomic, assign) double longitude; //经度
@property(nonatomic, assign) double latitude;  //纬度
@end

@interface HSGHLocationManager : NSObject

@property(strong, nonatomic) NSLock* lock;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(nonatomic, assign) double longitude; //经度
@property(nonatomic, assign) double latitude;  //纬度
@property(nonatomic, copy) NSString *name; // eg. Apple Inc.
@property(nonatomic, readonly, copy) NSString *thoroughfare; // street name, eg. Infinite Loop
@property(nonatomic, readonly, copy) NSString *subThoroughfare; // eg. 1
@property(nonatomic, readonly, copy) NSString *locality; // city, eg. Cupertino
@property(nonatomic, readonly, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property(nonatomic, readonly, copy) NSString *administrativeArea; // state, eg. CA
@property(nonatomic, readonly, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property(nonatomic, readonly, copy) NSString *postalCode; // zip code, eg. 95014
@property(nonatomic, readonly, copy) NSString *ISOcountryCode; // eg. US
@property(nonatomic, readonly, copy) NSString *country; // eg. United States
@property(nonatomic, readonly, copy) NSString *inlandWater; // eg. Lake Tahoe
@property(nonatomic, readonly, copy) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic ,assign)CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) AMapSearchAPI *AMapSearch;//高德POI
@property (nonatomic, assign) BOOL isChina;//0中国(默认),1外国,POI检索用高德或谷歌
@property(nonatomic, strong) void (^googlePickPlaceCompleteBlock)(HSGHPOIInfo* poiInfo);

//定位结束的回调
@property(nonatomic, strong) void (^locationCompleteBlock)
        ();

/**
 唯一实例

 @return self
 */
+ (instancetype)sharedManager;

- (void)fetchPOIInfo:(void (^)(NSArray *array))dataBlock;

/**
 授权
 */
- (void)getAuthorization;

/**
 提示用户打开定位开关
 */
- (void)alertOpenLocationSwitch;

/**
 点击某个按钮开始定位
 */
- (void)startLocation;

- (void)endLocation;


- (void)fetchLocationDescriptionInfo:(void (^)(BOOL success, NSString * subName))dataBlock ;

- (void)fetchCoordinate:(void(^)(CLLocationCoordinate2D coordinate))coordinateBlock ;

//开启google POI检索
- (void)postGooglePOIVC;
@end
