//
//  TVBranchPhoto.h
//  Anuong
//
//  Created by Hoang The Hung on 8/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVBranchPhoto : NSObject
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSDate *created;
@property(nonatomic,strong)NSDictionary *arrURLImages;
- (id)initWithDict:(NSDictionary *)dict ;
@end
