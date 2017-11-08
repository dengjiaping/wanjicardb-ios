//
//  BranchModel.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/24.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBranchModel.h"

@implementation CBBranchModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{

    return @{
             @"address":@"Address",
             @"businessTime":@"BusinessTime",
             @"category":@"Category",
             @"cover":@"Cover",
             @"distance":@"Distance",
             @"distanceStr":@"DistanceStr",
             @"branchID":@"Id",
             @"latitude":@"Latitude",
             @"longitude":@"Longitude",
             @"name":@"Name",
             @"phone":@"Phone",
             @"totalSale":@"TotalSale"
             };
    
}

@end
