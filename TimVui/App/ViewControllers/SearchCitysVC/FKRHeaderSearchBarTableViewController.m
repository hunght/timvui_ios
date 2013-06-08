//
//  FKRHeaderSearchBarTableViewController.m
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "FKRHeaderSearchBarTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>

@interface FKRHeaderSearchBarTableViewController () {
    BOOL _mayUsePrivateAPI;
}

@end

@implementation FKRHeaderSearchBarTableViewController

#pragma mark - Initializer

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes
{
    if ((self = [super initWithSectionIndexes:showSectionIndexes])) {
        self.title = @"Header Search Bar";
        
        /*
         The exact same behavior as the contacts app is only possible with using private API. Without using private API the section index control on the right of the table won't overlap the search bar.
         Note: You shouldn't use private API in an App Store app, this is just for demo purposes.
        */
        
        //_mayUsePrivateAPI = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
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

@end