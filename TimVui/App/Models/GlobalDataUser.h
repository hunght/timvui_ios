//
//  GlobalDataUser.h
//  TimVui
//
//  Created by Hoang The Hung on 4/17/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

@interface GlobalDataUser : NSObject

@property (assign, nonatomic) NSNumber *userID;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *facebookID;
@property (nonatomic, retain) NSURL *avatarImageURL;
@property (assign, nonatomic) BOOL isLogin;
+ (GlobalDataUser *)sharedAccountClient;
+(void)setGlocalDataUser:(NSDictionary *)attributes;
@end
