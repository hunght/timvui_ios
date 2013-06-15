//
//  PullToRevealViewController.m
//  PullToReveal
//
//  Created by Marcus Kida on 02.11.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#define kTableViewContentInsetX     133.0f
#define kAnimationDuration          0.5f

#import "PullToRevealMapVC.h"
#import "GlobalDataUser.h"
#import "Ultilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Crop.h"
@interface PullToRevealMapVC () <UIScrollViewDelegate, UITextFieldDelegate>
{
    @private
    UIView *toolbar;
    BOOL scrollViewIsDraggedDownwards;
    double lastDragOffset;
    BOOL firstLocationUpdate_;
    @public
}
@end

@implementation PullToRevealMapVC
@synthesize pullToRevealDelegate;
@synthesize mapView=mapView_;


#pragma mark - Init methods
- (void) initializeMapView
{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    CLLocationCoordinate2D userLocation=[GlobalDataUser sharedAccountClient].userLocation;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:userLocation.latitude
                                                            longitude:userLocation.longitude
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, self.tableView.contentInset.top*-1, self.tableView.bounds.size.width, self.tableView.contentInset.top) camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    [self.tableView setContentInset:UIEdgeInsetsMake(kTableViewContentInsetX,0,0,0)];
    [mapView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapMapView:)];
    [singleFingerTap setDelegate:self];
    [self.mapView addGestureRecognizer:singleFingerTap];
    
    [self.tableView insertSubview:mapView_ aboveSubview:self.tableView];
}

- (void) initalizeToolbar
{
    _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 301, 42)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(searchBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:_btnSearchBar];

    toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.tableView.bounds.size.width, 50)];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [toolbar setBackgroundColor:[UIColor clearColor]];

    UIButton*menu_icon = [[UIButton alloc] initWithFrame:CGRectMake(8, -50, 40, 40)];
    [menu_icon setImage:[UIImage imageNamed:@"img_map_view_menu_icon"] forState:UIControlStateNormal];
    [menu_icon addTarget:self action:@selector(menuLocationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [menu_icon setBackgroundColor:[UIColor whiteColor]];
    CALayer *l=menu_icon.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0];
    [self.tableView addSubview:menu_icon];
    
    UIButton*user_current_location = [[UIButton alloc] initWithFrame:CGRectMake(272, -50, 40, 40)];
    [user_current_location setImage:[UIImage imageNamed:@"img_map_view_user_current_location"] forState:UIControlStateNormal];
    [user_current_location addTarget:self action:@selector(currentLocationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [user_current_location setBackgroundColor:[UIColor whiteColor]];
    l=user_current_location.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0];
    [self.tableView addSubview:user_current_location];
    
    [self.tableView insertSubview:toolbar aboveSubview:self.tableView];
}

#pragma mark - ViewControllerDelegate
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeMapView];
    [self initalizeToolbar];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}
#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
}
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
     
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
    
    
    return nil;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    return YES;
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
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
        
    }
}

-(void)showBranchOnMap{
    NSLog(@"%d",_branches.count);
    
    for (TVBranch* branch in _branches.items) {
        
        // Add a custom 'arrow' marker pointing to Melbourne.
        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
//        melbourneMarker.title = @"Melbourne!";
        
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
             melbourneMarker.map = mapView_;
         }
                         failure:nil];
    }

}

#pragma mark - Helper
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
        if ([touch.view isEqual:_btnSearchBar]) {
            // we touched our control surface
            return NO; // ignore the touch
        }

    return YES; // handle the touch
}

//The event handling method
- (void)handleSingleTapMapView:(UITapGestureRecognizer *)recognizer {
    //    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    // Resize map to viewable size
    if (mapView_.frame.size.height==self.tableView.bounds.size.height)
        return;
    
    [mapView_ setFrame:
     CGRectMake(0, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height)
     ];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.bounds.size.height,0,0,0)];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}



#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    double contentOffset = scrollView.contentOffset.y;
    
    lastDragOffset = contentOffset;

    if(contentOffset < kTableViewContentInsetX*-1)
    {
        [self zoomMapToFitAnnotations];
//        [mapView_ setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^()
         {
             [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.bounds.size.height,0,0,0)];
             [self.tableView scrollsToTop];
         }];
    }
    else if (contentOffset >= kTableViewContentInsetX*-1)
    {
//        [mapView_ setUserInteractionEnabled:NO];
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^()
         {
             [self.tableView setContentInset:UIEdgeInsetsMake(kTableViewContentInsetX,0,0,0)];

         }];
        [self.tableView scrollsToTop];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    double contentOffset = scrollView.contentOffset.y;
    NSLog(@"contentOffset=%f",contentOffset);
    if (contentOffset < lastDragOffset)
        scrollViewIsDraggedDownwards = YES;
    else
        scrollViewIsDraggedDownwards = NO;
    
    if (!scrollViewIsDraggedDownwards)
    {
        [mapView_ setFrame:
         CGRectMake(0, self.tableView.contentInset.top*-1, self.tableView.bounds.size.width, self.tableView.contentInset.top)
         ];

        [self.tableView setContentInset:UIEdgeInsetsMake(kTableViewContentInsetX,0,0,0)];

        [self.tableView scrollsToTop];
    }

    if(contentOffset >= -50)
    {
        [toolbar removeFromSuperview];
        [toolbar setFrame:CGRectMake(0, contentOffset, self.tableView.bounds.size.width, 50)];
        [self.tableView addSubview:toolbar];
    }
    else if(contentOffset < 0)
    {
        [toolbar removeFromSuperview];
        [toolbar setFrame:CGRectMake(0, -50, self.tableView.bounds.size.width, 50)];
        [self.tableView insertSubview:toolbar aboveSubview:self.tableView];
        
        // Resize map to viewable size
        [mapView_ setFrame:CGRectMake(0, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, contentOffset*-1)];
        [self zoomMapToFitAnnotations];
    }
}




- (void) zoomMapToFitAnnotations
{

}

@end
