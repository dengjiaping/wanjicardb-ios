//
//  WJChoiceMapViewController.m
//  CardsBusiness
//
//  Created by 熊向天 on 16/1/21.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJChoiceMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


@interface WJChoiceMapViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BOOL isFirstLocation;
    BOOL isChoiceLocation;
    BMKGeoCodeSearch  * _geocodesearch;
}

@property(nonatomic,strong)BMKMapView             * mapView;
@property(nonatomic,strong)BMKLocationService     * locService;
@property(nonatomic,strong)BMKGeoCodeSearch       * geocodesearch;

@property(nonatomic,strong)UITableView            * tableView;
@property(nonatomic,strong)NSMutableArray         * dataSource;
@property(nonatomic,assign)CLLocationCoordinate2D   currentCoordinate;
@property(nonatomic,assign)NSInteger                currentSelectLocationIndex;
@property(nonatomic,strong)UIImageView            * centerCallOutImageView;
@property(nonatomic,strong)UIButton               * currentLocationBtn;

@property(nonatomic,strong)BMKPoiInfo             * selectModel;

@end

@implementation WJChoiceMapViewController

#pragma mark - Life cycle

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
    self.geocodesearch.delegate = self;
    self.selectModel = [[BMKPoiInfo alloc]init];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
    self.geocodesearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置";
    [self configUI];
    if (self.addressStr.length != 0) {
        [self chlickGeocode];
    }else{
        [self startLocation];
    }
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonAction)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)sureButtonAction
{
    if ([WJUtilityMethod isNotReachable]) {
        if (self.dataSource.count != 0) {
            if (!isChoiceLocation) {
                self.selectModel = self.dataSource[0];
            }
            [_delegate returnPoiMessage:self.selectModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            ALERT(@"请选择地址");
        }
    }else{
        ALERT(@"请检查网络");
    }
}


- (void)chlickGeocode
{
    BMKGeoCodeSearchOption * geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    self.geocodesearch.delegate = self;
//    geocodeSearchOption.city = @"北京市";
    geocodeSearchOption.address = self.addressStr;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    self.currentSelectLocationIndex = 0;
    self.currentLocationBtn.selected = YES;
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}

//正向编码代理
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        _mapView.centerCoordinate = result.location;
        self.currentCoordinate = result.location;
        BMKMapStatus *mapStatus = [self.mapView getMapStatus];
        mapStatus.targetGeoPt = result.location;
        [self.mapView setMapStatus:mapStatus withAnimation:YES];
    }
}

//加载UI
-(void)configUI
{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;//禁用旋转手势
    [self.mapView setZoomLevel:18];
    [self.view addSubview:self.mapView];
    
    self.centerCallOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ALD(17), ALD(29))];
    self.centerCallOutImageView.center = self.mapView.center;
    self.centerCallOutImageView.image = [UIImage imageNamed:@"Location"];
    [self.mapView addSubview:self.centerCallOutImageView];
    [self.view bringSubviewToFront:self.centerCallOutImageView];
    [self.mapView layoutIfNeeded];
    
    [self.view addSubview:self.tableView];
    
    self.currentLocationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.currentLocationBtn.frame = CGRectMake(kScreenWidth - ALD(67), (kScreenHeight/2) - ALD(67), ALD(50), ALD(50));
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"position_Location"] forState:UIControlStateNormal];
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"position_Location_Selected"] forState:UIControlStateSelected];
    [self.currentLocationBtn addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.currentLocationBtn];
    [self.view bringSubviewToFront:self.currentLocationBtn];
}


-(void)startLocation
{
    isFirstLocation = YES;//首次定位
    self.currentSelectLocationIndex = 0;
    self.currentLocationBtn.selected = YES;
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层

}

//开始反向编码
-(void)startGeocodesearchWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


-(void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate
{
    _currentCoordinate = currentCoordinate;
    [self startGeocodesearchWithCoordinate:currentCoordinate];
}

#pragma mark - BMKMapViewDelegate
//在地图View将要启动定位时，会调用此函数
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}

//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    isFirstLocation = NO;
    self.currentLocationBtn.selected=NO;
    [self.mapView  updateLocationData:userLocation];
    self.currentCoordinate = userLocation.location.coordinate;
    if (self.currentCoordinate.latitude != 0)
    {
        [self.locService stopUserLocationService];
    }
}

//在地图View停止定位后，会调用此函数
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

//定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"map view: click blank");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!isFirstLocation)
    {
        CGPoint point = self.centerCallOutImageView.center;
        point.x = point.x - 170;
        point.y = point.y - 170;
        NSLog(@"当前选点坐标是%f,%f",point.x,point.y);
        CLLocationCoordinate2D slideLocation = [mapView convertPoint:point toCoordinateFromView:self.centerCallOutImageView];
        self.currentCoordinate = slideLocation;
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
//返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:result.poiList];
        if (isFirstLocation)
        {
            //把当前定位信息自定义组装 放进数组首位
            BMKPoiInfo *first =[[BMKPoiInfo alloc]init];
            first.address = result.address;
            first.name = @"[当前位置]";
            first.pt = result.location;
            first.city = result.addressDetail.city;
            [self.dataSource insertObject:first atIndex:0];
        }
        if (isChoiceLocation) {
            BMKPoiInfo *poiInfo =[[BMKPoiInfo alloc]init];
            for (BMKPoiInfo * model in self.dataSource) {
                if ([model.name isEqualToString:self.selectModel.name]) {
                    poiInfo = model;
                }
            }
            if (poiInfo) {
                [self.dataSource removeObject:poiInfo];
            }
            [self.dataSource insertObject:self.selectModel atIndex:0];
            isChoiceLocation = NO;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(60);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    UILabel *textLabel = [[UILabel alloc]initForAutoLayout];
    textLabel.textColor = WJColorBlack;
    textLabel.font = WJFont14;
    [cell.contentView addSubview:textLabel];
    [cell.contentView addConstraints:[textLabel constraintsLeftInContainer:ALD(15)]];
    [cell.contentView addConstraints:[textLabel constraintsTopInContainer:ALD(10)]];
    
    UILabel *subLabel = [[UILabel alloc]initForAutoLayout];
    subLabel.textColor = WJColorDardGray9;
    subLabel.font = WJFont12;
    [cell.contentView addSubview:subLabel];
    [cell.contentView addConstraints:[subLabel constraintsLeftInContainer:ALD(15)]];
    [cell.contentView addConstraints:[subLabel constraintsRightInContainer:ALD(15)]];
    [cell.contentView addConstraints:[subLabel constraintsTopInContainer:ALD(35)]];
    
    BMKPoiInfo *model=[self.dataSource objectAtIndex:indexPath.row];
    textLabel.text=model.name;
    subLabel.text=model.address;
    if (self.currentSelectLocationIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *model = [self.dataSource objectAtIndex:indexPath.row];
    isChoiceLocation = YES;
    BMKMapStatus *mapStatus = [self.mapView getMapStatus];
    mapStatus.targetGeoPt = model.pt;
    self.selectModel = model;
    [self.mapView setMapStatus:mapStatus withAnimation:YES];
//    [self.dataSource removeObjectAtIndex:indexPath.row];
//    [self.dataSource insertObject:model atIndex:0];
//    self.currentSelectLocationIndex = indexPath.row;

    [self.tableView reloadData];
}

#pragma mark - InitMethod

-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
        _mapView.zoomEnabled=NO;
        _mapView.zoomEnabledWithTap=NO;
        _mapView.zoomLevel=17;
    }
    return _mapView;
}

-(BMKLocationService*)locService
{
    if (_locService==nil)
    {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}

-(BMKGeoCodeSearch*)geocodesearch
{
    if (_geocodesearch==nil)
    {
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}

-(UITableView*)tableView
{
    if (_tableView==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2 - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *) centerCallOutImageView
{
    if (_centerCallOutImageView == nil)
    {
        _centerCallOutImageView = [UIImageView new];
        [_centerCallOutImageView setImage:[UIImage imageNamed:@"Location"]];
    }
    return _centerCallOutImageView;
}

-(NSMutableArray*)dataSource
{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
