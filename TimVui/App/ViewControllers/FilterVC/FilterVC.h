//
//  FilterVC.h
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVFilter.h"
@protocol TVFilterVCDelegate
/**
 * Sent to the delegate when sign up has completed successfully. Immediately
 * followed by an invocation of userDidLogin:
 */
-(void)didClickedFilterButton;

@end

@interface FilterVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* cityArr;
@property (nonatomic, strong) NSArray* topicArr;
@property (nonatomic, assign)NSMutableDictionary* params;
@property (nonatomic, retain) NSObject<TVFilterVCDelegate>* delegate;
@end
