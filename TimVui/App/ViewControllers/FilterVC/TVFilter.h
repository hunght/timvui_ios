//
//  MyDictionary.h
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVFilter : NSObject
@property(nonatomic, assign) BOOL isCheck;
@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSString* TVFilteID;
-(id)initWithDic:(NSDictionary*)dic;
@end
