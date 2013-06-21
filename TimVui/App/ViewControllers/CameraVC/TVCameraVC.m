
#import "TVCameraVC.h"
#import "PageView.h"
#import "CameraBranchCell.h"
#import "MacroApp.h"
@interface TVCameraVC ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation TVCameraVC
{
	NSUInteger _numPages;
@private
    double lastDragOffset;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_numPages = kNumberOfSkinsCamera;

	self.pagingScrollView.previewInsets = UIEdgeInsetsMake(0.0f, 50.0f, 0.0f, 50.0f);
    [self.pagingScrollView selectPageAtIndex:0 animated:NO];
	[self.pagingScrollView reloadPages];

	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = _numPages;
    // Add scroll view KVO
    void *context = (__bridge void *)self;
    [self.pagingScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    [self setCaptureManager:[[CaptureSessionManager alloc] init] ];
    
	[[self captureManager] addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
    
    [[self captureManager] addStillImageOutput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:[[[self view] layer] bounds]];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageToAddSkin) name:kImageCapturedSuccessfully object:nil];
    
	[[[self view] layer] insertSublayer:[[self captureManager] previewLayer] below:_pageControl.layer];
	
    self.imgStillCamera=[[UIImageView alloc] initWithFrame:layerRect];
    _imgStillCamera.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_imgStillCamera aboveSubview:_pageControl];
    [self.imgStillCamera setHidden:YES];
    
    [[_captureManager captureSession] startRunning];
}

- (void)didReceiveMemoryWarning
{
	[self.pagingScrollView didReceiveMemoryWarning];
}

#pragma mark - Helper

-(void)getImageToAddSkin{
    [_imgStillCamera setHidden:NO];
    [_imgStillCamera setImage:self.captureManager.stillImage];

}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
    }
}
#pragma mark - IBActions
- (IBAction)pageTurn
{
	[self.pagingScrollView selectPageAtIndex:self.pageControl.currentPage animated:YES];
}

- (IBAction)cameraButtonClicked:(id)sender {
    //[[_captureManager captureSession] stopRunning];
    [[self captureManager] captureStillImage];
}

- (IBAction)closeButtonClicked:(id)sender {
    [[_captureManager captureSession] stopRunning];
    [self dismissModalViewControllerAnimated:YES];
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

        self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
        if (self.slidingViewController.underLeftShowing) {
            // actually this does not get called when the top view screenshot is enabled
            // because the screenshot intercepts the touches on the toggle button
            [self.slidingViewController resetTopView];
        } else {
            [self.slidingViewController anchorTopViewTo:ECRight];
        }
}

- (IBAction)skinPickerButtonClicked:(id)sender {
    self.slidingViewController.underRightWidthLayout = ECFixedRevealWidth;
    if (self.slidingViewController.underRightShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECLeft];
    }
}
#pragma mark Imagepickerdelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    [[_captureManager captureSession] startRunning];
    [picker dismissModalViewControllerAnimated:YES];
    //    CGSize size=selectedImage.size;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	// The user canceled -- simply dismiss the image picker.
    [[_captureManager captureSession] startRunning];
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
    NSLog(@"theScrollView.contentOffset.x==%d",(int)scrollOffset);
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
    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
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





- (void)viewDidUnload {
    [self setBtnStoreImage:nil];
    [self setViewBottomBar:nil];
    [self setBtnAlbumPicker:nil];
    [self setBtnLocationPicker:nil];
    [self setBtnClose:nil];
    [super viewDidUnload];
}
@end
