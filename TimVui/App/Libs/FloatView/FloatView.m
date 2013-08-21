//
//  FloatView.m
//  Anuong
//
//  Created by Hoang The Hung on 8/20/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "FloatView.h"
@interface FloatView() {
@private
    CGFloat lastDragOffset;
    BOOL isHiddenYES;
    BOOL isAnimating;
}
@end

@implementation FloatView

- (id)initWithFrame:(CGRect)frame withScrollView:(UIScrollView*)scroll
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView=scroll;
        // Initialization code
        void *context = (__bridge void *)self;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
        lastDragOffset = _scrollView.contentOffset.y;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        isHiddenYES=YES;
        [self setBackgroundColor:[UIColor greenColor]];
    }
    return self;
}

- (void)dealloc
{
//    if (self.scrollView) {
//        void *context = (__bridge void *)self;
//        [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
//    }

}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	// Make sure we are observing this value.
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    if ((object == self.scrollView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.scrollView.contentOffset.y];
        return;
    }
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    if (scrollOffset< lastDragOffset){
        if (isHiddenYES&&!isAnimating) {
            isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
            } completion:^(BOOL finished){
                isAnimating=NO;
                isHiddenYES=NO;
            }];
        }
    }else if (scrollOffset> lastDragOffset){
        if (!isHiddenYES&&!isAnimating) {
            isAnimating=YES;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                isAnimating=NO;
                isHiddenYES=YES;
            }];
        }
    }
    
    lastDragOffset = scrollOffset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
