//
//  BranchProfileVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TVBranch.h"

@class TVExtraBranchView;
@interface BranchProfileVC : GAITrackedViewController<UIWebViewDelegate,MFMessageComposeViewControllerDelegate>
@property (retain, nonatomic) TVBranch *branch;
@property (assign, nonatomic) BOOL isWantToShowEvents;
@property(strong, nonatomic)TVExtraBranchView *extraBranchView;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgBranchCover;

@property(nonatomic, strong)NSString* branchID;
@end
