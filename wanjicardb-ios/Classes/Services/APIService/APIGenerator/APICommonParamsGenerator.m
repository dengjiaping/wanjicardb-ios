//
//  APICommonParamsGenerator.m
//  LESports
//
//  Created by ZhangQibin on 15/6/22.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APICommonParamsGenerator.h"
#import <UIKit/UIKit.h>

#define kAppID          @"10002"
#define kAppIDKey       @"app_id"
#define kAppJAVAID      @"1_1"


@implementation APICommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary
{
    UIDevice *currentDevice = [UIDevice currentDevice];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{kAppIDKey:kAppID}];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{}];

    NSString * token = [CBPassport userToken];
//    WJModelPerson * person = [WJDBPersonManager getDefaultPerson];
    if (![token isEqualToString:@""]) {
//        [parameters addEntriesFromDictionary:@{@"token":person.token}];
        parameters[@"token"] = token;
    }
    
    parameters[@"appType"] = kAppJAVAID;
    parameters[@"buildModel"] = currentDevice.model;
    parameters[@"deviceId"] = [[WJUtilityMethod keyChainValue] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    parameters[@"deviceVersion"] = currentDevice.systemVersion;
    
//    parameters[@"system_version"] = currentDevice.systemVersion;
//    parameters[@"device_id"] = [WJUtilityMethod keyChainValue];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"from":@"8",@"version":@"1.0"}];
    //Device info
//    parameters[@"device_model"] = currentDevice.model;
//    parameters[@"system_name"] = currentDevice.systemName;

//    parameters[@"localized_model"] = currentDevice.localizedModel;
//    
//    parameters[@"caller"] = @"1003";
//    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    parameters[@"app_name"] = infoDictionary[(__bridge_transfer NSString *) kCFBundleNameKey];
//    parameters[@"app_version"] = infoDictionary[@"CFBundleShortVersionString"];
//    parameters[@"app_build_version"] = infoDictionary[(__bridge_transfer NSString *) kCFBundleVersionKey];
//    parameters[kAppIDKey] = kAppID;
    return parameters;
}

@end
