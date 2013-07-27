
#import "PageView.h"

@implementation PageView



- (id)init
{
	if ((self = [super init]))
	{
		self.opaque = YES;
        
		self.backgroundColor = [UIColor
                                colorWithRed:(float)arc4random() / 0xFFFFFFFF
                                green:(float)arc4random() / 0xFFFFFFFF
                                blue:(float)arc4random() / 0xFFFFFFFF
                                alpha:1.0];
        
	}
	return self;
}

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    _lblBranchName.backgroundColor = [UIColor clearColor];
    _lblBranchName.textColor = [UIColor whiteColor];
    _lblBranchName.numberOfLines = 0;
    _lblBranchName.lineBreakMode = UILineBreakModeWordWrap;
    _lblBranchName.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(20)];
    _lblBranchName.text=name;
    [_lblBranchName sizeToFit];
    
    CGRect rect=_lblAddress.frame;
    rect.origin.y=_lblBranchName.frame.origin.y+_lblBranchName.frame.size.height+5;
    _lblAddress.frame=rect;
    _lblAddress.backgroundColor = [UIColor clearColor];
    _lblAddress.textColor = [UIColor whiteColor];
    _lblAddress.numberOfLines = 0;
    _lblAddress.lineBreakMode = UILineBreakModeWordWrap;
    _lblAddress.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
    _lblAddress.text= address;
    [_lblAddress sizeToFit];
    
    rect=_backgroundLocation.frame;
    rect.size.height=_lblBranchName.frame.size.height+5+ _lblAddress.frame.size.height+15;
    _backgroundLocation.frame=rect;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
