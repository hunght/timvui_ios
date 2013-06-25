//
//  PhotoBrowseCell.h
//  TimVui
//
//  Created by Hoang The Hung on 6/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoBrowseCellDelegate<NSObject>
- (void)pickerButtonClicked:(UIButton*)sender;
@end

@interface PhotoBrowseCell : UITableViewCell
@property(nonatomic,strong)UIButton *btnPicked;
@property (nonatomic, unsafe_unretained) id<PhotoBrowseCellDelegate> delegate;
@end
