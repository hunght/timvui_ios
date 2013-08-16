#import "TVKaraoke.h"
#import "NSDictionary+Extensions.h"
@interface TVKaraoke ()
@end


@implementation TVKaraoke

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValues:dict];
	}
	return self;
}

- (void)setValues:(NSDictionary*)dict {
//    NSLog(@"tv Karaoke===%@",dict);
	self.karaokeID = [dict safeStringForKey:@"id"];
    self.type = [dict safeStringForKey:@"type"];
    self.content = [dict safeStringForKey:@"content"];
    self.price = [dict safeArrayForKey:@"price"];
    self.count = [dict safeStringForKey:@"count"];
    self.images= [dict safeArrayForKey:@"images"];
    
}

@end
