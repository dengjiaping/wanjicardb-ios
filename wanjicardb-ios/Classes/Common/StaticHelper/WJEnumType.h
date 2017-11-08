//
//  WJEnumType.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJEnumType_h
#define WanJiCard_WJEnumType_h

/**
 数据库排序
 */
typedef enum {
    ORDER_BY_NONE = 0,
    ORDER_BY_DESC,
    ORDER_BY_ASC
} TS_ORDER_E;

typedef enum {
    ConsumptionAllType = 0,//全部
    ConsumptionWaitPayType = 10,//待支付
    ConsumptionSuccessType = 30,//交易成功
    ConsumptionRefundType = 40,//退款
    ConsumptionCloseType = 60,//冲正关闭
    ConsumptionOrderCloseType = 70//订单关闭
}ConsumptionType;

typedef enum {
    AllTime = 0,
    Today = 1,
    BeforeThreeDays = 2,
    BeforWeeks = 3,
    CurrentTime = 4
} ConsumptionTimeType;

#endif
