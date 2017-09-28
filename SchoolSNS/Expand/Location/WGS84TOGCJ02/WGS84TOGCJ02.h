//
//  WGS84TOGCJ02.h
//  VideoShare
//
//  Created by wanliming on 14-2-18.
//  Copyright (c) 2014年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02:NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps;
@end
