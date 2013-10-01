//
//  FKRHeaderSearchBarTableViewController.h
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "FKRSearchBarTableViewController.h"
#import "SearchVC.h"
@protocol SearchCuisinesDelegate <NSObject>

- (void)didSearchWithResult:(NSDictionary*)cuisine;

@end

@interface SearchCuisines : FKRSearchBarTableViewController {
    
}

@property (strong, nonatomic) NSMutableArray  *pickedArr;
@property (nonatomic, weak) id<SearchCuisinesDelegate> delegate;

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes withParam:(NSArray*)dic;

@end