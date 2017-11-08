//
//  WJMoreShopInfoModel.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/11.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMoreShopInfoModel.h"

@implementation WJMoreShopInfoModel

- (id)initWithDictionary:(NSDictionary *)dictionaryValue
{
    if (self) {
        self.balance = [NSString stringWithFormat:@"%@", [dictionaryValue objectForKey:@"Balance"]];
        self.todayOrderNumber = [NSString stringWithFormat:@"%@",[dictionaryValue objectForKey:@"Neworder"]];
        self.todayPayNumber = [NSString stringWithFormat:@"%@",[dictionaryValue objectForKey:@"Newpay"]];
        
        CGFloat todayIncome = [[dictionaryValue objectForKey:@"TodayIncome"] floatValue];
        self.todayIncomeNumber = [WJUtilityMethod floatNumberForMoneyFomatter:todayIncome];

        self.productsNumber = [NSString stringWithFormat:@"%@",[dictionaryValue objectForKey:@"Products"]];
    }
    return self;
}

@end
