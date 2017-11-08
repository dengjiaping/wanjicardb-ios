//
//  CBUserClient.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBUserClient.h"
#import "Configure.h"
#import "CBUser.h"
#import "CBSecutityUtil.h"

@interface CBUserClient()

@property (nonatomic, strong) RESTClient * client;

@end

@implementation CBUserClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [RESTClient shareRESTClient];
    }
    return self;
}

//设置新密码接口
- (void)findPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"phone":[NSString stringWithFormat:@"%@",phone],
                           @"code":[NSString stringWithFormat:@"%@",code],
                           @"password":[NSString stringWithFormat:@"%@",password]
                           };
    NSString * requestURL = CBURLWithPath(kFindPassword);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error){
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            if (data && !([[data class ] isSubclassOfClass:[NSNull class]])) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
        
    }];
}

//短信接口验证
- (void)verifyCodeWithPhone:(NSString *)phone code:(NSString *)code finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"phone":[NSString stringWithFormat:@"%@",phone],
                           @"code":[NSString stringWithFormat:@"%@",code]
                           };
    NSString * requestURL = CBURLWithPath(kVerifyCode);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error){
         if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            if (data && !([[data class ] isSubclassOfClass:[NSNull class]])) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
        
    }];

}

//短信验证码接口
- (void)sendSMSWithPhone:(NSString *)phone finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished;
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"phone":[NSString stringWithFormat:@"%@",phone]
                           };
    NSString * requestURL = CBURLWithPath(kSendSMS);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error){
        
        //    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data && !([[data class ] isSubclassOfClass:[NSNull class]])) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
        
    }];
    
}



- (void)loginWithPhone:(NSString *)phone password:(NSString *)password finished:(void (^)(BOOL success, CBUser *userModel, NSString *message))finished
{
//    if (!phone || ![phone isMobilePhoneNumber]) {
//        finished(NO, nil, @"手机号格式不正确");
//        return;
//    } else
   
    
    NSString *loginURL = CBURLWithPath(kURLLogin);
    
    NSMutableString * sign = [NSMutableString stringWithFormat:@"app_id=%@name=%@pwd=%@%@",kAppID,phone,password,kLoginAppKey];
//    1de20fec286ed912015b5a406756b7ae;
//    18701612729
    NSDictionary *params = @{@"name":phone,
                              @"pwd":password,
                           @"app_id":kAppID,
                             @"sign":[[CBSecutityUtil md5ForString:sign] lowercaseString]
                            };
    
    [_client postToURL:loginURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
       
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSError *decodeError = nil;
            
            CBUser *userModel = [MTLJSONAdapter modelOfClass:[CBUser class] fromJSONDictionary:data error:&decodeError];
            [CBPassport storageUserInfo:userModel];
            
            if (!decodeError) {
                finished(YES, userModel, nil);
            } else {
                finished(YES, nil, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil, meta.message);
            } else {
            }
            
        }
    }];
}
@end
