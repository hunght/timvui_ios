//
//  PageOneView.h
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageView.h"

@interface PageTwoView : PageView
@property (nonatomic, assign) NSUInteger index;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblBranchName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblCompliment;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblDate;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTime;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblCity;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewSkin;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *backgroundLocation;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imagLocationIcon;

-(void)setName:(NSString*)name andAddress:(NSString*)address;
@end
