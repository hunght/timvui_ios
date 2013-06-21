
#import "MHPagingScrollView.h"
#import "CaptureSessionManager.h"
#import "ECSlidingViewController.h"
@interface TVCameraVC : UIViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIPageControl *pageControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnStoreImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnAlbumPicker;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnLocationPicker;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnClose;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewBottomBar;

@property (retain, nonatomic) UIImageView *imgStillCamera;
@property (nonatomic, retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UITableView *tblBranches;
@property (nonatomic, retain) UITableView *tblSkinStyle;
@property(nonatomic,strong)ECSlidingViewController *slidingViewController;
@property (nonatomic, retain) NSMutableArray *arrImages;

- (IBAction)skinPickerButtonClicked:(id)sender;

- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)pageTurn;
- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)albumPickerButtonClicked:(id)sender;
- (IBAction)locationPickerButtonClicked:(id)sender;

@end
