//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TVPhotoBrowserVC.h"
#import "TVNetworkingClient.h"
#import "Utilities.h"
#import "NSDictionary+Extensions.h"
#import <SVProgressHUD.h>
#import "TVBranchPhoto.h"
#import "TwoImageCell.h"
#import "NSDate-Utilities.h"
@interface TVPhotoBrowserVC ()<MHFacebookImageViewerDatasource>{
    @private
        NSArray *albumArr;
}

@end

@implementation TVPhotoBrowserVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark MHFacebookImageViewerDatasource
-(void)settingCaptionView:(UIView *)captionView withIndex:(int)index{
    NSLog(@"index=%d",index);
    TVBranchPhoto*photo=    [albumArr objectAtIndex:index];
    UILabel* title= (UILabel*)[captionView viewWithTag:1];
    UILabel* content= (UILabel*)[captionView viewWithTag:2];
    title.text=photo.user_name;
    content.text=[NSString stringWithFormat:@"%@ %@",photo.user_name,[photo.created stringMinutesFromNowAgo] ];     
}
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return albumArr.count;
}

-  (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    TVBranchPhoto*photo=    [albumArr objectAtIndex:index];
    return [Utilities getOriginalAlbumPhoto:photo.arrURLImages];
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return nil;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _branch.branchID,@"branch_id" ,
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"branch/getImages" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        NSMutableArray* arr=[[NSMutableArray alloc] init];
        for (NSArray* imagesArr in [[JSON safeDictForKey:@"data"] allValues] ) {
            NSLog(@"imagesArr=%@",imagesArr);
            for (NSDictionary* imageDic in imagesArr) {
                TVBranchPhoto* photo=[[TVBranchPhoto alloc] initWithDict:imageDic];
                [arr addObject:photo];
            }
        }
        albumArr=arr;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i=(float)[albumArr count]/2.0+.5;
    NSLog(@"row count=== %d",i);
    NSLog(@"[albumArr count] count=== %d",[albumArr count]);
    return  i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"two_image_cell";
    TwoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TwoImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSInteger imageIndex = indexPath.row;
    UIImageView * imgPickedOne = [cell imgPickedOne];
    UIImageView * imgPickedTwo = [cell imgPickedTwo];
    [self displayImage:imgPickedOne withImage:(imageIndex * 2)];
    if ([albumArr count]==imageIndex*2+1) {
        cell.imgPickedTwo.hidden=YES;
    }else{
        cell.imgPickedTwo.hidden=NO;

        [self displayImage:imgPickedTwo withImage:(imageIndex * 2)+1];
    }
    
    return cell;
}

- (void) displayImage:(UIImageView*)imageView withImage:(int)index  {
    TVBranchPhoto*photo=    [albumArr objectAtIndex:index];
//    NSLog(@"%@",[Utilities getLargeAlbumPhoto:photo.arrURLImages]);
    [imageView setImageWithURL:[Utilities getLargeAlbumPhoto:photo.arrURLImages] placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewerWithDatasource:self initialIndex:index];
    imageView.clipsToBounds = YES;
}

#pragma mark IBAction
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
