//
//  RESTClient.h
//  NewApp
//
//  Created by Lynn on 15/7/2.
//  Copyright (c) 2015年 NeoLynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libextobjc/extobjc.h>
#import "CBMetaData.h"
#import <UIKit/UIKit.h>

typedef void (^CBEngineCallback)(CBMetaData *meta, id data, NSError *error);
typedef void (^CBEngineArrayCallback)(CBMetaData *meta, NSArray *modelArray, NSError *error);
typedef void (^CBEngineSimpleCallback)(CBMetaData *meta, NSError *error);

NSString *const kNetworkErrorString = @"网络异常，请稍后再试";
NSString *const kGetLocationErrorString = @"定位失败，请检查您的定位设置";

@class AFHTTPRequestOperation;
@protocol AFMultipartFormData;
@interface RESTClient : NSObject
@property (nonatomic, strong) NSDictionary *autoParams;

- (NSString *)signWithDic:(NSDictionary *)dic;
- (NSDictionary *)haveSingDic:(NSDictionary *)dic;


- (AFHTTPRequestOperation *)getFromURL:(NSString *)URLString
                                params:(NSDictionary *)params
                              finished:(CBEngineCallback)finished;

- (AFHTTPRequestOperation *)postToURL:(NSString *)URLString
                        withURLParams:(NSDictionary *)URLParams
                           bodyParams:(NSDictionary *)bodyParams
                             finished:(CBEngineCallback)finished;

- (AFHTTPRequestOperation *)postToURL:(NSString *)URLString
                        withURLParams:(NSDictionary *)URLParams
                           bodyParams:(NSDictionary *)bodyParams
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             finished:(CBEngineCallback)finished;


- (AFHTTPRequestOperation *)postImagesToURL:(NSString *)URLString
                                 withParams:(NSDictionary *)URLParams
                                      image:(UIImage *)image
                                   finished:(CBEngineCallback)finished;

- (AFHTTPRequestOperation *)postImagesToURL:(NSString *)URLString
                                 withParams:(NSDictionary *)URLParams
                                 imagesData:(NSArray *)imagesDataArray
                                   finished:(CBEngineCallback)finished;

- (AFHTTPRequestOperation *)postImagesToURL:(NSString *)URLString
                                 withParams:(NSDictionary *)URLParams
                                 imagesData:(NSArray *)imagesDataArray
                                  imagesKey:(NSArray *)imageKeyArray
                                   finished:(CBEngineCallback)finished;

- (AFHTTPRequestOperation *)postToURL:(NSString *)URLString
                        withURLParams:(NSDictionary *)URLParams
                           bodyParams:(NSDictionary *)bodyParams
                             finished:(CBEngineCallback)finished
                        withMD5String:(NSString *)MD5String;
@end
