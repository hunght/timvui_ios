
#import "TVCameraVC.h"
#import "PageView.h"
@implementation TVCameraVC
{
	NSUInteger _numPages;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_numPages = 2;

	self.pagingScrollView.previewInsets = UIEdgeInsetsMake(0.0f, 50.0f, 0.0f, 50.0f);
	[self.pagingScrollView reloadPages];

	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = _numPages;
    [self setCaptureManager:[[CaptureSessionManager alloc] init] ];
    
	[[self captureManager] addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
    
    [[self captureManager] addStillImageOutput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
    layerRect.size.height-=44;
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
	[[[self view] layer] insertSublayer:[[self captureManager] previewLayer] below:_pageView.layer];
	[[_captureManager captureSession] startRunning];
}

- (void)didReceiveMemoryWarning
{
	[self.pagingScrollView didReceiveMemoryWarning];
}

#pragma mark - Actions
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

- (IBAction)cameraButtonClicked:(id)sender {
    [[self captureManager] captureStillImage];
}

- (IBAction)pageTurn
{
	[self.pagingScrollView selectPageAtIndex:self.pageControl.currentPage animated:YES];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
	if ([self.pagingScrollView indexOfSelectedPage] == _numPages - 1)
	{
		_numPages++;
		[self.pagingScrollView reloadPages];
		self.pageControl.numberOfPages = _numPages;
	}
}

#pragma mark - MHPagingScrollViewDelegate

- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
	return _numPages;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{
	PageView *pageView = (PageView *)[thePagingScrollView dequeueReusablePage];
	if (pageView == nil){
        [[NSBundle mainBundle] loadNibNamed:@"PageOneView" owner:self options:nil];
        pageView = self.pageView;
    }
    if (pageView == nil)
		pageView = [[PageView alloc] init];
    
	[pageView setPageIndex:index];
	return pageView;
}

@end
