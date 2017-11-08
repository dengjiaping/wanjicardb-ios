//
//  CBProductModel.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/24.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBProductModel.h"

@implementation CBProductModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"cover":@"Cover",
             @"facevalue":@"Facevalue",
             @"proID":@"Id",
             @"name":@"Name",
             @"saledNum":@"SaledNum",
             @"salePrice":@"Saleprice",
             @"status":@"Status"
             };
}

@end
