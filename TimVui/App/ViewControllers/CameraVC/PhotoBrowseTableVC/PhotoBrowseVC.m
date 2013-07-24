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
#import "NSDictionary+Extensions.h"
@interface PhotoBrowseVC ()
{
    @private
    NSMutableData *_responseData;
}
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
    btnPostPhoto.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(17)];
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

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString* strJSON = [[NSString alloc] initWithData:_responseData
                                              encoding:NSUTF8StringEncoding] ;
    NSDictionary* dic=[strJSON objectFromJSONString];
    NSLog(@"_responseData===%@",[NSString stringWithUTF8String:[_responseData bytes]]);
    NSLog(@"dic=%@",[dic objectForKey:@"status"]);
    
    if ([dic safeIntegerForKey:@"status"]==200)
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng ảnh thành công"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
    else
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng ảnh thất bại"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount] == 0) {

        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:@"ios"
                                                   password:@"ios"
                                                persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
        //[self showPreferencesCredentialsAreIncorrectPanel:self];
    }
}


#pragma mark IBAction
- (IBAction)switchChangedValue:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
}

-(void)uploadImagesToServer{
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //Set Params
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------WebKitFormBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //Populate a dictionary with all the regular values you would like to send.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:11];
    
    [parameters setValue:@"1" forKey:@"branch_id"];
    [parameters setValue:[GlobalDataUser sharedAccountClient].user.userId forKey:@"user_id"];
    // add params (all params are strings)
    for (NSString *param in parameters) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *FileParamConstant = @"image_arr[]";
    
    // add image data and compress to send if needed.
    int i=0;
    for (UIImage* image in _arrPhotos) {
        NSNumber* isPicked=[_arrPhotosPick objectAtIndex:i];
        if ([isPicked boolValue]) {
            NSData *imageData = UIImageJPEGRepresentation(image, .80);
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image_arr.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:imageData];
                
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        i++;
    }
    
    //Assuming data is not nil we add this to the multipart form

    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    NSLog(@"%@",[NSString stringWithUTF8String:[body bytes]]);
    // set URL
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@branch/postImages",kAFAppDotNetAPIBaseURLString]]];
    
    NSURLConnection*connect=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connect start];
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

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _album,@"album",
//                            _branch_id,@"branch_id",
                            @"1",@"branch_id",
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                            nil];
    
    NSLog(@"params=====%@",params);
    [self uploadImagesToServer];
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
