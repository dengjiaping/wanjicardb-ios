//
//  CBUserClient.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
@class CBUser;


@interface CBUserClient : RESTClient

@property (nonatomic, strong) CBUser * userModel;

//设置新密码接口
- (void)findPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished;

//短信接口验证
- (void)verifyCodeWithPhone:(NSString *)phone code:(NSString *)code finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished;

//短信验证码接口
- (void)sendSMSWithPhone:(NSString *)phone finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished;

//登录
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password finished:(void(^)(BOOL success, CBUser *userModel, NSString *message))finished;

@end
