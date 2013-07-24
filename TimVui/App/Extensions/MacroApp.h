//
//  MacroCityOffers.h
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GAI.h"

#define SharedAppDelegate ((TVAppDelegate*)[[UIApplication sharedApplication] delegate])
#define  kTrackingId @"UA-37079754-1"

// Settings
#define kAccountUserJSON               @"accountUserJSON"


// get params from server
#define kDataGetParamData                    @"kDataGetParamData"
#define kGetCityDistrictData                    @"kGetCityDistrictData"
#define kGetDistrictHasPublicLocationData   @"kGetDistrictHasPublicLocationData"
#define kGetPublicLocationData   @"kGetPublicLocationData"
#define kGetPriceAvgData   @"kGetPriceAvgData"
#define kGetCatData   @"kGetCatData"

#define kDistanceSearchMapDefault   @"5"//km
#define kTVDistanceMovingMap   5000 //m

#define kNumberOfSkinsCamera   2

#define kNumberLimitRefresh   @"10"


#define SMS_NUMBER @"8588"//VDC
#define SMS_STR @"CITYOFFERS"//VDC

#define kBranchIDs               @"kBranchIDs"
#define kAFAppDotNetAPIBaseURLString  @"http://anuong.net/api/"
#define kVatgiaClientID @"anuong-ios"
#define kVatgiaClientSecret @"2ETkVUuMAIPmOY8liDzj0x"