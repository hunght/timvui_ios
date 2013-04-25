//
//  MacroCityOffers.h
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define   CITYOFFERS_DEBUG          0



//#define BASE_URL_STR @"http://cityoffers.vn:3001"

//#define BASE_URL_STR @"http://192.168.52.61:3001"
//#define BASE_URL_STR @"http://192.168.2.2:3001"
//#define BASE_URL_STR @"http://localhost:3001"

/**********       APPOTA Ver          ************/
//#define FACEBOOK_APP_ID  @"428800500517443"
//#define SMS_NUMBER @"8598"//Appota
//#define SMS_STR @"NAP Q6"//Appota
//#define ENGLISH_VERSION 0
//#define BASE_URL_STR_WEB @"http://cityoffers.vn"
//#define BASE_URL_STR @"http://cityoffers.vn:3000"
/**********       APPOTA Ver          ************/

/**********       APPLE Ver          ************/
//#define FACEBOOK_APP_ID  @"428800500517443"
//#define SMS_NUMBER @"8588"//VDC
//#define SMS_STR @"CITYOFFERS"//VDC
//#define ENGLISH_VERSION 0
//#define BASE_URL_STR_WEB @"http://cityoffers.vn"
//#define BASE_URL_STR @"http://cityoffers.vn:3000"
/**********       APPLE Ver          ************/

/**********       ENGLISH Ver          ************/
#define FACEBOOK_APP_ID  @"412487342155272"
#define SMS_NUMBER @"nil"
#define SMS_STR @"nil"
#define ENGLISH_VERSION 1
#define BASE_URL_STR_WEB @"http://cityoffers.sg"
#define BASE_URL_STR @"http://cityoffers.vn:3001"
/**********       ENGLISH Ver          ************/


#define LOCATION_UPDATE_TIME  60*15
#define LENGHT_FOR_LOAD_OFFERS      @"5"  // default 5 offer per request   
#define DISTANCE_SEARCH_LOCATION    @"20" //default 20 km
#define DISTANCE_NOTIFICATION_LOCATION_USER    @"2" //default 1 km
#define LENGHT_FOR_LOAD_REVIEWS         10
#define REQUEST_LIMIT                   10
#define DISTANCE_MAP_VIEW           @"5"
#define MAP_REFRESH_DISTANCE            2500// 10 km
#define MAP_REFRESH_RADIUS           3000// 10 km