
@interface PageView : UIView
@property (nonatomic, assign)int pageIndex;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblBranchName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblComplement;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblDate;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTime;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblCity;

@end
