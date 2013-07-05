
#import "TVCameraVC.h"
#import "PageView.h"
#import "CameraBranchCell.h"
#import "MacroApp.h"
#import "UIImage+Crop.h"
#import "UIView+Genie.h"
#import "TVAppDelegate.h"
#import "PhotoBrowseVC.h"
#import "UINavigationBar+JTDropShadow.h"
#import "TSMessage.h"
@interface TVCameraVC ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation TVCameraVC
{
	NSUInteger _numPages;
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
}


#pragma mark - ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 5) radius:5 color:[UIColor blackColor] opacity:1];
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	_numPages = kNumberOfSkinsCamera;
    _arrImages=[[NSMutableArray alloc] init];
    _lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
    _lblPhone.backgroundColor = [UIColor whiteColor];
    _lblPhone.textColor = [UIColor redColor];
    _lblPhone.textAlignment=UITextAlignmentCenter;
    _lblPhone.font = [UIFont fontWithName:@"ArialMT" size:(15)];
    
    CALayer* l=_lblPhone.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:10];
    
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [_lblPhone setHidden:YES];
    [_btnStoreImage addSubview:_lblPhone];
    
    
	[self initScrollPagingView];
    [self initCameraCapture];
    
    [_btnStoreImage setImage:[UIImage imageNamed:@"img_camera_store_photos"] forState:UIControlStateNormal];
    [_btnAlbumPicker setImage:[UIImage imageNamed:@"img_camera_album_picker"] forState:UIControlStateNormal];
    [_btnCameraSkin setBackgroundImage:[UIImage imageNamed:@"img_camera_camera_skin"] forState:UIControlStateNormal];
    
}

- (void)viewDidUnload {
    [self setBtnStoreImage:nil];
    [self setBtnAlbumPicker:nil];
    [self setBtnLocationPicker:nil];
    [self setBtnClose:nil];
    [self setImgImagePicked:nil];
    [self setBtnCameraSkin:nil];
    [super viewDidUnload];
}
- (void)dealloc
{
    void *context = (__bridge void *)self;
    [self.pagingScrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
}

- (void)didReceiveMemoryWarning
{
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
    UIImage *image       = [self imageWithView:pageView.viewSkin]; //foreground image
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.width);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_arrImages addObject:newImage];
    
    if (_lblPhone.isHidden)
        _lblPhone.hidden=NO;
    
    self.imgStillCamera.image=newImage;
    [self showAnimationWhenDidTakeImage];
}

-(void)getImageToAddSkin{
    if (self.captureManager.stillImage) {
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
    [TSMessage showNotificationInViewController:self
                                      withTitle:@"Đăng ảnh thành công"
                                    withMessage:nil
                                       withType:TSMessageNotificationTypeSuccess];
    for (UIImage* image in images) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)wantToShowLeft:(BOOL)isLeft{
    if (isLeft) {
        [self.slidingViewController anchorTopViewTo:ECLeft];
    }else
        [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark - LocationTableVCDelegate

-(void)didPickWithLoation:(TVBranch *)branch{
    [self.slidingViewController resetTopView];
    _branch=branch;
    _photoBrowseTableVC.branch_id=_branch.branchID;
    
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
    
    if (self.imgImagePicked.image) {
        [self mergeSkinWithImage:self.imgImagePicked.image];
    }else
        [[self captureManager] captureStillImage];
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)albumPickerButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
//        [self.captureManager.captureSession stopRunning];
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
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}

- (IBAction)skinPickerButtonClicked:(id)sender {
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
    _photoBrowseTableVC.branch_id=_branch.branchID;
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
    BOOL isScrollViewIsDraggedLeft;
    if (scrollOffset < lastDragOffset)
        isScrollViewIsDraggedLeft = YES;
    else
        isScrollViewIsDraggedLeft = NO;
    
    if (isScrollViewIsDraggedLeft) {
        if (!self.slidingViewController.underLeftShowing && scrollOffset<-70) {
            [self.slidingViewController anchorTopViewTo:ECRight];
        }
    }else if (!self.slidingViewController.underRightShowing && scrollOffset>(_numPages-1)*320+70) {
        [self.slidingViewController anchorTopViewTo:ECLeft];
    }
}

- (void)toggleTopView {
    if (self.slidingViewController.underLeftShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
//	if ([self.pagingScrollView indexOfSelectedPage] == _numPages - 1)
//	{
//		[self.pagingScrollView reloadPages];
//		self.pageControl.numberOfPages = _numPages;
//	}
}




#pragma mark - MHPagingScrollViewDelegate

- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
	return _numPages;
}


- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{	PageView *pageView = (PageView *)[thePagingScrollView dequeueReusablePage];
    pageView.index=index;
	if (pageView == nil){
        switch (index) {

            case 0:
                
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageOneView" owner:self options:nil] objectAtIndex:0];
                break;
            case 1:
                
                pageView=[[[NSBundle mainBundle] loadNibNamed:@"PageTwoView" owner:self options:nil] objectAtIndex:0];
                break;

            default:
                break;
        }
    }
	return pageView;
}






@end
