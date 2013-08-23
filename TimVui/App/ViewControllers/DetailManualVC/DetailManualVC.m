//
//  DetailManualVC.m
//  Anuong
//
//  Created by Hoang The Hung on 7/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "DetailManualVC.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import "TVManual.h"
#import "TVCoupon.h"
#import "TVCoupons.h"
#import "TSMessage.h"
#import "BranchMainCell.h"
#import "TVBranch.h"
#import "TVAppDelegate.h"
#import "BranchProfileVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UIImage+Crop.h"
#import "FloatView.h"
#import "CMHTMLView.h"
@interface DetailManualVC ()<GMSMapViewDelegate>
{

@private
    TVManual* _manual;
    GMSMapView *mapView_;
}
@end

@implementation DetailManualVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManual:(TVManual*)manual
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _manual=manual;
        _branches=[[TVBranches alloc] initWithPath:@"branch/getById"];
        _branches.isNotSearchAPIYES=YES;
    }
    return self;
}

-(void)postGetBranches{
    if (_manual.branch_ids.count>0) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                _manual.branch_ids,@"id" ,
                                @"short",@"infoType",
                                nil];
        __unsafe_unretained __typeof(&*self)weakSelf = self;
        
        [weakSelf.branches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
            dispatch_async(dispatch_get_main_queue(),^ {
                //NSLog(@"weakSelf.branches.count===%@",[weakSelf.branches[0] name]);
                [self.tableView reloadData];
            });
        } failure:^(GHResource *instance, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^ {
                
            });
        }];

    }
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* floatView=[[FloatView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,320, 48) withScrollView:_tableView];
    [self.view addSubview:floatView];
    UIButton* _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 300, 34)];
    [_saveButton setTitle:@"Lưu lại" forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateNormal];
    
    [_saveButton setBackgroundImage:[Utilities imageFromColor:kPaleCyanGreenColor] forState:UIControlStateSelected];
    [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [floatView addSubview:_saveButton];
    
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    _couponBranch=[[UIView alloc] initWithFrame:CGRectMake(6, 6, 320-6*2, 200)];
    [_couponBranch setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=_couponBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 5, 300, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    lblTitle.numberOfLines = 0;
    lblTitle.lineBreakMode = UILineBreakModeWordWrap;
    [_couponBranch addSubview:lblTitle];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    
    int height=lblTitle.frame.origin.y+lblTitle.frame.size.height;
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><meta name=\"viewport\" content=\"user-scalable=no, width=200, initial-scale=.7, maximum-scale=.7\"/> <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" /><title></title></head><body style=\"background:transparent;\">"];
//        NSLog(@"%@",_manual.content);
    //continue building the string
    [html appendString:_manual.content];
    [html appendString:@"</body></html>"];
    [self.view insertSubview:_couponBranch belowSubview:self.tableView];
    
    CMHTMLView* htmlView = [[CMHTMLView alloc] initWithFrame:CGRectMake(6+5, height+5, 320-(6+5)*2, 25)] ;
    htmlView.backgroundColor = [UIColor clearColor];
    //htmlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin ;
    htmlView.scrollView.scrollEnabled=NO;
//    CGRect frame= htmlView.scrollView.frame;
//    frame.size.width-=22;
//    htmlView.frame=frame;
    htmlView.alpha = 0;
    
    [htmlView loadHtmlBody:html competition:^(NSError *error) {
        if (!error) {
            [UIView animateWithDuration:0.2 animations:^{
                self.tableView.alpha = 1;
            }];
            
            CGRect newBounds = htmlView.frame;
            newBounds.size.height = htmlView.scrollView.contentSize.height;
            htmlView.frame = newBounds;
            
            int height_p=htmlView.frame.origin.y+htmlView.frame.size.height+10;
            
            CGRect frame=_couponBranch.frame;
            frame.size.height=height_p;
            _couponBranch.frame=frame;
            
            if (_manual.branch_ids.count>0) {
                UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(25, 10, 300, 14)];
                lblTitle.backgroundColor = [UIColor clearColor];
                lblTitle.textColor = [UIColor whiteColor];
                lblTitle.font = [UIFont fontWithName:@"ArialMT" size:(13)];
                lblTitle.text=@"Danh sách gợi ý";
                
                
                UIView* viewButtons=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-35, 320, 35)];
                [viewButtons   setBackgroundColor:[UIColor colorWithRed:(72/255.0f) green:(217/255.0f) blue:(255/255.0f) alpha:1.0f]];
                [viewButtons addSubview:lblTitle];
                _btnListView = [[UIButton alloc] initWithFrame:CGRectMake(320-35,0 , 35, 35)];
                [_btnListView setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [_btnListView setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateSelected];
                [_btnListView setImage:[UIImage imageNamed:@"img_handbook_list_button"] forState:UIControlStateNormal];
                [_btnListView setImage:[UIImage imageNamed:@"img_handbook_list_button"] forState:UIControlStateSelected];
                [_btnListView addTarget:self action:@selector(listViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [viewButtons addSubview:_btnListView];
                
                _btnMapView = [[UIButton alloc] initWithFrame:CGRectMake(320-35-36,0 , 35, 35)];
                [_btnMapView setBackgroundImage:[Utilities imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [_btnMapView setBackgroundImage:[Utilities imageFromColor:kCyanGreenColor] forState:UIControlStateSelected];
                [_btnMapView setImage:[UIImage imageNamed:@"img_handbook_map_button"] forState:UIControlStateNormal];
                [_btnMapView setImage:[UIImage imageNamed:@"img_handbook_map_button"] forState:UIControlStateSelected];
                [_btnMapView addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [viewButtons addSubview:_btnMapView];
                [_couponBranch addSubview:viewButtons];
                _btnListView.selected=YES;
            }
            
            self.tableView.tableHeaderView = _couponBranch;
            [self postGetBranches];
            
            [UIView animateWithDuration:0.2 animations:^{
                htmlView.alpha = 1;
            }];
        }
    }];
    
    [_couponBranch addSubview:htmlView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showBranchOnMap{
    [mapView_ clear];
    NSLog(@"_branches.count = %d",_branches.count);
    int i=0;
    for (TVBranch* branch in _branches.items) {
        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
        melbourneMarker.title = [NSString stringWithFormat:@"%d",i];
        melbourneMarker.position =  branch.latlng;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[Utilities getThumbImageOfCoverBranch:branch.arrURLImages]
                        delegate:self
                         options:0
                         success:^(UIImage *image, BOOL cached)
         {
             UIImage *bottomImage = [UIImage imageNamed:@"imgMapMakerBackground"]; //background image
             image=[image imageByScalingAndCroppingForSize:CGSizeMake(40, 30)];
             UIGraphicsBeginImageContext( bottomImage.size );
             [bottomImage drawAtPoint:CGPointZero];
             [image drawInRect:CGRectMake(6.0f,5.0f,30.0f,30.0f) blendMode:kCGBlendModeNormal alpha:1];
             UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             melbourneMarker.icon = newImage;
             melbourneMarker.map = mapView_;
         }
                         failure:nil];
        i++;
    }
}

- (void)didTapFitBounds {
    GMSCoordinateBounds *bounds;
    for (TVBranch *marker in _branches.items) {
        if (bounds == nil) {
            bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.latlng
                                                          coordinate:marker.latlng];
        }
        bounds = [bounds includingCoordinate:marker.latlng];
    }
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                             withPadding:50.0f];
    [mapView_ moveCamera:update];
}


#pragma mark - IBActions
-(void)saveButtonClicked:(UIButton*)sender{
    NSDictionary *paramsHandBook = [NSDictionary dictionaryWithObjectsAndKeys:
                                    _manual.manualID,@"handbook_id" ,
                                    [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                                    nil];
    [[TVNetworkingClient sharedClient] postPath:@"handbook/userSaveHandbook" parameters:paramsHandBook success:^(AFHTTPRequestOperation *operation, id JSON) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Lưu cẩm nang thành công"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
        
        [self dismissModalViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Lưu cẩm nang thất bại thất bại"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    }];
}

-(void)listViewButtonClicked:(UIButton*)sender{
    sender.selected=YES;
    _btnMapView.selected=NO;
    if (!mapView_||mapView_.isHidden)return;
    if (mapView_) mapView_.hidden=YES;
    CGRect frame=    _couponBranch.frame;
    frame.size.height-=320;
    _couponBranch.frame=frame;
    self.tableView.tableHeaderView=_couponBranch;
    [_tableView reloadData];
    NSIndexPath *topPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:topPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)mapButtonClicked:(UIButton*)sender{
    sender.selected=YES;
    _btnListView.selected=NO;
    if (!mapView_) {
        TVBranch*branch=[_branches.items objectAtIndex:0];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:branch.latlng.latitude
                                                                longitude:branch.latlng.longitude
                                                                     zoom:4];
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, _couponBranch.frame.size.height, 320, 320) camera:camera];
        mapView_.delegate = self;
        [_couponBranch addSubview:mapView_];
        mapView_.hidden=YES;
        [self showBranchOnMap];
    }
    if (mapView_.isHidden==NO)return;
    CGRect frame = _couponBranch.frame;
    frame.size.height+=320;
    _couponBranch.frame=frame;
    self.tableView.tableHeaderView=_couponBranch;
    mapView_.hidden=NO;
    [_tableView reloadData];
    [self didTapFitBounds];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!mapView_|| mapView_.isHidden) {
        return [self.branches count];
    }else
        return 0;
    
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
