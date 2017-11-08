//
//  CBMetaData.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBMetaData.h"

@implementation CBMetaData
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"code":@"Code",
             @"message":@"Msg",
             @"value":@"Val"
             };
}
@end
