#import <Foundation/Foundation.h>


@class GHUser, TVComment;

@interface TVCoupon : NSObject
@property(nonatomic,strong)NSString *branchID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *price_avg;
@property(nonatomic,strong)NSDictionary *arrURLImages;
@property(nonatomic,strong)NSString *coupon_count;
@property(nonatomic,strong)NSMutableArray *pages;
@property(nonatomic,strong)GHUser *user;
@property(nonatomic,strong)GHUser *otherUser;
@property(nonatomic,strong)TVComment *organization;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,readonly)NSString *extendedEventType;
@property(nonatomic,readonly)BOOL isCommentEvent;
@property(nonatomic,readonly)BOOL read;

- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end