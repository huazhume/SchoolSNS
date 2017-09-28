//
//  HSGHAnotation.h
//  MapDemo
//
//  Created by Huaral on 2017/5/2.
//  Copyright © 2017年 Huaral. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HSGHAnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;//经纬度
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *subtitle;//副标题
@property(nonatomic, copy) NSString *icon;
@end
