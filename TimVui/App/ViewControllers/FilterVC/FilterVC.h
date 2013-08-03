//
//  FilterVC.h
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* cityArr;
@property (nonatomic, strong) NSArray* topicArr;
@end
