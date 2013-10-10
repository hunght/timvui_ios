//
//  Uitilities.m
//  CityOffers
//
//  Created by hunght on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "MacroApp.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@implementation Utilities
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


+ (NSURL *)getThumbImageOfCoverBranch:(NSDictionary *)arrURLs
{
    if (!isRetinaYES)
        return [NSURL URLWithString:[arrURLs valueForKey:@"40"]];
    else
        return [NSURL URLWithString:[arrURLs valueForKey:@"80"]];
}
+ (NSURL *)getLargeImageOfCoverBranch:(NSDictionary *)arrURLs
{
    if (!isRetinaYES)
        return [NSURL URLWithString:[arrURLs valueForKey:@"300"]];
    else
        return [NSURL URLWithString:[arrURLs valueForKey:@"640"]];
}

+ (NSURL *)getLargeAlbumPhoto:(NSDictionary *)arrURLs
{
    if (!isRetinaYES)
        return [NSURL URLWithString:[arrURLs valueForKey:@"160"]];
    else
        return [NSURL URLWithString:[arrURLs valueForKey:@"300"]];
}

+ (NSURL *)getOriginalAlbumPhoto:(NSDictionary *)arrURLs
{
        return [NSURL URLWithString:[arrURLs valueForKey:@"900"]];
}


+(void)iPhoneRetina{
    isRetinaYES= ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?1:0;
}

#pragma mark - CALayer
+ (void)setBorderForLayer:(CALayer *)l radius:(float)radius {
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}
+(UIImage*)imageWithCyanGreenColor{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f] CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (UIImage *) imageFromColor:(UIColor *)color withSize:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
        return NO;
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmedString length] >0 && [trimmedString length] < 100) {
        
        return YES;
        
    }
    return NO;
}
+ (BOOL)validatePassword:(NSString*)pass withConfirmPass:(NSString*)confirmPass {
    if ([Utilities validateString:pass]) {
        if ([Utilities validateString:confirmPass]) {
            if ([pass isEqualToString:confirmPass]) {
                return YES;
            }else {
                [Utilities showAlertWithMessage:NSLocalizedString(@"Password and Confirm Password don't have same value",@"")];
                return NO;
            }
        }
    }
    return NO;
}

+ (BOOL)validatePassword:(NSString*)pass{
    if ([pass length] ==0 ) {
        
            [Utilities showAlertWithMessage:@"Vui lòng nhập Password"];
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

//Method writes a string to a text file
+(void) writeToTextFile:(NSString*)name withContent:(NSDictionary*)content{
    
}


//Method retrieves content from documents directory and
//displays it in an alert
+(NSDictionary*) displayContentOfFile:(NSString*)name{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.json",
                          documentsDirectory,name];
    NSLog(@"%@",fileName);
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    return [content objectFromJSONString];
}

@end

