
#import "PageView.h"

@implementation PageView


-(id)initFromNib:(NSString*)str withIndex:(int)index{
    _pageIndex=index;
    return[[[NSBundle mainBundle] loadNibNamed:str owner:self options:nil] objectAtIndex:0];
}
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

@end
