//
//  FKRHeaderSearchBarTableViewController.h
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "FKRSearchBarTableViewController.h"
#import "SearchVC.h"

@interface SearchWithArrayVC : FKRSearchBarTableViewController {
    
}
@property (retain, nonatomic) SearchVC  *searchVC;

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes withParam:(NSArray*)dic;
@end