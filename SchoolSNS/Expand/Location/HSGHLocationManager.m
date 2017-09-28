//
//  HSGHLocationManager.m
//  MapDemo
//
//  Created by Huaral on 2017/5/2.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "HSGHLocationManager.h"
#import "HSGHLocationCoder.h"
#import "WGS84TOGCJ02.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>

@implementation HSGHPOIInfo
@end

@interface HSGHLocationManager () <CLLocationManagerDelegate, AMapSearchDelegate>

@property (nonatomic, strong) GMSPlacesClient *placesClient;
@property (nonatomic, strong) GMSPlacePicker *placePicker;

@end

@implementation HSGHLocationManager

/**
 唯一实例

 @return self
 */

+ (instancetype)sharedManager {
    static HSGHLocationManager *_sharedGps = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGps = [[HSGHLocationManager alloc] init];
        _sharedGps.coordinate = CLLocationCoordinate2DMake(-1, -1);
        _sharedGps.lock = [NSLock new];
    });
    return _sharedGps;
}

/**
 授权

 kCLAuthorizationStatusNotDetermined： 用户尚未做出决定是否启用定位服务
 kCLAuthorizationStatusRestricted： 没有获得用户授权使用定位服务
 kCLAuthorizationStatusDenied：用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
 kCLAuthorizationStatusAuthorizedAlways：应用获得授权可以一直使用定位服务，即使应用不在使用状态
 kCLAuthorizationStatusAuthorizedWhenInUse： 使用此应用过程中允许访问定位服务

 */
- (void)getAuthorization {
    if ([self.locationManager
            respondsToSelector:@selector(requestWhenInUseAuthorization)]) {

        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;

            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestWhenInUseAuthorization];
                break;
            case kCLAuthorizationStatusDenied:
                [self alertOpenLocationSwitch];
                break;
            default:
                break;
        }
    }
}

/**
 提示用户打开定位开关
 */

- (void)alertOpenLocationSwitch {
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:@""
                  message:@"开启系统定位后\n才能搜索到附近和全网新鲜事"
                 delegate:self
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil, nil];
    [alert show];
}

/**
 点击某个按钮开始定位
 */
- (void)startLocation {
    [_locationManager startUpdatingLocation];
}

- (void)endLocation {
    [_locationManager stopUpdatingLocation];
}

#pragma mark - LocationManager

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //定位精确度
        _locationManager.distanceFilter = 100; // 10米定位一次
    }
    return _locationManager;
}

#pragma mark -locationManager delegate
//- (void)locationManager:(CLLocationManager *)manager
// didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (status == kCLAuthorizationStatusAuthorizedAlways || status ==
//    kCLAuthorizationStatusAuthorizedWhenInUse) {
//        [manager startUpdatingLocation];
//    }
//}

#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    //判断一下国家
    HSGHLocationCoder *locationCoder = [[HSGHLocationCoder alloc] init];
    [locationCoder reverseGeocodeWithlocation:location success:^(CLPlacemark *pm) {
        self.isChina = ![@"中国" isEqualToString:pm.country];
    } failure:^{
    }];
    
    //取出经纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    _longitude = coordinate.longitude;
    _latitude = coordinate.latitude;
    
    WGS84TOGCJ02* coverCoor = [[WGS84TOGCJ02 alloc]init];
    if (![WGS84TOGCJ02 isLocationOutOfChina:coordinate])
    {
        coordinate = [coverCoor zzTransGPS:coordinate];
    }
    coverCoor = nil;
    
    
    self.coordinate = coordinate;
    // 3.打印经纬度
    HSLog(@"didUpdateLocations------%f %f", coordinate.latitude,
            coordinate.longitude);
    if (self.locationCompleteBlock) {
        self.locationCompleteBlock();
        [self fetchLocationDescriptionInfo:^(BOOL success, NSString *subName) {
            self.name = subName;
        
        }];
    }
    [_locationManager stopUpdatingLocation]; //停止定位
}



#pragma mark 获取经纬度

- (void)fetchCoordinate:(void(^)(CLLocationCoordinate2D coordinate))coordinateBlock {
    [self getAuthorization];
    [self startLocation];
    __weak HSGHLocationManager *weakSelf = self;
    self.locationCompleteBlock = ^{
        coordinateBlock(weakSelf.coordinate);
    };
}


- (void)fetchLocationDescriptionInfo:(void (^)(BOOL success, NSString * subName))dataBlock {
    __weak HSGHLocationManager *manager = [HSGHLocationManager sharedManager];
    [manager getAuthorization];
    [manager startLocation];
    HSGHLocationCoder *locationCoder = [[HSGHLocationCoder alloc] init];
    manager.locationCompleteBlock = ^{
       [locationCoder reverseGeocodeWithlocation:[HSGHLocationManager covertToNewLocation: manager.locationManager.location] success:^(CLPlacemark *pm) {
           dataBlock(YES ,pm.name);
       } failure:^{
           dataBlock(NO, nil);
       }];
    };
         
}


+ (CLLocation*)covertToNewLocation:(CLLocation*)location {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    WGS84TOGCJ02* coverCoor = [[WGS84TOGCJ02 alloc]init];
    if (![WGS84TOGCJ02 isLocationOutOfChina:coordinate])
    {
        coordinate = [coverCoor zzTransGPS:coordinate];
    }
    coverCoor = nil;
    
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}


- (void)fetchPOIInfo:(void (^)(NSArray *array))dataBlock {
    __block NSMutableArray *poiMutableArray = @[].mutableCopy;
    __weak HSGHLocationManager *manager = [HSGHLocationManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [manager getAuthorization];
    [manager startLocation];
    HSGHLocationCoder *locationCoder = [[HSGHLocationCoder alloc] init];
    manager.locationCompleteBlock = ^{
        CLLocation* location = [HSGHLocationManager covertToNewLocation: manager.locationManager.location];
        [locationCoder reverseGeocodeWithlocation:location success:^(CLPlacemark *pm) {
            HSLog(@"成功%@__%@__%@__%@__%@", pm.name, pm.thoroughfare, pm.locality, pm.administrativeArea, pm.country);
            //楚河南路__楚河南路__武汉市__湖北省__中国
            //First add city
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            
            if ([@"中国" isEqualToString:pm.country]) {//高德
                AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
                //request.keywords = @"北京大学";
                request.city = pm.locality;
                request.types = @"餐饮服务|商务住宅|生活服务";
                request.requireExtension = YES;
                request.offset = 50;//条数
                request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude];
                request.sortrule = 0;//排序规则, 0-距离排序；1-综合排序, 默认0
                request.cityLimit = YES;//只搜索本城市的POI
                request.requireSubPOIs = YES;
                
                [self.AMapSearch AMapPOIKeywordsSearch:request];
                
            } else {
                
            }
        }failure:^{
            HSLog(@"定位failed");
            if (dataBlock) {
                dataBlock(@[]);
            }
        }];
    };
}


+ (void)writePoiByLock:(NSMutableArray*)array obj:(HSGHPOIInfo*)obj {
    [[HSGHLocationManager sharedManager].lock lock];
    [array addObject:obj];
    [[HSGHLocationManager sharedManager].lock unlock];
}

+ (void)searchByAllKeys:(NSArray*)allKeys coordinate:(CLLocationCoordinate2D)coordinate block:(void (^)(NSArray *array))block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_t group = dispatch_group_create();
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
        __block NSMutableArray* allPois = [NSMutableArray array];

        for (NSString* key in allKeys) {
            dispatch_group_enter(group);
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
                request.region = region;
                request.naturalLanguageQuery = key;
                MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
                [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
                    if (!error) {
                        [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            if (obj) {
                                HSGHPOIInfo* poi = [HSGHPOIInfo new];
                                poi.name = obj.name ? obj.name : @"";
                                if (obj.placemark == nil) {
                                    poi.subName = @"";
                                } else {
                                    if ([obj.placemark.country isEqualToString:@"China"]
                                        || [obj.placemark.country isEqualToString:@"中国"]) {
                                        poi.subName = [NSString stringWithFormat:@"%@,%@ %@",
                                                       UN_NIL_STR(obj.placemark.locality),
                                                       UN_NIL_STR(obj.placemark.subLocality),
                                                       UN_NIL_STR(obj.placemark.thoroughfare)];
                                    } else {
                                        poi.subName = [NSString stringWithFormat:@"%@,%@ %@",
                                                       UN_NIL_STR(obj.placemark.thoroughfare), UN_NIL_STR(obj.placemark.subLocality),
                                                       UN_NIL_STR(obj.placemark.locality)];
                                    }
                                    poi.latitude = obj.placemark.coordinate.latitude;
                                    poi.longitude = obj.placemark.coordinate.longitude;
                                }
                                
                                HSLog(@"详细地址是 %@", poi.subName);
                                [HSGHLocationManager writePoiByLock:allPois obj:poi];
                                //                            [allPois addObject:poi];
                            }
                        }];
                    }
                    dispatch_group_leave(group);
                    
                }];
            });
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(allPois);
            }
        });
    });
}

#pragma mark - AMapSearch 高德
- (AMapSearchAPI *)AMapSearch {
    if (!_AMapSearch) {
        [AMapServices sharedServices].apiKey = @"5d2f7a2d88bc9d84b7ce79c4a7653686";
        _AMapSearch = [[AMapSearchAPI alloc] init];
        _AMapSearch.delegate = self;
        
    }
    return _AMapSearch;
}

#pragma mark - AMapSearch 高德POI 搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    //NSLog(@"response.pois.count=%zd",response.pois.count);
    
    if (response.pois.count < 1) {
        return;
    }
    
    NSMutableArray *rstMarr = [NSMutableArray array];
    
    //武汉市
//    AMapPOI *apoi = response.pois[0];
//    HSGHPOIInfo* poi = [HSGHPOIInfo new];
//    poi.name = apoi.city;
//    poi.subName = @"";
//    poi.latitude = apoi.location.latitude;
//    poi.longitude = apoi.location.longitude;
//    [rstMarr addObject:poi];
    
    for (AMapPOI *apoi in response.pois) {
        HSGHPOIInfo* poi = [HSGHPOIInfo new];
        poi.name = apoi.name;
        poi.subName = [NSString stringWithFormat:@"%@%@%@%@",
                       UN_NIL_STR(apoi.province),
                       UN_NIL_STR(apoi.city),
                       UN_NIL_STR(apoi.district),
                       UN_NIL_STR(apoi.address)
                       ];
        poi.latitude = apoi.location.latitude;
        poi.longitude = apoi.location.longitude;
        
        [rstMarr addObject:poi];
    }
    
    NSDictionary *userInfo = @{@"poiArr": [rstMarr copy]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAMapSearchAPIPOISuccess object:nil userInfo:userInfo];
}
#pragma mark - google map

//开启google POI检索
- (void)postGooglePOIVC {
    CLLocationCoordinate2D center = self.coordinate;
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
//    CLLocationCoordinate2D center = self.coordinate;
//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
//                                                                  center.longitude + 0.001);
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
//                                                                  center.longitude - 0.001);
//    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
//                                                                         coordinate:southWest];
//    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
//    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
//    
//    __weak typeof(self) weakSelf = self;
//    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
//        if (error != nil) {
//            HSLog(@"Google Pick Place error %@", [error localizedDescription]);
//            return;
//        }
//        if (place != nil) {
////            NSString *nametext = place.name;
////            NSString *addresstext = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
////            NSLog(@"nametext====%@,addresstext=%@",nametext,addresstext);
////            
////            
////            NSLog(@"name=%@",place.name);
////            NSLog(@"latitude=%f",place.coordinate.latitude);
////            NSLog(@"longitude=%f",place.coordinate.longitude);
////            NSLog(@"formattedAddress=%@",place.formattedAddress);
//            
//            HSGHPOIInfo* poi = [HSGHPOIInfo new];
//            poi.name = place.name ? place.name : @"";
//            poi.subName = place.formattedAddress ? place.formattedAddress : @"";
//            poi.latitude = place.coordinate.latitude;
//            poi.longitude = place.coordinate.longitude;
//            
//            
//            if (weakSelf.googlePickPlaceCompleteBlock) {
//                weakSelf.googlePickPlaceCompleteBlock(poi);
//            }
//            
//        } else {
//            HSLog(@"No place selected");
//        }
//    }];
}

@end
