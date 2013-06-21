
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

-(void)setContentWithName:(NSString*)name{
    _lblBranchName.text=name;
}
@end
