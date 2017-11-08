//
//  EnumManager.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/7.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AllOrders = 0,
    WaitPayOrders = 10,
    PayedOrders = 30,
    InvalidOrders = 45,
    CloseOrders = 50,
    NoType = -1,
}OrdersType;


typedef enum
{
    AllFinanceType = 0,
    IncomeType = 10,
    WithdrawType = 20,

}FinanceType;


typedef enum
{
    SalingGoods = 60,
    SaledGoods = 70
}GoodsType;

@interface EnumManager : NSObject

@end
