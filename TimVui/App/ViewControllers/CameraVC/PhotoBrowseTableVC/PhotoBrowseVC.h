//
//  PhotoBrowseVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowseCell.h"
@interface PhotoBrowseVC : UIViewController<PhotoBrowseCellDelegate,UITableViewDataSource, UITableViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *arrPhotos;
@property(nonatomic,strong)NSMutableArray *arrPhotosPick;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)switchChangedValue:(id)sender;

@end
