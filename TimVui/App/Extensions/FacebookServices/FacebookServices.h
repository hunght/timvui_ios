//
//  FacebookServices.h
//  Anuong
//
//  Created by Hoang The Hung on 8/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
@class TVBranch;

@interface FacebookServices : NSObject

+(void)loginAndTakePermissionWithHanlder:(FBSessionRequestPermissionResultHandler)handler;
+(void)checkFacebookSessionIsOpen:(void (^)(bool))callback;
+(void)postFollowActionWithBranch:(TVBranch*)_branch;
+ (void)postWriteReviewActionWithBranch:(TVBranch*)branch;
+(void)postImageActionWithBranch:(TVBranch*)_branch;
@end
