#import <Foundation/Foundation.h>


@class GHUser;

@interface TVCoupon : NSObject
@property(nonatomic,strong)NSString *couponID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *used;
@property(nonatomic,assign)int view;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSDate *start;
@property(nonatomic,strong)NSDate *end;

- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end