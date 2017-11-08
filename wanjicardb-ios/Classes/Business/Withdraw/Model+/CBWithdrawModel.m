//
//  CBWithdrawModel.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/5.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBWithdrawModel.h"

@implementation CBWithdrawModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{@"userID":@"Id",
             @"isSetPayPassword":@"IsSetPayPassword",
             @"name":@"Name",
             @"merID":@"Merid",
             @"token":@"Token"
             };
}
@end
