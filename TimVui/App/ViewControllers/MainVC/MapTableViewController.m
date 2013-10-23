//
//  MapTableViewController.m
//  TimVui
//
//  Created by Hoang The Hung on 6/13/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "MapTableViewController.h"
#import "TVBranch.h"
#import "GlobalDataUser.h"
#import "Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Crop.h"
#import "BranchProfileVC.h"
#import "BranchMainCell.h"
#import "TVAppDelegate.h"
#import "Utilities.h"
#import "NSDate-Utilities.h"
#import "NSDictionary+Extensions.h"
#import "TVNotification.h"
#import "ECSlidingViewController.h"
#import "LocationTableVC.h"
#import "TVCoupon.h"
#import "TVCoupons.h"
#import "MyNavigationController.h"
#import "TSMessage.h"
#import "TVEvent.h"
#import "SVPullToRefresh.h"
#import <JSONKit.h>
static const int maxLimitBranches=100;
@interface MapTableViewController (){
@private
    __strong UIActivityIndicatorView *_activityIndicatorView;
    __strong  SBTableAlert *alert;
    int offset;
    UILabel* tableFooter;
    NSDictionary *_params;
}

@end

@implementation MapTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)initNotificationView
{
    // Do any additional setup after loading the view from its nib.
    self.notificationView=[[TVNotification alloc] initWithView:self.view withTitle:nil goWithCamera:^{
        [SharedAppDelegate.menuVC cameraButtonClickedWithNav:self.navigationController andWithBranches:_branches];
    } withComment:^{
        [SharedAppDelegate.menuVC commentButtonClickedWithNav:self.navigationController andWithBranches:_branches];
    }];
}


#pragma mark - ViewController

- (void)getBranchesForView {
//  NSLog(@"%@",[GlobalDataUser sharedAccountClient].dicCity);
    if (!self.branches.isLoading) {
        CLLocationCoordinate2D location=[GlobalDataUser sharedAccountClient].userLocation;
        NSDictionary* params=nil;
        if (location.latitude) {
            NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
            params = @{@"city_alias": [[GlobalDataUser sharedAccountClient].homeCity safeStringForKey:@"alias"],
                       @"latlng": strLatLng};
        }
        offset=0;
        _currentCameraPositionSearch=location;
        _locationPickerView.mapView.camera = [GMSCameraPosition cameraWithTarget:location zoom:15];
        [self postSearchBranch:[[NSMutableDictionary alloc] initWithDictionary:params] withReturnFromSearchScreenYES:NO];
    }
    
}

- (void)loadView {
    [super loadView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Trang chủ";
    _lastDistanceSearch=kDistanceSearchMapDefault.floatValue;
    // The LocationPickerView can be created programmatically (see below) or
    // using Storyboards/XIBs (see Storyboard file).
    self.locationPickerView = [[LocationPickerView alloc] initWithFrame:self.view.bounds];
    self.locationPickerView.tableViewDataSource = self;
    self.locationPickerView.tableViewDelegate = self;
    [self.locationPickerView setMapViewDelegate:self];
    
    // Optional parameters
    self.locationPickerView.delegate = self;
    self.locationPickerView.shouldCreateHideMapButton = YES;
    self.locationPickerView.pullToExpandMapEnabled = YES;
    
    // Optional setup
    self.locationPickerView.mapViewDidLoadBlock = ^(LocationPickerView *locationPicker) {
        //        locationPicker.mapView.mapType = MKMapTypeStandard;
    };
    self.locationPickerView.tableViewDidLoadBlock = ^(LocationPickerView *locationPicker) {
        
    };
    
    [self.view addSubview:self.locationPickerView];

    self.navigationItem.rightBarButtonItem = [self searchButtonItem];
    [self initNotificationView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    _locationPickerView.firstLocationUpdate=NO;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [self setNotificationView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LocationPickerViewDelegate

-(void)didClickedCurrentLocationButton:(UIButton *)btn {
    if (![GlobalDataUser sharedAccountClient].isShowAletForLocationServicesYES&&([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)))
    {
        [GlobalDataUser sharedAccountClient].isShowAletForLocationServicesYES=YES;
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Bạn cần bật chức năng Định vị vị trí (Location services) để sử dụng tiện ích này"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeWarning];
    }
}

-(void)searchBarButtonClicked{
    SearchVC* searchVC=[[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
    [searchVC setDelegate:self];
//    [GlobalDataUser sharedAccountClient].dicDistrictSearchParam=_arrDics;
    [self.navigationController pushViewController:searchVC animated:YES];
}

/** Called when the mapView is about to be expanded (made fullscreen).
 Use this to perform custom animations or set attributes of the map/table. */
- (void)locationPicker:(LocationPickerView *)locationPicker
     mapViewWillExpand:(GMSMapView *)mapView
{
    
}

/** Called when the mapView was expanded (made fullscreen). Use this to
 perform custom animations or set attributes of the map/table. */
- (void)locationPicker:(LocationPickerView *)locationPicker
      mapViewDidExpand:(GMSMapView *)mapView
{
    [_notificationView closeButtonClicked:nil];
}

- (void)alertWhenNoDataLoaded
{
    if (self.branches.count==0) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Không có dữ liệu địa điểm"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeWarning];
    }
}

/** Called when the mapView is about to be hidden (made tiny). Use this to
 perform custom animations or set attributes of the map/table. */
- (BOOL)locationPicker:(LocationPickerView *)locationPicker
   mapViewWillBeHidden:(GMSMapView *)mapView
{
    [self alertWhenNoDataLoaded];
    if (self.branches.count>0) return YES;
    return NO;
}

/** Called when the mapView was hidden (made tiny). Use this to
 perform custom animations or set attributes of the map/table. */
- (void)locationPicker:(LocationPickerView *)locationPicker
      mapViewWasHidden:(GMSMapView *)mapView
{
    
}

- (void)locationPicker:(LocationPickerView *)locationPicker mapViewDidLoad:(GMSMapView *)mapView
{
    _lastPosition=mapView.camera.target;
    
    
    //Update location user and get branches
    if ([GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic=[defaults dictionaryForKey:kGetCityDataUser];
        if (dic) {
            [GlobalDataUser sharedAccountClient].homeCity=    dic;
            [GlobalDataUser sharedAccountClient].userLocation=[dic safeLocationForKey:@"latlng"];
            [self getBranchesForView];
        }else if(([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))){
            int i=    [[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] count];
            NSLog(@"count == %d",i);
            alert	= [[SBTableAlert alloc] initWithTitle:@"Vui lòng chọn Tỉnh/TP" cancelButtonTitle:@"Cancel" messageFormat:nil];
            [alert setDelegate:self];
            [alert setDataSource:self];
            [alert show];
            //NSLog(@"%@",SharedAppDelegate.getCityDistrictData);
        }
    }else
        [self getBranchesForView];
}

- (void)locationPicker:(LocationPickerView *)locationPicker tableViewDidLoad:(UITableView *)tableView
{
    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    tableFooter.textColor = [UIColor grayColor];
    tableFooter.textAlignment=UITextAlignmentCenter;
    tableFooter.backgroundColor = [UIColor clearColor];
    tableFooter.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    tableFooter.hidden=YES;
    [tableFooter setText:@"Không còn địa điểm nào"];
    tableView.tableFooterView = tableFooter;
    
    __weak MapTableViewController *weakSelf = self;
    // setup infinite scrolling
    
    [tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf postSearchBranch:[[NSMutableDictionary alloc] initWithDictionary:_params] withReturnFromSearchScreenYES:NO];
    }];
}

#pragma mark - SBTableAlertDataSource

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (tableAlert.view.tag == 0 || tableAlert.view.tag == 1) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
	} else {
		// Note: SBTableAlertCell
		cell = [[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
	}
	
	[cell.textLabel setText:[[[SharedAppDelegate.getCityDistrictData safeArrayForKey:@"data"] objectAtIndex:indexPath.row] safeStringForKey:@"name"]];
	
	return cell;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
    return [[SharedAppDelegate.getCityDistrictData valueForKey:@"data"] count];
}

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert {
    return 1;
}

//- (NSString *)tableAlert:(SBTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section {
//	if (tableAlert.view.tag == 3)
//		return [NSString stringWithFormat:@"Section Header %d", section];
//	else
//		return nil;
//}

#pragma mark - SBTableAlertDelegate

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [GlobalDataUser sharedAccountClient].homeCity=     [[SharedAppDelegate.getCityDistrictData safeArrayForKey:@"data"] objectAtIndex:indexPath.row];
    [GlobalDataUser sharedAccountClient].userLocation=[[GlobalDataUser sharedAccountClient].homeCity safeLocationForKey:@"latlng"];
    [self getBranchesForView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[GlobalDataUser sharedAccountClient].homeCity forKey:kGetCityDataUser];
    [defaults synchronize];
    
    [GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES=NO;
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES) {
        [GlobalDataUser sharedAccountClient].isCanNotGetLocationServiceYES=NO;
        [self getBranchesForView];
    }
    
	//
    
}

#pragma mark - Helper

-(void)showBranchOnMap{
    [_locationPickerView.mapView clear];
//    NSLog(@"_branches.count = %d",_branches.count);
    int i=0;
    for (TVBranch* branch in _branches.items) {
        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
        melbourneMarker.title = [NSString stringWithFormat:@"%d",i];
        melbourneMarker.position =  branch.latlng;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:[branch.arrURLImages safeStringForKey:@"80"]]
                        delegate:self
                         options:0
                         success:^(UIImage *image, BOOL cached)
         {
                 UIImage *bottomImage = [UIImage imageNamed:@"imgMapMakerBackground"]; //background image
//                 image=[image imageByScalingAndCroppingForSize:CGSizeMake(45,45/4*3)];
                 UIGraphicsBeginImageContext( bottomImage.size );
                 [bottomImage drawAtPoint:CGPointZero];
                 [image drawInRect:CGRectMake(3.0f,3.0f,45,45/4*3) blendMode:kCGBlendModeNormal alpha:1];
                 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 melbourneMarker.icon = newImage;
                 melbourneMarker.map = _locationPickerView.mapView;

         }
            failure:nil];
        
        i++;
    }
}

-(void)updateCameraMapPosition:(CLLocationCoordinate2D) latlng{
    
    CLLocationCoordinate2D center = _currentCameraPositionSearch;
    
    float radius = [self getDistanceMetresFrom:_currentCameraPositionSearch toLocation:latlng]*1000; //radius in meters (25km)
    _lastDistanceSearch=radius/1000;
    //float radius=3000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, radius*2, radius*2);
    
    CLLocationCoordinate2D  northEast = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta/2, region.center.longitude - region.span.longitudeDelta/2);
    CLLocationCoordinate2D  southWest = CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta/2, region.center.longitude + region.span.longitudeDelta/2);
    
    GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc]
                                   initWithCoordinate:northEast
                                   coordinate: southWest];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [_locationPickerView.mapView animateWithCameraUpdate:update];
}

- (void)postSearchBranch:(NSMutableDictionary*)params withReturnFromSearchScreenYES:(BOOL)isSearchYES{
    _params=params;
    if (offset>maxLimitBranches) {
        _locationPickerView.tableView.showsInfiniteScrolling=NO;
        return;
    }
    if (offset==0) {
        [self.branches.items removeAllObjects];
        _locationPickerView.tableView.showsInfiniteScrolling=YES;
    }
    if ([GlobalDataUser sharedAccountClient].dicCatSearchParam.count>0) {
        [params setValue:[[GlobalDataUser sharedAccountClient].dicCatSearchParam valueForKey:@"alias"] forKey:@"cat_aliases"];
    }
    
    if ([GlobalDataUser sharedAccountClient].dicPriceSearchParam.count>0) {
        [params setValue:[[GlobalDataUser sharedAccountClient].dicPriceSearchParam JSONString]  forKey:@"prices"];
    }
    
    NSMutableArray* paramsForSearch=[[NSMutableArray alloc] init];
    if ([GlobalDataUser sharedAccountClient].dicCuisineSearchParam){
        for (NSString* strCuisine in [[GlobalDataUser sharedAccountClient].dicCuisineSearchParam valueForKey:@"alias"]) {
            [paramsForSearch addObject:[NSString stringWithFormat:@"mon-an_%@",strCuisine]];
        }
    }
    
    if ([GlobalDataUser sharedAccountClient].dicPurposeSearchParam)
    {
        for (NSString* strCuisine in [[GlobalDataUser sharedAccountClient].dicPurposeSearchParam valueForKey:@"alias"]) {
            [paramsForSearch addObject:[NSString stringWithFormat:@"muc-dich_%@",strCuisine]];
        }
    }
    
    if ([GlobalDataUser sharedAccountClient].dicUtilitiesSearchParam)
    {
        for (NSString* strCuisine in [[GlobalDataUser sharedAccountClient].dicUtilitiesSearchParam valueForKey:@"alias"]) {
            [paramsForSearch addObject:[NSString stringWithFormat:@"tien-ich_%@",strCuisine]];
        }
    }
    
    [params setValue:paramsForSearch  forKey:@"params"];
    [params setValue:kSearchBranchLimit  forKey:@"limit"];
    [params setValue:[NSString stringWithFormat:@"%d",offset]  forKey:@"offset"];
    NSLog(@"params == %@",params);
    
    if (!self.branches) {
        self.branches=[[TVBranches alloc] initWithPath:@"search/branch"];
    }
    
    _lastPosition=_currentCameraPositionSearch;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [_locationPickerView.tableView.infiniteScrollingView stopAnimating];
            // View map with contain all search items
            if (weakSelf.branches.count>0) {
                _locationPickerView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                TVBranch* branch=weakSelf.branches.items.lastObject;
                [self updateCameraMapPosition:branch.latlng];
            }
            
            if (weakSelf.branches.countAddedItems<kSearchBranchLimit.intValue) {
                _locationPickerView.tableView.showsInfiniteScrolling=NO;
                tableFooter.hidden=NO;
            }else{
                tableFooter.hidden=YES;
            }
            
            if (weakSelf.branches.count==0) {
                
                [_locationPickerView expandMapView:nil];
                [self alertWhenNoDataLoaded];
            }
            
            _lastUpdate=[NSDate date];
            offset+=kSearchBranchLimit.intValue;
            [_locationPickerView.tableView reloadData];
            [weakSelf showBranchOnMap];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
        });
    }];
}

-(double) getDistanceMetresFrom:(CLLocationCoordinate2D)coord1 toLocation:(CLLocationCoordinate2D) coord2
{
    CLLocation* location1 =
    [[CLLocation alloc]
     initWithLatitude: coord1.latitude
     longitude: coord1.longitude];
    CLLocation* location2 =
    [[CLLocation alloc]
     initWithLatitude: coord2.latitude
     longitude: coord2.longitude];
    
    return [location1 distanceFromLocation: location2]/1000; //KM
}

#pragma mark - UIscrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_notificationView closeButtonClicked:nil];
}


#pragma mark - SearchVCDelegate
-(void)didClickedOnButtonSearch:(NSMutableDictionary *)params withLatlng:(CLLocationCoordinate2D)latlng{
    _locationPickerView.mapView.camera = [GMSCameraPosition cameraWithTarget:latlng zoom:15];
    _currentCameraPositionSearch=latlng;
     NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",latlng.latitude,latlng.longitude];
    [params setValue:strLatLng forKey:@"latlng"];
    offset=0;
    [self postSearchBranch:params withReturnFromSearchScreenYES:YES];
    
}

-(void)didPickDistricts:(NSArray *)arrDics{
//    _arrDics=arrDics;
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    TVBranch* branch= _branches[[marker.title intValue]];
    BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
    branchProfileVC.branchID=[branch branchID];
    [self.navigationController pushViewController:branchProfileVC animated:YES];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    NSLog(@"_lastDistanceSearch/2=%f",_lastDistanceSearch/2);
    if (_lastPosition.latitude) {
        double distance=[self getDistanceMetresFrom:position.target toLocation:_lastPosition];
//        NSLog(@"distance ==== %f",distance);
        if (distance>_lastDistanceSearch/2) {
            if ([_lastUpdate isLaterThanSeconds:2]) {
                CLLocationCoordinate2D bottomLeftCoord =
                mapView.projection.visibleRegion.nearLeft;
                double distanceMetres=[self getDistanceMetresFrom:position.target toLocation:bottomLeftCoord];
                float radiusKm=distanceMetres;
                NSDictionary *params = nil;
                CLLocationCoordinate2D location=position.target;
                
                NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
                float distance=(radiusKm<kDistanceSearchMapDefault.floatValue)?radiusKm:kDistanceSearchMapDefault.floatValue;
                if (![GlobalDataUser sharedAccountClient].dicCitySearchParam) {
                    [GlobalDataUser sharedAccountClient].dicCitySearchParam=[GlobalDataUser sharedAccountClient].homeCity;
                }
                params = @{@"city_alias": [[GlobalDataUser sharedAccountClient].dicCitySearchParam valueForKey:@"alias"],@"latlng": strLatLng
                           ,@"distance": [NSString stringWithFormat:@"%f",distance]
                           };
                
                _lastDistanceSearch=distance;
                offset=0;
                [self performSelector:@selector(postSearchBranch:withReturnFromSearchScreenYES:) withObject:[[NSMutableDictionary alloc] initWithDictionary:params] afterDelay:2];
                _currentCameraPositionSearch=position.target;
            }
        }
    }else
        _lastPosition=position.target;
}

- (void)setBorderForLayer:(CALayer *)l radius:(float)radius {
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}


- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    //
    TVBranch* branch= _branches[[marker.title intValue]];
    UIImageView* imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 8.0f + 4, 70.0f, 52.5f)];
    imgPhoto.contentMode = UIViewContentModeScaleAspectFit;

    imgPhoto.image=[[SDImageCache sharedImageCache] imageFromKey:[branch.arrURLImages safeStringForKey:@"80"]];
    if (!imgPhoto.image) {
        NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[branch.arrURLImages safeStringForKey:@"80"]]];
        imgPhoto.image = [UIImage imageWithData:myData];

    }
    
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 308, 80)];
    UIView* viewPad;
    if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        viewPad=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 308, 220)];
    }else{
        viewPad=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 308, 165)];
    }
    
    [viewPad addSubview:view];
    [viewPad setBackgroundColor:[UIColor clearColor]];
    [view addSubview:imgPhoto];
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80+10.0f, 8.0f+2, 180.0f, 20.0f)];
    [view  addSubview:textLabel];
    
    UILabel* detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80+25.0f, 30.0f+2, 210.0f, 20.0f)];
    [view  addSubview:detailTextLabel];
    
    textLabel.textColor = [UIColor blackColor];
    textLabel.numberOfLines = 1;
    detailTextLabel.numberOfLines = 1;
    textLabel.backgroundColor=[UIColor clearColor];
    detailTextLabel.backgroundColor=[UIColor clearColor];
    detailTextLabel.textColor=kGrayTextColor;
    UILabel* price_avg = [[UILabel alloc] initWithFrame: CGRectMake(80 +25.0f, 48.0f+2, 210.0f, 20.0f)];
    price_avg.backgroundColor = [UIColor clearColor];
    
    price_avg.textColor = kGrayTextColor;
    price_avg.highlightedTextColor = [UIColor whiteColor];
    
    textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    price_avg.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80+ 8.0, 35.0+2, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80+ 10.0, 53.0+2, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    
    CALayer* l = [imgPhoto layer];
    [self setBorderForLayer:l radius:1];
    
    [view addSubview:price_avg];
    [view addSubview:homeIcon];
    [view addSubview:price_avgIcon];
    
    UIView* _utility=[[UIView alloc] initWithFrame:CGRectMake(88,70+2, 320-88, 0)];
    [view   addSubview:_utility];
    [view   setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    
    UILabel* _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(270,7+2, 60, 15)];
    _lblDistance.backgroundColor = [UIColor clearColor];
    _lblDistance.textColor = [UIColor grayColor];
    _lblDistance.font = [UIFont fontWithName:@"Arial-ItalicMT" size:(10)];
    
    textLabel.text=branch.name;
    detailTextLabel.text=branch.address_full;
    price_avg.text=(branch.price_avg && ![branch.price_avg isEqualToString:@""])?branch.price_avg:@"Đang cập nhật";
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:[branch latlng]];
    
    if (distance<0) {
        _lblDistance.hidden=YES;
    }else{
        _lblDistance.hidden=NO;
        if (distance>1000.0)
            _lblDistance.text=[NSString stringWithFormat:@"%.01f km",distance/1000];
        else
            _lblDistance.text=[NSString stringWithFormat:@"%.01f m",distance];
    }
    
    int lineHeight=0;
    
    for (TVEvent* event in branch.events.items) {
        UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(0+18, lineHeight, 210, 17)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = kCyanGreenColor;
        lblAddress.highlightedTextColor = [UIColor redColor];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblAddress.numberOfLines = 1;
        lblAddress.text=event.title;
        [_utility addSubview:lblAddress];
        UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineHeight, 15, 15)];
        homeIcon.image=[UIImage imageNamed:@"img_main_event_icon"];
        [_utility addSubview:homeIcon];
        lineHeight+=lblAddress.frame.size.height+5;
    }
    
    for (TVCoupon* coupon in branch.coupons.items) {
        UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(0+18, lineHeight, 210, 17)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = kDeepOrangeColor;
        lblAddress.highlightedTextColor = [UIColor redColor];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblAddress.numberOfLines = 1;
        lblAddress.text=coupon.name;
        [_utility addSubview:lblAddress];
        UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineHeight, 15, 15)];
        homeIcon.image=[UIImage imageNamed:@"img_main_coupon_icon"];
        [_utility addSubview:homeIcon];
        lineHeight+=lblAddress.frame.size.height+5;
    }
    
    CGRect frame=_utility.frame;
    frame.size.height+=(branch.events.items.count+ branch.coupons.items.count)*20;
    [_utility setFrame:frame];
    
    [view  addSubview:_lblDistance];
    
    frame=view.frame;
    frame.size.height+=_utility.frame.size.height;
    view.frame=frame;
    
    return viewPad;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    // Animate to the marker
    //    [CATransaction begin];
    //    [CATransaction setAnimationDuration:1.f];  // 3 second animation
    //
    //    GMSCameraPosition *camera =
    //    [[GMSCameraPosition alloc] initWithTarget:marker.position
    //                                         zoom:14
    //                                      bearing:0
    //                                 viewingAngle:0];
    //    [mapView animateToCameraPosition:camera];
    //    [CATransaction commit];
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.branches count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    BranchMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BranchMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else{
        [[cell.utility subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:[self.branches[indexPath.row]latlng]];
    [cell setBranch:self.branches[indexPath.row] withDistance:distance];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BranchMainCell heightForCellWithPost:self.branches[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    
    BranchProfileVC* branchProfileVC=[[BranchProfileVC alloc] initWithNibName:@"BranchProfileVC" bundle:nil];
    branchProfileVC.branchID=[_branches[indexPath.row] branchID];
    [self.navigationController pushViewController:branchProfileVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
