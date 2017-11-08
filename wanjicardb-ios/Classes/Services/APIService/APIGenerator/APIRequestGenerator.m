//
//  APIRequestGenerator.m
//  LESports
//
//  Created by ZhangQibin on 15/6/23.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APIRequestGenerator.h"
#import "AFNetworking.h"
#import "APINetworkingConfiguration.h"
#import "APIBaseService.h"
#import "APIServiceFactory.h"
#import "APICommonParamsGenerator.h"
#import "SecurityService.h"
#import "WJSignCreateManager.h"

#import "NSString+CoculationSize.h"

#define kAppkey         @"7r0Ed2ErDIxh9OOmzxlN"

@interface APIRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation APIRequestGenerator

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kAPINetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static APIRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    APIBaseService *service = [[APIServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[APICommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    
//    [self addSignWithGetDic:allParams];
//    allParams = (NSMutableDictionary *)[WJSignCreateManager GetSignWithDic:allParams];
    NSMutableDictionary * paramsDic = (NSMutableDictionary *)[WJSignCreateManager postSignWithDic:allParams methodName:methodName];
//    [paramsDic setObject:kSystemVersion forKey:@"sysVersion"];

//    NSString *urlString = [service.apiBaseUrl stringByAppendingString:paramsString];
//    NSLog(@"urlString = %@",urlString);
//    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:allParams error:NULL];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:service.apiBaseUrl parameters:paramsDic error:NULL];
    
    request.timeoutInterval = kAPINetworkingTimeoutSeconds;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    APIBaseService *service = [[APIServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[APICommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionaryWithDictionary:[WJSignCreateManager postSignWithDic:allParams methodName:methodName]];
//    [paramsDic setObject:kSystemVersion forKey:@"sysVersion"];

//    allParams = (NSMutableDictionary *)@{@"key":paramsString};
//    [self addSignWithPostDic:allParams];
//    NSString *urlString = [service.apiBaseUrl stringByAppendingString:methodName];
//    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:allParams error:NULL];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:service.apiBaseUrl parameters:paramsDic error:NULL];
    request.timeoutInterval = kAPINetworkingTimeoutSeconds;
    return request;
}



- (void )addSignWithGetDic:(NSMutableDictionary *)dict
{
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [[obj1 lowercaseString] compare:[obj2 lowercaseString]];
        // 如果有相同的姓，就比较名字
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * sign = (NSMutableString *)@"";
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        sign = (NSMutableString *)[sign stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[tempArray objectAtIndex:i],str]];
    }
    
    sign = (NSMutableString *)[[sign stringByAppendingString:kAppkey] lowercaseString];
    sign = (NSMutableString *)[SecurityService md5ForString:sign];
    
    [dict addEntriesFromDictionary:@{@"sign":[sign lowercaseString]}];
}


- (void )addSignWithPostDic:(NSMutableDictionary *)dict
{
    //    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [[obj1 lowercaseString] compare:[obj2 lowercaseString]];
        // 如果有相同的姓，就比较名字
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * sign = (NSMutableString *)@"";
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
        //        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        sign = (NSMutableString *)[sign stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[tempArray objectAtIndex:i],str]];
    }
    
    sign = (NSMutableString *)[[sign stringByAppendingString:kAppkey] lowercaseString];
    sign = (NSMutableString *)[SecurityService md5ForString:sign];
    
    [dict addEntriesFromDictionary:@{@"sign":[sign lowercaseString]}];
}


@end
