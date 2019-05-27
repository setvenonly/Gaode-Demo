//
//  ViewController.m
//  GaoDe_Demo
//
//  Created by Setven on 2019/5/23.
//  Copyright © 2019 Setven. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry.h>
#import <AFNetworking/AFNetworking.h>
///屏幕高
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
///屏幕宽
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UILabel *AddressLab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    //是否显示比例尺, 默认YES
    self.mapView.showsScale = NO;
    //是否显示指南针, 默认YES
    self.mapView.showsCompass = NO;
    //缩放级别
    self.mapView.zoomLevel = 15;
    //显示用户位置
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(10, 200,80 , 50);
    [btn setTitle:@"当前位置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clcick) forControlEvents:UIControlEventTouchUpInside
     ];
    [self.view addSubview:btn];
    
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei"]];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_offset(-33 / 2.f);
        make.width.mas_offset(21);
        make.height.mas_offset(33);
    }];
    
    _AddressLab = [[UILabel alloc]init];
    _AddressLab.textColor = [UIColor blackColor];
    _AddressLab.backgroundColor = [UIColor whiteColor];
    _AddressLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_AddressLab];
    [_AddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(80);
        make.bottom.mas_offset(-70);
    }];
    
}

#pragma 点击当前位置
-(void)clcick{
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];

}

-(AMapSearchAPI *)search{
    if (!_search) {
        _search =[[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}

#pragma 地图移动结束后调用
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
    
    [self jumpAnimation];
    
}
#pragma 跳动动画
-(void)jumpAnimation{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.imageView.center;
                         center.y -= 20;
                         [self.imageView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.imageView.center;
                         center.y += 20;
                         [self.imageView setCenter:center];}
                     completion:nil];
}

#pragma 逆编码查询代理
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if(response.regeocode != nil)
    {
        NSLog(@"%@",response.regeocode.formattedAddress);
        self.AddressLab.text = response.regeocode.formattedAddress;
    }
}



@end
