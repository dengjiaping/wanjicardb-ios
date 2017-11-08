//
//  WJSignCreateManager.m
//  WanJiCard
//
//  Created by Lynn on 15/12/15.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSignCreateManager.h"
#import "NSString+CoculationSize.h"
#import "SecurityService.h"


@implementation WJSignCreateManager

+ (NSDictionary *)postSignWithDic:(NSMutableDictionary *)dict methodName:(NSString *)methodName
{
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        // 如果有相同的姓，就比较名字
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * sign = (NSMutableString *)@"";
    NSMutableString * valueString = [NSMutableString string];
    NSMutableArray * valueArray = [NSMutableArray array];
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [valueArray addObject:str];
        sign = (NSMutableString *)[sign stringByAppendingString:[NSString stringWithFormat:@"%@%@",[tempArray objectAtIndex:i],str]];
    }

    valueString = (NSMutableString *)[valueArray componentsJoinedByString:@"-"];
    
    valueString = (NSMutableString *)[valueString stringByAppendingString:[NSString stringWithFormat:@"-%@",kSystemVersion]];
    
    NSLog(@"sign = %@\n \n\n\nparam = %@\n\n\n\n",sign,valueString);
    
    NSString * param = [SecurityService stringWithBase64Str:valueString];
    param = [param stringByReversed];
    
//    de5e0afd9801702f8e494559db0f789b0c8777f1
//    606eaf7650a1e5507d887d0a784186bd1a0b0471
    
    NSString * randomString =  [self randomString];
    NSMutableString * randomCharacter = [NSMutableString stringWithFormat:@"%@",[self randomCharacter]];
    
    sign = (NSMutableString *)[SecurityService getSha1String:[sign lowercaseString]];
    
    sign = (NSMutableString *)[SecurityService stringWithBase64Str:sign] ;
    
    NSMutableString * methodNameStr = (NSMutableString *)[SecurityService stringWithBase64Str:methodName];
    
    //    NSMutableString * str = (NSMutableString *)@"123467890";
    //    [str insertString:@"5" atIndex:4];
    //    NSLog(@"%@",str);
    
    NSString * methodStr = [NSString stringWithFormat:@"%@%@%@",[methodNameStr substringToIndex:1],randomCharacter,[methodNameStr substringFromIndex:1]];
    
    //    if (methodNameStr.length > 5) {
    //        [methodNameStr insertString:randomCharacter atIndex:5];
    //    }else {
    //        return @"";
    //    }
    NSString * sid = [NSString stringWithFormat:@"%@=%@%@=%@",param,randomString,methodStr,sign];
    NSLog(@"param = %@\n\n\n\n valueStr = %@\n\n\n\n   randomstr = %@\n\n\nmothodStr = %@\n\n\n\nsign = %@\n\n\n\n all = %@",param,valueString,randomString,methodStr,sign,[NSString stringWithFormat:@"%@=%@%@=%@",param,randomString,methodStr,sign]);
    NSLog(@"sid = %@",sid);
    
//    return [NSString stringWithFormat:@"%@=%@%@=%@",param,randomString,methodStr,sign];
    return @{@"sid":sid};
}

+ (NSDictionary *)getSignWithDic:(NSMutableDictionary *)dict methodName:(NSString *)methodName
{
    
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        // 如果有相同的姓，就比较名字
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * sign = (NSMutableString *)@"";
    NSMutableString * valueString = [NSMutableString string];
    NSMutableArray * valueArray = [NSMutableArray array];
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [valueArray addObject:str];
        sign = (NSMutableString *)[sign stringByAppendingString:[NSString stringWithFormat:@"%@%@",[tempArray objectAtIndex:i],str]];
    }
    
    valueString = (NSMutableString *)[valueArray componentsJoinedByString:@"-"];
    
    NSLog(@"sign = %@\n \n\n\nparam = %@\n\n\n\n",sign,valueString);
    
    NSString * param = [SecurityService stringWithBase64Str:valueString];
    param = [param stringByReversed];
    
    NSString * randomString =  [self randomString];
    NSMutableString * randomCharacter = [NSMutableString stringWithFormat:@"%@",[self randomCharacter]];
    
    sign = (NSMutableString *)[SecurityService getSha1String:sign];
    sign = (NSMutableString *)[SecurityService stringWithBase64Str:sign];
    
    NSMutableString * methodNameStr = (NSMutableString *)[SecurityService stringWithBase64Str:methodName];
//    NSMutableString * str = (NSMutableString *)@"123467890";
//    [str insertString:@"5" atIndex:4];
//    NSLog(@"%@",str);
    
    NSString * methodStr = [NSString stringWithFormat:@"%@%@%@",[methodNameStr substringToIndex:1],randomCharacter,[methodNameStr substringFromIndex:1]];
//    if (methodNameStr.length > 5) {
//        [methodNameStr insertString:randomCharacter atIndex:5];
//    }else {
//        return @"";
//    }
    NSLog(@"param = %@\nrandomstr = %@\nmothodStr = %@\nsign = %@\nall = %@",param,randomString,methodStr,sign,[NSString stringWithFormat:@"%@=%@%@=%@",param,randomString,methodStr,sign]);
    NSString * sid = [NSString stringWithFormat:@"%@=%@%@=%@",param,randomString,methodStr,sign];
    return @{@"sid":sid};
//    sign = (NSMutableString *)[[sign stringByAppendingString:kAppkey] lowercaseString];
//    sign = (NSMutableString *)[SecurityService md5ForString:sign];
//    sign = [SecurityService getSha1String:sign];
//    [dict addEntriesFromDictionary:@{@"sign":}];
}

+ (NSMutableString *)randomString
{
    return (NSMutableString *)[SecurityService stringWithBase64Str:@"020"];
}

+ (NSMutableString *)randomCharacter
{
    return (NSMutableString *)@"w";
}


@end
