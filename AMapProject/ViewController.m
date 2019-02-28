//
//  ViewController.m
//  AMapProject
//
//  Created by xie on 2017/8/9.
//  Copyright © 2017年 xie. All rights reserved.
//
#import  <Masonry.h>
#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
#import  <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import  <AMapSearchKit/AMapSearchObj.h>
#import "hotCityViewController.h"
#import "driveWayViewController.h"

@interface ViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>
@property(nonatomic,strong)MAMapView * mapView;
///大头针
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@property (nonatomic, strong) MAPinAnnotationView *annotationView;
//逆地理编码
@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;

@property (nonatomic, strong) AMapLocationManager *locationManager;

//逆地理编码使用的
@property (nonatomic, strong) AMapSearchAPI *search;
@property(nonatomic,strong)UIView * bottomView;
@property(nonatomic,strong)UIButton * startLabel;
@property(nonatomic,strong)UIButton * endLabel;
@property(nonatomic,strong)UIButton * exchangeBtn;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

///传过来的终点站
@property(nonatomic,strong)AMapPOI * destationPoi;

///重新定位
@property(nonatomic,strong)UIButton * getLocationButton;

///驾车导航按钮
@property(nonatomic,strong)UIButton * driveBtn;

@property(nonatomic,assign)BOOL  isNowWay;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.toolbar.translucent   = YES;
//    self.navigationController.toolbarHidden         = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.locationManager startUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"优e出行";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"Left"
                                            
                                                                          style:UIBarButtonItemStylePlain
                                            
                                                                         target:self
                                            
                                                                         action:@selector(presentLeftMenuViewController:)];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"Right"
                                             
                                                                           style:UIBarButtonItemStylePlain
                                             
                                                                          target:self
                                             
                                                                          action:@selector(presentRightMenuViewController:)];
    
    UIImageView*imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    imageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    imageView.image= [UIImage imageNamed:@"redPin_lift"];
    
    [self.view addSubview:imageView];
    
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
   _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120)];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    _mapView.delegate= self;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
//    [_mapView setZoomLevel:17.5 animated:YES];
//    _mapView.zoomEnabled = YES;
//    _mapView.scrollEnabled = YES ;
//    _mapView.rotateEnabled= YES;
//    _mapView.showsCompass= YES;
//    MAMapStatus *status = [self.mapView getMapStatus];
//    status.screenAnchor = CGPointMake(0.5, 0.5);//地图左上为(0,0)点，右下为(1,1)点。
//    [self.mapView setMapStatus:status animated:NO];
   
    
//    NSString *path = [NSString stringWithFormat:@"%@/mystyle_sdk_1510206859_0100.data", [NSBundle mainBundle].bundlePath];
//     NSString *file = [[NSBundle mainBundle] pathForResource:@"0100.data" ofType:nil];
    NSString *file = [NSString stringWithFormat:@"%@/mystyle_sdk_1510210749_0100.data", [NSBundle mainBundle].bundlePath];
    NSData *data = [NSData dataWithContentsOfFile:file];
    [self.mapView setCustomMapStyleWithWebData:data];
    [self.mapView setCustomMapStyleEnabled:YES];
      [self addbottomView];

    
 
    
    [self initCompleteBlock];
    
    [self configLocationManager];
//    [self getLocation];

    [self reGeocodeAction];
  
    //进行单次带逆地理定位请求
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEnd:) name:@"destantionNotify" object:nil];
    
    
    self.getLocationButton = [[UIButton alloc]init];
    
    [self.getLocationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.getLocationButton setTitle:@"重新定位" forState:UIControlStateNormal];
    
    self.getLocationButton.frame = CGRectMake(0, self.view.frame.size.height-160, 100, 50);
    
    [_mapView addSubview:self.getLocationButton];
    
    [self.getLocationButton addTarget:self action:@selector(getLocationAgain) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.driveBtn = [[UIButton alloc]init];
    
    [self.driveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.driveBtn setTitle:@"驾车导航" forState:UIControlStateNormal];
    
    self.driveBtn.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-160, 100, 50);
    
    [_mapView addSubview:self.driveBtn];
    
    [self.driveBtn addTarget:self action:@selector(goToDriveWayVc) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.isNowWay = YES;
}


- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:2];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
//    [self.locationManager setDetectRiskOfFakeLocation:NO];
 
}
#pragma mark----重定位
-(void)getLocationAgain{

    [self reGeocodeAction];
}
- (void)reGeocodeAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            
            [_startLabel setTitle:regeocode.formattedAddress forState:UIControlStateNormal] ;
        }
    }];
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}
#pragma mark - Initialization

- (void)initCompleteBlock
{
//    __weak ViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        _pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [_pointAnnotaiton setCoordinate:location.coordinate];
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            [_startLabel setTitle:regeocode.formattedAddress forState:UIControlStateNormal];
        
            [_pointAnnotaiton setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            [_pointAnnotaiton setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            [_pointAnnotaiton setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [_pointAnnotaiton setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
        }
        
//        ViewController *strongSelf = weakSelf;
        [self addAnnotationToMapView:_pointAnnotaiton];
    };
}


- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:16 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}



-(void)addbottomView{
    
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width, 120)];
        
        [self.view addSubview:_bottomView];
    
    _bottomView.backgroundColor = [UIColor whiteColor];
      _startLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width-80, 60)];
        
        [_startLabel setTitle:@"请选择起点" forState:UIControlStateNormal];
    [_startLabel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [_bottomView addSubview:_startLabel];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadStartLabel) name:@"reloadStartLabel" object:nil];
        
        _endLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 60, _bottomView.frame.size.width-80, 60)];
    
    [_endLabel setTitle:@"请选择终点" forState:UIControlStateNormal];
    [_endLabel setTitleColor: [UIColor darkGrayColor] forState:UIControlStateNormal];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEndLabel) name:@"reloadEndLabel" object:nil];
        
        [_bottomView addSubview:_endLabel];
    [_endLabel addTarget:self action:@selector(selectEndIndex) forControlEvents:UIControlEventTouchUpInside];
    
    self.exchangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(_bottomView.frame.size.width-80, 0, 80, 120)];
    
    [_bottomView addSubview:self.exchangeBtn];
    
    [self.exchangeBtn setTitle:@"交换" forState:UIControlStateNormal];
    
    [self.exchangeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.exchangeBtn addTarget:self action:@selector(exchangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        _annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (_annotationView == nil)
        {
            _annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        _annotationView.canShowCallout   = YES;
        _annotationView.animatesDrop     = YES;
        _annotationView.draggable        = NO;
        _annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return _annotationView;
    }
    
    return nil;
}
//- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    if (_annotationView.annotation.coordinate.latitude !=  mapView.region.center.latitude) {
//            _annotationView.annotation.coordinate = mapView.region.center;
//    }
//    
//    
////    [self reGeocodeAction];
////
////    self.pointAnnotaiton.coordinate = mapView.region.center;
//    
//}


#pragma mark-----拖拽地图
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if (_annotationView.annotation.coordinate.latitude !=  mapView.region.center.latitude) {
        _annotationView.annotation.coordinate = mapView.region.center;
         [_pointAnnotaiton setCoordinate:_annotationView.annotation.coordinate];
        [self setGegeo:_annotationView.annotation.coordinate];
    }
    
    
    //    [self reGeocodeAction];
    //
    //    self.pointAnnotaiton.coordinate = mapView.region.center;
    
}
- (void)setGegeo:(CLLocationCoordinate2D)coor {
    
    self.search = [[AMapSearchAPI alloc]init];
      self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    regeo.requireExtension            = YES;
   
    [self.search AMapReGoecodeSearch:regeo];
   
}

/* 逆地理编码回调. */
//下面的这个方法是逆地理编码的回调方法
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode !=nil)
    {
        
        [_pointAnnotaiton setTitle:[NSString stringWithFormat:@"%@",response.regeocode.formattedAddress]];
        [_pointAnnotaiton setSubtitle:[NSString stringWithFormat:@"%@", response.regeocode.addressComponent.city]];
  
        [self.startLabel setTitle:[NSString stringWithFormat:@" %@",response.regeocode.formattedAddress] forState:UIControlStateNormal];
    }
}
//- (void)dealloc
//{
//    [self cleanUpAction];
//    
//    self.completionBlock = nil;
//}
- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

//跳转至目的地选择
-(void)selectEndIndex{

    
    hotCityViewController * endLocationVc = [[hotCityViewController alloc]init];
    
    
    [self.navigationController pushViewController:endLocationVc animated:YES];
   

}

-(void)reloadEnd:(NSNotification * )noty{

  _destationPoi =  noty.userInfo[@"poi"];

    [self.endLabel setTitle:_destationPoi.name forState:UIControlStateNormal];
    
    
}
#pragma mark ----- 交换地点
-(void)exchangeBtnClick{
 
    
    NSString * str = self.endLabel.titleLabel.text;
//    self.endLabel.titleLabel.text = self.startLabel.titleLabel.text;
    [self.endLabel setTitle: self.startLabel.titleLabel.text forState:UIControlStateNormal];
    [self.startLabel setTitle:str forState:UIControlStateNormal];

    self.isNowWay = !self.isNowWay;
}


#pragma mark ---- 驾车路线

-(void)goToDriveWayVc{

    driveWayViewController * driveWayVc = [[driveWayViewController alloc]init];
    
    [self.navigationController pushViewController:driveWayVc animated:YES];
    
    driveWayVc.annotation = _annotationView.annotation.coordinate;
    
    driveWayVc.poi = _destationPoi;
    driveWayVc.isNowWay = self.isNowWay;

}
@end
