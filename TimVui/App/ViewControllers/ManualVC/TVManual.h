//
//  TVManual.h
//  Anuong
//
//  Created by Hoang The Hung on 7/12/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVManual : NSObject
@property(nonatomic,strong)NSString *manualID;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSArray *branch_ids;

@property(nonatomic,strong)NSString *view;
@property(nonatomic,strong)NSDate *created;
@property(nonatomic,strong)NSString *images;
@property(nonatomic, strong)NSString *desc;
@property(nonatomic, strong)NSArray* handbook_cat;
@property(nonatomic, strong)NSArray* cities;
- (id)initWithDict:(NSDictionary *)dict;
@end
