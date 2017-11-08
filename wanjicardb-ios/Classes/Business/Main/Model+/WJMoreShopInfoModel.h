//
//  WJMoreShopInfoModel.h
//  CardsBusiness
//
//  Created by Lynn on 16/1/11.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJMoreShopInfoModel : NSObject

@property (nonatomic, strong) NSString * balance;//账户余额
@property (nonatomic, strong) NSString * todayOrderNumber;//当日购卡订单数
@property (nonatomic, strong) NSString * todayPayNumber;//当日卡消费订单数
@property (nonatomic, strong) NSString * productsNumber;//在线商品数
@property (nonatomic, strong) NSString * todayIncomeNumber;//当日购卡总金额。

- (id)initWithDictionary:(NSDictionary *)dictionaryValue;

@end
