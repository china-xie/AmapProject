//
//  driveWayViewController.h
//  AMapProject
//
//  Created by xie on 2017/8/10.
//  Copyright © 2017年 xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import  <MAMapKit/MAMapKit.h>
#import  <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import  <AMapLocationKit/AMapLocationKit.h>
#import <AVFoundation/AVFoundation.h>
@interface driveWayViewController : UIViewController

@property(nonatomic,assign)CLLocationCoordinate2D annotation;

@property(nonatomic,strong)AMapPOI * poi;
@property(nonatomic,assign)BOOL isNowWay;
@end
