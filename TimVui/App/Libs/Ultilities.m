//
//  Uitilities.m
//  CityOffers
//
//  Created by hunght on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ultilities.h"
#import "MacroCityOffers.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <QuartzCore/QuartzCore.h>
@implementation Ultilities
static bool isRetinaYES =NO;
+(BOOL)isRetinaYES{
    return isRetinaYES;
    
}
+ (void)roundCornerUIImageView:(UIImageView *)img
{
    [img setBackgroundColor:[UIColor whiteColor]];
    img.contentMode = UIViewContentModeScaleAspectFit; 
    CALayer * l = [img layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
}
+(void) logMemoryUsage
{
    static natural_t initialUsed = 0xFFFFFFFF;
    static natural_t previousUsed = 0xFFFFFFFF;
    
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        NSLog(@"Failed to fetch vm statistics");
    }
    
    natural_t memUsed = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t memFree = vm_stat.free_count * pagesize;
    natural_t memTotal = memUsed + memFree;
    
    if (initialUsed == 0xFFFFFFFF)
    {
        initialUsed = memUsed;
    }
    if (previousUsed == 0xFFFFFFFF)
    {
        previousUsed = memUsed;
    }
    NSLog(@"Memory usage (KB): app %d, delta %d, used %u/%u",
          ((int)memUsed - (int)initialUsed) / 1024,
          ((int)memUsed - (int)previousUsed) / 1024,
          memUsed / 1024,
          memTotal / 1024);
    previousUsed = memUsed;
}

+ (void)settingURLString:(NSString **)usrAvatar_p sizeType:(ImageSizeType)sizeType
{
    switch (sizeType) {
        case kThumbnailSizeType:
            *usrAvatar_p=[*usrAvatar_p stringByAppendingString:@"_thumb"];
            break;
        case kNormalSizeType:
            if (!isRetinaYES){
                *usrAvatar_p=[*usrAvatar_p stringByAppendingString:@"_small"];
            }else{
                *usrAvatar_p=[*usrAvatar_p stringByAppendingString:@"_large"];
            }
            break;
        case kOriginalSizeType:
            break;
        default:
            break;
    }
}

+ (NSURL *)getImageOfCoverEntre:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType
{
    [self settingURLString:&usrAvatar sizeType:sizeType];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/getEntreCoverImage/%@",BASE_URL_STR,usrAvatar]];
    return url;
}

+ (NSURL *)getImageOfPhotoEntre:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType
{
    [self settingURLString:&usrAvatar sizeType:sizeType];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/getEntreUploadImage/%@",BASE_URL_STR,usrAvatar]];
    return url;
}
+ (NSURL *)getImageOfReview:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType
{
    [self settingURLString:&usrAvatar sizeType:sizeType];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/getReviewsImage/%@",BASE_URL_STR,usrAvatar]];
    return url;
}
+ (NSURL *)getImageOfUser:(NSString *)usrAvatar withSizeType:(ImageSizeType)sizeType
{
    [self settingURLString:&usrAvatar sizeType:sizeType];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/getUserImage/%@",BASE_URL_STR,usrAvatar]];
    return url;
}
+ (NSURL *)getImageOfEntre:(NSString *)logoImgPath withSizeType:(ImageSizeType)sizeType
{
    [self settingURLString:&logoImgPath sizeType:sizeType];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/getImageEntre/%@",BASE_URL_STR,logoImgPath]];
    return url;
}
+ (NSURL *)getImageOfOffer:(NSString *)imgURL withSizeType:(ImageSizeType)sizeType{
    [self settingURLString:&imgURL sizeType:sizeType];
    NSURL* urlImage=[NSURL URLWithString:[NSString stringWithFormat:@"%@/getImageOffer/%@",BASE_URL_STR,imgURL]];
    return urlImage;
}
+(void)iPhoneRetina{
    isRetinaYES= ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?1:0;
}

#pragma mark - Validate TextField
+(BOOL)validateInputString:(NSString*)string withMessage:(NSString*)strMess {
    if (!string) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:strMess
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
        [alertView show];
        
        return NO;
        
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmedString length] >10) {
        
        return YES;
        
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:strMess
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    [alertView show];
    return NO;
}
+(void)showAlertWithMessage:(NSString*)strMessage{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:strMessage
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    [alertView show];
}
+ (BOOL)validateString:(NSString*)string {
    if (!string) {
        [Ultilities showAlertWithMessage:NSLocalizedString(@"Text must not null",@"")];
        return NO;
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmedString length] >0 && [trimmedString length] < 100) {
        
        return YES;
        
    }
    [Ultilities showAlertWithMessage:NSLocalizedString(@"Text must not null",@"")];
    return NO;
}
+ (BOOL)validatePassword:(NSString*)pass withConfirmPass:(NSString*)confirmPass {
    if ([Ultilities validateString:pass]) {
        if ([Ultilities validateString:confirmPass]) {
            if ([pass isEqualToString:confirmPass]) {
                return YES;
            }else {
                [Ultilities showAlertWithMessage:NSLocalizedString(@"Password and Confirm Password don't have same value",@"")];
                return NO;
            }
        }
    }
    return NO;
}

+ (BOOL)validatePassword:(NSString*)pass{
    if ([pass length] ==0 ) {
        
            [Ultilities showAlertWithMessage:@"Vui lòng nhập Password"];
        return NO;
    }
    return YES;
}
+(BOOL)validateEmail:(NSString*)email{
    NSString *trimmedString = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!([trimmedString length] >0 && [trimmedString length] < 100)) {
        
//        [Ultilities showAlertWithMessage:@"Vui lòng nhập Email"];
        return NO;
        
    }
    
    //BOOL stricterFilter = YES;
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	//NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	//NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
	if (![emailTest evaluateWithObject:email]) {
        NSLog(@"Mail input invalid");
//        [Ultilities showAlertWithMessage:NSLocalizedString(@"Enter mail invalid!",@"")];
		return NO;
	}
    return YES;
}

+ (BOOL)validatePhone:(NSString *)aString
{
    NSString *trimmedString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!([trimmedString length] >0 && [trimmedString length] < 100)) {
        
//        [Ultilities showAlertWithMessage:NSLocalizedString(@"Please fill your phone number", nil)];
        return NO;
        
    }
    NSString * const regularExpression = @"^([+-]{0,1})([0-9]{1,14})$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSLog(@"-------->%d",[aString length]);
    if ([aString length] < 1 )  {
//        [Ultilities showAlertWithMessage:NSLocalizedString(@"Enter phone number invalid!",@"")];
        return NO;
    }
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aString
                                                        options:0
                                                          range:NSMakeRange(0, [aString length])];
    if (!(numberOfMatches>0)) {
//        [Ultilities showAlertWithMessage:NSLocalizedString(@"Enter phone number invalid!",@"")];
    }
    return numberOfMatches > 0;
}
+(BOOL)checkPhoneNumber:(NSString *)aString{
    
    NSString * const regularExpression = @"^([+-]{0,1})([0-9]{1,14})$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSLog(@"-------->%d",[aString length]);
    if ([aString length] < 1 )  {
        return NO;
    }
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aString
                                                        options:0
                                                          range:NSMakeRange(0, [aString length])];
    
    return numberOfMatches > 0;
    
}
@end

