//
//  UILabel+DynamicHeight.h
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

@implementation UILabel (DynamicHeight)
-(void)resizeWidthToStretch{
    float width = [self expectedWidth];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self setFrame:newFrame];
}
-(void)resizeWidthToStretchToCenter{
    float width ;
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(9999,self.frame.size.height);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    width= expectedLabelSize.width;
    
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    //newFrame.size.height = height;
    newFrame.origin.x=(320-width)/2;
    [self setFrame:newFrame];
}


-(float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(9999,self.frame.size.height);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.width;
}


-(void)resizeToStretch{
    self.numberOfLines = 0;
    self.lineBreakMode = UILineBreakModeWordWrap;
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
}
-(void)resizeToStretchWidth:(int)width{
    self.numberOfLines = 0;
    self.lineBreakMode = UILineBreakModeWordWrap;
    float height;
    CGSize maximumLabelSize = CGSizeMake(width,9999);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
    height= expectedLabelSize.height;
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    newFrame.size.width = width;
    newFrame.origin.x=(320-width)/2;
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