//
//  MyViewController.h
//  Anuong
//
//  Created by Hoang The Hung on 10/16/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "MyLeftBarButton.h"
#import "MyRightBarButton.h"

@interface MyViewController : GAITrackedViewController
- (UIBarButtonItem *)backBarButtonItem;
- (UIBarButtonItem *)toggleBarButtonItem;
- (UIBarButtonItem *)searchButtonItem;
-(UIBarButtonItem*)handbookFilterButton;
-(UIBarButtonItem*)barButtonWithTitle:(NSString*)strTitle;
@end