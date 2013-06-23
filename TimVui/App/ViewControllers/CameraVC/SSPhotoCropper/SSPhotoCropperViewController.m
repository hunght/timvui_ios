
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  SSPhotoCropperViewController.m
//  SSPhotoCropperDemo
//
//  Created by Ahmet Ardal on 10/17/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSPhotoCropperViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SSPhotoCropperViewController(Private)
- (void) loadPhoto;
- (void) setScrollViewBackground;
- (BOOL) isRectanglePositionValid:(CGPoint)pos;

@end

@implementation SSPhotoCropperViewController

@synthesize scrollView, photo, imageView, cropRectangleButton, delegate,
            minZoomScale, maxZoomScale, infoMessageTitle, infoMessageBody, photoCropperTitle, isNotWantToCropImageYES;

- (id) initWithPhoto:(UIImage *)aPhoto
            delegate:(id<SSPhotoCropperDelegate>)aDelegate
{
    return [self initWithPhoto:aPhoto
                      delegate:aDelegate
                        uiMode:SSPCUIModePresentedAsModalViewController
               showsInfoButton:YES];
}

- (id) initWithPhoto:(UIImage *)aPhoto
            delegate:(id<SSPhotoCropperDelegate>)aDelegate
              uiMode:(SSPhotoCropperUIMode)uiMode
     showsInfoButton:(BOOL)showsInfoButton
{
    if (!(self = [super initWithNibName:@"SSPhotoCropperViewController" bundle:nil])) {
        return self;
    }

    self.photo = aPhoto;
    self.delegate = aDelegate;
    _uiMode = uiMode;
    _showsInfoButton = showsInfoButton;


    self.infoMessageTitle = @"In order to crop the photo";
    self.infoMessageBody = @"Use two of your fingers to zoom in and out the photo and drag the"
                           @" green window to crop any part of the photo you would like to use.";
    self.photoCropperTitle = @"";

    return self;
}



- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photo = nil;
        self.delegate = nil;
    }
    return self;
}

- (void) dealloc
{
}

- (void) didReceiveMemoryWarning
{
//    self.navigationController.toolbarHidden=YES;
    [super didReceiveMemoryWarning];
}

- (IBAction) infoButtonTapped:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:self.infoMessageTitle
                                                 message:self.infoMessageBody
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

-(void)backButtonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidZoom:(UIScrollView *)_scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    NSLog(@"[%f,%f]",subView.center.x,subView.center.y);
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (_scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (320 > scrollView.contentSize.height)?
    (320 - scrollView.contentSize.height) * 0.5 : 0.0;
    NSLog(@"[%f,offsetY=%f]",320.0,offsetY);
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 +offsetX,
                                 scrollView.contentSize.height* 0.5 +offsetY);
    NSLog(@"[%f,%f]",subView.center.x,subView.center.y);
}

#pragma -
#pragma mark - View lifecycle

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    //
    // setup view ui
    //
//    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 33)] autorelease];
//    [backButton setTitle:@"Done" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"Button-touch.png"] forState:UIControlStateHighlighted];
//    [backButton addTarget:self action:@selector(saveAndClose:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    
//    self.navigationItem.rightBarButtonItem = bi;
//    [bi release];
//
//    if (_uiMode == SSPCUIModePresentedAsModalViewController) {
//        bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                           target:self
//                                                           action:@selector(cancelAndClose:)];
//        self.navigationItem.leftBarButtonItem = bi;
//        [bi release];
//    }else{
//        UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 33)] autorelease];
//        [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_egle_off.png"] forState:UIControlStateNormal];
//        [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_egle_on.png"] forState:UIControlStateHighlighted];
//        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [backButton setTitle:@"Back" forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        backButton.titleLabel.font=[UIFont systemFontOfSize:13];
//        
//        self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//        UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
//        self.navigationItem.leftBarButtonItem = backButtonItem;
//    }


    self.navigationController.navigationBarHidden=YES;
    self.title = self.photoCropperTitle;

    //
    // photo cropper ui stuff
    //
    [self setScrollViewBackground];
//    [self.cropRectangleButton addTarget:self
//                                 action:@selector(imageTouch:withEvent:)
//                       forControlEvents:UIControlEventTouchDown];
//    [self.cropRectangleButton addTarget:self
//                                 action:@selector(imageMoved:withEvent:)
//                       forControlEvents:UIControlEventTouchDragInside];

    if (self.photo != nil) {
        [self loadPhoto];
        
    }
    if (isNotWantToCropImageYES) {
        cropRectangleButton.hidden=YES;
    }else{
        cropRectangleButton.layer.borderColor = [UIColor whiteColor].CGColor;
        cropRectangleButton.layer.borderWidth = 1.0;
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}
- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma -
#pragma UIScrollViewDelegate Methods

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma -
#pragma Private Methods

- (void) loadPhoto
{
    if (self.photo == nil) {
        return;
    }

    CGFloat w = self.photo.size.width;
    CGFloat h = self.photo.size.height;
    CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, roundf(w / 2.0f), roundf(h / 2.0f));
    self.scrollView.contentSize = imageViewFrame.size;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.scrollView.contentInset=UIEdgeInsetsMake(48.0+44.0,0.0,48.0+44.0+44.0,0.0);
        CGRect frame =cropRectangleButton.frame;
        frame.origin.y+=44;
        [cropRectangleButton setFrame:frame];
    } else {
        // code for 3.5-inch screen
        self.scrollView.contentInset=UIEdgeInsetsMake(48.0,0.0,48.0+44.0,0.0);
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
    iv.image = self.photo;
    [self.scrollView addSubview:iv];
    self.imageView = iv;

    float minimumScaleW = [cropRectangleButton frame].size.width  / [imageView frame].size.width;
    float minimumScaleH = [cropRectangleButton frame].size.height  / [imageView frame].size.height;
    float minimumScale=(minimumScaleH<minimumScaleW)?minimumScaleH:minimumScaleW;
    [scrollView setMinimumZoomScale:minimumScale];
    [scrollView setMaximumZoomScale:640.0f/100.0f];
    [scrollView setZoomScale:(minimumScaleH>minimumScaleW)?minimumScaleH:minimumScaleW];
}

- (void) setScrollViewBackground
{
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    rect.size.height = rect.size.height * [image scale];
    rect.size.width = rect.size.width * [image scale];
    rect.origin.x = rect.origin.x * [image scale];
    rect.origin.y = rect.origin.y * [image scale];
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[image scale] orientation:[image imageOrientation]];
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage *) croppedPhoto
{
    CGFloat ox = self.scrollView.contentOffset.x;
    CGFloat oy = self.scrollView.contentOffset.y;
    CGFloat zoomScale = self.scrollView.zoomScale;
    CGFloat cx = (ox + self.cropRectangleButton.frame.origin.x) * 2.0f / zoomScale;
    CGFloat cy = (oy + self.cropRectangleButton.frame.origin.y) * 2.0f / zoomScale;
    CGFloat cw = 640.0f / zoomScale;
    CGFloat ch = 640.0f / zoomScale;
    CGRect cropRect = CGRectMake(cx, cy, cw, ch);
    
    NSLog(@"---------- cropRect: %@", NSStringFromCGRect(cropRect));
    NSLog(@"--- self.photo.size: %@", NSStringFromCGSize(self.photo.size));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.photo CGImage], cropRect);
    UIImage *result = [self imageFromImage:self.photo inRect:cropRect];//[UIImage imageWithCGImage:[self.photo CGImage]];
    CGImageRelease(imageRef);
    
    NSLog(@"------- result.size: %@", NSStringFromCGSize(result.size));
    return result;
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCropperDidCancel:)]) {
        [self.delegate photoCropperDidCancel:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonClicked:(id)sender {
    NSLog(@"----------- zoomScale: %.04f", self.scrollView.zoomScale);
    NSLog(@"------- contentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));
    NSLog(@"-- contentScaleFactor: %.04f", self.scrollView.contentScaleFactor);
    NSLog(@"--------- contentSize: %@", NSStringFromCGSize(self.scrollView.contentSize));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCropper:didCropPhoto:)]) {
        UIImage*myPhoto=nil;
        if (isNotWantToCropImageYES)
            myPhoto=self.photo;
        else
            myPhoto=[self croppedPhoto];
        [self.delegate photoCropper:self didCropPhoto:myPhoto];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (BOOL) isRectanglePositionValid:(CGPoint)pos
{
    CGRect innerRect = CGRectMake((pos.x + 15), (pos.y + 15), 150, 150);
    return CGRectContainsRect(self.scrollView.frame, innerRect);
}

- (IBAction) imageMoved:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];

    CGPoint prev = _lastTouchDownPoint;
    _lastTouchDownPoint = point;
    CGFloat diffX = point.x - prev.x;
    CGFloat diffY = point.y - prev.y;

    UIControl *button = sender;
    CGRect newFrame = button.frame;
    newFrame.origin.x += diffX;
    newFrame.origin.y += diffY;
    if ([self isRectanglePositionValid:newFrame.origin]) {
        button.frame = newFrame;
    }
}

- (IBAction) imageTouch:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    _lastTouchDownPoint = point;
    NSLog(@"imageTouch. point: %@", NSStringFromCGPoint(point));
}

@end
