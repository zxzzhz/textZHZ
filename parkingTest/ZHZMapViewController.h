//
//  ZHZMapViewController.h
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


@interface ZHZMapViewController : UIViewController<BMKMapViewDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;

}

@end
