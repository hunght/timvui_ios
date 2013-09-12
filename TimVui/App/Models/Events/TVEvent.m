#import "TVEvent.h"
#import "NSDictionary+Extensions.h"
#import "NSDate-Utilities.h"
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

- (void)getTheDayEventStart:(NSNumber *)num keyValueFre:(NSMutableDictionary *)keyValueFre date:(NSDate *)date dayCount:(int)dayCount {
    NSString* timeStr=[[keyValueFre safeDictForKey:num.stringValue] safeStringForKey:@"time_start"];
    NSLog(@"timeStr= %@",timeStr);
    NSLog(@"[date weekday]= %d",[date weekday]);
    _start=[date dateByAddingDays:dayCount];
    
    NSDateFormatter *timeOnlyFormatter = [[NSDateFormatter alloc] init];
    
    [timeOnlyFormatter setDateFormat:@"HH:mm:ss"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:_start];
    
    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[timeOnlyFormatter dateFromString:timeStr]];
    
    comps.day = todayComps.day;
    comps.month = todayComps.month;
    comps.year = todayComps.year;
    _start = [calendar dateFromComponents:comps];
    NSLog(@"_start = %@",_start);
}

- (void)setValues:(NSDictionary*)dict {
//    NSLog(@"tvEvent===%@",dict);
    
	self.eventID = [dict safeStringForKey:@"id"];
    self.title = [dict safeStringForKey:@"title"];
    self.alias = [dict safeStringForKey:@"alias"];
    self.desc = [dict safeStringForKey:@"desc"];
    self.content = [dict safeStringForKey:@"content"];
    
    self.addresses = [dict safeArrayForKey:@"addresses"];
    self.hot = [dict safeStringForKey:@"hot"];

    self.start = [dict safeDateForKey:@"start"];
    if ([[dict safeArrayForKey:@"frequencies"] count]<=0) {
        self.end= [dict safeDateForKey:@"end"];
    }else{
        NSDate* date=[NSDate date];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableDictionary* keyValueFre=[[NSMutableDictionary alloc] init];
        for (NSDictionary* dic in [dict safeArrayForKey:@"frequencies"]) {
            NSNumber* i=[NSNumber numberWithInteger:[dic safeIntegerForKey:@"frequency_id"]];
            [array addObject:i];
            [keyValueFre setObject:dic forKey:i.stringValue];
        }
        
        NSArray* sorted = [array sortedArrayUsingSelector: @selector(compare:)];
//        NSLog(@"tvEvent===%@",_title);
        for (NSNumber* num in sorted) {
            int dayCount=num.intValue-[date weekday];
            if (dayCount>=0) {
                [self getTheDayEventStart:num keyValueFre:keyValueFre date:date dayCount:dayCount];
                break;
            }else if([num isEqual:[sorted lastObject]]){
                dayCount=7-([date weekday]-[[sorted objectAtIndex:0] intValue]);
                [self getTheDayEventStart:num keyValueFre:keyValueFre date:date dayCount:dayCount];
                break;
            }
        }
    }
    NSLog(@"self.start= %@",self.start);
    self.image= [[dict safeDictForKey:@"image"] safeStringForKey:@"cover"];
    self.created= [dict safeDateForKey:@"created"];
    
    
}

@end
