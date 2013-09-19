//
//  TVExtraBranchView.m
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVExtraBranchView.h"
#import "ExtraCommentCell.h"
#import "ExtraMenuCell.h"
#import "SVPullToRefresh.h"
#import "TSMessage.h"
#import "TVGroupCuisines.h"
#import "TVCuisine.h"
#import "MacroApp.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "SVProgressHUD.h"
#import "TVComment.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+DynamicHeight.h"
#import "TVEvent.h"
#import "TVKaraokes.h"
#import "TVKaraoke.h"
#import "InfinitePagingView.h"
#import "CommentVC.h"
#import "CMHTMLView.h"
#import "ExtraSuggestionMenuCell.h"
#import "LoginVC.h"
#import "SIAlertView.h"
#define kTableViewHeightOffset 150
#define kCommentLimitCount 2

@interface TVExtraBranchView() {
@private
    double lastDragOffset;
    UIButton* commentButton;
    UIButton* menuButton;
    UIButton* karaokeButton;
    UIButton* eventButton;
    UIButton* similarButton;
    UIView* floatView;
    CGFloat lastDragOffsetFloatView;
    BOOL isFloatViewHiddenYES;
    BOOL isFloatViewAnimating;
    UILabel* lblWriteReviewNotice;
    int countMenu;
    int pageSimilarCount;
}
@end

@implementation TVExtraBranchView
-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView=scrollView;
    [_scrollView setDelegate:self];
    lastDragOffset = scrollView.contentOffset.y;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

- (id)initWithFrame:(CGRect)frame andBranch:(TVBranch*)branch withViewController:(UIViewController*)viewController
{
    _branch=branch;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//#warning test without karaoke
//        _branch.isHasKaraokeYES=NO;
        
        int pad=(_branch.isHasKaraokeYES)?83:0;
        
        _viewScroll= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
        [self addSubview:_viewScroll];
        lblWriteReviewNotice=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
        
        lblWriteReviewNotice.numberOfLines=2;
        lblWriteReviewNotice.text=@"Hãy viết đánh giá về địa điểm này để chia sẻ với bạn bè của bạn";
        lblWriteReviewNotice.backgroundColor = [UIColor clearColor];
        lblWriteReviewNotice.textColor = [UIColor grayColor];
        lblWriteReviewNotice.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblWriteReviewNotice.hidden=YES;
        //[viewScroll setPagingEnabled:YES];
        [_viewScroll setBackgroundColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:1.0f]];
        [_viewScroll setShowsHorizontalScrollIndicator:NO];
        UIImageView* image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 384+pad, 41)];
        
        if (_branch.isHasKaraokeYES)
            image.image=[UIImage imageNamed:@"img_profile_branch_scrollView_karaoke"];
        else
            image.image=[UIImage imageNamed:@"img_profile_branch_scrollView"];
        
        [_viewScroll addSubview:image];
        [_viewScroll setContentSize:CGSizeMake(384+pad, 41)];
        
        commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 99, 41)];
        _lblReview=[[UILabel alloc] initWithFrame:CGRectMake(65, 10, 30, 20)];
        [commentButton addSubview:_lblReview];
        _lblReview.textColor=[UIColor colorWithRed:(146/255.0f) green:(232/255.0f) blue:(255/255.0f) alpha:1.0f];
        _lblReview.font=[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
        
        _lblReview.backgroundColor=[UIColor clearColor];
        
        [commentButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [commentButton setTitle:@"    ĐÁNH GIÁ" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font =[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(99, 0, 100, 41)];
        _lblMenu=[[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 20)];
        [menuButton addSubview:_lblMenu];
        _lblMenu.textColor=[UIColor colorWithRed:(146/255.0f) green:(232/255.0f) blue:(255/255.0f) alpha:1.0f];
        _lblMenu.font=[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
        
        _lblMenu.backgroundColor=[UIColor clearColor];
        [menuButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_viewScroll addSubview:menuButton];
        
        if (_branch.isHasKaraokeYES) {
            
            karaokeButton = [[UIButton alloc] initWithFrame:CGRectMake(199, 0, 98, 41)];
            _lblKaraoke=[[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 20)];
            [karaokeButton addSubview:_lblKaraoke];
            _lblKaraoke.textColor=[UIColor colorWithRed:(146/255.0f) green:(232/255.0f) blue:(255/255.0f) alpha:1.0f];
            _lblKaraoke.font=[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
            _lblKaraoke.backgroundColor=[UIColor clearColor];
            
            [karaokeButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
            [karaokeButton setTitle:@"  PHÒNG HÁT" forState:UIControlStateNormal];
            [karaokeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            karaokeButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
            
            [karaokeButton addTarget:self action:@selector(karaokeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_viewScroll addSubview:karaokeButton];
            
            pad=karaokeButton.frame.size.width;
        }
        
        eventButton = [[UIButton alloc] initWithFrame:CGRectMake(199+pad,0, 82, 41)];
        [eventButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [eventButton setTitle:@"          SỰ KIỆN" forState:UIControlStateNormal];
        [eventButton addTarget:self action:@selector(eventButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [eventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        eventButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
        [_viewScroll addSubview:eventButton];
        
        similarButton = [[UIButton alloc] initWithFrame:CGRectMake(199+82+pad,0, 94, 41)];
        [similarButton setBackgroundImage:[Utilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [similarButton setTitle:@"     SIMILAR" forState:UIControlStateNormal];
        [similarButton addTarget:self action:@selector(similarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [similarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        similarButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(12)];
        [_viewScroll addSubview:similarButton];
        [_viewScroll addSubview:commentButton];
        [self   setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
        
        countMenu=0;
        for (TVGroupCuisines* group in _branch.menu.items ) {
            countMenu+=group.items.count;
        }
        
        self.lblMenu.text=[NSString stringWithFormat:@"(%d)",countMenu];
        
        self.lblKaraoke.text=[NSString stringWithFormat:@"(%d)",_branch.karaokes.items.count];
        _viewController=viewController;

    }
    if (_isWantToShowEvents) {
        _isHiddenYES=YES;
        [self showMenuExtraWithoutTableView];
    }
    return self;
}

#pragma TVNetworking

- (void)postCommentBranch:(NSDictionary*)params {
    NSLog(@"%@",params);
    if (!self.comments) {
        self.comments=[[TVComments alloc] initWithPath:@"branch/getComments"];
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    self.comments.isShowLoading=NO;
    [weakSelf.comments loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            self.lblReview.text=[NSString stringWithFormat:@"    (%d)",weakSelf.comments.count];
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
        });
    }];
}

- (void)postSimilarBranch:(NSDictionary*)params {
    NSLog(@"%@",params);
    if (!self.similarBranches) {
        self.similarBranches=[[TVBranches alloc] initWithPath:@"branch/getListBranchSibling"];
        self.similarBranches.isNotSearchAPIYES=YES;
        pageSimilarCount=0;
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.similarBranches loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
            pageSimilarCount++;
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
//            self..text=[NSString stringWithFormat:@"    (%d)",weakSelf.similarBranches.count];
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
        });
    }];
}

- (void)initTableView {
    
    
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 41, 320,self.superview.bounds.size.height- kTableViewHeightOffset) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_tableView];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _currentTableType=-1;
        CGRect frame= self.frame;
        frame.size.height+=_tableView.frame.size.height;
        self.frame=frame;
        
        if (!_btnBackground) {
            _btnBackground = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, kTableViewHeightOffset-41)];
            
            [_btnBackground addTarget:self action:@selector(backgroundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.superview addSubview:_btnBackground];
        }
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
        floatView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height,320, 48)];
        [self addSubview:floatView];
        UIButton* _btnCommentPost = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 300, 34)];
        [_btnCommentPost setBackgroundImage:[Utilities imageFromColor:kDeepOrangeColor] forState:UIControlStateNormal];
        [_btnCommentPost setBackgroundImage:[Utilities imageFromColor:kOrangeColor] forState:UIControlStateHighlighted];
        [_btnCommentPost setImage:[UIImage imageNamed:@"img_comment_postButton"] forState:UIControlStateNormal];
        [_btnCommentPost setTitleEdgeInsets:UIEdgeInsetsMake(7, - 250.0, 5.0, 5.0)];
        [_btnCommentPost setTitle:@"VIẾT ĐÁNH GIÁ" forState:UIControlStateNormal];
        [_btnCommentPost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCommentPost.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
        
        [_btnCommentPost addTarget:self action:@selector(writeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [floatView addSubview:_btnCommentPost];
        [floatView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:.5]];
        [self insertSubview:floatView aboveSubview:_tableView];
        isFloatViewHiddenYES=YES;
        lastDragOffsetFloatView=_tableView.contentOffset.y;
        [self addSubview:lblWriteReviewNotice];
        __unsafe_unretained TVExtraBranchView *weakSelf = self;
        __block NSString*branchID=_branch.branchID;
        
        //
        [self.tableView addPullToRefreshWithActionHandler:^{
            weakSelf.comments.items=nil;
            NSDictionary* params = @{@"branch_id": branchID,
                                     @"limit": @kCommentLimitCount
                                     };
            [weakSelf postCommentBranch:params];
        }];
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf getCommentRefresh];
        }];

    }
    
    [self showExtraView:YES];
}


- (void)setConnerBorderWithLayer:(CALayer *)l
{
    [l setMasksToBounds:YES];
    [l setCornerRadius:1.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}

- (void)settingTextForTitle:(UILabel *)lblTitle
{
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
}

-(int)addLineToView:(UIView*)view{
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(5,19+23, 295, 1)];
    grayLine.backgroundColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:1.0f];
    
    //    UIImageView* imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(5, 19+23, 295, 3)];
    //    [imageLine setImage:[UIImage imageNamed:@"img_profile_branch_line"]];
    [view addSubview:grayLine];
    return grayLine.frame.origin.y+grayLine.frame.size.height+15;
}

- (void)addEventAtCount:(int)eventCount height:(int)height
{
    CALayer *l;
    TVEvent* event = _branch.events.items[eventCount];
    UIView* eventView=[[UIView alloc] initWithFrame:CGRectMake(6, height, 320-6*2, 90)];
    [eventView setBackgroundColor:[UIColor whiteColor]];
    l=eventView.layer;
    [self setConnerBorderWithLayer:l];
    [self.scrollEvent addSubview:eventView];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    lblTitle.text=@"Sự kiện";
    [eventView addSubview:lblTitle];

    //EVENT
    height =[self addLineToView:eventView];
    
    
    UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(5+5 ,height , 290, 23)];
    lblDetailRow.backgroundColor = [UIColor clearColor];
    lblDetailRow.textColor = [UIColor blackColor];
    lblDetailRow.font = [UIFont fontWithName:@"Arial-BoldMT" size:(12)];
    lblDetailRow.text = event.title;
    [lblDetailRow resizeToStretch];
    height=lblDetailRow.frame.origin.y+lblDetailRow.frame.size.height+ 3;
    [eventView addSubview:lblDetailRow];
    for (NSString*addressStr in event.addresses) {
        UILabel *lblAddress= [[UILabel alloc] initWithFrame:CGRectMake(10, height, 290, 23)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor colorWithRed:(11/255.0f) green:(154 /255.0f) blue:(227/255.0f) alpha:1.0f];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(11)];
        lblAddress.text=addressStr;
        
        [lblDetailRow resizeToStretch];
        [eventView addSubview:lblAddress];
        height=lblAddress.frame.origin.y+lblAddress.frame.size.height+ 3;
    }
    
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    //    NSLog(@"%@",_coupon.content);
    //continue building the string
    [html appendString:event.content];
    [html appendString:@"</body></html>"];
    
    CMHTMLView* htmlView = [[CMHTMLView alloc] initWithFrame:CGRectMake(10, height, 290, 25)] ;
    htmlView.backgroundColor = [UIColor whiteColor];
    htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    htmlView.alpha = 0;
    [htmlView.scrollView setScrollEnabled:NO];
    [htmlView loadHtmlBody:html competition:^(NSError *error) {
        if (!error) {
            CGRect newBounds = htmlView.frame;
            newBounds.size.height = htmlView.scrollView.contentSize.height;
            htmlView.frame = newBounds;
            
            int height_p=htmlView.frame.origin.y+htmlView.frame.size.height+10;
            CGRect frame=eventView.frame;
            frame.size.height=height_p;
            eventView.frame=frame;
            
            int eventHeight=eventView.frame.origin.y+eventView.frame.size.height+30;
            NSLog(@"eventHeight=%d",eventHeight);
            
            [UIView animateWithDuration:0.2 animations:^{
                htmlView.alpha = 1;
            }];
            
            if (eventCount<_branch.events.items.count-1) {
                [self addEventAtCount:eventCount+1 height:eventHeight];
            }else{
                [_scrollEvent setContentSize:CGSizeMake(320, eventHeight)];
            }
        }
    }];
    
    [eventView addSubview:htmlView];
}

- (void)addEventToInfoView
{
    if (_branch.events.items.count>0) {
        lblWriteReviewNotice.hidden=YES;
    }else{
        lblWriteReviewNotice.hidden=NO;
    }
    if (!_scrollEvent) {
        _scrollEvent=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, 320,self.superview.bounds.size.height- kTableViewHeightOffset)];
        [_scrollEvent setDelegate:self];
        [_scrollEvent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
        [_scrollEvent setUserInteractionEnabled:YES];
        [self insertSubview:_scrollEvent belowSubview:_tableView ];
    }else{
        return;
    }
    
    int height=15;
    int eventCount=0;
    if (_branch.events.items.count>0) {
        
        [self addEventAtCount:eventCount height:height];
        
        
    }
}


- (void)addKaraokeAtCount:(int)karaokeCount withHeight:(int)karaokeHeight
{
    CALayer *l;
    TVKaraoke* karaoke= _branch.karaokes.items[karaokeCount];
    UIView* karaokeView=[[UIView alloc] initWithFrame:CGRectMake(6, karaokeHeight, 320-12, 90)];
    [karaokeView setBackgroundColor:[UIColor whiteColor]];
    l=karaokeView.layer;
    [self setConnerBorderWithLayer:l];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
    lblTitle.text=karaoke.name;
    [karaokeView addSubview:lblTitle];

    
    //Add Images Scrollview
    karaokeHeight =[self addLineToView:karaokeView];
    
    CGRect frame=CGRectMake(0.f, karaokeHeight,320,190.f);
    if (karaoke.images.count>0) {
        // pagingView
        InfinitePagingView *pagingView = [[InfinitePagingView alloc] initWithFrame:frame];
        pagingView.backgroundColor = [UIColor whiteColor];
        CGSize size= CGSizeMake(295, 190);
        pagingView.pageSize =size;
        [karaokeView addSubview:pagingView];
        
        for (NSDictionary*dicImage in karaoke.images)
        {
            UIImageView *page = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 290, 190)];
            [page setImageWithURL:[Utilities getLargeImageOfCoverBranch:dicImage] placeholderImage:nil];
            page.contentMode = UIViewContentModeScaleAspectFill;
            [pagingView addPageView:page];
        }
        
        karaokeHeight +=pagingView.frame.size.height+15;
    }

    
    
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    //continue building the string
    [html appendString:karaoke.content];
    [html appendString:@"</body></html>"];
    
    [self.scrollKaraoke addSubview:karaokeView];
    
    CMHTMLView* htmlView = [[CMHTMLView alloc] initWithFrame:CGRectMake(0, karaokeHeight, 290, 25)] ;
    htmlView.backgroundColor = [UIColor whiteColor];
    htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    htmlView.alpha = 0;
    [htmlView.scrollView setScrollEnabled:NO];
    [htmlView loadHtmlBody:html competition:^(NSError *error) {
        if (!error) {
            CGRect newBounds = htmlView.frame;
            newBounds.size.height = htmlView.scrollView.contentSize.height;
            htmlView.frame = newBounds;
            
            int height_p=htmlView.frame.origin.y+htmlView.frame.size.height+10;
            CGRect frame=karaokeView.frame;
            frame.size.height=height_p;
            karaokeView.frame=frame;
            
            int karaokeHeight=karaokeView.frame.origin.y+karaokeView.frame.size.height+30;
//            NSLog(@"karaokeHeight=%d",karaokeHeight);
            
            [UIView animateWithDuration:0.2 animations:^{
                htmlView.alpha = 1;
            }];
            NSLog(@"karaokeCount=%d",karaokeCount);
             NSLog(@"_branch.karaokes.items.count-1=%d",_branch.karaokes.items.count-1);
            if (karaokeCount<_branch.karaokes.items.count-1) {
                [self addKaraokeAtCount:karaokeCount+1 withHeight:karaokeHeight];
            }else{
                [_scrollKaraoke setContentSize:CGSizeMake(320, karaokeHeight)];
            }
        }
    }];
    
    [karaokeView addSubview:htmlView];
}

- (void)addKaraokeToInfoView
{
    if (_branch.karaokes.items.count>0) {
        lblWriteReviewNotice.hidden=YES;
    }else{
        lblWriteReviewNotice.hidden=NO;
    }
    if (!_scrollKaraoke) {
        _scrollKaraoke=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, 320,self.superview.bounds.size.height- kTableViewHeightOffset)];
        [_scrollKaraoke setDelegate:self];
        [_scrollKaraoke setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
        [_scrollKaraoke setUserInteractionEnabled:YES];
        [self insertSubview:_scrollKaraoke belowSubview:_tableView ];
    }else {
        return;
    }
    
    int height=15;
    
    if (_branch.karaokes.items.count>0) {
        NSLog(@"_branch.karaokes.items.count=%d",_branch.karaokes.items.count);
        [self addKaraokeAtCount:0 withHeight:height];
    }
}




#pragma mark Actions

-(void)eventButtonClicked:(UIButton*)sender{
    
    [self resetToUnselectedButtons];
    [eventButton setSelected:YES];
    [self initTableView];
    [self addEventToInfoView ];
    floatView.hidden=YES;
    [self.tableView setHidden:YES];
    [self.scrollEvent setHidden:NO];
    [self.scrollKaraoke setHidden:YES];
    CGRect frame=eventButton.frame;
    [self.viewScroll setContentOffset:CGPointMake(frame.origin.x - 150, 0) animated:YES];
}

-(void)similarButtonClicked:(UIButton*)sender{
    self.tableView.showsPullToRefresh=YES;
    self.tableView.showsInfiniteScrolling=YES;
    [self.tableView setHidden:NO];
    [self.scrollEvent setHidden:YES];
    [self.scrollKaraoke setHidden:YES];
    [self resetToUnselectedButtons];
    [sender setSelected:YES];
    [self initTableView];

    
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
    if (_currentTableType!=kTVSimilar){
        floatView.hidden=YES;
        _currentTableType=kTVSimilar;
        [self getBranchSimilar];
    }
}

-(void)menuButtonClicked:(UIButton*)sender{

    [self.tableView setHidden:NO];
    [self.scrollEvent setHidden:YES];
    [self.scrollKaraoke setHidden:YES];
    [self resetToUnselectedButtons];
    [sender setSelected:YES];
    [self initTableView];
    CGRect frame=sender.frame;
    [self.viewScroll setContentOffset:CGPointMake(frame.origin.x -100, 0) animated:YES];
    
    if (_currentTableType!=kTVMenu){
        floatView.hidden=YES;
        _currentTableType=kTVMenu;
        [_tableView reloadData];
    }
    self.tableView.showsPullToRefresh=NO;
    self.tableView.showsInfiniteScrolling=NO;
}

-(void)karaokeButtonClicked:(UIButton*)sender{
    
    [self resetToUnselectedButtons];
    [sender setSelected:YES];
    [self initTableView];
    [self addKaraokeToInfoView];
    floatView.hidden=YES;
    [self.tableView setHidden:YES];
    [self.scrollKaraoke setHidden:NO];
    [self.scrollEvent setHidden:YES];
    CGRect frame=sender.frame;
    [self.viewScroll setContentOffset:CGPointMake(frame.origin.x-100, 0) animated:YES];
}

-(void)commentButtonClicked:(UIButton*)sender{
    self.tableView.showsPullToRefresh=YES;
    self.tableView.showsInfiniteScrolling=YES;
    
    [self.tableView setHidden:NO];
    [self.scrollEvent setHidden:YES];
    [self.scrollKaraoke setHidden:YES];
    [self resetToUnselectedButtons];
    [sender setSelected:YES];
    [self initTableView];
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
    
    if (_currentTableType!=kTVComment)
    {
        _currentTableType=kTVComment;
        floatView.hidden=NO;
        [self getCommentRefresh];
    }
}

-(void)backgroundButtonClicked:(id)sender{
    [self showExtraView:NO];
}


#pragma mark Helper

-(void)writeButtonClicked{
    CommentVC* commentVC=[[CommentVC alloc] initWithNibName:@"CommentVC" bundle:nil];
    UINavigationController* navController =navController = [[UINavigationController alloc] initWithRootViewController:commentVC];
    commentVC.branch=_branch;
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [_viewController presentModalViewController:_slidingViewController animated:YES];
    commentVC.slidingViewController=_slidingViewController;
}

-(void)resetToUnselectedButtons{
    commentButton.selected=NO;
    karaokeButton.selected=NO;
    eventButton.selected=NO;
    menuButton.selected=NO;
    similarButton.selected=NO;
}

-(void)showExtraView:(BOOL)isYES{
    if (isYES){
        if (!self.isAnimating) {
            self.isAnimating=YES;
            
            [_btnBackground setHidden:NO];
            [self.scrollView setContentOffset:CGPointMake(0, kTableViewHeightOffset+28) animated:YES];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformMakeTranslation(0, -41-(self.superview.bounds.size.height- kTableViewHeightOffset));
            } completion:^(BOOL finished){
                self.isAnimating=NO;
                self.isShowFullExtraYES=YES;
            }];
        }
        
    }else{
        if (!self.isAnimating) {
            [_btnBackground setHidden:YES];
            //            [self.scrollView setDelegate:self];
            self.isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformMakeTranslation(0, -41);
            } completion:^(BOOL finished){
                self.isAnimating=NO;
                self.scrollView.scrollEnabled=YES;
            }];
        }
    }
}

- (void)getCommentRefresh {
    NSDictionary* params;
    if (_comments.last_id)
        params = @{@"branch_id": _branch.branchID,
                   @"limit": @kCommentLimitCount
                   ,@"last_id": _comments.last_id
                   };
    else
        params = @{@"branch_id": _branch.branchID,
                   @"limit": @kCommentLimitCount
                   };
    [self postCommentBranch:params];
}

- (void)getBranchSimilar{
    NSDictionary* params;
        params = @{@"id": _branch.branchID,
                   @"limit": @kCommentLimitCount
                   ,@"offset": [NSString stringWithFormat:@"%d",pageSimilarCount]
                   };

    [self postSimilarBranch:params];
}   

#pragma mark - UIScrollViewDelegate
- (void)showFloatView
{
    if (isFloatViewHiddenYES&&!isFloatViewAnimating) {
        isFloatViewAnimating=YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            floatView.transform = CGAffineTransformMakeTranslation(0, -floatView.frame.size.height);
        } completion:^(BOOL finished){
            isFloatViewAnimating=NO;
            isFloatViewHiddenYES=NO;
        }];
    }
}

- (void)showMenuExtraWithoutTableView
{
    if (self.isHiddenYES&&!self.isAnimating) {
        self.isAnimating=YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -41);
        } completion:^(BOOL finished){
            self.isAnimating=NO;
            self.isHiddenYES=NO;
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (![scrollView isEqual:_scrollView]){
        CGFloat scrollOffset=scrollView.contentOffset.y;
        if (floatView.isHidden||scrollOffset<0) {
            return;
        }
        if (scrollOffset< lastDragOffsetFloatView){
            if (scrollView.contentSize.height-scrollOffset- scrollView.frame.size.height<50) {
                return;
            }
            [self showFloatView];
        }else if (scrollOffset> lastDragOffsetFloatView){
            if (!isFloatViewHiddenYES&&!isFloatViewAnimating) {
                isFloatViewAnimating=YES;
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    // animate it to the identity transform (100% scale)
                    floatView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished){
                    isFloatViewAnimating=NO;
                    isFloatViewHiddenYES=YES;
                }];
            }
        }
        
        lastDragOffsetFloatView = scrollOffset;
        return;
    }
    if (_isShowFullExtraYES) {
        return;
    }
    //NSLog(@"scrollView.contentOffset.y====%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < lastDragOffset){

        [self showMenuExtraWithoutTableView];
    }else{
        if (!self.isHiddenYES&&!self.isAnimating) {
            self.isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                self.isAnimating=NO;
                self.isHiddenYES=YES;
            }];
        }
    }
    
    lastDragOffset = scrollView.contentOffset.y;
    // do whatever you need to with scrollDirection here.
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_currentTableType==kTVMenu) {
        return  44.0f;
    }else
        return 0;
}

- (void)likeCommentWithButton:(UIButton *)sender {
    sender.userInteractionEnabled=NO;
    TVComment* comment=_comments[sender.tag];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id" ,
                            comment.commentID,@"comment_id",
                            nil];
    NSLog(@"%@",params);
    
    [[TVNetworkingClient sharedClient] postPath:@"branch/userVoteComment" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        //        [SVProgressHUD showSuccessWithStatus:@"Bạn vừa thích comment này!"];
        [TSMessage showNotificationInViewController:_viewController
                                          withTitle:@"Bạn đã vote cho đánh giá thành công!"
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
        sender.userInteractionEnabled=YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sender.userInteractionEnabled=YES;
        //        [SVProgressHUD showErrorWithStatus:@"Có lỗi khi vote cho đánh giá về nhà hàng."];
        [TSMessage showNotificationInViewController:_viewController
                                          withTitle:@"Có lỗi khi vote cho đánh giá về nhà hàng."
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeWarning];
        NSLog(@"%@",error);
    }];
}

-(void)likeCommentButtonClicked:(UIButton*)sender{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self likeCommentWithButton:sender];
    else{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Bạn muốn login để vote cho đánh giá này?"];
        
        [alertView addButtonWithTitle:@"Login"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  
                                  LoginVC* loginVC=nil;
                                  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                                      loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
                                  } else {
                                      loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
                                  }
                                  
                                  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                                  [_viewController presentModalViewController:navController animated:YES];
                                  [loginVC goWithDidLogin:^{
                                      [self performSelector:@selector(likeCommentWithButton:) withObject:sender afterDelay:1];
                                  } thenLoginFail:^{
                                      [TSMessage showNotificationInViewController:_viewController
                                                                        withTitle:@"Có lỗi khi đăng nhập!"
                                                                      withMessage:nil
                                                                         withType:TSMessageNotificationTypeWarning];
                                  }];

                                  
                              }];
        [alertView addButtonWithTitle:@"Cancel"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
    }
    
    
}
- (void)voteCuisineWithButton:(UIButton *)sender {
    sender.userInteractionEnabled=NO;
    TVGroupCuisines* group=_branch.menuSuggesting;
    TVCuisine* cuisine=group.items[sender.tag];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id" ,
                            cuisine.cuisineID,@"item_id",
                            nil];
    NSLog(@"%@",params);
    
    [[TVNetworkingClient sharedClient] postPath:@"item/userLikeItem" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        cuisine.like_count++;
        ExtraSuggestionMenuCell*cell=(ExtraSuggestionMenuCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d votes",cuisine.like_count];
        [TSMessage showNotificationInViewController:_viewController
                                          withTitle:[NSString stringWithFormat:@"Bạn đã vote cho món %@ thành công!",cuisine.name]
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeSuccess];
        sender.userInteractionEnabled=YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sender.userInteractionEnabled=YES;
        [TSMessage showNotificationInViewController:_viewController
                                          withTitle:@"Có lỗi khi vote cho món ăn."
                                        withMessage:nil
                                           withType:TSMessageNotificationTypeWarning];
        NSLog(@"%@",error);
    }];
}

-(void)voteCuisineButtonClicked:(UIButton*)sender{
    
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self voteCuisineWithButton:sender];
    else{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Bạn muốn login để vote cho món ăn này?"];
        
        [alertView addButtonWithTitle:@"Login"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  
                                  LoginVC* loginVC=nil;
                                  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                                      loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
                                  } else {
                                      loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
                                  }
                                  
                                  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                                  [_viewController presentModalViewController:navController animated:YES];
                                  [loginVC goWithDidLogin:^{
                                      [self performSelector:@selector(voteCuisineWithButton:) withObject:sender afterDelay:1];
                                  } thenLoginFail:^{
                                      [TSMessage showNotificationInViewController:_viewController
                                                                        withTitle:@"Có lỗi khi đăng nhập!"
                                                                      withMessage:nil
                                                                         withType:TSMessageNotificationTypeWarning];
                                  }];

                              }];
        [alertView addButtonWithTitle:@"Cancel"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView show];
    }
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_currentTableType==kTVMenu) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 44.0f)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 3.0f, 5.0f)];

        TVGroupCuisines* group;
        if (section==0) {
            group=_branch.menuSuggesting;
        }else{
            group=[_branch.menu.items objectAtIndex:section-1];
        }
		textLabel.text =group.name;
		textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor redColor];
		textLabel.backgroundColor = [UIColor clearColor];
        [textLabel sizeToFit];
        
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(5,44-3, 295, 3)];
        grayLine.backgroundColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:1.0f];
        
//        UIImageView* imageLine=[[UIImageView alloc] initWithFrame:CGRectMake(5,44-3, 295, 3)];
//        [imageLine setImage:[UIImage imageNamed:@"img_profile_branch_line"]];
		[headerView addSubview:grayLine];
		
		[headerView addSubview:textLabel];
        return headerView;
        
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    int count=0;
    switch (_currentTableType) {
        case kTVComment:
            count= 1;
            break;
        case kTVMenu:
            count= [self.branch.menu.items count]+1;
            break;
        case kTVSimilar:
            count=1;
            break;
        default:
            break;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count=0;
    switch (_currentTableType) {
        case kTVComment:
            count= [self.comments count];
            if (count==0) {
                [self showFloatView];
                lblWriteReviewNotice.hidden=NO;
            }else{
                lblWriteReviewNotice.hidden=YES;
            }
            break;
        case kTVMenu:
            if (section==0) {
                count= [[self.branch.menuSuggesting items] count];
            }else{
                count= [[[self.branch.menu.items objectAtIndex:section-1] items] count];
            }
            
            if (countMenu==0) {
                [self showFloatView];
                lblWriteReviewNotice.hidden=NO;
            }else{
                lblWriteReviewNotice.hidden=YES;
            }
            break;
        case kTVSimilar:
            count= _similarBranches.count;
            if (count==0) {
                [self showFloatView];
                lblWriteReviewNotice.hidden=NO;
            }else{
                lblWriteReviewNotice.hidden=YES;
            }
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    switch (_currentTableType) {
        case kTVComment:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExtraCommentCell"];
            if (!cell) {
                cell = [[ExtraCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExtraCommentCell"];
                
                [[(ExtraCommentCell*)cell btnLike] addTarget:self action:@selector(likeCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            [[(ExtraCommentCell*)cell btnLike] setTag:indexPath.row];
            [(ExtraCommentCell*)cell setComment:_comments[indexPath.row]];
            break;
        case kTVMenu:
        {
            if (indexPath.section==0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ExtraSuggestionMenuCell"];
                if (!cell) {
                    cell = [[ExtraSuggestionMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExtraSuggestionMenuCell"];
                    [[(ExtraSuggestionMenuCell*)cell btnVote] addTarget:self action:@selector(voteCuisineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                [[(ExtraSuggestionMenuCell*)cell btnVote] setTag:indexPath.row];
                TVGroupCuisines* group=_branch.menuSuggesting;
                TVCuisine* cuisine=group.items[indexPath.row];
                [(ExtraSuggestionMenuCell*)cell titleRow].text=cuisine.name;
                [[(ExtraSuggestionMenuCell*)cell titleRow] sizeToFit];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%d votes",cuisine.like_count];
                
                
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ExtraMenuCell"];
                if (!cell) {
                    cell = [[ExtraMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExtraMenuCell"];
                    
                }
                TVGroupCuisines* group=[_branch.menu.items objectAtIndex:indexPath.section-1];
                TVCuisine* cuisine=group.items[indexPath.row];
                [(ExtraMenuCell*)cell titleRow].text=cuisine.name;[[(ExtraMenuCell*)cell titleRow] sizeToFit];
                cell.detailTextLabel.text=cuisine.price;

            }
            break;
        }
        case kTVSimilar:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[ExtraCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_currentTableType) {
        case kTVMenu:
            return 44;
            break;
            
        case kTVComment:
            return [ExtraCommentCell heightForCellWithPost:self.comments[indexPath.row]];
            break;
            
        case kTVSimilar:
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
}



@end
