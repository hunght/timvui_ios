//
//  TwoImageCell.m
//  FBImageViewController_Demo
//
//  Created by Hoang The Hung on 8/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "TwoImageCell.h"

@implementation TwoImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _imgPickedOne=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        [self.contentView addSubview:_imgPickedOne];
        
        _imgPickedTwo=[[UIImageView alloc] initWithFrame:CGRectMake(161, 0, 160, 160)];
        [self.contentView addSubview:_imgPickedTwo];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

@end
