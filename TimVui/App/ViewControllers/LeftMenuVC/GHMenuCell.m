//
//  GHSidebarMenuCell.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHMenuCell.h"


#pragma mark -
#pragma mark Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

#pragma mark -
#pragma mark Implementation
@implementation GHMenuCell

#pragma mark Memory Management
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        self.clipsToBounds = YES;
        
		UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern_menu"]];
		self.selectedBackgroundView = bgView;
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		
        self.textLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [UIColor colorWithRed:(101.0f/255.0f) green:(96.0f/255.0f) blue:(100.0f/255.0f) alpha:1.0f];
		self.textLabel.highlightedTextColor = [UIColor colorWithRed:(101.0f/255.0f) green:(96.0f/255.0f) blue:(100.0f/255.0f) alpha:1.0f];
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(219.0f/255.0f) green:(219.0f/255.0f) blue:(219.0f/255.0f) alpha:2.0f];
		[self.textLabel.superview addSubview:topLine];
		        self.contentView.backgroundColor=[UIColor clearColor];
//		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
//		topLine2.backgroundColor = [UIColor whiteColor];
//		[self.textLabel.superview addSubview:topLine2];
		
//		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
//		bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f];
//		[self.textLabel.superview addSubview:bottomLine];
        
	}
	return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = CGRectMake(73.0f, 5.0f, 200.0f, 43.0f);
	self.imageView.frame = CGRectMake(25, 15.0f, 20, 20);
}

@end
