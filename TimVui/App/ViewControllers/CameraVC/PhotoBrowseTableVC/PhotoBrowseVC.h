//
//  PhotoBrowseVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowseCell.h"
@protocol PhotoBrowseVCDelegate;


@interface PhotoBrowseVC : UIViewController<PhotoBrowseCellDelegate,UITableViewDataSource, UITableViewDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)NSMutableArray *arrPhotos;
@property(nonatomic,strong)NSMutableArray *arrPhotosPick;
@property (nonatomic, unsafe_unretained) id<PhotoBrowseVCDelegate> delegate;
@property (nonatomic, strong) NSString* branch_id;
@property (nonatomic, strong) NSString* album;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *bottomView;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)switchChangedValue:(id)sender;

@end
@protocol PhotoBrowseVCDelegate<NSObject>
-(void)didPickWithImages:(NSArray*)images;
-(void)wantToShowLeft:(BOOL)isLeft;
@end