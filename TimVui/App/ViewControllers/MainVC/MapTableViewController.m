//
//  MapTableViewController.m
//  TimVui
//
//  Created by Hoang The Hung on 6/13/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "MapTableViewController.h"
#import "TVBranch.h"
#import "GlobalDataUser.h"
#import "Ultilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Crop.h"
#import "BranchProfileVC.h"
#import "BranchMainCell.h"
#import "TVAppDelegate.h"
#import "Ultilities.h"
#import "NSDate+Helper.h"
#import "NSDictionary+Extensions.h"
#import "TVNotification.h"

#import "ECSlidingViewController.h"
#import "LocationTableVC.h"
#import "TVCoupon.h"
#import "TVCoupons.h"
#import "MyNavigationController.h"
#import "TSMessage.h"
@interface MapTableViewController (){
@private
__strong UIActivityIndicatorView *_activityIndicatorView;
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
        [SharedAppDelegate.menuVC commentButtonClickedWithNav:self.navigationController];
    }];
}


#pragma mark - ViewController

- (void)loadView {
    [super loadView];
    NSLog(@"%@",[GlobalDataUser sharedAccountClient].dicCity);
    NSDictionary *params = nil;
    CLLocationCoordinate2D location=[GlobalDataUser sharedAccountClient].userLocation;
    
    if (location.latitude) {
        NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
        params = @{@"city_alias": [[GlobalDataUser sharedAccountClient].dicCity safeStringForKey:@"alias"],
                   @"latlng": strLatLng};
    }else
        params = @{@"city_alias": [[GlobalDataUser sharedAccountClient].dicCity valueForKey:@"alias"]};
    
    [self postSearchBranch:[[NSMutableDictionary alloc] initWithDictionary:params] withReturnFromSearchScreenYES:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        locationPicker.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    };
    
    [self.view addSubview:self.locationPickerView];
    _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 301, 42)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(searchBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.locationPickerView addSubview:_btnSearchBar];
    [self initNotificationView];
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
                                      withTitle:@"Để sử dụng tốt nhất tính năng của ứng dụng này, bạn vui lòng bật tính năng Dò tìm vị trí- Location Service trong phần cài đặt của máy điện thoại."
                                    withMessage:nil
                                       withType:TSMessageNotificationTypeWarning];
    }
}

-(void)locationPickerSearchBarButtonClicked{
    SearchVC* searchVC=[[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
    [searchVC setDelegate:self];
    [GlobalDataUser sharedAccountClient].dicDistrictSearchParam=_arrDics;
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
}

- (void)locationPicker:(LocationPickerView *)locationPicker tableViewDidLoad:(UITableView *)tableView
{
    
}

#pragma mark - Helper

-(void)showBranchOnMap{
    [_locationPickerView.mapView clear];
    NSLog(@"_branches.count = %d",_branches.count);
    int i=0;
    for (TVBranch* branch in _branches.items) {
        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
        melbourneMarker.title = [NSString stringWithFormat:@"%d",i];
        melbourneMarker.position =  branch.latlng;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[Ultilities getThumbImageOfCoverBranch:branch.arrURLImages]
                        delegate:self
                         options:0
                         success:^(UIImage *image, BOOL cached)
         {
             UIImage *bottomImage = [UIImage imageNamed:@"imgMapMakerBackground"]; //background image
             image=[image imageByScalingAndCroppingForSize:CGSizeMake(30, 30)];
             UIGraphicsBeginImageContext( bottomImage.size );
             [bottomImage drawAtPoint:CGPointZero];
             [image drawInRect:CGRectMake(6.0f,5.0f,30.0f,30.0f) blendMode:kCGBlendModeNormal alpha:1];
             UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             melbourneMarker.icon = newImage;
             melbourneMarker.map = _locationPickerView.mapView;
         }
        failure:nil];
        i++;
    }
}

- (void)postSearchBranch:(NSMutableDictionary*)params withReturnFromSearchScreenYES:(BOOL)isSearchYES{
    
    if ([GlobalDataUser sharedAccountClient].dicCatSearchParam.count>0) {
        [params setValue:[[GlobalDataUser sharedAccountClient].dicCatSearchParam valueForKey:@"alias"] forKey:@"cat_aliases"];
    }
    
    if ([GlobalDataUser sharedAccountClient].dicPriceSearchParam.count>0) {
        [params setValue:[GlobalDataUser sharedAccountClient].dicPriceSearchParam  forKey:@"prices"];
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
    
//    NSLog(@"%@",[GlobalDataUser sharedAccountClient].dicCuisineSearchParam);
    [params setValue:paramsForSearch  forKey:@"params"];
    NSLog(@"%@",params);
    if (!self.branches) {
        self.branches=[[TVBranches alloc] initWithPath:@"search/branch"];
    }
    _lastPosition=_currentCameraPosition;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (weakSelf.branches.count>0&&isSearchYES) {
                TVBranch* branch=weakSelf.branches[0];
                _locationPickerView.mapView.camera = [GMSCameraPosition cameraWithTarget:branch.latlng zoom:14];
            }
            if (weakSelf.branches.count==0) {
                [_locationPickerView expandMapView:nil];
                [self alertWhenNoDataLoaded];
            }
            _lastUpdate=[NSDate date];
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
    
    return [location1 distanceFromLocation: location2];
}

#pragma mark - UIscrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_notificationView closeButtonClicked:nil];
}


#pragma mark - SearchVCDelegate
-(void)didClickedOnButtonSearch:(NSMutableDictionary *)params withLatlng:(CLLocationCoordinate2D)latlng{
    _locationPickerView.mapView.camera = [GMSCameraPosition cameraWithTarget:latlng zoom:14];
    [self postSearchBranch:params withReturnFromSearchScreenYES:YES];
}
-(void)didPickDistricts:(NSArray *)arrDics{
    _arrDics=arrDics;
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
    NSLog(@"_lastPosition.latitude=%f",_lastPosition.latitude);
    if (_lastPosition.latitude) {
        double distance=[self getDistanceMetresFrom:position.target toLocation:_lastPosition];
        NSLog(@"distance ==== %f",distance);
        if (distance>kTVDistanceMovingMap) {
            if ([_lastUpdate isLaterThanSeconds:2]) {
                CLLocationCoordinate2D bottomLeftCoord =
                mapView.projection.visibleRegion.nearLeft;
                double distanceMetres=[self getDistanceMetresFrom:position.target toLocation:bottomLeftCoord];
                int radiusKm=distanceMetres/1000;
                NSDictionary *params = nil;
                CLLocationCoordinate2D location=position.target;
                
                if (location.latitude) {
                    NSString* strLatLng=[NSString   stringWithFormat:@"%f,%f",location.latitude,location.longitude];
                    params = @{@"city_alias": [[GlobalDataUser sharedAccountClient].dicCity valueForKey:@"alias"],@"latlng": strLatLng
                               ,@"distance": [NSString stringWithFormat:@"%d",(radiusKm)?radiusKm:1]
                               };
                }
                [self performSelector:@selector(postSearchBranch:withReturnFromSearchScreenYES:) withObject:[[NSMutableDictionary alloc] initWithDictionary:params] afterDelay:2];
                _currentCameraPosition=position.target;
            }
        }
    }else
        _lastPosition=position.target;
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    //
    TVBranch* branch= _branches[[marker.title intValue]];
    UIImageView* imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [imgPhoto setImageWithURL:[Ultilities getThumbImageOfCoverBranch:branch.arrURLImages]];
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 308, 110)];
    [view addSubview:imgPhoto];

    UIView* _whiteView;
    UILabel* textLabel= [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel* detailTextLabel= [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.textColor = [UIColor redColor];
    
    detailTextLabel.numberOfLines = 1;
    textLabel.backgroundColor=[UIColor clearColor];
    detailTextLabel.backgroundColor=[UIColor clearColor];

    UILabel* price_avg = [[UILabel alloc] initWithFrame:CGRectZero];
    price_avg.backgroundColor = [UIColor clearColor];
    
    price_avg.textColor = [UIColor grayColor];
    price_avg.highlightedTextColor = [UIColor whiteColor];
    
    
    textLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    price_avg.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 53.0, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    
    
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(80.0, 0, 234, 96)];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    // Get the Layer of any view
    CALayer * l = [_whiteView layer];
    [Ultilities setBorderForLayer:l radius:3];
    
    l = [imgPhoto layer];
    [Ultilities setBorderForLayer:l radius:1];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 66.0f, 234.0f, 1.0f)];
    grayLine.backgroundColor = [UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f];
    [_whiteView addSubview:grayLine];
    [_whiteView addSubview:textLabel];
    [_whiteView addSubview:detailTextLabel];
    [_whiteView addSubview:price_avg];
    [_whiteView addSubview:homeIcon];
    [_whiteView addSubview:price_avgIcon];
    
    [view  addSubview:_whiteView];

    textLabel.frame = CGRectMake(10.0f, 8.0f, 222.0f, 20.0f);
    detailTextLabel.frame = CGRectMake(25.0f, 30.0f, 210.0f, 20.0f);
    price_avg.frame = CGRectMake(25.0f, 48.0f, 210.0f, 20.0f);
    textLabel.text=branch.name;
    detailTextLabel.text=branch.address_full;
    price_avg.text=branch.price_avg;
//    NSLog(@"%@",branch.utilities);
    int countUtilities=0;
    for (NSString* strAlias in branch.utilities) {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"(alias == %@)",strAlias];
        NSDictionary* params=[SharedAppDelegate getParamData];
        NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
        NSArray* idPublicArr = [[dicCuisines allValues] filteredArrayUsingPredicate:filter];
        NSDictionary* utilityDic=[idPublicArr lastObject];
        
        UIImageView *iconIView = [[UIImageView alloc] initWithFrame:CGRectMake(8+countUtilities*(8+18),73, 18, 18)];
        
        [iconIView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",[utilityDic valueForKey:@"id"]]]];
        [_whiteView addSubview:iconIView];
        countUtilities++;
    }
    return view;
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

- (void)settingForCell:(BranchMainCell *)cell indexPath:(NSIndexPath *)indexPath {
    int countUtilities=0;
    TVBranch* branch=self.branches[indexPath.row];
    
    for (NSString* strAlias in [branch utilities]) {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"(alias == %@)",strAlias];
        NSDictionary* params=[SharedAppDelegate getParamData];
        NSDictionary* dicCuisines=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
        NSArray* idPublicArr = [[dicCuisines allValues] filteredArrayUsingPredicate:filter];
        NSDictionary* utilityDic=[idPublicArr lastObject];
        
        UIImageView *iconIView = [[UIImageView alloc] initWithFrame:CGRectMake(countUtilities*(8+18),0, 18, 18)];
        [iconIView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",[utilityDic valueForKey:@"id"]]]];
        
        [cell.utility addSubview:iconIView];
        countUtilities++;
    }
    
    int lineHeight=25;
    
    for (TVCoupon* coupon in branch.coupons.items) {
        UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+25, lineHeight, 265, 25)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor grayColor];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(15)];
        lblAddress.numberOfLines = 0;
        lblAddress.lineBreakMode = UILineBreakModeWordWrap;
        lblAddress.text=coupon.name;
        [lblAddress sizeToFit];
        [cell.utility addSubview:lblAddress];
        
        UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, lineHeight, 25, 25)];
        homeIcon.image=[UIImage imageNamed:@"img_camera_cell_button"];
        [cell.utility addSubview:homeIcon];
        lineHeight+=lblAddress.frame.size.height+5;
    }
    
    CGRect frame=cell.utility.frame;
    frame.size.height+=branch.coupons.items.count*30;
    [cell.utility setFrame:frame];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    BranchMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BranchMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [self settingForCell:cell indexPath:indexPath];
    }
    else{
        [[cell.utility subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self settingForCell:cell indexPath:indexPath];
    }
    cell.branch = self.branches[indexPath.row];
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
