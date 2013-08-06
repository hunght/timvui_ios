//
//  TVExtraBranchView.h
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVComments.h"
#import "TVBranch.h"
typedef enum {
    kTVComment =0,
    kTVMenu,
    kTVSimilar
} kTVTable;

@interface TVExtraBranchView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) kTVTable currentTableType;
@property (strong, nonatomic) TVComments* comments;
@property (strong, nonatomic) NSArray* arrMenu;
@property (strong, nonatomic) NSArray* arrSimilar;
@property(nonatomic,strong)TVBranch *branch;
@property (assign, nonatomic) BOOL isHiddenYES;
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *viewScroll;
@property (strong, nonatomic) UIButton* btnBackground;
@property (strong, nonatomic) UILabel*lblReview;
@property (strong, nonatomic) UILabel*lblMenu;
@property (assign, nonatomic) BOOL isHasKaraokeYES;
@property (strong, nonatomic) UIScrollView *scrollEvent;
@property (assign, nonatomic) BOOL isShowFullExtraYES;
@end
