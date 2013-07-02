//
//  SkinPickerTableVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/20/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "SkinPickerTableVC.h"

@interface SkinPickerTableVC ()

@end

@implementation SkinPickerTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SkinPickerTableVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    NSString* strAlbum;
    switch (indexPath.row) {
        case 0:
            strAlbum=@"DECORATION";
            break;
        case 1:
            strAlbum=@"FOOD";
            break;
        case 2:
            strAlbum=@"MENU";
            break;
        case 3:
            strAlbum=@"OTHER";
            break;
        default:
            break;
    }
    cell.textLabel.text=strAlbum;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(didPickWithAlbum:)]) {
        UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
        [_delegate didPickWithAlbum:cell.textLabel.text];
    }
}

@end
