//
//  CBSecutityUtil.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBSecutityUtil.h"
//#import "CXGTMBase64.h"
#import "NSData+AES.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

#define Encryt_Key [[NSBundle mainBundle] bundleIdentifier] //@"key"
@implementation CBSecutityUtil

//#pragma mark - Base64
//+ (NSString*)encodeBase64String:(NSString * )input {
//    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    data = [CXGTMBase64 encodeData:data];
//    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return base64String;
//}
//
//+ (NSString*)decodeBase64String:(NSString * )input {
//    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    data = [CXGTMBase64 decodeData:data];
//    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return base64String;
//}
//
//+ (NSString*)encodeBase64Data:(NSData *)data {
//    data = [CXGTMBase64 encodeData:data];
//    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return base64String;
//}
//
//+ (NSString*)decodeBase64Data:(NSData *)data {
//    data = [CXGTMBase64 decodeData:data];
//    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return base64String;
//}

#pragma mark - AES加密
//将string转成带密码的data
+(NSData*)encryptAESData:(NSString*)string {
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES256EncryptWithKey:Encryt_Key];
    return encryptedData;
}

//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data {
    //使用密码对data进行解密
    NSData *decryData = [data AES256DecryptWithKey:Encryt_Key];
    //将解了密码的nsdata转化为nsstring
    NSString *string = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return string;
}

#pragma mark - MD5加密

+(NSString *) md5ForString:(NSString *)string {
    return [string md5Encrypt];
}

+(NSString *) md5ForFileContent:(NSString *)filePath {
    
    if (nil == filePath) {
        return nil;
    }
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    return [CBSecutityUtil md5ForData:data];
}

+(NSString *) md5ForData:(NSData *)data {
    
    if (!data || ![data length]) {
        return nil;
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([data bytes], [data length], result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}


@end
