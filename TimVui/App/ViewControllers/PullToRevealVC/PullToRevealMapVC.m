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
@interface PullToRevealMapVC () <UIScrollViewDelegate, UITextFieldDelegate, MKMapViewDelegate>
{
    @private
    UIView *toolbar;
    BOOL scrollViewIsDraggedDownwards;
    double lastDragOffset;
    
    @public
    MKMapView *mapView;
    BOOL centerUserLocation;
}
@end

@implementation PullToRevealMapVC

@synthesize pullToRevealDelegate;
@synthesize centerUserLocation;
@synthesize mapView;


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
    [self displayMapViewAnnotationsForTableViewCells];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (mapView.frame.size.height==self.tableView.bounds.size.height)
        return;
    
    [mapView setFrame:
     CGRectMake(0, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height)
     ];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.bounds.size.height,0,0,0)];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void) centerToUserLocation
{
    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
}

- (void) zoomToUserLocation
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 21.009550;
    newRegion.center.longitude = 105.802727;
    //  newRegion.center=[GlobalDataUser sharedAccountClient].userLocation.coordinate;
    //    mapView.userLocation.coordinate=newRegion.center;
    
    
    newRegion.span.latitudeDelta = 0.012872*7;
    newRegion.span.longitudeDelta = 0.009863*7;
    [self.mapView setRegion:newRegion animated:NO];
}

#pragma mark - Init methods
- (void) initializeMapView
{

    [self.tableView setContentInset:UIEdgeInsetsMake(kTableViewContentInsetX,0,0,0)];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.tableView.contentInset.top*-1, self.tableView.bounds.size.width, self.tableView.contentInset.top)];
    [mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [mapView setShowsUserLocation:YES];
    self.mapView.showsUserLocation = YES;
    [mapView setUserInteractionEnabled:YES];
    [mapView setDelegate:self];
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapMapView:)];
    [singleFingerTap setDelegate:self];
    [self.mapView addGestureRecognizer:singleFingerTap];
    
    centerUserLocation=YES;
    if(centerUserLocation)
    {
        [self centerToUserLocation];
        [self zoomToUserLocation];
    }
    [self.tableView insertSubview:mapView aboveSubview:self.tableView];
}

- (void) initalizeToolbar
{
    _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 301, 42)];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_off"] forState:UIControlStateNormal];
    [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_on"] forState:UIControlStateHighlighted];
    [_btnSearchBar addTarget:self action:@selector(searchBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:_btnSearchBar];
    
    toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.tableView.bounds.size.width, 20)];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [toolbar setBackgroundColor:[UIColor clearColor]];
    
    //[self.tableView insertSubview:toolbar aboveSubview:self.tableView];
}




#pragma mark - ScrollView Delegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    double contentOffset = scrollView.contentOffset.y;
    lastDragOffset = contentOffset;

    if(contentOffset < kTableViewContentInsetX*-1)
    {
        [self zoomMapToFitAnnotations];
        //[mapView setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^()
         {
             [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.bounds.size.height,0,0,0)];
             [self.tableView scrollsToTop];
         }];
    }
    else if (contentOffset >= kTableViewContentInsetX*-1)
    {
        //[mapView setUserInteractionEnabled:NO];
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^()
         {
             [self.tableView setContentInset:UIEdgeInsetsMake(kTableViewContentInsetX,0,0,0)];

         }];
        
        if(centerUserLocation)
        {
            [self centerToUserLocation];
            [self zoomToUserLocation];
        }
        
        [self.tableView scrollsToTop];
    }
    NSLog(@"contentOffset:%f",contentOffset);
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    double contentOffset = scrollView.contentOffset.y;
    
    if (contentOffset < lastDragOffset)
        scrollViewIsDraggedDownwards = YES;
    else
        scrollViewIsDraggedDownwards = NO;

    if (!scrollViewIsDraggedDownwards)
    {
        [mapView setFrame:
         CGRectMake(0, self.tableView.contentInset.top*-1, self.tableView.bounds.size.width, self.tableView.contentInset.top)
         ];
        //[mapView setUserInteractionEnabled:NO];

        [self.tableView setContentInset:UIEdgeInsetsMake(kTableViewContentInsetX,0,0,0)];
        
        if(centerUserLocation)
        {
            [self centerToUserLocation];
            [self zoomToUserLocation];
        }
        
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
        [mapView setFrame:
         CGRectMake(0, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, contentOffset*-1)
         ];
        [self zoomMapToFitAnnotations];
    }
    
    if(centerUserLocation)
    {
        [self centerToUserLocation];
        [self zoomToUserLocation];
        [self displayMapViewAnnotationsForTableViewCells];
    }
}




#pragma mark - MKMapview Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self centerUserLocation];
}

- (void) displayMapViewAnnotationsForTableViewCells
{
    [mapView removeAnnotations:mapView.annotations];
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++)
    {
        
    }
}

- (void) zoomMapToFitAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [mapView setVisibleMapRect:zoomRect animated:NO];
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [self displayMapViewAnnotationsForTableViewCells];
}
@end
