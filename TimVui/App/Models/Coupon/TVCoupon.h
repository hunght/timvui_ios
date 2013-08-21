#import <Foundation/Foundation.h>


@class GHUser,TVBranch;

@interface TVCoupon : NSObject
@property(nonatomic,strong)NSString *couponID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *used;
@property(nonatomic,strong)NSString* view;
@property(nonatomic,strong)NSString *syntax;
@property(nonatomic,strong)NSDate *start;
@property(nonatomic,strong)NSDate *end;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)TVBranch *branch;
- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end