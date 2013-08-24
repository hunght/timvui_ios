//
//  FacebookServices.m
//  Anuong
//
//  Created by Hoang The Hung on 8/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "FacebookServices.h"
#import "TVBranch.h"
@implementation FacebookServices

+ (void)postWriteReviewActionWithBranch:(TVBranch*)branch {
    if (FBSession.activeSession.isOpen ==NO)return;
    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject graphObject];
    object[@"url"] = @"http://cung-sach.herokuapp.com";
    NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
    action[@"nha_hang"] = object;
    NSLog(@"%@",action);
    [FBRequestConnection startForPostWithGraphPath:@"me/anuongnet:viet_danh_gia" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success %@", result);
            
        }
    }];
    
}
+(void)postFollowActionWithBranch:(TVBranch*)_branch {
    if (FBSession.activeSession.isOpen ==NO)return;
    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject graphObject];
    object[@"url"] = @"http://cung-sach.herokuapp.com";
    NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
    action[@"nha_hang"] = object;
    NSLog(@"%@",action);
    [FBRequestConnection startForPostWithGraphPath:@"anuongnet:quan_tam" graphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success %@", result);
            
        }
    }];
}

+(void)postImageActionWithBranch:(TVBranch*)_branch {
    if (FBSession.activeSession.isOpen ==NO)return;
    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject graphObject];
    object[@"url"] = @"http://cung-sach.herokuapp.com";
    NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
    action[@"nha_hang"] = object;
    NSLog(@"%@",action);
    
    [FBRequestConnection startForPostWithGraphPath:@"anuongnet:quan_tam" graphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success %@", result);
            
        }
    }];
}

+(void)loginAndTakePermissionWithHanlder:(FBSessionRequestPermissionResultHandler)handler{
    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
            
            [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_action"] defaultAudience:FBSessionDefaultAudienceFriends
                                                  completionHandler:^(FBSession *session,NSError *error){
                                                      handler(session,error);
                                                  }];
            
        }else{
            
        }
    }else{
        /*
         * open a new session with publish permission
         */
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceOnlyMe
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             handler(session,error);
                                             
                                             if (!error && status == FBSessionStateOpen) {
                                                 
                                             }else{
                                                 NSLog(@"error");
                                             }
                                         }];
    }
}

+(void)checkFacebookSessionIsOpen:(void (^)(bool))callback{
    if (FBSession.activeSession.isOpen == YES)
    {
        // post to wall else login
        callback(YES);
        
    }else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,FBSessionState status,NSError *error)
         {
             // load user details
             if (!error && status == FBSessionStateOpen) {
                 callback(YES);
             }else{
                 NSLog(@"error");
                 callback(NO);
             }
         }];
    }
    else
    {
        // show login screen
        callback(NO);
    }
}

@end
