//
//  Created by hunght on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"navigation_bar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
