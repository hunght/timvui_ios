
@interface PageView : UIView
@property (nonatomic, assign)int pageIndex;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblBranchName;

-(id)initFromNib:(NSString*)str withIndex:(int)index;

@end
