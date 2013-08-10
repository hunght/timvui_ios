//
//  PageOneView.h
//  Anuong
//
//  Created by Hoang The Hung on 7/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "PageView.h"

@interface PageTenView : PageView
@property (nonatomic, assign) NSUInteger index;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblBranchName;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewSkin;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *bgBranchView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *bgBranchAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imagImHereIcon;
-(void)setName:(NSString*)name andAddress:(NSString*)address;

@end
