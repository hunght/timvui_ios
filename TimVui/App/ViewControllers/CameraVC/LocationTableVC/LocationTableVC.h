//
//  LocationTableVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/20/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVBranches.h"
#import "TVBranch.h"
@protocol LocationTableVCDelegate;


@interface LocationTableVC : UITableViewController
@property (nonatomic, unsafe_unretained) id<LocationTableVCDelegate> delegate;
@property(nonatomic,strong)TVBranches *branches;
@end
@protocol LocationTableVCDelegate<NSObject>
-(void)didPickWithLoation:(TVBranch *)branch;
@end