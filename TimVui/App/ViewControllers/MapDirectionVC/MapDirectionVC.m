//
//  MapDirectionVC.m
//  Anuong
//
//  Created by Hoang The Hung on 9/6/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "MapDirectionVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SDWebImageManager.h"
#import "UIImage+Crop.h"
#import "MDDirectionService.h"
#import "NSDictionary+Extensions.h"
@interface MapDirectionVC (){
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    BOOL firstLocationUpdate_;
    UILabel *_lblDistance;
}
@end

@implementation MapDirectionVC
-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_branch.latlng.latitude
                                                            longitude:_branch.latlng.longitude  
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];

    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = mapView_;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    _lblDistance=[[UILabel alloc] initWithFrame:CGRectMake(10, 416-26-5,300 , 26)];
    _lblDistance.backgroundColor = [UIColor clearColor];
    _lblDistance.textColor = [UIColor whiteColor];
    _lblDistance.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    
    [mapView_ addSubview:_lblDistance];
//    _lblDistance.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _lblDistance.hidden=YES;
    CALayer* l=_lblDistance.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:13];
    [_lblDistance setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:.5]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
    melbourneMarker.position =  _branch.latlng;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[_branch.arrURLImages valueForKey:@"80"]
                    delegate:self
                     options:0
                     success:^(UIImage *image, BOOL cached)
     {
         UIImage *bottomImage = [UIImage imageNamed:@"imgMapMakerBackground"]; //background image
         image=[image imageByScalingAndCroppingForSize:CGSizeMake(40, 30)];
         UIGraphicsBeginImageContext( bottomImage.size );
         [bottomImage drawAtPoint:CGPointZero];
         [image drawInRect:CGRectMake(6.0f,6.0f,30,30/4*3) blendMode:kCGBlendModeNormal alpha:1];
         UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         melbourneMarker.icon = newImage;
         melbourneMarker.map = mapView_;
     }
        failure:nil];
    [waypoints_ addObject:melbourneMarker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                _branch.latlng.latitude,_branch.latlng.longitude];
    [waypointStrings_ addObject:positionString];
    
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
        marker.map = mapView_;
        [waypoints_ addObject:marker];
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    location.coordinate.latitude,location.coordinate.longitude];
        [waypointStrings_ addObject:positionString];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:mapView_.camera.zoom];
        
        if([waypoints_ count]>1){
            NSString *sensor = @"true";
            NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                   nil];
            NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
            NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                              forKeys:keys];
            MDDirectionService *mds=[[MDDirectionService alloc] init];
            SEL selector = @selector(addDirections:);
            [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
        }
    }else{
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:mapView_.camera.zoom];
    }
}

- (void)addDirections:(NSDictionary *)json {
//    NSLog(@"addDirections == %@",json);
    if ([[json safeArrayForKey:@"routes"] count]==0) {
        return;
    }
    NSDictionary *routes = [json safeArrayForKey:@"routes"][0];
//    NSLog(@"legs = %@",[routes safeArrayForKey:@"legs"][0]);
    NSDictionary* legs=[routes safeArrayForKey:@"legs"][0];
    NSString* strDistance=[legs safeStringForKeyPath:@"distance.text"];
//    NSString* strTime=[legs safeStringForKeyPath:@"duration.text"];
    _lblDistance.text=[NSString stringWithFormat:@"   Khoảng cách %@.",strDistance];
    _lblDistance.hidden=NO;
    _lblDistance.textAlignment=UITextAlignmentCenter;
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
//    NSLog(@"overview_route = %@",overview_route);
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = kCyanGreenColor;
    polyline.strokeWidth = 5.f;
    GMSCoordinateBounds *bounds= [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                             withPadding:50.0f];
    [mapView_ moveCamera:update];
    polyline.map = mapView_;
}

- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
