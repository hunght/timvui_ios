//
//  PhotoBrowseCell.m
//  TimVui
//
//  Created by Hoang The Hung on 6/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PhotoBrowseCell.h"

@implementation PhotoBrowseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _btnPicked=[[UIButton alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
        [self.contentView addSubview:_btnPicked];
        self.imageView.frame=CGRectMake(7, 7, 313, 120);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
