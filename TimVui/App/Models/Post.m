// Post.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Post.h"
#import "User.h"

#import "AFAppDotNetAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
@implementation Post
@synthesize postID = _postID;
@synthesize text = _text;
@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _postID = [[attributes valueForKeyPath:@"id"] integerValue];
    _text = [attributes valueForKeyPath:@"text"];
    _user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    return self;
}

    #pragma mark -

+ (void)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"hunght",@"name" ,
                             @"0982366155", @"phone",
                            @"123456",@"password" ,
                            nil];
    
    [[AFAppDotNetAPIClient sharedClient] postPath:@"user/createPhone" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@----------",[[operation response] allHeaderFields]);
        NSLog(@"%@",JSON);
//        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
//        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        for (NSDictionary *attributes in postsFromResponse) {
//            Post *post = [[Post alloc] initWithAttributes:attributes];
//            [mutablePosts addObject:post];
//        }
//        if (block) {
//            block([NSArray arrayWithArray:mutablePosts], nil);
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            NSLog(@"%@----------",[[operation response] allHeaderFields]);
            block([NSArray array], error);
            
            NSLog(@"%@",error);
        }
    }];
    
}

@end
