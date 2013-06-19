//
//  UIImage+Crop.h
//  CityOffers
//
//  Created by hunght on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ultilities.h"
@interface UIImage (Crop)
- (UIImage *)cropImageInstagramStyle;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
@end
