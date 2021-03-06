//
//  NSStringAdditions.h
//  MTFramework
//
//  Created by jianjingbao  on 11-7-12.
//  Copyright 2011年 Sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>
//TODO DING Leon
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Common)

+ (NSString *)UUID;

- (NSString *)humanReadabFleString;

/**
 * @abstract 将当前字符串分割成数组，每个单元的字符串长度为count，最后一个单元字符串长度可能小于count
 * @param count:每个单元字符串的长度
 * @return 分割成的array，如果count == 0
 */

- (NSArray *)componentsSeparatedByComponentCount:(NSUInteger)count;

/**
 * 对当前的NSString对象分割为charCount块，每块字符串之间插入string。
 * @params string 将要被插入的字符串。
 * @params charCount 被分割的块数。
 * @return 当前字符串被分割并且插入string后的数据。
 */

- (NSString *)stringByInsertSeparator:(NSString *)separator
                                every:(NSUInteger)charCount;

@end



@interface NSString (Parse)

/**
 * 将url中的NSDictionary类型的网络请求参数转换为NSString类型的参数。
 * @params params 将要被转化的NSDictionary格式的网络请求参数。
 * @return A string。
 */

+ (NSString *)urlParameterFormatStringWithDictionary:(NSDictionary *)params;

/**
 * 把url中的参数转成NSDictionary.
 * @return A Dictionary.
 */

- (NSDictionary *)dictionaryByParseInURLParameterFormat;

@end


@interface NSString (Hash)

/**
 * 对当前的NSString对象进行MD5加密。
 * @return MD5加密后的NSString格式的字符串。
 */

- (NSString *)stringByComputingMD5;

@end

@interface NSString (NumberFormat)

/**
 * 将float格式的数据转换为有若干位小数的小数形式。
 * @params number 需要被转化为string的float格式的数据。
 * @return 转换为NSString格式的小数。
 */

+ (NSString *)stringWithFloat:(float)number;
+ (NSString *)stringFromNumber:(NSNumber *)number;
+ (NSString *)RMBStringWithFloat:(float)number;

+ (NSString *)countString:(int)count;
@end

@interface NSString (PhoneNumber)

/**
 * 判断当前的字符串是不是手机号码。
 * @return A BOOL.
 */

- (BOOL)isMobilePhoneNumber;

/**
 * 返回字符串中的所有电话号码，将这些电话号码以Array的形式返回。
 * @params orginalStr 需要筛选出电话号码的字符串。
 * @return A array of phoneNumder.
 */

+ (NSArray *)phoneNumberArrayFromString:(NSString *)originalStr;

@end

@interface NSString (OAURLEncodingAdditions)

/**
 * 转换NSString为UTF8编码。
 * @return 转换为UTF8编码的字符串。
 */

- (NSString *)URLEncodedString;

/**
 * 转换UTF8的解码。
 * @return UTF8解码后的字符串。
 */

- (NSString *)URLDecodedString;

@end


@interface NSString (VersionCompare)

/**
 * 比较两个版本号大小。
 * @params other 比较版本号大小的对象。
 * @return 比较版本号大小的结果。
 */

- (NSComparisonResult)versionStringCompareWithOther:(NSString *)other;

@end



//https://github.com/Koolistov/NSString-HTML
//http://www.weste.net/tools/ASCII.asp
//http://114.xixik.com/character/
@interface NSString (HTMLCharacterEntity)

- (NSString *)decodeHTMLCharacterEntities;

- (NSString *)encodeHTMLCharacterEntities;

@end

@interface NSString (URLParameter)

- (NSString *)stringByAppendingURLParameters:(NSString *)URLParameterString;

@end

typedef enum {
    DDWeakPasswordTypeNone = -1,
    DDWeakPasswordTypeTooShort,
} DDWeakPasswordType;

@interface NSString (Security)
- (DDWeakPasswordType)isValidPassword;
+ (NSString *)tipsWithWeakPassword:(DDWeakPasswordType)weakType;
@end
