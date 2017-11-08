//
//  CBWithdrawModel.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/5.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

//Accountbalance = 62347;
//Amount = 2234;
//Applydate = "2015/8/5 15:51:38";
//Applyuserid = 86;
//Id = 273;
//Merid = 79;
//Paydate = "2015/8/5 15:51:38";
//Status = 15;

@interface CBWithdrawModel : CBBaseModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString * accountBablance;   //剩余金额
@property (nonatomic, strong) NSString * amount;            //提现金额
@property (nonatomic, strong) NSString * applyDate;         //申请日期
@property (nonatomic, strong) NSString * userID;            //用户ID
@property (nonatomic, strong) NSString * merID;             //店铺ID
@property (nonatomic, strong) NSString * payDate;           //打款日期
@property (nonatomic, strong) NSString * status;            //状态  status:  15 处理中   30：提现成功   50：提现失败

@end
