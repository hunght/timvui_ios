//
//  TVExtraBranchView.m
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVExtraBranchView.h"
#import "ExtraCommentCell.h"
#define kTableViewHeightOffset 290
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
        UIButton* similarButton = [[UIButton alloc] initWithFrame:CGRectMake(214,0, 106, 56)];
        [similarButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
        [similarButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
        
        [similarButton addTarget:self action:@selector(similarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:similarButton];
        
        UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(107, 0, 106, 56)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
        
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        
        UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106, 56)];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
        [commentButton setTitle:@"             BÌNH LUẬN" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentButton];
        
    }
    return self;
}

- (void)postCommentBranch:(NSDictionary*)params {
    NSLog(@"%@",params);
    if (!self.comments) {
        self.comments=[[TVComments alloc] initWithPath:@"branch/getComments"];
    }
    __unsafe_unretained __typeof(&*self)weakSelf = self;
    [weakSelf.comments loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self.tableView reloadData];
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
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

- (void)initTableView {
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 47, 320,self.superview.bounds.size.height- kTableViewHeightOffset) style:UITableViewStylePlain];
        [self addSubview:_tableView];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _currentTableType=-1;
        CGRect frame= self.frame;
        frame.size.height+=_tableView.frame.size.height;
        self.frame=frame;
    }
    if (!_btnBackground) {
        _btnBackground = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, kTableViewHeightOffset)];
        
        [_btnBackground addTarget:self action:@selector(backgroundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_btnBackground];
    }
    
    [self showExtraView:YES];

}


-(void)similarButtonClicked:(id)sender{
    [self initTableView];
    if (_currentTableType!=kTVSimilar)
        [_tableView reloadData];
    _currentTableType=kTVSimilar;
}



-(void)menuButtonClicked:(id)sender{
    [self initTableView];
    if (_currentTableType!=kTVMenu)
        [_tableView reloadData];
    _currentTableType=kTVMenu;
}

-(void)showExtraView:(BOOL)isYES{
    
    if (isYES){
        if (!self.isAnimating) {
            self.isAnimating=YES;
            [_btnBackground setHidden:NO];
            [self.scrollView setDelegate:nil];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformMakeTranslation(0, -46-(self.superview.bounds.size.height- kTableViewHeightOffset));
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
                self.transform = CGAffineTransformMakeTranslation(0, -46);
            } completion:^(BOOL finished){
                self.isAnimating=NO;
            }];
        }
    }
}

-(void)commentButtonClicked:(id)sender{
    [self initTableView];
    if (_currentTableType!=kTVComment)
    {
        NSDictionary* params;
        if (_comments.last_id) 
            params = @{@"branch_id": _branchID,
                                     @"limit": kNumberLimitRefresh
                                     ,@"last_id": _comments.last_id
                                     };
        else
            params = @{@"branch_id": _branchID,
                                 @"limit": kNumberLimitRefresh
                                 };
        [self postCommentBranch:params];
        
    }
    
    _currentTableType=kTVComment;
}



-(void)layoutSubviews{
    [super layoutSubviews];

}

-(void)backgroundButtonClicked:(id)sender{
    [self showExtraView:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]])
        return;
    lastDragOffset = scrollView.contentOffset.y;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) 
        return;
    
    NSLog(@"%f",scrollView.contentOffset.y);
    if ((int)scrollView.contentOffset.y < lastDragOffset){
        if (self.isHiddenYES&&!self.isAnimating) {
            self.isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformMakeTranslation(0, -46);
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    ExtraCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ExtraCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.comment = self.comments[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_comments count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //

}



@end
