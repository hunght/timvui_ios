//
//  MyDictionary.m
//  Anuong
//
//  Created by Hoang The Hung on 8/3/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "TVFilter.h"
#import "NSDictionary+Extensions.h"
@implementation TVFilter
-(id)initWithDic:(NSDictionary*)dic isChildren:(BOOL)isChildrenYES{
    self=[super init];
    if (self) {
        _isCheck=NO;
        if (isChildrenYES) {
            _name=[NSString stringWithFormat:@"      -%@",[dic safeStringForKey:@"name"]];
        }else{
            _name=[dic safeStringForKey:@"name"];
        }
        
        _TVFilteID=[dic safeStringForKey:@"id"];
    }
    return self;
}
@end
