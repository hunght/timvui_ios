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
#import "TVGroupCuisines.h"
#import "TVCuisine.h"
#import "MacroApp.h"
#import "TVNetworkingClient.h"
#import "GlobalDataUser.h"
#import "SVProgressHUD.h"
#import "TVComment.h"
#import "Ultilities.h"
#define kTableViewHeightOffset 150
@interface TVExtraBranchView() {
@private
    double lastDragOffset;
}
@end
@implementation TVExtraBranchView
-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView=scrollView;
    [_scrollView setDelegate:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewScroll= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
        [self addSubview:_viewScroll];
//        [viewScroll setPagingEnabled:YES];
        [_viewScroll setBackgroundColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:1.0f]];
        [_viewScroll setShowsHorizontalScrollIndicator:NO];
        UIImageView* image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 384, 41)];
        image.image=[UIImage imageNamed:@"img_profile_branch_scrollView"];
        
        [_viewScroll addSubview:image];
        [_viewScroll setContentSize:CGSizeMake(384, 41)];
        
        
        
        UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 99, 41)];
        [commentButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [commentButton setTitle:@"             BÌNH LUẬN" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font =[UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(99, 0, 100, 41)];
        [menuButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [menuButton setTitle:@"             MENU" forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_viewScroll addSubview:menuButton];
        int pad=0;
        if (_isHasKaraokeYES) {
            UIButton* karaokeButton = [[UIButton alloc] initWithFrame:CGRectMake(199, 0, 98, 41)];
            [karaokeButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
            [karaokeButton setTitle:@"             MENU" forState:UIControlStateNormal];
            [karaokeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            karaokeButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
            [karaokeButton addTarget:self action:@selector(karaokeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_viewScroll addSubview:karaokeButton];
            pad=karaokeButton.frame.size.width;
        }
        
        
        UIButton* eventButton = [[UIButton alloc] initWithFrame:CGRectMake(199+pad,0, 82, 41)];
        [eventButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [eventButton setTitle:@"             SỰ KIỆN" forState:UIControlStateNormal];
        [eventButton addTarget:self action:@selector(eventButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [eventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        eventButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
        [_viewScroll addSubview:eventButton];
        
        UIButton* similarButton = [[UIButton alloc] initWithFrame:CGRectMake(199+8+pad,0, 94, 41)];
        [similarButton setBackgroundImage:[Ultilities imageFromColor:[UIColor colorWithRed:(51/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:.5f]] forState:UIControlStateSelected];
        [similarButton setTitle:@"             SIMILAR" forState:UIControlStateNormal];
        [similarButton addTarget:self action:@selector(similarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [similarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        similarButton.titleLabel.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(13)];
        [_viewScroll addSubview:similarButton];
        [_viewScroll addSubview:commentButton];
    }
    return self;
}

- (void)postCommentBranch:(NSDictionary*)params {
    //NSLog(@"%@",params);
    if (!self.comments) {
        self.comments=[[TVComments alloc] initWithPath:@"branch/getComments"];
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.comments loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        });
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark Actions

-(void)eventButtonClicked:(UIButton*)sender{
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
}

-(void)similarButtonClicked:(UIButton*)sender{
    [self initTableView];
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
    if (_currentTableType!=kTVSimilar){
        _currentTableType=kTVSimilar;
        [_tableView reloadData];
    }
    
}



-(void)menuButtonClicked:(UIButton*)sender{
    [self initTableView];
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
    if (_currentTableType!=kTVMenu){
        _currentTableType=kTVMenu;
        [_tableView reloadData];
        
    }
}
-(void)karaokeButtonClicked:(UIButton*)sender{
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
}

-(void)commentButtonClicked:(UIButton*)sender{
    [self initTableView];
    [self.viewScroll scrollRectToVisible:sender.frame animated:YES];
    if (_currentTableType!=kTVComment)
    {
        _currentTableType=kTVComment;
        [self getCommentRefresh];
        
    }
    
}

-(void)backgroundButtonClicked:(id)sender{
    [self showExtraView:NO];
}


#pragma mark Helper

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
            }];
        }
        
    }else{
        if (!self.isAnimating) {
            [_btnBackground setHidden:YES];
            [self.scrollView setDelegate:self];
            self.isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformMakeTranslation(0, -41);
            } completion:^(BOOL finished){
                self.isAnimating=NO;
            }];
        }
    }
}

- (void)getCommentRefresh {
    NSDictionary* params;
    if (_comments.last_id) 
        params = @{@"branch_id": _branch.branchID,
                   @"limit": kNumberLimitRefresh
                   ,@"last_id": _comments.last_id
                   };
    else
        params = @{@"branch_id": _branch.branchID,
                   @"limit": kNumberLimitRefresh
                   };
    [self postCommentBranch:params];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    __unsafe_unretained TVExtraBranchView *weakSelf = self;
    __block NSString*branchID=_branch.branchID;
    
    //
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.comments.items=nil;
        NSDictionary* params = @{@"branch_id": branchID,
                  @"limit": kNumberLimitRefresh
                  };
        [weakSelf postCommentBranch:params];
    }];
    
#warning this is what todo when get total comments
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf getCommentRefresh];
//    }];
    
}

- (void)initTableView {
    
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 41, 320,self.superview.bounds.size.height- kTableViewHeightOffset) style:UITableViewStylePlain];
        [self addSubview:_tableView];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _currentTableType=-1;
        CGRect frame= self.frame;
        frame.size.height+=_tableView.frame.size.height;
        self.frame=frame;
        //        int numberOfPages=(_isHasKaraokeYES)?5:4;
        //        [_viewScroll setPagingEnabled: YES] ;
        //        [_viewScroll setContentSize: CGSizeMake(_viewScroll.bounds.size.width * numberOfPages, _viewScroll.bounds.size.height)] ;
        
        
    }
    
    if (!_btnBackground) {
        _btnBackground = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, kTableViewHeightOffset-41)];
        
        [_btnBackground addTarget:self action:@selector(backgroundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_btnBackground];
    }
    
    
    
    [self showExtraView:YES];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:[UITableView class]])
        return;
    lastDragOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]])
        return;
//    NSLog(@"%f",scrollView.contentOffset.y);
    if ((int)scrollView.contentOffset.y < lastDragOffset){
        if (self.isHiddenYES&&!self.isAnimating) {
            self.isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -41);
            } completion:^(BOOL finished){
                self.isAnimating=NO;
                self.isHiddenYES=NO;
            }];
        }
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_currentTableType==kTVMenu) {
        return  44.0f;
    }else
        return 0;
	
}

-(void)likeCommentButtonClicked:(UIButton*)sender{
    sender.userInteractionEnabled=NO;
    TVComment* comment=_comments[sender.tag];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [GlobalDataUser sharedAccountClient].user.userId,@"user_id" ,
                            comment.commentID,@"comment_id",
                            nil];
     NSLog(@"%@",params);
    [[TVNetworkingClient sharedClient] postPath:@"branch/userVoteComment" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        [SVProgressHUD showSuccessWithStatus:@"Bạn vừa thích comment này!"];
        sender.userInteractionEnabled=YES;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sender.userInteractionEnabled=YES;
        [SVProgressHUD showErrorWithStatus:@"Có lỗi khi like bình luận"];
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_currentTableType==kTVMenu) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 44.0f)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 3.0f, 5.0f)];
        TVGroupCuisines* group=[_branch.menu.items objectAtIndex:section];
		textLabel.text =group.name;
		textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(20)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor redColor];
		textLabel.backgroundColor = [UIColor clearColor];
        [textLabel sizeToFit];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(textLabel.frame.size.width+textLabel.frame.origin.x, 30.0f, [UIScreen mainScreen].bounds.size.height, 2.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(219.0f/255.0f) green:(219.0f/255.0f) blue:(219.0f/255.0f) alpha:1.0f];
		[textLabel.superview addSubview:topLine];
		
		[headerView addSubview:textLabel];
        return headerView;

    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    switch (_currentTableType) {
        case kTVComment:
            return 1;
            break;
        case kTVMenu:
            return [self.branch.menu.items count];
            break;
        case kTVSimilar:
            //return [self.comments count];
            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_currentTableType) {
        case kTVComment:
            return [self.comments count];
            break;
        case kTVMenu:
            return [[[self.branch.menu.items objectAtIndex:section] items] count];
            break;
        case kTVSimilar:
            //return [self.comments count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    switch (_currentTableType) {
        case kTVComment:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExtraCommentCell"];
            if (!cell) {
                cell = [[ExtraCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExtraCommentCell"];
                [(ExtraCommentCell*)cell setComment:_comments[indexPath.row]];
                [[(ExtraCommentCell*)cell btnLike] addTarget:self action:@selector(likeCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [[(ExtraCommentCell*)cell btnLike] setTag:indexPath.row];
            }
            
            break;
        case kTVMenu:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExtraMenuCell"];
            if (!cell) {
                cell = [[ExtraMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExtraMenuCell"];
                
            }
            TVGroupCuisines* group=[_branch.menu.items objectAtIndex:indexPath.section];
            TVCuisine* cuisine=group.items[indexPath.row];
            cell.textLabel.text=cuisine.name;
            cell.detailTextLabel.text=cuisine.price;
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
