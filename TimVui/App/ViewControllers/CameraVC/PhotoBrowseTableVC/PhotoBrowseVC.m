//
//  PhotoBrowseVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PhotoBrowseVC.h"
#import "UIImage+Crop.h"
#import "GlobalDataUser.h"
#import "TVNetworkingClient.h"
@interface PhotoBrowseVC ()

@end

@implementation PhotoBrowseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrPhotosPick=[[NSMutableArray alloc] init];
    for (int i=0; i<_arrPhotos.count; i++) {
        [_arrPhotosPick addObject:[NSNumber numberWithBool:YES]];
    }
    
    [self.view insertSubview:_bottomView aboveSubview:self.tableView];
    [_bottomView setBackgroundColor:[UIColor colorWithRed:(2/255.0f) green:(1/255.0f) blue:(1/255.0f) alpha:1.0f]];
    UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(15, 10.0, 210, 15)];
    lblAddress.backgroundColor = [UIColor clearColor];
    lblAddress.textColor = [UIColor grayColor];
    lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(17)];
    lblAddress.text=@"Chia sẻ lên Facbook";
    [_bottomView addSubview:lblAddress];
    
    
    UIButton* btnPostPhoto = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, 300, 46)];
    [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_buttom-big-off"] forState:UIControlStateNormal];
    [btnPostPhoto setBackgroundImage:[UIImage imageNamed:@"img_button_big_on"] forState:UIControlStateHighlighted];
    [btnPostPhoto setTitle:@"ĐĂNG ẢNH" forState:UIControlStateNormal];
    [btnPostPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNVanBold" size:(17)];
    [btnPostPhoto addTarget:self action:@selector(postPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btnPostPhoto];
    
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBAction
- (IBAction)switchChangedValue:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
}

-(void)postPhotoButtonClicked:(id)s{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _album,@"album" ,
                            _branch_id,@"branch_id",
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                            
                            nil];
    NSLog(@"%@",params);
    [[TVNetworkingClient sharedClient] postPath:@"branch/postImages" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark PhotoBrowseCellDelegate

-(void)pickerButtonClicked:(UIButton *)sender{
    if (sender.isSelected)
        [_arrPhotosPick replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithBool:NO]];
    else
        [_arrPhotosPick replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithBool:YES]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of sections.
    return  [_arrPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoBrowseCell";
    PhotoBrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PhotoBrowseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.btnPicked.tag=indexPath.row;
        [cell setDelegate:self];
    }
    // Configure the cell...
    cell.imageView.image=[[_arrPhotos objectAtIndex:indexPath.row] imageByScalingAndCroppingForSize:(CGSizeMake(306, 120))];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120+7+7;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoBrowseCell* cell=(PhotoBrowseCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.btnPicked.isSelected){
        [_arrPhotosPick replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        [cell.btnPicked setSelected:NO];
    }
    else{
        [_arrPhotosPick replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        [cell.btnPicked setSelected:YES];
    }
    
}




@end
