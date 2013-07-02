//
//  SkinPickerTableVC.h
//  TimVui
//
//  Created by Hoang The Hung on 6/20/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SkinPickerTableVCDelegate;


@interface SkinPickerTableVC : UITableViewController
@property (nonatomic, unsafe_unretained) id<SkinPickerTableVCDelegate> delegate;
@end
@protocol SkinPickerTableVCDelegate<NSObject>
-(void)didPickWithAlbum:(NSString *)strAlbum;
@end