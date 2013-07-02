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
        _btnPicked=[[UIButton alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
        [_btnPicked addTarget:self action:@selector(pickButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnPicked setImage:[UIImage imageNamed:@"img_camera_cell_button"] forState:UIControlStateSelected];
        [_btnPicked setBackgroundColor:[UIColor whiteColor]];
        CALayer* l=_btnPicked.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:3];
        [self.contentView insertSubview:_btnPicked aboveSubview:self.imageView];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
    if ([_delegate respondsToSelector:@selector(pickerButtonClicked:)]){
        [_delegate pickerButtonClicked:s];
    }
}

@end
