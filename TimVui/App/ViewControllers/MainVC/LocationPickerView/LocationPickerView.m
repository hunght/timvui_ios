    //
//  LocationPickerView.m
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Futura IO. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LocationPickerView.h"
#import "GlobalDataUser.h"
@interface LocationPickerView ()
{
@private
    double lastDragOffset;

}
@property (nonatomic) BOOL isMapAnimating;
@property (nonatomic) CGRect defaultMapViewFrame;
@property (nonatomic, strong) UITapGestureRecognizer *mapTapGesture;

/** This is only created if the user does not override the 
 mapViewDidExpand: method. Allows the user to shrink the map. */
@property (nonatomic, strong) UIButton *closeMapButton;
@property (nonatomic, strong) UIButton *currentLocation;

@property (nonatomic, strong) UIButton *btnZoomIn;
@property (nonatomic, strong) UIButton *btnZoomOut;

@end

@implementation LocationPickerView

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _defaultMapHeight               = 130.0f;
    _parallaxScrollFactor           = 0.6f;
    _amountToScrollToFullScreenMap  = 110.0f;
    self.autoresizesSubviews        = YES;
    self.autoresizingMask           = UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleHeight;
}

- (void)dealloc
{
    void *context = (__bridge void *)self;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:context];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self.tableViewDelegate;
        self.tableView.dataSource = self.tableViewDataSource;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        
        // Add scroll view KVO
        void *context = (__bridge void *)self;
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
        
        [self addSubview:self.tableView];
        
        if ([self.delegate respondsToSelector:@selector(locationPicker:tableViewDidLoad:)]) {
            [self.delegate locationPicker:self tableViewDidLoad:self.tableView];
        }
        
        if (self.tableViewDidLoadBlock) {
            self.tableViewDidLoadBlock(self);
        }
    }
    
    if (!self.tableView.tableHeaderView) {
        CGRect tableHeaderViewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, self.defaultMapHeight);
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderViewFrame];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = tableHeaderView;
    }
    
    if (!self.mapView) {
        self.defaultMapViewFrame = CGRectMake(0.0,
                                              -self.defaultMapHeight * self.parallaxScrollFactor * 2,
                                              self.tableView.frame.size.width,
                                              self.defaultMapHeight + (self.defaultMapHeight * self.parallaxScrollFactor * 4));
        _mapView = [[GMSMapView alloc] initWithFrame:self.defaultMapViewFrame];
        GMSCameraPosition *camera =
        [[GMSCameraPosition alloc] initWithTarget:[GlobalDataUser sharedAccountClient].userLocation
                                             zoom:14
                                          bearing:0
                                     viewingAngle:0];
        [_mapView setCamera:camera];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.mapView.delegate = self.mapViewDelegate;
        [self insertSubview:self.mapView belowSubview:self.tableView];
        
        if ([self.delegate respondsToSelector:@selector(locationPicker:mapViewDidLoad:)]) {
            [self.delegate locationPicker:self mapViewDidLoad:self.mapView];
        }
        
        if (self.mapViewDidLoadBlock) {
            self.mapViewDidLoadBlock(self);
        }
    }
    // Add tap gesture to table
    if (!self.mapTapGesture) {
        self.mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(mapWasTapped:)];
        self.mapTapGesture.cancelsTouchesInView = YES;
        self.mapTapGesture.delaysTouchesBegan = NO;
        [self.tableView.tableHeaderView addGestureRecognizer:self.mapTapGesture];
    }
    
//    UIView* toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.tableView.bounds.size.width, 50)];
//    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//    [toolbar setBackgroundColor:[UIColor redColor]];
//    [self.tableView addSubview:toolbar];
    if (!_btnSearchBar) {
        _btnSearchBar = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 301, 42)];
        [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_off"] forState:UIControlStateNormal];
        [_btnSearchBar setImage:[UIImage imageNamed:@"img_search_bar_on"] forState:UIControlStateHighlighted];
        [_btnSearchBar addTarget:self action:@selector(searchBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnSearchBar];
    }
}

-(void)searchBarButtonClicked{
    if ([_delegate respondsToSelector:@selector(locationPickerSearchBarButtonClicked)]) {
        [_delegate locationPickerSearchBarButtonClicked];
    }
}
- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource
{
    _tableViewDataSource = tableViewDataSource;
    self.tableView.dataSource = _tableViewDataSource;
    
    if (_tableViewDelegate) {
        [self.tableView reloadData];
    }
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    _tableViewDelegate = tableViewDelegate;
    self.tableView.delegate = _tableViewDelegate;
    
    if (_tableViewDataSource) {
        [self.tableView reloadData];
    }
}

- (void)setMapViewDelegate:(id<GMSMapViewDelegate>)mapViewDelegate
{
    _mapViewDelegate = mapViewDelegate;
    self.mapView.delegate = _mapViewDelegate;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    if ([self.delegate respondsToSelector:@selector(locationPicker:tableViewDidLoad:)]) {
        [self.delegate locationPicker:self tableViewDidLoad:self.tableView];
    }
    
    if (self.tableViewDidLoadBlock) {
        self.tableViewDidLoadBlock(self);
    }
}

- (void)setMapView:(GMSMapView *)mapView
{
    _mapView = mapView;
    
    if ([self.delegate respondsToSelector:@selector(locationPicker:mapViewDidLoad:)]) {
        [self.delegate locationPicker:self mapViewDidLoad:self.mapView];
    }
    
    if (self.mapViewDidLoadBlock) {
        self.mapViewDidLoadBlock(self);
    }
}
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    double contentOffset = self.tableView.contentOffset.y;
    lastDragOffset = contentOffset;
}


#pragma mark - Internal Methods
-(void)zoomInMapView:(id)sender{
    [self.mapView animateToZoom:self.mapView.camera.zoom+2];
}

-(void)zoomOutMapView:(id)sender{
    [self.mapView animateToZoom:self.mapView.camera.zoom-2];
}

-(void)currentLocationBarButtonClicked:(id)sender{
    [self.mapView animateToLocation:[GlobalDataUser sharedAccountClient].userLocation];
}

- (void)mapWasTapped:(id)sender
{ 
    [self expandMapView:self];
}

- (void)showCloseMapButton
{
    if (!self.currentLocation) {
        
        self.currentLocation = [[UIButton alloc] initWithFrame:CGRectMake(272, 180, 40, 40)];
        [self.currentLocation setImage:[UIImage imageNamed:@"img_map_view_user_current_location"] forState:UIControlStateNormal];
        [self.currentLocation addTarget:self action:@selector(currentLocationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.currentLocation setBackgroundColor:[UIColor whiteColor]];
        CALayer *l=self.currentLocation.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:2.0];
        [self insertSubview:self.currentLocation aboveSubview:self.mapView];

        self.closeMapButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 180, 40, 40)];
        [self.closeMapButton setImage:[UIImage imageNamed:@"img_map_view_menu_icon"] forState:UIControlStateNormal];
        [self.closeMapButton addTarget:self action:@selector(hideMapView:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeMapButton setBackgroundColor:[UIColor whiteColor]];
        l=self.closeMapButton.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:2.0];
        [self insertSubview:self.closeMapButton aboveSubview:self.mapView];
        
        self.btnZoomIn = [[UIButton alloc] initWithFrame:CGRectMake(272, 290, 40, 40)];
        [self.btnZoomIn setImage:[UIImage imageNamed:@"img_map_view_zoom_in"] forState:UIControlStateNormal];
        [self.btnZoomIn addTarget:self action:@selector(zoomInMapView:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnZoomIn setBackgroundColor:[UIColor whiteColor]];
        l=self.btnZoomIn.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:2.0];
        
        self.btnZoomIn.hidden = YES;
        [self insertSubview:self.btnZoomIn aboveSubview:self.mapView];
        

        self.btnZoomOut = [[UIButton alloc] initWithFrame:CGRectMake(272, 333, 40, 40)];
        [self.btnZoomOut setImage:[UIImage imageNamed:@"img_map_view_zoom_out"] forState:UIControlStateNormal];
        [self.btnZoomOut addTarget:self action:@selector(zoomOutMapView:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnZoomOut setBackgroundColor:[UIColor whiteColor]];
        l=self.btnZoomOut.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:2.0];
        
        self.btnZoomOut.hidden = YES;
        [self insertSubview:self.btnZoomOut aboveSubview:self.mapView];
        
    }
    
    self.currentLocation.alpha = 0.0;
    self.currentLocation.hidden = NO;
    
    self.closeMapButton.alpha = 0.0;
    self.closeMapButton.hidden = NO;
    
    self.btnZoomOut.alpha = 0.0;
    self.btnZoomOut.hidden = NO;
    
    self.btnZoomIn.alpha = 0.0;
    self.btnZoomIn.hidden = NO;
    
    self.btnSearchBar.alpha = 0.0;
    self.btnSearchBar.hidden = NO;
    
    if (_btnSearchBar) {
        [_btnSearchBar removeFromSuperview];
        [self addSubview:_btnSearchBar];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.currentLocation.alpha=1.0;
                         self.closeMapButton.alpha=1.0;
                         self.btnZoomIn.alpha = 1.0;
                         self.btnZoomOut.alpha = 1.0;
                         self.btnSearchBar.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)hideCloseMapButton
{
    if (self.currentLocation) {
        self.closeMapButton.hidden = NO;
        self.currentLocation.hidden = NO;
        self.btnZoomIn.hidden = NO;
        self.btnZoomOut.hidden = NO;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.currentLocation.alpha = 0.0;
                             self.closeMapButton.alpha = 0.0;
                             
                             self.btnZoomOut.alpha = 0.0;
                             self.btnZoomIn.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.closeMapButton.hidden = YES;
                             self.currentLocation.hidden = YES;
                             
                             self.btnZoomIn.hidden = YES;
                             self.btnZoomOut.hidden = YES;
                             
                         }];
    }
}

#pragma mark - Public Methods

- (void)expandMapView:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(locationPicker:mapViewWillExpand:)]) {
        [self.delegate locationPicker:self mapViewWillExpand:self.mapView];
    }
    
    self.isMapAnimating = YES;
    [self.tableView.tableHeaderView removeGestureRecognizer:self.mapTapGesture];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    CGRect newMapFrame = self.mapView.frame;
    newMapFrame = CGRectMake(self.defaultMapViewFrame.origin.x,
                             self.defaultMapViewFrame.origin.y + (self.defaultMapHeight * self.parallaxScrollFactor),
                             self.defaultMapViewFrame.size.width,
                             self.defaultMapHeight + (self.defaultMapHeight * self.parallaxScrollFactor * 2));
    self.mapView.frame = newMapFrame;
    
    [self bringSubviewToFront:self.mapView];
    [self insertSubview:self.closeMapButton aboveSubview:self.mapView];
    [self insertSubview:self.currentLocation aboveSubview:self.mapView];
    
    [self insertSubview:self.btnZoomOut aboveSubview:self.mapView];
    [self insertSubview:self.btnZoomIn aboveSubview:self.mapView];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mapView.frame = self.bounds;
                     } completion:^(BOOL finished) {
                         self.isMapAnimating = NO;
                         _isMapFullScreen = YES;
                         
                         if ([self.delegate respondsToSelector:@selector(locationPicker:mapViewDidExpand:)]) {
                             [self.delegate locationPicker:self mapViewDidExpand:self.mapView];
                         }
                         
                         if (self.shouldCreateHideMapButton) {
                             [self showCloseMapButton];
                         }
                     }];
}

- (void)hideMapView:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(locationPicker:mapViewWillBeHidden:)]) {
        [self.delegate locationPicker:self mapViewWillBeHidden:self.mapView];
    }
    
    if (self.shouldCreateHideMapButton) {
        [self hideCloseMapButton];
    }
    
    self.isMapAnimating = YES;
    [self.tableView.tableHeaderView addGestureRecognizer:self.mapTapGesture];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newMapFrame = CGRectMake(self.mapView.frame.origin.x,
                                                         self.mapView.frame.origin.y,
                                                         self.mapView.frame.size.width,
                                                         self.defaultMapHeight);
                         self.mapView.frame = newMapFrame;
                     } completion:^(BOOL finished) {
                         
                         // "Pop" the map view back in
                         self.mapView.frame = self.defaultMapViewFrame;
                         [self insertSubview:self.mapView belowSubview:self.tableView];
                         [self insertSubview:self.closeMapButton aboveSubview:self.mapView];
                         [self insertSubview:self.currentLocation aboveSubview:self.mapView];
                         
                         [self insertSubview:self.btnZoomIn aboveSubview:self.mapView];
                         [self insertSubview:self.btnZoomOut aboveSubview:self.mapView];
                         
                         self.isMapAnimating = NO;
                         _isMapFullScreen = NO;
                         
                         if ([self.delegate respondsToSelector:@selector(locationPicker:mapViewWasHidden:)]) {
                             [self.delegate locationPicker:self mapViewWasHidden:self.mapView];
                         }
                     }];
}

- (void)toggleMapView:(id)sender
{
    if (!self.isMapAnimating) {
        if (self.isMapFullScreen) {
            [self hideMapView:self];
        }
        else {
            [self expandMapView:self];
        }
    }
}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{    
	// Make sure we are observing this value.
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    
    if ((object == self.tableView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.tableView.contentOffset.y];
        return;
    }
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    BOOL isScrollViewIsDraggedDownwards;
    if (scrollOffset < lastDragOffset){
        isScrollViewIsDraggedDownwards = YES;
        
    }
    else
        isScrollViewIsDraggedDownwards = NO;
    
    if ((self.isMapFullScreen == NO) &&
        (self.isMapAnimating == NO)) {
        CGFloat mapFrameYAdjustment = 0.0;
        if (scrollOffset < -30) {
            if (self.pullToExpandMapEnabled
                ){
                [self expandMapView:self];
            }
            else {
                mapFrameYAdjustment = self.defaultMapViewFrame.origin.y - (scrollOffset * self.parallaxScrollFactor);
            }
        }else {
            mapFrameYAdjustment = self.defaultMapViewFrame.origin.y - (scrollOffset * self.parallaxScrollFactor);
            // Don't move the map way off-screen
            if (mapFrameYAdjustment <= -(self.defaultMapViewFrame.size.height)) {
                mapFrameYAdjustment = -(self.defaultMapViewFrame.size.height);
            }
        }
        
        if (mapFrameYAdjustment) {
            CGRect newMapFrame = self.mapView.frame;
            newMapFrame.origin.y = mapFrameYAdjustment;
            [self.mapView setFrame:newMapFrame];
        }
        if ( isScrollViewIsDraggedDownwards && scrollOffset < 70 ) {
            
            if ([self.btnSearchBar isHidden]) {
                self.btnSearchBar.alpha = 0.0;
                self.btnSearchBar.hidden = NO;
                [UIView animateWithDuration:0.3
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     self.btnSearchBar.alpha = 1.0;
                                 }
                                 completion:nil];
            }
        }else if ( !isScrollViewIsDraggedDownwards && scrollOffset > 70 ) {
            if (![_btnSearchBar isHidden]) {
                self.btnSearchBar.alpha = 1.0;
                self.btnSearchBar.hidden = YES;
                [UIView animateWithDuration:0.3
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     self.btnSearchBar.alpha = 0.0;
                                 }
                                 completion:nil];
            }
        }
    }
}

@end
