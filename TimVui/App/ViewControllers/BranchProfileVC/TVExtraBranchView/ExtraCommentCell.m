// TweetTableViewCell.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ExtraCommentCell.h"
#import "TVComment.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "NSDate+Helper.h"
@implementation ExtraCommentCell {
}

@synthesize comment = _comment;

- (void)setBorderForLayer:(CALayer *)l radius:(float)radius {
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor redColor];

    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.date = [[UILabel alloc] initWithFrame:CGRectZero];
    self.date.backgroundColor = [UIColor clearColor];
    
    self.date.textColor = [UIColor grayColor];
    self.date.highlightedTextColor = [UIColor whiteColor];
    
    _firstStar=[[UIImageView alloc] initWithFrame:CGRectMake(230, 8, 12, 12)];
    _secondStar=[[UIImageView alloc] initWithFrame:CGRectMake(230+15, 8, 12, 12)];
    _thirdStar=[[UIImageView alloc] initWithFrame:CGRectMake(230+15*2, 8, 12, 12)];
    _fourthStar=[[UIImageView alloc] initWithFrame:CGRectMake(230+15*3, 8, 12, 12)];
    _fifthStar=[[UIImageView alloc] initWithFrame:CGRectMake(230+15*4, 8, 12, 12)];
    
    _btnLike=[[UIButton alloc] initWithFrame:CGRectZero];
    [_btnLike setBackgroundImage:[UIImage imageNamed:@"imgTVExtraBranchViewLikeButton_off"] forState:UIControlStateNormal];
    [_btnLike setBackgroundImage:[UIImage imageNamed:@"imgTVExtraBranchViewLikeButton_on"] forState:UIControlStateHighlighted];
    _btnLike.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:(13)];
    [_btnLike setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLike setTitle:@"Hữu ích" forState:UIControlStateNormal];
    _imgLike=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgTVExtraBranchViewLike"]];
    
    
    _lblLike=[[UILabel alloc] initWithFrame:CGRectZero];
    [_lblLike setFont:[UIFont fontWithName:@"ArialMT" size:(15)]];
    [_lblLike setTextColor:[UIColor whiteColor]];
    [_lblLike setBackgroundColor:[UIColor clearColor]];
    _lblLike.textAlignment = UITextAlignmentCenter;
    
    [self.contentView addSubview:_firstStar];
    [self.contentView addSubview:_secondStar];
    [self.contentView addSubview:_thirdStar];
    [self.contentView addSubview:_fourthStar];
    [self.contentView addSubview:_fifthStar];
    
    [self.contentView addSubview:_btnLike];
    [self.contentView addSubview:_imgLike];
    [self.contentView addSubview:_lblLike];
    
    self.textLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    self.date.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];

    CALayer* l = [self.imageView layer];
    [self setBorderForLayer:l radius:1];
    [self.contentView addSubview:_date];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    return self;
}

- (void)setComment:(TVComment*)branch {
    _comment = branch;
    self.textLabel.text=_comment.user_name;
    self.detailTextLabel.text=_comment.content;

    [self.detailTextLabel sizeToFit];

    self.date.text=[_comment.created stringWithFormat:@"dd/mm/yy"];
    [self.imageView setImageWithURL:[Utilities getThumbImageOfCoverBranch:_comment.arrURLImages]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    _firstStar.image=[UIImage imageNamed:(_comment.rating>=1)?@"img_branch_profile_star_on":@"img_branch_profile_star"];
    _secondStar.image=[UIImage imageNamed:(_comment.rating>=2)?@"img_branch_profile_star_on":@"img_branch_profile_star"];
    _thirdStar.image=[UIImage imageNamed:(_comment.rating>=3)?@"img_branch_profile_star_on":@"img_branch_profile_star"];
    _fourthStar.image=[UIImage imageNamed:(_comment.rating>=4)?@"img_branch_profile_star_on":@"img_branch_profile_star"];
    _fifthStar.image=[UIImage imageNamed:(_comment.rating>=5)?@"img_branch_profile_star_on":@"img_branch_profile_star"];
    
    int height=self.detailTextLabel.frame.size.height+44;
    _btnLike.frame=CGRectMake(216, height-3 , 56, 22);
    _lblLike.frame=CGRectMake(280, height , 28, 17);
    _imgLike.frame=CGRectMake(280, height , 28, 17);
    
    [_lblLike setText:[NSString stringWithFormat:@"%d", _comment.like_count]];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVComment *)branch {
    CGSize maximumLabelSize = CGSizeMake(245.0f,9999);
    UIFont *cellFont = [UIFont fontWithName:@"ArialMT" size:(13)];
    CGSize expectedLabelSize = [branch.content sizeWithFont:cellFont
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height+ 8+44+8+10;
}

#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(7.0f, 8.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(67.0f, 8.0f, 222.0f, 15.0f);
    self.detailTextLabel.frame = CGRectMake(67.0f, 45.0f, 245.0f, 20.0f);
    self.date.frame = CGRectMake(67.0f, 30.0f, 210.0f, 15.0f);
}

@end
