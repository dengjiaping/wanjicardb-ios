//
//  CBSecutityUtil.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBSecutityUtil : NSObject
//#pragma mark - Base64
//+ (NSString*)encodeBase64String:(NSString *)input;
//+ (NSString*)decodeBase64String:(NSString *)input;
//+ (NSString*)encodeBase64Data:(NSData *)data;
//+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES
//将string转换成加密后的data(自定义密码)
+ (NSData*)encryptAESData:(NSString*)string;
//将加密后的data转成string(自定义密码)
+ (NSString*)decryptAESData:(NSData*)data;

#pragma mark - MD5
+(NSString *) md5ForString:(NSString *)string;
+(NSString *) md5ForFileContent:(NSString *)filePath;
+(NSString *) md5ForData:(NSData *)data;
@end
