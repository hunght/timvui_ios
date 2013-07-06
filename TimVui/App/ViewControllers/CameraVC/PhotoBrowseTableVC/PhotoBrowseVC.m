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
#import "AFHTTPRequestOperation.h"
#import "BlockAlertView.h"
#import "Base64.h"
#import "TSMessage.h"
#import <JSONKit.h>
@interface PhotoBrowseVC ()

@end

@implementation PhotoBrowseVC
-(void)backButtonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
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
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    
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
    if (!_album) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Notify" message:@"Vui lòng chọn tên album trước khí đăng ảnh"];
        [alert setCancelButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Chọn Ablum!" block:^{
            if ([_delegate respondsToSelector:@selector(wantToShowLeft:)]) {
                [_delegate wantToShowLeft:YES];
            }
        }];
        [alert show];
        return;
    }
    if (!_branch_id) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Notify" message:@"Vui lòng chọn nhà hàng trước khí đăng ảnh"];
        [alert setCancelButtonWithTitle:@"Cancel" block:nil];
        [alert setDestructiveButtonWithTitle:@"Chọn Nhà hàng" block:^{
            if ([_delegate respondsToSelector:@selector(wantToShowLeft:)]) {
                [_delegate wantToShowLeft:NO];
            }
        }];
        [alert show];
        return;
    }
    int i=0;
    NSMutableArray* arrImageStr=[[NSMutableArray alloc] init];
    NSMutableArray* arrImage=[[NSMutableArray alloc] init];
    for (UIImage* image in _arrPhotos) {
        NSNumber* isPicked=[_arrPhotosPick objectAtIndex:i];
        if ([isPicked boolValue]) {
            
            NSData *imageToUpload = UIImageJPEGRepresentation(image, 0.00);
            [arrImageStr addObject:[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imageToUpload base64EncodedString]]];
            [arrImage addObject:image];
        }
        i++;
    }

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _album,@"album" ,
//                            _branch_id,@"branch_id",
                            @"1",@"branch_id",
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                            [arrImageStr JSONString],@"image_arr",
                            nil];
    
    NSLog(@"params=====%@",params);
    /*
    [[TVNetworkingClient sharedClient] postPath:@"branch/postImages" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {

        if ([_delegate respondsToSelector:@selector(didPickWithImages:)]) {
            [_delegate didPickWithImages:arrImage];
        }
        [self dismissModalViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng ảnh không thành công, vui lòng thử lại"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    }];
    */
    
    NSURLRequest* request = [[TVNetworkingClient sharedClient] multipartFormRequestWithMethod:@"POST"
            path:@"branch/postImages"  parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                int i=0;
                for (UIImage* image in _arrPhotos) {
                    NSNumber* isPicked=[_arrPhotosPick objectAtIndex:i];
                    if ([isPicked boolValue]) {
                        NSData *imageToUpload = UIImageJPEGRepresentation(image, .80);
                        [formData appendPartWithFileData:imageToUpload
                                                    name:[NSString stringWithFormat:@"%d",i]
                                                fileName:[NSString stringWithFormat:@"%d.jpg",i]
                                                mimeType:@"image/jpeg"];
                    }
                    i++;
                }
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];
        NSLog(@"response: [%@]",response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [operation error]);
        
    }];
    
    [operation start];


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
    }else{
        [_arrPhotosPick replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        [cell.btnPicked setSelected:YES];
    }
}

@end
