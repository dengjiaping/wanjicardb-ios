//
//  CBUser.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBUser.h"

//nonatomic, strong) NSString *userID;
//@property (nonatomic, strong) NSString *isSetPayPassword;
//@property (nonatomic, strong) NSString *merID;
//@property (nonatomic, strong) NSString *token;

@implementation CBUser
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
