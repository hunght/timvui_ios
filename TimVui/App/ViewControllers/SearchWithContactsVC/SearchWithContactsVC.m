//
//  FKRHeaderSearchBarTableViewController.m
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "SearchWithContactsVC.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import "UINavigationBar+JTDropShadow.h"
#import "TVAppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "MacroApp.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
#import "NSDictionary+Extensions.h"
static NSString * const kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier = @"kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier";
@interface SearchWithContactsVC () {
    BOOL _mayUsePrivateAPI;
}

@end

@implementation SearchWithContactsVC

#pragma mark - IBAction

-(void)doneButtonClicked:(id)sender{
    [self showSMSPicker];
//    [self.navigationController.navigationBar setNavigationBarWithoutIcon:NO];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController.navigationBar setNavigationBarWithoutIcon:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper

- (NSArray*)loadContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray* dataArray = [NSMutableArray new];
    
    for (int i = 0; i < nPeople; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        ABMultiValueRef property = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSArray *propertyArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(property);
        CFRelease(property);

        CFStringRef name;
        name = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef lastNameString;
        lastNameString = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef emailString;
        emailString = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        NSString *nameString = (__bridge NSString *)name;
        
        NSString *lastName = (__bridge NSString *)lastNameString;

        if ((__bridge id)lastNameString != nil)
        {
            nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastName];
        }
        
        NSMutableDictionary *info = [NSMutableDictionary new];
        [info setValue:[NSString stringWithFormat:@"%@", nameString] forKey:@"name"];

        [info setValue:propertyArray forKey:@"telephone"];
                
        [dataArray addObject:info];
        
        if (name) CFRelease(name);
        if (lastNameString) CFRelease(lastNameString);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBook);
    return dataArray;
//    NSLog(@"data======%@",self.famousPersons);
}

#pragma mark - Initializer

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes isInviting:(BOOL)isInviting

{
    isInvitingFriend=isInviting;
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] == 6) {
        
        __block SearchWithContactsVC *controller = self;
        
        // Request authorization to Address Book
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef,
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted)
                                                              self.famousPersons=[controller loadContacts];
                                                         
                                                     });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            // The user has previously given access, add the contact
             self.famousPersons=[self loadContacts];
        }
        else
        {
            NSString *currentLanguage = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] lowercaseString];
            
            NSString *msg = @"";
            
            if ([currentLanguage isEqualToString:@"es"])
            {
                msg = @"No se tiene permiso para obtener los contactos, por favor, actívelo en Preferencias de la privacidad.";
            }
            else
            {
                msg = @"Unable to get your contacts, enable it on your privacy preferences.";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            alert.tag = 457;
            [alert show];

        }
    } else {
         self.famousPersons=[self loadContacts];
    }
    if ((self = [super initWithSectionIndexes:showSectionIndexes])) {
        /*
         The exact same behavior as the contacts app is only possible with using private API. Without using private API the section index control on the right of the table won't overlap the search bar.
         Note: You shouldn't use private API in an App Store app, this is just for demo purposes.
        */
        
        //_mayUsePrivateAPI = YES;
        _pickedArr=[[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!isInvitingFriend) {
        [self.navigationController.navigationBar setNavigationBarWithoutIcon:YES];
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    }
    
    self.navigationItem.rightBarButtonItem=[self barButtonWithTitle:@"Xong"];
    
    if (_mayUsePrivateAPI) {
        self.tableView.tableHeaderView = self.searchBar;
        
        SEL setPinsTableHeaderViewSelector = NSSelectorFromString(@"_setPinsTableHeaderView:");
        if ([self.tableView respondsToSelector:setPinsTableHeaderViewSelector]) {
            objc_msgSend(self.tableView, setPinsTableHeaderViewSelector, YES);
        }
    } else {        
        [self.tableView addSubview:self.searchBar];
        
        self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    // The search bar is always visible, so just scroll to the first section
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) { // Don't do anything if the search table view get's scrolled
        if (!_mayUsePrivateAPI) {
            if (scrollView.contentOffset.y < -CGRectGetHeight(self.searchBar.bounds)) {
                self.searchBar.layer.zPosition = 0; // Make sure the search bar is below the section index titles control when scrolling up
            } else {
                self.searchBar.layer.zPosition = 1; // Make sure the search bar is above the section headers when scrolling down
            }
            
            CGRect searchBarFrame = self.searchBar.frame;
            searchBarFrame.origin.y = MAX(scrollView.contentOffset.y, -CGRectGetHeight(searchBarFrame));
            
            self.searchBar.frame = searchBarFrame;
        }
    }
}

#pragma mark - Overrides
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier];
    }
    NSDictionary* dic;
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            dic=[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.textLabel.text = [dic valueForKey:@"name"] ;
            
        } else {
            dic=[self.famousPersons objectAtIndex:indexPath.row];
            cell.textLabel.text = [dic valueForKey:@"name"];
        }
    } else {
        dic=[self.filteredPersons objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic valueForKey:@"name"];
    }
    if ([_pickedArr containsObject:dic])
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}
/*
 Override these methods so that the search symbol isn't shown in the section index titles control. 
*/

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView && self.showSectionIndexes) {
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]; // Don't show the search symbol
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* arrResult=nil;

    
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        arrResult =  [self.filteredPersons objectAtIndex:indexPath.row];
        if ([_pickedArr containsObject:arrResult])
            [_pickedArr removeObject:arrResult];
        else
        {
            arrResult=  [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [_pickedArr removeObject:arrResult];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        if (tableView != self.tableView){
            arrResult =  [self.filteredPersons objectAtIndex:indexPath.row];
            
        }else{
            arrResult=  [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        [_pickedArr addObject:arrResult];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Show Mail/SMS picker

-(void)showMailPicker:(id)sender {
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
	// So, we must verify the existence of the above class and provide a workaround for devices running
	// earlier versions of the iPhone OS.
	// We display an email composition interface if MFMailComposeViewController exists and the device
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil) {
        //[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayMailComposerSheet];
		}
		else {
			feedbackMsg.hidden = NO;
			feedbackMsg.text = @"Device not configured to send mail.";
		}
	}
	else	{
		feedbackMsg.hidden = NO;
		feedbackMsg.text = @"Device not configured to send mail.";
	}
}


-(void)showSMSPicker{
    //	The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
    //	So, we must verify the existence of the above class and log an error message for devices
    //		running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
    //		MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet];
		}
		else {
			feedbackMsg.hidden = NO;
			feedbackMsg.text = @"Device not configured to send SMS.";
            
		}
	}
	else {
		feedbackMsg.hidden = NO;
		feedbackMsg.text = @"Device not configured to send SMS.";
	}
}


#pragma mark -
#pragma mark Compose Mail/SMS

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello from California!"];
	
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"It is raining in sunny California!";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
}


- (void)hasLinkAppleAndSend
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    if (isInvitingFriend) {
        
        picker.body =[NSString stringWithFormat:@"Ứng dụng địa điểm ăn uống, coupon giảm giá hấp dẫn: %@",[GlobalDataUser sharedAccountClient].linkAppleStore];
    }else{
        picker.body =@"";
    }
    
    NSMutableArray* arrPhone=[NSMutableArray new];
    for (NSArray* arr in [_pickedArr valueForKey:@"telephone"]) {
        [arrPhone addObjectsFromArray:arr];
    }
    picker.recipients = arrPhone;
	[self presentModalViewController:picker animated:YES];
}

// Displays an SMS composition interface inside the application.
-(void)displaySMSComposerSheet
{
    if (![GlobalDataUser sharedAccountClient].linkAppleStore) {
        [[TVNetworkingClient sharedClient] postPath:@"user/getIOSAppInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            [GlobalDataUser sharedAccountClient].linkAppleStore=[JSON safeStringForKeyPath:@"data.link"] ;
            NSLog(@"JSON=%@",JSON);
            [self hasLinkAppleAndSend];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        [self hasLinkAppleAndSend];
    }
	
}


#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			feedbackMsg.text = @"Result: Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			feedbackMsg.text = @"Result: Mail saved";
			break;
		case MFMailComposeResultSent:
			feedbackMsg.text = @"Result: Mail sent";
			break;
		case MFMailComposeResultFailed:
			feedbackMsg.text = @"Result: Mail sending failed";
			break;
		default:
			feedbackMsg.text = @"Result: Mail not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	
	feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			feedbackMsg.text = @"Result: SMS sending canceled";
			break;
		case MessageComposeResultSent:
			feedbackMsg.text = @"Result: SMS sent";
			break;
		case MessageComposeResultFailed:
			feedbackMsg.text = @"Result: SMS sending failed";
			break;
		default:
			feedbackMsg.text = @"Result: SMS not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end