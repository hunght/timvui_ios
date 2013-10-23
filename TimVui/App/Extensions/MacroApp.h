//HUNGHT

#import "MyViewController.h"

#define kAFAppDotNetAPIBaseURLString  @"http://anuong.net/api/"
#define SharedAppDelegate ((TVAppDelegate*)[[UIApplication sharedApplication] delegate])
#define  kTrackingId @"UA-43969947-1"

// Settings
#define kAccountUserJSON               @"accountUserJSON"
#define kVersionAppDate               @"kVersionAppDate"
#define kUserPhoneNumber               @"kUserPhoneNumber"
#define kCheckHasCouponBranchIsInBackGround @"2"

#define kCheckHasNearlyBranchIsInBackGround @".02" //20 m

#define kNotifBranches                    @"kNotifBranches"
#define kNotifCoupons                   @"kNotifCoupons"

// get params from server
#define kGetCityDataUser                    @"kGetCityDataUser"
#define kDataGetParamData                    @"kDataGetParamData"
#define kGetCityDistrictData                    @"kGetCityDistrictData"
#define kGetDistrictHasPublicLocationData   @"kGetDistrictHasPublicLocationData"
#define kGetPublicLocationData   @"kGetPublicLocationData"
#define kGetPriceAvgData   @"kGetPriceAvgData"
#define kGetCatData   @"kGetCatData"

#define kReceivedEnabledCoupon   @"kReceivedEnabledCoupon"
#define kReceivedCoupon   @"kReceivedCoupon"

#define kDistanceSearchMapDefault   @"5"//km
#define kTVDistanceMovingMap   5000 //m

#define kNumberOfSkinsCamera   3
#define kNumberLimitRefresh   @"10"
#define kLimitNumRecentlyBranches   30

#define SMS_NUMBER @"8%@88"//VDC

#define kBranchIDs               @"kBranchIDs"

#define kVatgiaClientID @"anuong-ios"
#define kVatgiaClientSecret @"2ETkVUuMAIPmOY8liDzj0x"

#define kSearchBranchLimit @"30"
#define kKYCustomPhotoAlbumName_ @"ĂnUống.net Album"

#define kCyanGreenColor [UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f]
#define kPaleCyanGreenColor [UIColor colorWithRed:(71/255.0f) green:(217/255.0f) blue:(255/255.0f) alpha:1.0f]
#define kOrangeColor [UIColor colorWithRed:(245/255.0f) green:(110/255.0f) blue:(44/255.0f) alpha:1.0f]
#define kDeepOrangeColor [UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]
#define kGrayTextColor [UIColor colorWithWhite:.3 alpha:1.0]

#define kHTMLString         [NSMutableString stringWithFormat: @"<html><head><meta name=\"viewport\" content=\"user-scalable=no, width=200, initial-scale=.7, maximum-scale=.7\"/> <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" /><title></title></head> <style type=\"text/css\">body {font-family: \"%@\"; font-size: %@;}</style><body style=\"background:transparent;\">",@"ArialMT", [NSNumber numberWithInt:12+1]]

