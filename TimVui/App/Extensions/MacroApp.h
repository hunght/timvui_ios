//
//  MacroCityOffers.h
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GAI.h"

#define kAFAppDotNetAPIBaseURLString  @"http://dev.anuong.net/api/"
#define SharedAppDelegate ((TVAppDelegate*)[[UIApplication sharedApplication] delegate])
#define  kTrackingId @"UA-43969947-1"
#define LOCATION_UPDATE_TIME  60*15//60*15

// Settings
#define kAccountUserJSON               @"accountUserJSON"
#define kUserPhoneNumber               @"kUserPhoneNumber"
#define kCheckHasCouponBranchIsInBackGround @"50"
#define kCheckHasNearlyBranchIsInBackGround @"5"

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
#define kReceivedCoupon   @"kReceivedCoupon"

#define kDistanceSearchMapDefault   @"20"//km
#define kTVDistanceMovingMap   5000 //m

#define kNumberOfSkinsCamera   3
#define kNumberLimitRefresh   @"10"
#define kLimitNumRecentlyBranches   30

#define SMS_NUMBER @"8188"//VDC

#define kBranchIDs               @"kBranchIDs"

#define kVatgiaClientID @"anuong-ios"
#define kVatgiaClientSecret @"2ETkVUuMAIPmOY8liDzj0x"

#define kSearchBranchLimit @"20"
#define kKYCustomPhotoAlbumName_ @"Anuong.net Album"

#define kCyanGreenColor [UIColor colorWithRed:(3/255.0f) green:(190/255.0f) blue:(239/255.0f) alpha:1.0f]
#define kPaleCyanGreenColor [UIColor colorWithRed:(71/255.0f) green:(217/255.0f) blue:(255/255.0f) alpha:1.0f]
#define kOrangeColor [UIColor colorWithRed:(245/255.0f) green:(110/255.0f) blue:(44/255.0f) alpha:1.0f]
#define kDeepOrangeColor [UIColor colorWithRed:(245/255.0f) green:(77/255.0f) blue:(44/255.0f) alpha:1.0f]