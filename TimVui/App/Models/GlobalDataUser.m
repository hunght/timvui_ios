//
//  GlobalDataUser.m
//  TimVui
//
//  Created by Hoang The Hung on 4/17/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "GlobalDataUser.h"

@implementation GlobalDataUser

@synthesize userID = _userID;
@synthesize username = _username;
@synthesize facebookID = _facebookID;
@synthesize avatarImageURL=_avatarImageURL;
@synthesize isLogin=_isLogin;

static GlobalDataUser *_sharedClient = nil;

+ (GlobalDataUser *)sharedClient{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GlobalDataUser alloc] init];
    });
    
    return _sharedClient;
}
+(void)setGlocalDataUser:(NSDictionary *)attributes{
    _sharedClient.userID = [[attributes valueForKeyPath:@"id"] integerValue];
    _sharedClient.username = [attributes valueForKeyPath:@"username"];
    _sharedClient.avatarImageURL = [attributes valueForKeyPath:@"avatar_image.url"];
}
@end
