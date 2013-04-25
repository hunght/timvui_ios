//
//  Uitilities.h
//  CityOffers
//
//  Created by hunght on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
typedef enum
{
    kThumbnailSizeType = 0,//50*50
    kNormalSizeType,//300*300
    kOriginalSizeType,//1024*1024
} ImageSizeType;
@interface Ultilities : NSObject
+(void) logMemoryUsage;
+(BOOL)isRetinaYES;
+(void)iPhoneRetina;
+ (void)roundCornerUIImageView:(UIImageView *)img;
+ (NSURL *)getImageOfPhotoEntre:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType;
+ (NSURL *)getImageOfReview:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType;
+ (NSURL *)getImageOfUser:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType;
+ (NSURL *)getImageOfEntre:(NSString *)logoImgPath withSizeType:(ImageSizeType)sizeType;
+ (NSURL *)getImageOfOffer:(NSString *)imgURL withSizeType:(ImageSizeType)sizeType;
+ (NSURL *)getImageOfCoverEntre:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType;
+(void)showAlertWithMessage:(NSString*)strMessage;
+ (BOOL)validateString:(NSString*)string;
+(BOOL)validateEmail:(NSString*)email;
+ (BOOL)validatePhone:(NSString *)aString;
+ (BOOL)validatePassword:(NSString*)pass;
+ (BOOL)validatePassword:(NSString*)pass withConfirmPass:(NSString*)confirmPass;
+(BOOL)checkPhoneNumber:(NSString *)aString;
+(BOOL)validateInputString:(NSString*)string withMessage:(NSString*)strMess;
@end
