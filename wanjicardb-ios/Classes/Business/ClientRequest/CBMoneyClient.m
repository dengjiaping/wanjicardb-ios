//
//  CBMoneyClient.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBMoneyClient.h"
#import "CBPassport.h"
#import "Configure.h"
#import "CBUser.h"
#import "CBWithdrawModel.h"
#import "Configure.h"

@interface CBMoneyClient()

@property (nonatomic, strong) RESTClient * client;

@end

@implementation CBMoneyClient
- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [RESTClient shareRESTClient];
    }
    return self;
}



- (void)systemMessagewithPage:(int)page finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"token":[CBPassport userToken],
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"page":[NSString stringWithFormat:@"%d",page]
                           };
    NSString * requestURL = CBURLWithPath(kSyetemMessages);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
        
    }];
    
}

- (void)selectWithdrawWithPage:(int)page finished:(void(^)(BOOL success, NSDictionary * data, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                            @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                            @"token":[CBPassport userToken],
                            @"stime":@"",
                            @"etime":@"",
                            @"page":[NSString stringWithFormat:@"%d",page]
                           };
    NSString * requestURL = CBURLWithPath(kSelectWithdrawHistory);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }

    }];
    
}

- (void)withdrawWithMoney:(NSString *)moneyCount finished:(void(^)(BOOL success, NSString *message))finished
{
    
    if ([moneyCount isEqualToString:nil] || moneyCount.length == 0) {
        NSLog(@"请输入提取金额");
        return;
    }
    
    if ([moneyCount isEqualToString:@"0"]) {
        NSLog(@"请金额大于0");
        return;
    }
    
    NSDictionary * dic = @{@"app_id":kAppID,
                            @"Merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"Userid":[NSString stringWithFormat:@"%d",[CBPassport userID]],
                           @"Amount":moneyCount,
                            @"token":[CBPassport userToken]
                           };
    
    NSString * requestURL = CBURLWithPath(kAddWithdraw);
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
     
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error)
     {
        
         if (!meta) {
            finished(NO, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            //            CBShopInfo *shopModel =[[CBShopInfo alloc] initWithDictionary:data[@"Val"]];
            //            [CBPassport storageShopInfo:shopModel];
            
            if (data) {
                finished(YES, nil);
            } else {
                finished(YES, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }

    }];
    
}

- (void)ordersListWithType:(OrdersType)type page:(int)page searchKey:(NSString *)searchKey finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"status":[NSString stringWithFormat:@"%d",(int)type],
                           @"size":@"20",//申请20个
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"username":searchKey
                           };
    
    NSString * requestURL = CBURLWithPath(kOrdersList);
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
//            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
//                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
}

//- (void)ordersCount

- (void)consumptionInfoWithPage:(int)page searchKey:(NSString *)searchKey branch:(NSString *)branchID startTime:(NSString *)startTime endTime:(NSString *)endTime status:(ConsumptionType)status finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished
{
    if (startTime == nil) {
        startTime = @"";
    }
    
    if (endTime == nil) {
        endTime = @"";
    }
    
    if (branchID == nil) {
        branchID = @"";
    }
    
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"Stime":startTime,
                           @"Etime":endTime,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"branchid":branchID,
                           @"username":searchKey,
                           @"size":@"20",//申请20个
                           @"status":[NSString stringWithFormat:@"%d",status]
                           };
    
    NSString * requestURL = CBURLWithPath(kConsumptionList);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];

    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
    
}

- (void)goodsListWithType:(GoodsType)type page:(int)page finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"status":[NSString stringWithFormat:@"%d",type],
                           @"size":@"20"//申请20个
                           };
    NSString * requestURL = CBURLWithPath(kGoodsList);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];

    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
}

- (void)updateGoodsStatusWithGoodsID:(NSString *)goodsID status:(int)status finished:(void(^)(BOOL success, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"productid":goodsID,
                           @"newstatus":[NSString stringWithFormat:@"%d",status]
                           };
    NSString * requestURL = CBURLWithPath(kGoodsStatusUpdate);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0 ) {
            NSLog(@"%@",meta.code);
            //            CBShopInfo *shopModel =[[CBShopInfo alloc] initWithDictionary:data[@"Val"]];
            //            [CBPassport storageShopInfo:shopModel];
            
            if (data) {
                finished(YES, nil);
            } else {
                finished(YES, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
}

- (void)financeWithPage:(int)page type:(FinanceType)type finished:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"type":[NSString stringWithFormat:@"%d",type],
                           @"Stime":@"",
                           @"Etime":@"",
                           @"size":@"20"//申请20个
                           };
    NSString * requestURL = CBURLWithPath(kFinanceList);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"],nil);
            } else {
                finished(YES, nil,kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil,meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }

    }];
}

- (void)spendNcomsumeWithAmount:(NSString *)amount payCode:(NSString *)payCode finished:(void(^)(BOOL success, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"token":[CBPassport userToken],
                           @"amount":amount,
                           @"paycode":payCode
                           };
    NSString * requestURL = CBURLWithPath(kSpendNconsume);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    NSLog(@"signDic = %@",params);
    
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, nil);
            } else {
                finished(YES, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];

 
    
}


@end
