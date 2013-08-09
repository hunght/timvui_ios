
@interface PageView : UIView
@property (nonatomic, assign) NSUInteger index;

-(void)setName:(NSString*)name andAddress:(NSString*)address;
- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage;
- (void)settingView;
@end
