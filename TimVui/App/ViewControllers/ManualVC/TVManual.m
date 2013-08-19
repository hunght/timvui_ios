//
//  TVManual.m
//  Anuong
//
//  Created by Hoang The Hung on 7/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVManual.h"
#import "NSDictionary+Extensions.h"
@implementation TVManual
- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}

- (void)setValues:(id)dic {
//    NSLog(@"%@",dic);
    self.title      =[dic safeStringForKey:@"tilte"];
    self.desc       =[dic safeStringForKey:@"desc"];
    self.content    =[dic safeStringForKey:@"content"];
    self.manualID   =[dic safeStringForKey:@"id"];
    self.branch_ids =[dic safeArrayForKey:@"branch_ids"];
    
    self.view       =[dic safeStringForKey:@"view"];
    self.changed    =[dic safeDateForKey:@"changed"];
    self.images     =[dic safeStringForKey:@"images"];
    NSLog(@"branch_ids===%@",_branch_ids);
    self.handbook_cat=[dic safeArrayForKey:@"handbook_cat"];
    self.cities=[dic safeArrayForKey:@"cities"];
    
}

@end
