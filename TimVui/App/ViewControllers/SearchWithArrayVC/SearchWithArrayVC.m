//
//  FKRHeaderSearchBarTableViewController.m
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "SearchWithArrayVC.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import "UINavigationBar+JTDropShadow.h"
#import "TVAppDelegate.h"
#import "GlobalDataUser.h"
static NSString * const kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier = @"kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier";
@interface SearchWithArrayVC () {
    BOOL _mayUsePrivateAPI;
}

@end

@implementation SearchWithArrayVC

#pragma mark - IBAction

-(void)doneButtonClicked:(id)sender{
    switch ([GlobalDataUser sharedAccountClient].currentSearchParam) {
        case kSearchParamCuisine:
            
            [GlobalDataUser sharedAccountClient].dicCuisineSearchParam=_pickedArr;
            break;
            
        case kSearchParamPurpose:
            [GlobalDataUser sharedAccountClient].dicPurposeSearchParam=_pickedArr;
            break;
        case kSearchParamZone:
            [GlobalDataUser sharedAccountClient].dicPublicLocation=_pickedArr;
            break;
        case kSearchParamUtilities:
            [GlobalDataUser sharedAccountClient].dicUtilitiesSearchParam=_pickedArr;
            break;
        default:
        break;
    }
    [self.navigationController.navigationBar setNavigationBarWithoutIcon:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController.navigationBar setNavigationBarWithoutIcon:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper


#pragma mark - Initializer
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font =  [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor blackColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
- (id)initWithSectionIndexes:(BOOL)showSectionIndexes withParam:(NSArray*)dic

{
    self.famousPersons=dic;
    NSLog(@"%@",dic);
    if ((self = [super initWithSectionIndexes:showSectionIndexes])) {
        /*
         The exact same behavior as the contacts app is only possible with using private API. Without using private API the section index control on the right of the table won't overlap the search bar.
         Note: You shouldn't use private API in an App Store app, this is just for demo purposes.
        */
        
        //_mayUsePrivateAPI = YES;
        _pickedArr=[[NSMutableArray alloc] init];
        
        switch ([GlobalDataUser sharedAccountClient].currentSearchParam) {
            case kSearchParamCuisine:
                [self setTitle:@"Món ăn"];
                break;
                
            case kSearchParamPurpose:
                [self setTitle:@"Mục đích"];
                break;
            
            case kSearchParamZone:
                [self setTitle:@"Khu vực"];
                break;
            
            case kSearchParamUtilities:
                [self setTitle:@""];
                break;
            
            case kSearchParamCity:
                [self setTitle:@"Tỉnh/Thành Phố"];
                break;
            
            case kSearchParamDistrict:
                [self setTitle:@"Quận/Huyện"];
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setNavigationBarWithoutIcon:YES];
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    

    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 43)];
    
    [doneButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateNormal];
    
    [doneButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(245/255.0f) green:(110/255.0f) blue:(44/255.0f) alpha:1.0f]] forState:UIControlStateHighlighted];
    
    [doneButton setTitle:@"Xong" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 43)];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, -5, -0);
    [backButtonView addSubview:doneButton];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    self.navigationItem.rightBarButtonItem=doneButtonItem;
    [super viewDidLoad];
    
    /*
     SearchBar as header and at the top:
     The search bar always stays at the top if the table view is scrolled down and behaves similar to a section header.
     
     Note: For this scrolling behavior it is *essential* that the view controller is a subclass of UIViewController instead of UITableViewController, because UISearchDisplayController adds the dimming view to the searchContentsController's view and because UITableViewController's view is the table view, the dimming view is added to the table view and is only visible when the table view is scrolled to the top. If you can't change the superclass to UIViewController, you'll have to manually set the dimming view's frame by iterating through the table view's view hierarchy when the search begins which is very ugly.
    */
    
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
    switch ([GlobalDataUser sharedAccountClient].currentSearchParam) {
        case kSearchParamCity:
            [GlobalDataUser sharedAccountClient].dicCitySearchParam=arrResult;
            [GlobalDataUser sharedAccountClient].dicDistrictSearchParam=nil;
            [GlobalDataUser sharedAccountClient].dicPublicLocation=nil;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case kSearchParamDistrict:
            [GlobalDataUser sharedAccountClient].dicDistrictSearchParam=_pickedArr;
            
            //To do with this because mutile choose make it fail
            [GlobalDataUser sharedAccountClient].dicPublicLocation=nil;
            break;
        
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

@end