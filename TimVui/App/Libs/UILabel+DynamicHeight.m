//
//  UILabel+DynamicHeight.h
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

@implementation UILabel (DynamicHeight)

-(void)resizeToStretch{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
}

-(float)expectedHeight{
   
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height;
}

@end