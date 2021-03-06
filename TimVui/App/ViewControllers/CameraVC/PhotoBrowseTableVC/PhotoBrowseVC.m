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
#import "SIAlertView.h"
#import "Base64.h"
#import "TSMessage.h"
#import <JSONKit.h>
#import "NSDictionary+Extensions.h"
#import <SVProgressHUD.h>
#import "FacebookServices.h"
#import "TVBranch.h"
@interface PhotoBrowseVC ()
{
    @private
    BOOL isSaveImagesYES;
    NSMutableData *_responseData;
}
@end

@implementation PhotoBrowseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isSaveImagesYES=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FacebookServices checkFacebookSessionIsOpen:^(bool isOpen){
        [_swichFacebook setOn:isOpen];
    }];
    
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];

    _arrPhotosPick=[[NSMutableArray alloc] init];
    for (int i=0; i<_arrPhotos.count; i++) {
        [_arrPhotosPick addObject:[NSNumber numberWithBool:YES]];
    }
    
    [self.view insertSubview:_bottomView aboveSubview:self.tableView];
    [_bottomView setBackgroundColor:[UIColor colorWithRed:(2/255.0f) green:(1/255.0f) blue:(1/255.0f) alpha:1.0f]];
    UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 210, 15)];
    lblAddress.backgroundColor = [UIColor clearColor];
    lblAddress.textColor = kGrayTextColor;
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
    [self setSwichFacebook:nil];
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
    [SVProgressHUD dismiss];
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString* strJSON = [[NSString alloc] initWithData:_responseData
                                              encoding:NSUTF8StringEncoding] ;
    NSDictionary* dic=[strJSON objectFromJSONString];
    NSLog(@"strJSON===%@",strJSON);
    NSLog(@"dic=%@",[dic objectForKey:@"status"]);
    
    if ([dic safeIntegerForKey:@"status"]==200){
        if (_swichFacebook.on) {
            [FacebookServices postImageActionWithBranch:_branch withArrayUrl:[dic safeArrayForKey:@"data"]];
        }
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng ảnh thành công"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
        [self.navigationController   popViewControllerAnimated:YES];
    }
    else
        [TSMessage showNotificationInViewController:self
                                          withTitle:@"Đăng ảnh thất bại"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeError];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
     NSLog(@"error =%@",error);
    [SVProgressHUD dismiss];
    [TSMessage showNotificationInViewController:self
                                      withTitle:@"Đăng ảnh thất bại"
                                    withMessage:nil
                                       withType:TSMessageNotificationTypeError];
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
    if (_swichFacebook.on) {
        [FacebookServices loginAndTakePermissionWithHanlder:^(FBSession *session,NSError *error){
            _swichFacebook.on=(!error);
        }];
    }
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
    
//    [parameters setValue:@"1" forKey:@"branch_id"];
    [parameters setValue:_branch.branchID forKey:@"branch_id"];
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
    NSMutableArray* arrImages=[[NSMutableArray alloc] init];
    for (UIImage* image in _arrPhotos) {
        NSNumber* isPicked=[_arrPhotosPick objectAtIndex:i];
        if ([isPicked boolValue]) {
            [arrImages addObject:image];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
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
    if (isSaveImagesYES==NO) {
        if ([_delegate respondsToSelector:@selector(didPickWithImages:)]) {
            [_delegate didPickWithImages:arrImages];
            isSaveImagesYES=YES;
        }
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
    [SVProgressHUD show];
}

-(void)postPhotoButtonClicked:(id)s{
    if (!_branch) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Vui lòng chọn nhà hàng trước khi đăng ảnh"];
        
        [alertView addButtonWithTitle:@"Chọn Nhà hàng"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  if ([_delegate respondsToSelector:@selector(wantToShowLeft:)]) {
                                      [_delegate wantToShowLeft:NO];
                                  }
                                  NSLog(@"Button1 Clicked");
                              }];
        [alertView addButtonWithTitle:@"Bỏ qua"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
        
        return;
    }

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _album,@"album",
                            _branch.branchID,@"branch_id",
//                            @"1",@"branch_id",
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id",
                            nil];
    
    NSLog(@"params=====%@",params);
    [self uploadImagesToServer];
}

#pragma mark PhotoBrowseCellDelegate

-(void)pickerButtonClicked:(UIButton *)sender{
    NSLog(@"sender.tag=====%d",sender.tag);
    if (sender.isSelected)
        [_arrPhotosPick replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithBool:NO]];
    else
        [_arrPhotosPick replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithBool:YES]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of sections.
    int i=(float)[_arrPhotos count]/2.0+.5;
    NSLog(@"row count=== %d",i);
    return  i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoBrowseCell";
    PhotoBrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PhotoBrowseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.btnImageOne.selected=YES;
        cell.btnImageTwo.selected=YES;
        
        cell.btnImageOne.tag=indexPath.row*2;
        cell.btnImageTwo.tag=indexPath.row*2+1;
        [cell setDelegate:self];
        
    }
    [cell.btnImageOne setImage:[_arrPhotos objectAtIndex:cell.btnImageOne.tag] forState:UIControlStateNormal];
    
    if (!([_arrPhotos count]==cell.btnImageTwo.tag))
        [cell.btnImageTwo setImage:[_arrPhotos objectAtIndex:cell.btnImageTwo.tag] forState:UIControlStateNormal];
    else
        cell.imgPickedTwo.hidden=YES;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

@end
