//
//  NearbyCouponCell.h
//  Anuong
//
//  Created by Hoang The Hung on 8/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class TVCoupon;

@interface NearbyCouponCell : UITableViewCell

@property(nonatomic,strong)UIView *whiteView;
@property(nonatomic,strong)UILabel *lblDetailRow;
@property(nonatomic,strong)UILabel *lblNameBranch;
@property(nonatomic,strong)UILabel *lblAddressBranch;
@property(nonatomic,strong)UIImageView *avatarBranch;
@property(nonatomic,strong)UIView *borderView;
@property(nonatomic,strong)CAShapeLayer *border;
+ (CGFloat)heightForCellWithPost:(TVCoupon *)coupon;
- (void)setCoupon:(TVCoupon *)coupon;
@end
