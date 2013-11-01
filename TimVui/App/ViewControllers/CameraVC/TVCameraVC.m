
#import "TVCameraVC.h"
#import "PageView.h"
#import "MacroApp.h"
#import "UIImage+Crop.h"
#import "UIView+Genie.h"
#import "TVAppDelegate.h"
#import "PhotoBrowseVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "TSMessage.h"
#import "PageTwoView.h"
#import "PageThreeView.h"
#import "PageFourView.h"
#import "PageFiveView.h"
#import "PageEightView.h"
#import "PageTwelveView.h"
#import "SIAlertView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@interface TVCameraVC ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

static int _numPages = 16;

@implementation TVCameraVC
{
@private
    double lastDragOffset;
}

#pragma mark - Init

- (void)initCameraCapture
{
    [self setCaptureManager:[[CaptureSessionManager alloc] init] ];
    
	[[self captureManager] addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
    
    [[self captureManager] addStillImageOutput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:[[[self view] layer] bounds]];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageToAddSkin) name:kImageCapturedSuccessfully object:nil];
    
	[[[self view] layer] insertSublayer:[[self captureManager] previewLayer] below:_imgImagePicked.layer];
    self.imgStillCamera=[[UIImageView alloc] initWithFrame:CGRectMake(0, 48, 320, 320)];
    _imgStillCamera.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:_imgStillCamera belowSubview:_pagingScrollView];
    [self.imgStillCamera setHidden:NO];
    [self.imgStillCamera setUserInteractionEnabled:NO];
    [[_captureManager captureSession] startRunning];
    _imgImagePicked.hidden=YES;
}

- (void)initScrollPagingView
{
    self.pagingScrollView.previewInsets = UIEdgeInsetsMake(0.0f, 50.0f, 0.0f, 50.0f);
    [self.pagingScrollView selectPageAtIndex:0 animated:NO];
	[self.pagingScrollView reloadPages];
    
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = _numPages;
    
    // Add scroll view KVO
    void *context = (__bridge void *)self;
    [self.pagingScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    if (_branch) {
        [self.pagingScrollView setNameBranchForPageViewName:_branch.name andAddress:_branch.address_full];
    }else{
        _viewSlidePickSkin.hidden=YES;
        [self.pagingScrollView setScrollEnabled:NO];
    }
}

#pragma mark - ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self statusBar:YES];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController.navigationBar dropShadow];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}


- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _arrImages=[[NSMutableArray alloc] init];
    _lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(5, -14, 20, 20)];
    _lblPhone.backgroundColor = [UIColor redColor];
    _lblPhone.textColor = [UIColor whiteColor];
    _lblPhone.textAlignment=UITextAlignmentCenter;
    _lblPhone.font = [UIFont fontWithName:@"ArialMT" size:(15)];
    
    CALayer* l=_lblPhone.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:10];
    
    [_lblPhone setHidden:YES];
    [_btnStoreImage addSubview:_lblPhone];

	[self initScrollPagingView];
    [self initCameraCapture];
    
    [_btnStoreImage setImage:[UIImage imageNamed:@"img_camera_store_photos"] forState:UIControlStateNormal];
    [_btnAlbumPicker setImage:[UIImage imageNamed:@"img_camera_album_picker"] forState:UIControlStateNormal];
    [_btnCameraSkin setBackgroundImage:[UIImage imageNamed:@"img_camera_camera_skin"] forState:UIControlStateNormal];
    [_btnCameraSkin setBackgroundImage:[UIImage imageNamed:@"img_camera_camera_skin_on"] forState:UIControlStateHighlighted];
    
    [_btnClose setImage:[UIImage imageNamed:@"img_camera_close"] forState:UIControlStateNormal];
    [_btnLocationPicker setImage:[UIImage imageNamed:@"img_camera_location_picker"] forState:UIControlStateNormal];
}

- (void)viewDidUnload {
    [self setBtnStoreImage:nil];
    [self setBtnAlbumPicker:nil];
    [self setBtnLocationPicker:nil];
    [self setBtnClose:nil];
    [self setImgImagePicked:nil];
    [self setBtnCameraSkin:nil];
    [self setViewNotify:nil];
    [self setViewSlidePickSkin:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    void *context = (__bridge void *)self;
    [self.pagingScrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
}

- (void)didReceiveMemoryWarning
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
	[self.pagingScrollView didReceiveMemoryWarning];
}

#pragma mark - Helper

-(void)showAnimationWhenDidTakeImage{
    
    CGRect rect= _btnStoreImage.frame;
    CGRect endRect = CGRectInset(rect, 5.0, 5.0);
    NSTimeInterval duration = 0.5;
    if (self.imgStillCamera.image) {
        [self.imgStillCamera genieInTransitionWithDuration:duration destinationRect:endRect destinationEdge:BCRectEdgeTop completion:
         ^{
             self.imgStillCamera.image=nil;
             self.imgImagePicked.image=nil;
             _lblPhone.text=[NSString stringWithFormat:@"%d",[_arrImages count]];
             // instantaneously make the image view small (scaled to 1% of its actual size)
             _lblPhone.transform = CGAffineTransformMakeScale(0.5, 0.5);
             [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                 // animate it to the identity transform (100% scale)
                 _lblPhone.transform = CGAffineTransformIdentity;
             } completion:^(BOOL finished){
                 // if you want to do something once the animation finishes, put it here
                 
                 [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                     // animate it to the identity transform (100% scale)
                     _lblPhone.transform = CGAffineTransformMakeScale(0.6, 0.6);
                 } completion:^(BOOL finished){
                     // if you want to do something once the animation finishes, put it here
                     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                         // animate it to the identity transform (100% scale)
                         _lblPhone.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished){
                         // if you want to do something once the animation finishes, put it here
                         _imgStillCamera.transform = CGAffineTransformIdentity;
                         _imgImagePicked.hidden=YES;
                         [self.captureManager.captureSession startRunning];
                     }];
                 }];
             }];
         }];
    }
}



- (void)mergeSkinWithImage:(UIImage *)bottomImage {
    PageView* pageView=[_pagingScrollView getPageForIndex:self.pageControl.currentPage];
    UIImage* newImage=[pageView mergeSkinWithImage:bottomImage];
    [_arrImages addObject:newImage];
    
    if (_lblPhone.isHidden)
        _lblPhone.hidden=NO;
    NSLog(@"newImage.size.height = %f",newImage.size.height);
    NSLog(@"newImage.size.width = %f",newImage.size.width);
    self.imgStillCamera.image=newImage;
    [self showAnimationWhenDidTakeImage];
}

-(void)getImageToAddSkin{
    if (self.captureManager.stillImage) {
        [self.captureManager.captureSession stopRunning];
        UIImage *bottomImage = [self.captureManager.stillImage cropImageInstagramStyleWithBottomBar:44+20]; //background image
        
        [self mergeSkinWithImage:bottomImage];
    }
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        
    }
}

#pragma mark - PhotoBrowseVCDelegate

-(void)didPickWithImages:(NSArray*)images{
    for (UIImage* image in images) {
        void (^completion)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
            if (error){
               
                NSLog(@"!!!ERROR,  write the image data to the assets library (camera roll): %@",
                      [error description]);
            }
            else{
                            }
            NSLog(@"*** URL %@ | %@ || type: %@ ***", assetURL, [assetURL absoluteString], [assetURL class]);
        };
        
        void (^failure)(NSError *) = ^(NSError *error) {
            
            if (error == nil) return;
            NSLog(@"!!!ERROR, failed to add the asset to the custom photo album: %@", [error description]);
        };
        ALAssetsLibrary* assetsLibrary_ = [[ALAssetsLibrary alloc] init];
        [assetsLibrary_ saveImage:image
                          toAlbum:kKYCustomPhotoAlbumName_
                       completion:completion
                          failure:failure];
    }
    [_arrImages removeAllObjects];
    _lblPhone.hidden=YES;
}

-(void)wantToShowLeft:(BOOL)isLeft{
    if (isLeft) {
        [self.slidingViewController anchorTopViewTo:ECLeft];
    }else    if (self.slidingViewController.underLeftViewController){
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}

#pragma mark - LocationTableVCDelegate

- (void)didPickedABranch:(TVBranch *)branch {
    if (_viewNotify){ [_viewNotify removeFromSuperview];
        _viewSlidePickSkin.hidden=NO;
    }
    [self.slidingViewController resetTopView];
    _branch=branch;
    _photoBrowseTableVC.branch=_branch;
    [self.pagingScrollView setScrollEnabled:YES];
    
//    _branch.name=@"Cua hang ban niem vui mua nu cuoi day that tuyet voi khi thay ban o day.";
//    _branch.address_full=@"ngay thang nga tu o cho dua, nhin sang duong ton duc thang, ngay tai cai cua hang rat to nhe.";
//    
    [self.pagingScrollView setNameBranchForPageViewName:_branch.name andAddress:_branch.address_full];
}

-(void)didPickWithLoation:(TVBranch *)branch{
    if (_arrImages.count>0){
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Nếu chọn địa điểm khác thì các ảnh vừa chụp sẽ bị xóa"];
    
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [_arrImages removeAllObjects];
                              _lblPhone.hidden=YES;
                              [self didPickedABranch:branch];
                          }];
    [alertView addButtonWithTitle:@"Hủy"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Cancel Clicked");
                          }];
    [alertView show];
    }else{
        [self didPickedABranch:branch];
    }
    
}

#pragma mark - SkinPickerTableVCDelegate

-(void)didPickWithAlbum:(NSString *)strAlbum{
    [self.slidingViewController resetTopView];
    _strAlbum=strAlbum;
    _photoBrowseTableVC.album=_strAlbum;
}

#pragma mark - IBActions

- (IBAction)pageTurn
{
	[self.pagingScrollView selectPageAtIndex:self.pageControl.currentPage animated:YES];
}

- (IBAction)cameraButtonClicked:(id)sender {
    if (!_branch) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Vui lòng chọn nhà hàng trước khi đăng ảnh"];
        
        [alertView addButtonWithTitle:@"Chọn Nhà hàng"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  [self wantToShowLeft:NO];
                                  NSLog(@"Button1 Clicked");
                              }];
        [alertView addButtonWithTitle:@"Bỏ qua"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
        return;
    }
    if (self.imgImagePicked.image) {
        [self.captureManager.captureSession stopRunning];
        [self mergeSkinWithImage:self.imgImagePicked.image];
    }else
        [[self captureManager] captureStillImage];
}

- (IBAction)closeButtonClicked:(id)sender {
    if (_arrImages.count>0) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Bạn chưa đăng ảnh! Các ảnh vừa chụp sẽ bị xóa"];
        
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  
                                  [_arrImages removeAllObjects];
                                  _lblPhone.hidden=YES;

                                  [self dismissModalViewControllerAnimated:YES];
                              }];
        [alertView addButtonWithTitle:@"Hủy"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
    }else{

        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)albumPickerButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;

        [self presentModalViewController:imagePicker animated:YES];
    }
}

- (IBAction)locationPickerButtonClicked:(id)sender {
    [self.pagingScrollView selectPageAtIndex:0 animated:NO];
    if (self.slidingViewController.underLeftShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        if (self.slidingViewController.underLeftViewController)[self.slidingViewController anchorTopViewTo:ECRight];
    }
}

- (IBAction)skinPickerButtonClicked:(id)sender {
    return;
    [self.pagingScrollView selectPageAtIndex:_numPages-1 animated:NO];
    if (self.slidingViewController.underRightShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECLeft];
    }
}

- (IBAction)photoBrowseButtonClicked:(id)sender {
    _photoBrowseTableVC=[[PhotoBrowseVC alloc] initWithNibName:@"PhotoBrowseVC" bundle:nil];
    _photoBrowseTableVC.arrPhotos=[[NSMutableArray alloc] initWithArray:_arrImages];
    _photoBrowseTableVC.branch=_branch;
    _photoBrowseTableVC.album=_strAlbum;
    [_photoBrowseTableVC setDelegate:self];
    [self.navigationController pushViewController:_photoBrowseTableVC animated:YES];
}

#pragma mark SSPhotoCropperDelegate

- (void) photoCropper:(SSPhotoCropperViewController *)photoCropper
         didCropPhoto:(UIImage *)image
{
    if (image!=nil) {
        self.imgImagePicked.image=image;
        _imgImagePicked.hidden=NO;
    }
}

- (void) photoCropperDidCancel:(SSPhotoCropperViewController *)photoCropper
{
    
    //[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark Imagepickerdelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissModalViewControllerAnimated:YES];
    SSPhotoCropperViewController *photoCropper =
    [[SSPhotoCropperViewController alloc] initWithPhoto:selectedImage
                                               delegate:self
                                                 uiMode:SSPCUIModePushedOnToANavigationController
                                        showsInfoButton:YES];
    photoCropper.isNotWantToCropImageYES=NO;
    [(UINavigationController*)self.slidingViewController.topViewController pushViewController:photoCropper animated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	// The user canceled -- simply dismiss the image picker.
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - View Controller Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView beforeRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView afterRotation];
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
    
    if ((object == self.pagingScrollView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.pagingScrollView.contentOffset.x];
        return;
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    double contentOffset = self.pagingScrollView.contentOffset.x;
    lastDragOffset = contentOffset;
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
//    NSLog(@"theScrollView.contentOffset.x==%d",(int)scrollOffset);

        if (!self.slidingViewController.underLeftShowing && scrollOffset<-70) {
            
            if (self.slidingViewController.underLeftViewController){
                [self.slidingViewController anchorTopViewTo:ECRight];
            }
        }
    /*
        else if (!self.slidingViewController.underRightShowing && scrollOffset>(_numPages-1)*320+70) {
            [self.slidingViewController anchorTopViewTo:ECLeft];
        }
   */
}

- (void)toggleTopView {
    if (self.slidingViewController.underLeftShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        if (self.slidingViewController.underLeftViewController)
        {
            [self.slidingViewController anchorTopViewTo:ECRight];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    if (_viewSlidePickSkin.isHidden) {
        return;
    }
	if ([self.pagingScrollView indexOfSelectedPage]>0)
	{
            _viewSlidePickSkin.hidden=YES;
	}
}

#pragma mark - MHPagingScrollViewDelegate
- (NSUInteger)numberOfPagesInPagingScrollView:(TVPagingScrollView *)pagingScrollView
{
	return _numPages;
}

- (UIView *)pagingScrollView:(TVPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{
    PageView *pageView = (PageView *)[thePagingScrollView dequeueReusablePageAtIndex:index];

    
	if (pageView == nil){
        switch (index) {
            case 0:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageOneView" owner:self options:nil] objectAtIndex:0];
                break;
                
            case 1:

                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageTwoView" owner:self options:nil] objectAtIndex:0];

                break;
            case 2:

                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageThreeView" owner:self options:nil] objectAtIndex:0];


                break;
            case 3:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageFourView" owner:self options:nil] objectAtIndex:0];
                break;
            case 4:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageFiveView" owner:self options:nil] objectAtIndex:0];
                break;
            case 5:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageSixView" owner:self options:nil] objectAtIndex:0];
                break;
            case 6:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageSevenView" owner:self options:nil] objectAtIndex:0];
                break;
            case 7:
            {
                PageEightView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageEightView" owner:self options:nil] objectAtIndex:0];
//                [page.imgMummum setImage:[UIImage imageNamed:@"skin_mammam_text_mobile"]];
                page.strImageName= @"skin_mammam_text";
                pageView=page;
            }
                break;
            case 8:
            {
                PageEightView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageEightView" owner:self options:nil] objectAtIndex:0];
                [page.imgMummum setImage:[UIImage imageNamed:@"skin_ngon_qua_uc_uc_text_mobile"]];
                page.strImageName= @"skin_ngon_qua_uc_uc_text";
                pageView=page;
            }
                break;
            case 9:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageTenView" owner:self options:nil] objectAtIndex:0];
                break;
            case 10:
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageElevenView" owner:self options:nil] objectAtIndex:0];
                break;
            case 11:
            {
                PageTwelveView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageTwelveView" owner:self options:nil] objectAtIndex:0];
                page.strImageName= @"skin_khong_den_day_thi_phi_text";
                pageView=page;
            }
                break;
            case 12:{
                PageTwelveView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageTwelveView" owner:self options:nil] objectAtIndex:0];
                page.imagLocationIcon.image=[UIImage imageNamed:@"skin_do_an_ngon_text_mobile"];
                page.strImageName= @"skin_do_an_ngon_text";
                pageView=page;
            }
                break;
            case 13:
            {
                PageTwelveView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageTwelveView" owner:self options:nil] objectAtIndex:0];
                page.imagLocationIcon.image=[UIImage imageNamed:@"skin_khong_gian_dep_text_mobile"];
                page.strImageName= @"skin_khong_gian_dep_text";
                pageView=page;
            }
                break;
            case 14:
            {
                PageTwelveView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageTwelveView" owner:self options:nil] objectAtIndex:0];
                page.imagLocationIcon.image=[UIImage imageNamed:@"skin_dich_vu_tot_mobile"];
                page.strImageName= @"skin_dich_vu_tot";
                pageView=page;
            }
                break;
            case 15:
            {
                PageTwelveView* page=[[[NSBundle mainBundle] loadNibNamed:@"PageTwelveView" owner:self options:nil] objectAtIndex:0];
                page.imagLocationIcon.image=[UIImage imageNamed:@"skin_gia_hop_ly_mobile"];
                page.strImageName= @"skin_gia_hop_ly";
                pageView=page;
            }
                break;
            default:
                break;
        }
        
        pageView.index=index;[pageView settingView];
        if (_branch) {
            [_viewNotify removeFromSuperview];
            
            [pageView setName:_branch.name andAddress:_branch.address_full];
        }
        
    }
    
    //pageView.lblCompliment.text=@"Seize the day";
	return pageView;
}

@end
