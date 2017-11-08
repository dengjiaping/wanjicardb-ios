//
//  CBScan.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/3.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBScan.h"

@implementation CBScan

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{@"userId":@"Id",
             @"userName":@"Name",
             @"userPhone":@"Phone",
             @"pictureAddress":@"Face",
             @"amount":@"Amount"
             };
}

@end
