//
//  TVBranchPhoto.m
//  Anuong
//
//  Created by Hoang The Hung on 8/27/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVBranchPhoto.h"
#import "NSDictionary+Extensions.h"
@implementation TVBranchPhoto
- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}


- (void)setValues:(NSDictionary*)dict {
    NSLog(@"tvbranchphoto===%@",dict);
	self.user_id = [dict safeStringForKey:@"user_id"];
	self.user_name = [dict safeStringForKey:@"user_name"];
    
    self.created = [dict safeDateForKey:@"created"];
    
	self.arrURLImages = [dict safeDictForKey:@"image"];    
    }

@end
