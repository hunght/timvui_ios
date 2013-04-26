// GlobalTimelineViewController.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MainVC.h"
#import "LoginVC.h"
#import "Post.h"

#import "PostTableViewCell.h"
#import "IIViewDeckController.h"
@interface MainVC ()
- (void)reload:(id)sender;
@end

@implementation MainVC {
@private
    NSArray *_posts;
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
}
#warning Potentially useless method implementation.
- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            _posts = posts;
            [self.tableView reloadData];
        }
        
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}


#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"]
                                                                       forBarMetrics:UIBarMetricsDefault];
    }
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"leftMenuBtn.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"leftMenuCoverBtn.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.viewDeckController action:@selector(toggleDownLeftView) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.tableView.rowHeight = 70.0f;
    [self reload:nil];   
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
}

- (void)viewDidUnload {
    _activityIndicatorView = nil;
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.post = [_posts objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [PostTableViewCell heightForCellWithPost:[_posts objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
