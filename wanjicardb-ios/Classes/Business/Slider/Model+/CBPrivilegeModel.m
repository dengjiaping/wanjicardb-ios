//
//  CBPrivilegeModel.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/24.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBPrivilegeModel.h"

@implementation CBPrivilegeModel
//@property (nonatomic, strong)NSString * createDate;
//@property (nonatomic, strong)NSString * descStr;
//@property (nonatomic, strong)NSString * detail;
//@property (nonatomic, strong)NSString * privilegeID;
//@property (nonatomic, strong)NSString * imageURL;
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"createDate":@"CreateDate",
             @"descStr":@"Desc",
             @"detail":@"Detail",
             @"privilegeID":@"Id",
             @"imageURL":@"ImgUrl"
             };
}

@end
