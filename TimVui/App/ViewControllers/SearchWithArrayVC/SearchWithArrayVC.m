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
#import "NSDictionary+Extensions.h"
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

    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    


    self.navigationItem.rightBarButtonItem=[self barButtonWithTitle:@"Xong"];
    [super viewDidLoad];
    
    /*
     Default behavior:
     The search bar scrolls along with the table view.
     */
    
    self.tableView.tableHeaderView = self.searchBar;
    
    // The search bar is hidden when the view becomes visible the first time
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.searchBar.frame animated:animated];
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
            if ([CLLocationManager locationServicesEnabled]==NO||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
                [GlobalDataUser sharedAccountClient].homeCity=arrResult;
                [GlobalDataUser sharedAccountClient].userLocation=[[GlobalDataUser sharedAccountClient].homeCity safeLocationForKey:@"latlng"];
                [[NSUserDefaults standardUserDefaults] setValue:[GlobalDataUser sharedAccountClient].homeCity forKey:kGetCityDataUser];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            

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