//
//  RESTClient+CBFactory.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
extern NSString* CBURLWithPath(NSString *path);
extern NSString* CBURLByAppendQuery(NSString *url, NSString *key, NSString *value);
extern NSDictionary* CBParamWithPageAndLimit(int page, int limit);

@interface RESTClient (CBFactory)

+ (instancetype)shareRESTClient;

@end
