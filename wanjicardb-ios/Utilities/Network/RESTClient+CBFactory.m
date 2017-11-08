//
//  RESTClient+CBFactory.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient+CBFactory.h"

// const variable
#ifdef DEBUG
//NSString *const kCBBaseURL = @"http://182.92.11.169:8555";
NSString *const kCBBaseURL = @"http://ca.wjika.com:80";
#else
NSString *const kCBBaseURL = @"http://ca.wjika.com:80";
//NSString *const kCBBaseURL = @"http://182.92.11.169:8555";

#endif

//helper function
NSString* CBURLWithPath(NSString *Path)
{
    return [NSString stringWithFormat:@"%@%@", kCBBaseURL, Path];
}

NSString *CBURLByAppendQuery(NSString *url, NSString *key, NSString *value)
{
    if([url rangeOfString:@"&"].location != NSNotFound ) {
        return [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
    } else {
        return [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
    }
}

NSDictionary* CBParamWithPageAndLimit(int page, int limit)
{
    return @{@"page":@(page),@"limit":@(limit)};
}

@implementation RESTClient (CBFactory)

+ (instancetype)shareRESTClient
{
    RESTClient *baseEngine = [[self alloc] init];
    return baseEngine;
}

@end
