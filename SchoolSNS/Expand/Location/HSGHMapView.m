//
//  HSGHMapView.m
//  MapDemo
//
//  Created by Huaral on 2017/5/2.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import "HSGHMapView.h"
#import <MapKit/MapKit.h>
#import "HSGHLocationManager.h"
#import "HSGHAnotation.h"
#import "HSGHLocationCoder.h"

@interface HSGHMapView () <MKMapViewDelegate>
@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(copy, nonatomic) NSString *address;
@property(assign, nonatomic) float longitude;
@property(assign, nonatomic) float latitude;

@end
@implementation HSGHMapView

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  HSGHLocationManager *gps = [HSGHLocationManager sharedManager];
  [gps getAuthorization]; //授权
  [gps startLocation];    //开始定位
  //跟踪用户位置
  self.mapView.userTrackingMode = MKUserTrackingModeFollow;
  //地图类型
  //    self.mapView.mapType = MKMapTypeSatellite;
  self.mapView.delegate = self;
}

#pragma mark - 事件
/**
 点击重新定位

 @param tap 点击手势
 */
- (void)tap:(UITapGestureRecognizer *)tap {
  CGPoint touchPoint = [tap locationInView:tap.view];
  CLLocationCoordinate2D coordinate =
      [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

  HSLog(@"%@", self.mapView.annotations);
  NSMutableArray *array = [NSMutableArray array];
  NSUInteger count = self.mapView.annotations.count;
  if (count > 1) {
    for (id obj in self.mapView.annotations) {
      if (![obj isKindOfClass:[MKUserLocation class]]) {
        [array addObject:obj];
      }
    }
    [self.mapView removeAnnotations:array];
  }
  //  MKUserLocation *locationAnno = self.mapView.annotations[0];
  HSGHAnotation *anno = [[HSGHAnotation alloc] init];

  anno.coordinate = coordinate;
  anno.title = [NSString stringWithFormat:@"经度：%f", coordinate.longitude];
  anno.subtitle = [NSString stringWithFormat:@"纬度：%f", coordinate.latitude];

  self.longitude = coordinate.longitude;
  //反地理编码
//  HSGHLocationCoder *locCoder = [[HSGHLocationCoder alloc] init];

//  [locCoder reverseGeocodeWithlatitude:coordinate.latitude
//                             longitude:coordinate.longitude
//                               success:^(NSString *address) {
//                                 NSLog(@"___%@", address);
//
//                               }
//                               failure:^{
//
//                               }];
  [self.mapView addAnnotation:anno];
  [self.mapView setCenterCoordinate:coordinate animated:YES];
}

#pragma mark - delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
  //如果是定位的大头针就不用自定义
  if (![annotation isKindOfClass:[HSGHAnotation class]]) {
    return nil;
  }

  static NSString *ID = @"anno";
  MKAnnotationView *annoView =
      [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
  if (annoView == nil) {
    annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                            reuseIdentifier:ID];
  }

  HSGHAnotation *anno = annotation;
  annoView.image = [UIImage imageNamed:@"map_locate_blue"];
  annoView.annotation = anno;
  return annoView;
}

- (void)mapView:(MKMapView *)mapView
    didSelectAnnotationView:(MKAnnotationView *)view {
  HSLog(@"didSelectAnnotationView--%@", view);
}

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation:(MKUserLocation *)userLocation {
  CLLocationCoordinate2D center = userLocation.location.coordinate;
  userLocation.title =
      [NSString stringWithFormat:@"经度：%f", center.longitude];
  userLocation.subtitle =
      [NSString stringWithFormat:@"纬度：%f", center.latitude];

  HSLog(@"定位：%f %f --- %i", center.latitude, center.longitude,
        mapView.showsUserLocation);

  if (mapView.showsUserLocation) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      //监听MapView点击
      HSLog(@"添加监听");
      [mapView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                                action:@selector(tap:)]];
    });
  }
}

@end
