//
//  DetailManualVC.h
//  Anuong
//
//  Created by Hoang The Hung on 7/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TVManual;
@interface DetailManualVC : UIViewController<UIWebViewDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManual:(TVManual*)manual;
@end
