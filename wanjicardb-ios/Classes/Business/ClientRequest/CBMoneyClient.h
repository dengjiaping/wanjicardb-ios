//
//  CBMoneyClient.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
#import "EnumManager.h"

@interface CBMoneyClient : RESTClient

- (void)systemMessagewithPage:(int)page finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished;

- (void)selectWithdrawWithPage:(int)page finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished;

- (void)withdrawWithMoney:(NSString *)moneyCount finished:(void(^)(BOOL success, NSString *message))finished;

- (void)ordersListWithType:(OrdersType)type page:(int)page searchKey:(NSString *)searchKey finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished;

- (void)consumptionInfoWithPage:(int)page searchKey:(NSString *)searchKey branch:(NSString *)branchID startTime:(NSString *)startTime endTime:(NSString *)endTime status:(ConsumptionType)status finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished;

- (void)goodsListWithType:(GoodsType)type page:(int)page finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished;

- (void)updateGoodsStatusWithGoodsID:(NSString *)goodsID status:(int)status finished:(void(^)(BOOL success, NSString *message))finished;

- (void)financeWithPage:(int)page type:(FinanceType)type finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished;

- (void)spendNcomsumeWithAmount:(NSString *)amount payCode:(NSString *)payCode finished:(void(^)(BOOL success, NSString *message))finished;
@end
