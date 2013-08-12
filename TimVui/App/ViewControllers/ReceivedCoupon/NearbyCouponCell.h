//
//  NearbyCouponCell.h
//  Anuong
//
//  Created by Hoang The Hung on 8/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TVBranch;

@interface NearbyCouponCell : UITableViewCell

@property (nonatomic, strong) TVBranch *branch;
@property(nonatomic,strong)UIView *whiteView;
@property(nonatomic,strong)UILabel *lblDetailRow;

+ (CGFloat)heightForCellWithPost:(TVBranch *)branch;

@end
