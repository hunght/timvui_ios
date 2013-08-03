//
//  FilterCell.m
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "FilterCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation FilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView* view=[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 32)];
        CALayer* l=[view layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:1];
        // You can even add a border
        [l setBorderWidth:1.0];
        [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_filter_check_mark"]];
        self.accessoryView = imageView;
        
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:view];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setBackgroundColor:[UIColor whiteColor]];
        self.textLabel.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        self.textLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
