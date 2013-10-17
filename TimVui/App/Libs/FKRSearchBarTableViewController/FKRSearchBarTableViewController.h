//
//  FKRSearchBarTableViewController.h
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKRSearchBarTableViewController : MyViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
}

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes;

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated; // Implemented by the subclasses

@property(nonatomic, assign, readonly) BOOL showSectionIndexes;

@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong, readonly) UISearchBar *searchBar;
@property(nonatomic, copy) NSArray *famousPersons;
@property(nonatomic, copy) NSArray *sections;
@property(nonatomic, copy) NSArray *filteredPersons;
-(void)setDataForSearchTable:(NSArray*)arr;

@end