//
//  NSStringAdditions.m
//  MTFramework
//
//  Created by jianjingbao on 11-7-12.
//  Copyright 2011年 Sankuai. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (Common)

+ (NSString *)UUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)humanReadableString
{
    NSMutableString *string = [NSMutableString stringWithString:self];
    int index = 4;
    while ([string length] > index) {
        [string insertString:@" " atIndex:index];
        index += 5;
    }
    return [NSString stringWithString:string];
}

- (NSArray *)componentsSeparatedByComponentCount:(NSUInteger)count
{
    if (count == 0 || !self) {
        return nil;
    }
    NSMutableArray *separatedMutableArray = [NSMutableArray arrayWithCapacity:lround([self length] / count) + 1];
    NSUInteger i = 0;
    while (i + count < [self length]) {
        [separatedMutableArray addObject:[self substringWithRange:NSMakeRange(i, count)]];
        i += count;
    }
    [separatedMutableArray addObject:[self substringWithRange:NSMakeRange(i, [self length] - i)]];
    return separatedMutableArray;
}

- (NSString *)stringByInsertSeparator:(NSString *)separator every:(NSUInteger)charCount
{
    if (0 == charCount || !self || !separator) {
        return self;
    }
    NSMutableString *insertedMutableString = [NSMutableString string];
    NSUInteger i = 0;
    while (i + charCount < [self length]) {
        [insertedMutableString appendString:[self substringWithRange:NSMakeRange(i, charCount)]];
        [insertedMutableString appendString:separator];
        i += charCount;
    }
    [insertedMutableString appendString:[self substringWithRange:NSMakeRange(i, [self length] - i)]];
    return insertedMutableString;
}

@end

@implementation NSString (Parse)

+ (NSString *)urlParameterFormatStringWithDictionary:(NSDictionary *)params
{
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (key != [NSNull null] && obj != [NSNull null]) {
            [mutableQueryStringComponents addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    return [mutableQueryStringComponents componentsJoinedByString:@"&"];
}

- (NSDictionary *)dictionaryByParseInURLParameterFormat
{
    NSMutableDictionary *paragrmsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *pagramArray = [self componentsSeparatedByString:@"&"];
    [pagramArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSArray *keyAndValue = [obj componentsSeparatedByString:@"="];
        if ([keyAndValue count] == 2) {
            [paragrmsDict setObject:keyAndValue[1] forKey:keyAndValue[0]];
        }
    }];
    return paragrmsDict;
}

@end


@implementation NSString (Hash)
// Create pointer to the string as UTF8
// Create byte array of unsigned chars
// Create 16 byte MD5 hash value, store in buffer
// Convert MD5 value in the buffer to NSString of hex values
- (NSString *)stringByComputingMD5
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    return output;
}

@end


@implementation NSString (NumberFormat)

// 此函数作用在于确保number转为string ,只保留两位小数
+ (NSString *)stringFromNumber:(NSNumber *)number
{
    float floatValue = [number floatValue];
    NSString *result = [number stringValue];
    NSRange pointRange = [result rangeOfString:@"."];
    if (pointRange.length > 0 && pointRange.location < result.length - 2) {
        result = [NSString stringWithFormat:@"%.2f", floatValue];
    }
    return result;
}

+ (NSString *)stringWithFloat:(float)number
{
    NSNumber *floatNumber = [NSNumber numberWithFloat:number];
    return [NSString stringFromNumber:floatNumber];
}

+ (NSString *)RMBStringWithFloat:(float)number
{
    return [NSString stringWithFormat:@"%@元", [self stringWithFloat:number]];
}

+ (NSString *)countString:(int)count
{
    if (count>=10000) {
        float floadCount = count/1000;
        return [NSString stringWithFormat:@"%.1f万",floadCount];
    } else {
        return [@(count) stringValue];
    }
}
@end


@implementation NSString (PhoneNumber)

- (BOOL)isMobilePhoneNumber
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^1[\\d\\*]{10}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if (1 == numberOfMatches) {
        return YES;
    }
    return NO;
}

+ (NSArray *)phoneNumberArrayFromString:(NSString *)originalStr
{
    if (nil == originalStr) {
        return nil;
    }
    
    
    
    NSMutableString *mutablePhoneString = [originalStr mutableCopy];
    [mutablePhoneString replaceOccurrencesOfString:@"-" withString:@"-" options:0 range:NSMakeRange(0, [mutablePhoneString length])];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9/-]+" options:0 error:&error];
    if (nil == error) {
        [regex replaceMatchesInString:mutablePhoneString options:0 range:NSMakeRange(0, [mutablePhoneString length]) withTemplate:@"/"];
    }
    NSArray *phoneArray = [mutablePhoneString componentsSeparatedByString:@"/"];
    NSMutableArray *phoneResultArray = [NSMutableArray array];
    NSString *codeString = nil;
    for (NSString *tempPhone in phoneArray) {
        NSString *newPhone = tempPhone;
        
        if (![newPhone isMobilePhoneNumber]) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d{3,4}\\-"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            NSTextCheckingResult *checkingResult = [regex firstMatchInString:newPhone options:0 range:NSMakeRange(0, [newPhone length])];
            if (checkingResult) {
                codeString = [newPhone substringWithRange:checkingResult.range];
            } else {
                if ([codeString length]) {
                    newPhone = [NSString stringWithFormat:@"%@%@", codeString, newPhone];
                }
            }
        }
        
        if ([newPhone length] >= 3) {
            [phoneResultArray addObject:newPhone];
        }
    }
    return phoneResultArray;
}

@end


@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodedString
{
    CFStringRef result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *tmpResult = CFBridgingRelease(result);
    return tmpResult;
}

- (NSString *)URLDecodedString
{
    CFStringRef result = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    NSString *tmpResult = CFBridgingRelease(result);
    return tmpResult;
}

@end

@implementation NSString (VersionCompare)

- (NSComparisonResult)versionStringCompareWithOther:(NSString *)other
{
    NSArray *oneComponents = [self componentsSeparatedByString:@"."];
    NSArray *twoComponents = [other componentsSeparatedByString:@"."];
    __block NSComparisonResult comparionResult;
    [oneComponents enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if (idx < [twoComponents count]) {
            if ([obj intValue] > [twoComponents[idx] intValue]) {
                *stop = YES;
                comparionResult = NSOrderedDescending;
            } else if ([obj intValue] == [twoComponents[idx] intValue]) {
                if (idx == [oneComponents count] - 1) {  // will end the enumerate
                    if (idx == [twoComponents count] - 1) {
                        comparionResult = NSOrderedSame;
                    } else {
                        comparionResult = NSOrderedAscending;
                    }
                } else {
                    *stop = NO;
                }
            } else {
                *stop = YES;
                comparionResult = NSOrderedAscending;
            }
        } else {
            comparionResult = NSOrderedDescending;
            *stop = YES;
        }
    }];
    return comparionResult;
}

@end

@implementation NSString (HTMLCharacterEntity)

- (NSString *)decodeHTMLCharacterEntities
{
    if ([self rangeOfString:@"&"].location == NSNotFound) {
        return self;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:self];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", (unichar)(160 + i)]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [self rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", (unichar)38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [self rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", (unichar)60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [self rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", (unichar)62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [self rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", (unichar)39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [self rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", (unichar)34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unichar)tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unichar)[value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else {i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)encodeHTMLCharacterEntities
{
    NSMutableString *encoded = [NSMutableString stringWithString:self];
    
    // @"&amp;"
    NSRange range = [self rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"&"
                                 withString:@"&amp;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&lt;"
    range = [self rangeOfString:@"<"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<"
                                 withString:@"&lt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&gt;"
    range = [self rangeOfString:@">"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@">"
                                 withString:@"&gt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    return encoded;
}

@end

@implementation NSString (URLParameter)

- (NSString *)stringByAppendingURLParameters:(NSString *)URLParameterString
{
    if ([self rangeOfString:@"?"].location != NSNotFound) {
        return [self stringByAppendingFormat:@"&%@", URLParameterString];
    } else {
        return [self stringByAppendingFormat:@"?%@", URLParameterString];
    }
}
@end

@implementation NSString(Security)

- (DDWeakPasswordType)isValidPassword
{
    if (self.length < 6) {
        return DDWeakPasswordTypeTooShort;
    }
    return DDWeakPasswordTypeNone;
}

+ (NSString *)tipsWithWeakPassword:(DDWeakPasswordType)type
{
    switch (type) {
        case DDWeakPasswordTypeTooShort: {
            return @"密码太短了，至少6位";
            break;
        }
        default:
            
            break;
    }
    return nil;
}
@end