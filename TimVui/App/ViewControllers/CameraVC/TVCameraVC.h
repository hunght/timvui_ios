
#import "MHPagingScrollView.h"
#import "CaptureSessionManager.h"
#import "PageView.h"
@interface TVCameraVC : UIViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet  PageView*pageView;
@property (nonatomic, retain) CaptureSessionManager *captureManager;
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)pageTurn;

@end
