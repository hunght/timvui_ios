#import "TVComments.h"
#import "TVComment.h"


@implementation TVComments


- (void)setValues:(id)valuesJSON {
    if (!self.items) {
        self.items = [NSMutableArray array];
    }
    NSArray* values=[valuesJSON valueForKey:@"comments"];
//    NSLog(@"TVComments= %@",values);
    for (int i=0; i< [values count]; i++) {
        NSDictionary* dict=[values objectAtIndex:i];
        TVComment *branch = [[TVComment alloc] initWithDict:dict];
		[self addObject:branch];
        if (i==[values count]-1) {
            _last_id=branch.commentID;
        }
    }
}

@end