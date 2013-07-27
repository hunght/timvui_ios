//
//  PhotoBrowseCell.m
//  TimVui
//
//  Created by Hoang The Hung on 6/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PhotoBrowseCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Crop.h"
@implementation PhotoBrowseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _btnImageOne=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        [_btnImageOne addTarget:self action:@selector(pickButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnImageOne setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_btnImageOne];
        
        _btnImageTwo=[[UIButton alloc] initWithFrame:CGRectMake(161, 0, 160, 160)];
        [_btnImageTwo addTarget:self action:@selector(pickButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnImageTwo setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_btnImageTwo];
        
        _imgPickedOne=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
        [self.contentView addSubview:_imgPickedOne];
        
        _imgPickedTwo=[[UIImageView alloc] initWithFrame:CGRectMake(15+160, 15, 25, 25)];
        [self.contentView addSubview:_imgPickedTwo];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(7, 7, 306, 120);
}

-(void)pickButtonClicked:(UIButton*)s{

    if (s.isSelected) 
        [s setSelected:NO];
    else
        [s setSelected:YES];
    
    if ([s isEqual:_btnImageOne]) {
        if (s.isSelected)
            [_imgPickedOne setImage:[UIImage imageNamed:@""]];
        else
            [_imgPickedOne setImage:[UIImage imageNamed:@""]];
        
    }else{
        if (s.isSelected)
            [_imgPickedTwo setImage:[UIImage imageNamed:@""]];
        else
            [_imgPickedTwo setImage:[UIImage imageNamed:@""]];
        
    }
    
    if ([_delegate respondsToSelector:@selector(pickerButtonClicked:)]){
        [_delegate pickerButtonClicked:s];
    }
}

@end
