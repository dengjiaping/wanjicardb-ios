//
//  RESTClient.m
//  NewApp
//
//  Created by Lynn on 15/7/2.
//  Copyright (c) 2015年 NeoLynn. All rights reserved.
//

#import "RESTClient.h"
#import <AFNetworking/AFNetworking.h>
#import "CBPassport.h"
#import "Configure.h"
#import "CBSecutityUtil.h"

@implementation RESTClient
- (AFHTTPRequestOperation *)getFromURL:(NSString *)URLString params:(NSDictionary *)params finished:(CBEngineCallback)finished
{
    NSDictionary *requestParams = nil;
    if (_autoParams && [_autoParams count]>0) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:params];
        [dictionary addEntriesFromDictionary:_autoParams];
        requestParams = dictionary;
    } else {
        requestParams = params;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([CBPassport isLogined]) {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:@"%d",[CBPassport userID]] forHTTPHeaderField:@"X-uid"];
        [requestSerializer setValue:[CBPassport userToken] forHTTPHeaderField:@"X-token"];
        [requestSerializer setValue:[CBPassport userSecret] forHTTPHeaderField:@"X-secret"];
        manager.requestSerializer = requestSerializer;
    }
    
    return [manager GET:URLString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CBMetaData *meta = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:responseObject error:nil];
        if (!meta) {
            finished(nil,nil,nil);
            return ;
        }
        id data = responseObject[@"data"];
        if (!data) {
            data = responseObject;
        }
        finished(meta, data, nil);
//        NSLog(@"\ndata = %@\n operation = %@ \n",data,operation);
//        NSLog(@"\nmessage = %@\n",data[@"Msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finished(nil, nil, error);
    }];
}

- (AFHTTPRequestOperation *)postToURL:(NSString *)URLString withURLParams:(NSDictionary *)URLParams bodyParams:(NSDictionary *)bodyParams finished:(CBEngineCallback)finished
{
    if (_autoParams && [_autoParams count] > 0) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:URLParams];
        [params addEntriesFromDictionary:_autoParams];
        
        NSMutableArray *paramsArray = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *queryPair = [NSString stringWithFormat:@"%@=%@", key, obj];
            [paramsArray addObject:queryPair];
        }];
        NSString *autoURLString = [paramsArray componentsJoinedByString:@"&"];
        if([URLString rangeOfString:@"?"].length >0 ) {
            URLString = [NSString stringWithFormat:@"%@&%@", URLString, autoURLString];
        } else {
            URLString = [NSString stringWithFormat:@"%@?%@", URLString, autoURLString];
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];

    return [manager POST:URLString parameters:bodyParams success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        CBMetaData *meta = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:responseObject error:nil];
        id data = responseObject[@"Val"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@""];
        finished(meta, data, nil);
//        NSLog(@"\ndata = %@\n operation = %@ \n",data,operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finished(nil, nil, error);
    }];
}

- (AFHTTPRequestOperation *)postToURL:(NSString *)URLString
                        withURLParams:(NSDictionary *)URLParams
                           bodyParams:(NSDictionary *)bodyParams
                             finished:(CBEngineCallback)finished
                        withMD5String:(NSString *)MD5String{
    
    if (_autoParams && [_autoParams count]>0) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:URLParams];
        [params addEntriesFromDictionary:_autoParams];
        
        NSMutableArray *paramsArray = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *queryPair = [NSString stringWithFormat:@"%@=%@", key, obj];
            [paramsArray addObject:queryPair];
        }];
        NSString *autoURLString = [paramsArray componentsJoinedByString:@"&"];
        if([URLString rangeOfString:@"?"].length >0 ) {
            URLString = [NSString stringWithFormat:@"%@&%@", URLString, autoURLString];
        } else {
            URLString = [NSString stringWithFormat:@"%@?%@", URLString, autoURLString];
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[MD5String uppercaseString] forHTTPHeaderField:@"token"];
    if ([CBPassport isLogined]) {
        [requestSerializer setValue:[NSString stringWithFormat:@"%d",[CBPassport userID]] forHTTPHeaderField:@"X-uid"];
        [requestSerializer setValue:[CBPassport userToken] forHTTPHeaderField:@"X-token"];
        [requestSerializer setValue:[CBPassport userSecret] forHTTPHeaderField:@"X-secret"];
    }
    manager.requestSerializer = requestSerializer;
    return [manager POST:URLString parameters:bodyParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CBMetaData *meta = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:responseObject error:nil];
        id data = responseObject[@"data"];
        finished(meta, data, nil);
        NSLog(@"\ndata = %@\n operation = %@ \n",data,operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finished(nil, nil, error);
    }];
}

- (AFHTTPRequestOperation *)postToURL:(NSString *)URLString withURLParams:(NSDictionary *)URLParams bodyParams:(NSDictionary *)bodyParams constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block finished:(CBEngineCallback)finished
{
    if (_autoParams && [_autoParams count]>0) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:URLParams];
        [params addEntriesFromDictionary:_autoParams];
        
        NSMutableArray *paramsArray = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *queryPair = [NSString stringWithFormat:@"%@=%@", key, obj];
            [paramsArray addObject:queryPair];
        }];
        NSString *autoURLString = [paramsArray componentsJoinedByString:@"&"];
        if([URLString rangeOfString:@"?"].length >0 ) {
            URLString = [NSString stringWithFormat:@"%@&%@", URLString, autoURLString];
        } else {
            URLString = [NSString stringWithFormat:@"%@?%@", URLString, autoURLString];
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([CBPassport isLogined]) {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:@"%d",[CBPassport userID]] forHTTPHeaderField:@"X-uid"];
        [requestSerializer setValue:[CBPassport userToken] forHTTPHeaderField:@"X-token"];
        [requestSerializer setValue:[CBPassport userSecret] forHTTPHeaderField:@"X-secret"];
        manager.requestSerializer = requestSerializer;
    }
    
    return [manager POST:URLString parameters:bodyParams constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CBMetaData *meta = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:responseObject error:nil];
        id data = responseObject[@"data"];
        finished(meta, data, nil);
        NSLog(@"\ndata = %@\n operation = %@ \n",data,operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finished(nil, nil, error);
    }];
}

- (AFHTTPRequestOperation *)postImagesToURL:(NSString *)URLString withParams:(NSDictionary *)URLParams  imagesData:(NSArray *)imagesDataArray finished:(CBEngineCallback)finished
{
    return [self postImagesToURL:URLString withParams:URLParams imagesData:imagesDataArray imagesKey:nil finished:finished];
}

- (AFHTTPRequestOperation *)postImagesToURL:(NSString *)URLString withParams:(NSDictionary *)URLParams  image:(UIImage *)image finished:(CBEngineCallback)finished
{
    if (_autoParams && [_autoParams count]>0) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:URLParams];
        [params addEntriesFromDictionary:_autoParams];
        
        NSMutableArray *paramsArray = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *queryPair = [NSString stringWithFormat:@"%@=%@", key, obj];
            [paramsArray addObject:queryPair];
        }];
        NSString *autoURLString = [paramsArray componentsJoinedByString:@"&"];
        if([URLString rangeOfString:@"?"].length >0 ) {
            URLString = [NSString stringWithFormat:@"%@&%@", URLString, autoURLString];
        } else {
            URLString = [NSString stringWithFormat:@"%@?%@", URLString, autoURLString];
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([CBPassport isLogined]) {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:@"%d",[CBPassport userID]] forHTTPHeaderField:@"X-uid"];
        [requestSerializer setValue:[CBPassport userToken] forHTTPHeaderField:@"X-token"];
        [requestSerializer setValue:[CBPassport userSecret] forHTTPHeaderField:@"X-secret"];
        manager.requestSerializer = requestSerializer;
    }
    return [manager POST:URLString parameters:URLParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        [formData appendPartWithFormData:data name:@"image"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        CBMetaData *meta = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:responseObject error:nil];
        id data = responseObject[@"data"];
        finished(meta, data, nil);
        NSLog(@"\ndata = %@\n operation = %@ \n",data,operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        finished(nil, nil, error);
    }];

}

- (AFHTTPRequestOperation *)postImagesToURL:(NSString *)URLString withParams:(NSDictionary *)URLParams imagesData:(NSArray *)imagesDataArray imagesKey:(NSArray *)imageKeyArray finished:(CBEngineCallback)finished
{
    if (_autoParams && [_autoParams count]>0) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:URLParams];
        [params addEntriesFromDictionary:_autoParams];
        
        NSMutableArray *paramsArray = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *queryPair = [NSString stringWithFormat:@"%@=%@", key, obj];
            [paramsArray addObject:queryPair];
        }];
        NSString *autoURLString = [paramsArray componentsJoinedByString:@"&"];
        if([URLString rangeOfString:@"?"].length >0 ) {
            URLString = [NSString stringWithFormat:@"%@&%@", URLString, autoURLString];
        } else {
            URLString = [NSString stringWithFormat:@"%@?%@", URLString, autoURLString];
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([CBPassport isLogined]) {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:@"%d",[CBPassport userID]] forHTTPHeaderField:@"X-uid"];
        [requestSerializer setValue:[CBPassport userToken] forHTTPHeaderField:@"X-token"];
        [requestSerializer setValue:[CBPassport userSecret] forHTTPHeaderField:@"X-secret"];
        manager.requestSerializer = requestSerializer;
    }
    
    return [manager POST:URLString parameters:URLParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageKeyArray != nil) {
            NSAssert([imageKeyArray count] == [imagesDataArray count], @"image name 和 image 数目不相等");
        }
        
        for(NSData *imgData in imagesDataArray)
        {
            NSString *imageName = @"image";
            NSUInteger index = [imagesDataArray indexOfObject:imgData];
            if (imageKeyArray != nil && [imageKeyArray count] > index) {
                imageName = imageKeyArray[index];
            } else {
                imageName = [NSString stringWithFormat:@"%@[%lu]", imageName, (unsigned long)index];
            }
            [formData appendPartWithFileData:imgData name:imageName fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        CBMetaData *meta = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:responseObject error:nil];
        id data = responseObject[@"data"];
        finished(meta, data, nil);
        NSLog(@"\ndata = %@\n operation = %@ \n",data,operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        finished(nil, nil, error);
    }];
}

- (NSString *)signWithDic:(NSDictionary *)dic
{
    NSArray * keys = [dic allKeys];
    
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [[obj1 lowercaseString] compare:[obj2 lowercaseString]];
        // 如果有相同的姓，就比较名字
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * sign = (NSMutableString *)@"";
    
    for(int i = 0; i < [ tempArray count];i++)
    {
       sign = (NSMutableString *)[sign stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[tempArray objectAtIndex:i],[dic objectForKey:[tempArray objectAtIndex:i]]]];
    }
    
    sign = (NSMutableString *)[sign stringByAppendingString:kLoginAppKey];
    sign = (NSMutableString *)[CBSecutityUtil md5ForString:sign];
    
    return [(NSString *)sign lowercaseString];
}

- (NSDictionary *)haveSingDic:(NSDictionary *)dic
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString * sign  = [self signWithDic:dic];
    
    [dictionary setObject:sign forKey:@"sign"];
    
    return (NSDictionary *)dictionary;
}

@end
