//
//  CBConfirmOrder.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBConfirmOrder.h"

@implementation CBConfirmOrder

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
   
    return @{@"confirmOrderId":@"Id",
             @"confirmOrderNum":@"Paymentno",
             @"confirmMerId":@"MerId",
             @"confirmUserId":@"ConsumerId",
             @"confirmUserName":@"Consumername",
             @"confirmAmount":@"Amount",
             @"confirmDate":@"Date",
             @"confirmMerName":@"Mername"
             };
}


//{
//    Amount = "0.01";
//    ConsumerId = 40;
//    Consumername = 15010301103;
//    Date = "2015/8/4 16:49:26";
//    MerId = 79;
//    Paymentno = KXF150804000568;
@end
