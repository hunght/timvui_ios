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

+ (void)postWriteReviewActionWithBranch:(TVBranch*)_branch {
    if (FBSession.activeSession.isOpen ==NO)return;
    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject graphObject];
    object[@"url"] = _branch.url;
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
    if (FBSession.activeSession.isOpen ==NO ||!_branch)return;
    
    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject graphObject];
    object[@"url"] =_branch.url;
    
    NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
    action[@"nha_hang"] = object;
    NSLog(@"%@",action);
    [FBRequestConnection startForPostWithGraphPath:@"me/anuongnet:quan_tam" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success %@", result);
        }
    }];
}

+(void)postImageActionWithBranch:(TVBranch*)_branch  withArrayUrl:(NSArray*)arrUrl{
    if (FBSession.activeSession.isOpen ==NO)return;
    
    NSMutableDictionary<FBGraphObject> *object = [FBGraphObject graphObject];
    object[@"url"] = _branch.url;
    NSMutableDictionary<FBOpenGraphAction> *action = [FBGraphObject openGraphActionForPost];
    action[@"nha_hang"] = object;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString* urlStr in arrUrl) {
        NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
        [image setObject:urlStr forKey:@"url"];
        [image setObject:@"true" forKey:@"user_generated"]; // <======= ***add this line***
        [images addObject:image];
        action.image = images;
    }

    
    NSLog(@"%@",action);
    [FBRequestConnection startForPostWithGraphPath:@"me/anuongnet:dang_anh" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
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
                                                 NSLog(@"success");
                                             }else{
                                                 NSLog(@"error=%@",error);
                                             }
                                         }];
    }
}

+(void)checkFacebookSessionIsOpen:(void (^)(bool))callback{
    if (FBSession.activeSession.isOpen == YES)
    {
        // post to wall else login
        [FacebookServices postFollowActionWithBranch:nil];
        callback(YES);
        
    }else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,FBSessionState status,NSError *error)
         {
             // load user details
             if (!error && status == FBSessionStateOpen) {
//                 [FacebookServices postFollowActionWithBranch:nil];
//                 [FacebookServices postWriteReviewActionWithBranch:nil];
                 
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
