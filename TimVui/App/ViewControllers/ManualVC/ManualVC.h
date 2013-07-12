//
//  ManualVC.h
//  Anuong
//
//  Created by Hoang The Hung on 7/11/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnRecently;
@property (weak, nonatomic) IBOutlet UIButton *btnPopular;
@property (weak, nonatomic) IBOutlet UIButton *btnSaved;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* manualArr;
- (IBAction)recentlyButtonClicked:(id)sender;
- (IBAction)popularButtonClicked:(id)sender;
- (IBAction)savedButtonClicked:(id)sender;

@end
