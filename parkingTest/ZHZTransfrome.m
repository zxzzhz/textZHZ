//
//  ZHZTransfrome.m
//  parkingTest
//
//  Created by zhanghangzhen on 16/1/7.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZTransfrome.h"

@interface ZHZTransfrome ()
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@end
@implementation ZHZTransfrome
- (CLLocation*)locationMarsFromEarth
{
//    double lat = 0.0;
//    double lng = 0.0;
//    transform_earth_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
//    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat+self.coordinate.latitude, lng+self.coordinate.longitude)
//                                         altitude:self.altitude
//                               horizontalAccuracy:self.horizontalAccuracy
//                                 verticalAccuracy:self.verticalAccuracy
//                                           course:self.course
//                                            speed:self.speed
//                                        timestamp:self.timestamp];
    return nil;
}

- (CLLocation*)locationEarthFromMars
{
//    double lat = 0.0;
//    double lng = 0.0;
//    transform_earth_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
//    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.coordinate.latitude-lat, self.coordinate.longitude-lng)
//                                         altitude:self.altitude
//                               horizontalAccuracy:self.horizontalAccuracy
//                                 verticalAccuracy:self.verticalAccuracy
//                                           course:self.course
//                                            speed:self.speed
//                                        timestamp:self.timestamp];
    return nil;
}

- (CLLocation*)locationBaiduFromMars
{
//    double lat = 0.0;
//    double lng = 0.0;
//    transform_mars_from_baidu(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
//    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
//                                         altitude:self.altitude
//                               horizontalAccuracy:self.horizontalAccuracy
//                                 verticalAccuracy:self.verticalAccuracy
//                                           course:self.course
//                                            speed:self.speed
//                                        timestamp:self.timestamp];
    return nil;
}

- (CLLocation*)locationMarsFromBaidu
{
    double lat = 0.0;
    double lng = 0.0;
//    transform_baidu_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
//    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
//                                         altitude:self.altitude
//                               horizontalAccuracy:self.horizontalAccuracy
//                                 verticalAccuracy:self.verticalAccuracy
//                                           course:self.course
//                                            speed:self.speed
//                                        timestamp:self.timestamp];
    return nil;
}

-(CLLocation*)locationEarthFromBaidu
{
//    double lat = 0.0;
//    double lng = 0.0;
//    CLLocation *Mars = [self locationMarsFromBaidu];
    
//    transform_earth_from_mars(Mars.coordinate.latitude, Mars.coordinate.longitude, &lat, &lng);
//    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(Mars.coordinate.latitude-lat, Mars.coordinate.longitude-lng)
//                                         altitude:self.altitude
//                               horizontalAccuracy:self.horizontalAccuracy
//                                 verticalAccuracy:self.verticalAccuracy
//                                           course:self.course
//                                            speed:self.speed
//                                        timestamp:self.timestamp];
    return nil;
}
@end
