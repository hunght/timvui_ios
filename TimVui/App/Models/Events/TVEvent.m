#import "TVEvent.h"
#import "NSDictionary+Extensions.h"
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
    self.end= [dict safeDateForKey:@"end"];
    self.image= [dict safeStringForKey:@"image"];
    self.created= [dict safeDateForKey:@"created"];
}

@end
