//
//  LocationTableVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/20/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "LocationTableVC.h"
#import "GlobalDataUser.h"
#import "NSDictionary+Extensions.h"
#import "CameraBranchCell.h"
@interface LocationTableVC ()

@end

@implementation LocationTableVC


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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.branches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CameraBranchCell";

        CameraBranchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[CameraBranchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.branch = self.branches[indexPath.row];
        return cell;

    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [CameraBranchCell heightForCellWithPost:self.branches[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if ([_delegate respondsToSelector:@selector(didPickWithLoation:)]) {
        [_delegate didPickWithLoation:self.branches[indexPath.row]];
    }
    
}

@end
