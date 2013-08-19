#import "TVEvent.h"
#import "NSDictionary+Extensions.h"
#import "NSDate-Utilities.h"
@interface TVEvent ()
@end


@implementation TVEvent

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}

- (void)setValues:(NSDictionary*)dict {
    NSLog(@"tvEvent===%@",dict);
    
	self.eventID = [dict safeStringForKey:@"id"];
    self.title = [dict safeStringForKey:@"title"];
    self.alias = [dict safeStringForKey:@"alias"];
    self.desc = [dict safeStringForKey:@"desc"];
    self.content = [dict safeStringForKey:@"content"];
    
    self.addresses = [dict safeArrayForKey:@"addresses"];
    self.hot = [dict safeStringForKey:@"hot"];

    self.start = [dict safeDateForKey:@"start"];
    if (self.start) {
        self.end= [dict safeDateForKey:@"end"];
    }else{
        NSDate* date=[NSDate date];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableDictionary* keyValueFre=[[NSMutableDictionary alloc] init];
        for (NSDictionary* dic in [dict safeDictForKey:@"frequencies"]) {
            NSNumber i=[NSNumber numberWithInteger:[dic safeIntegerForKey:@"frequency_id"]];
            [array addObject:i];
            [keyValueFre setObject:dic forKey:i];
        }
        
        NSArray* sorted = [array sortedArrayUsingSelector: @selector(compare:)];
        for (NSNumber* num in sorted) {
            if (num.intValue>=[date day]) {
                
                
                continue;
            }
        }
    }
    
    self.image= [[dict safeDictForKey:@"image"] safeStringForKey:@"cover"];
    self.created= [dict safeDateForKey:@"created"];
    
    
}

@end
