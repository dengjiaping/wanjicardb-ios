//
//  APIServiceLESports.m
//  LESports
//
//  Created by ZhangQibin on 15/6/22.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APIServiceWanJiKa.h"

@implementation APIServiceWanJiKa
#pragma mark - AIFServiceProtocal
- (BOOL)isOnline
{
    return YES;
}

- (NSString *)onlineApiBaseUrl
{
//#ifdef DEBUG
//    return @"http://182.92.11.169:8555";
////    return @"http://ca.wjika.com:80";
//#else
//    return @"http://ca.wjika.com:80";
//#endif
#if TestAPI
    return @"http://192.168.1.129:8080/wjapp_mobile_2";
#else
    return @"http://192.168.1.129:8080/wjapp_mobile_2";
#endif
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";
}

- (NSString *)offlineApiBaseUrl
{
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion
{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey
{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey
{
    return self.onlinePublicKey;
}

@end
