//
//  ZHZTransfrome.h
//  parkingTest
//
//  Created by zhanghangzhen on 16/1/7.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface ZHZTransfrome : NSObject

- (CLLocation*)locationMarsFromEarth;

//从火星坐标转化到百度坐标
- (CLLocation*)locationBaiduFromMars;

//从百度坐标到火星坐标
- (CLLocation*)locationMarsFromBaidu;

//从火星坐标到地图坐标
- (CLLocation*)locationEarthFromMars;

//从百度坐标到地图坐标
- (CLLocation*)locationEarthFromBaidu;


@end
