//
//  FKRHeaderSearchBarTableViewController.h
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "FKRSearchBarTableViewController.h"
#import "SearchVC.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TVCoupon.h"
@interface SearchWithContactsVC : FKRSearchBarTableViewController  <MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>{
    @private
    NSMutableArray *filteredListContent;
    IBOutlet UILabel *feedbackMsg;
    BOOL isInvitingFriend;
}
@property (strong, nonatomic) NSMutableArray  *pickedArr;

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes isInviting:(BOOL)isInviting;
@end