//
//  CBShopInfoClient.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBShopInfoClient.h"
#import "Configure.h"
#import "CBShopInfo.h"
#import "WJMoreShopInfoModel.h"
#import "WJPhotoesModel.h"

@interface CBShopInfoClient()

@property (nonatomic, strong) RESTClient * client;

@end


@implementation CBShopInfoClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [RESTClient shareRESTClient];
    }
    return self;
}

- (void)updatesShopInfoWithLongitude:(NSString *)longitude Latitude:(NSString *)latitude Address:(NSString *)address finished:(void(^)(BOOL success,NSString * message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"address":address,
//                           @"address":[CBPassport shopAddress],
//                           @"phone":[CBPassport phone],
//                           @"contacter":[CBPassport contacter],
//                           @"introduction":[[CBPassport detail] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           @"longitude":longitude,
                           @"latitude":latitude
                           };
    
    NSString * requestURL = CBURLWithPath(kUpdateshopinfo);
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
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
                finished(NO, kNetworkErrorString);
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


- (void)shopInfoWithStatus:(NSString *)status finished:(void(^)(BOOL success, NSString * message))finish
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"status":status,
                           @"token":[CBPassport userToken]
                           };
    
    NSString * requestURL = CBURLWithPath(kUpdateshop);
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error)
     {
         
         if (!meta) {
             finish(NO, kNetworkErrorString);
             return ;
         }
         
         if ([meta.code intValue] == 0) {
             NSLog(@"%@",meta.code);
             //            CBShopInfo *shopModel =[[CBShopInfo alloc] initWithDictionary:data[@"Val"]];
             //            [CBPassport storageShopInfo:shopModel];
             
             if (data) {
                 finish(YES, nil);
             } else {
                 finish(YES, kNetworkErrorString);
             }
         } else {
             if (meta) {
                 finish(NO, meta.message);
                 NSLog(@"%@",meta.code);
             } else {
                 
             }
         }
         
     }];
}


- (void)shopinfoWithID:(NSString *)shopID finished:(void(^)(BOOL success, CBShopInfo *shopInfo, NSString *message))finished
{
    
    if ([shopID isEqualToString:@"0"]|| shopID.length == 0) {
        return;
    }
    
    NSString *shopInfoUrl = CBURLWithPath(kShopInfo);
    NSDictionary * dic = @{@"id":shopID,@"app_id":kAppID};
    
    NSLog(@"dic = %@",dic);
    
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:shopInfoUrl params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            
            CBShopInfo *shopModel =[[CBShopInfo alloc] initWithDictionary:data[@"Val"]];
            [CBPassport storageShopInfo:shopModel];
            
            if (shopModel) {
                finished(YES, shopModel, nil);
            } else {
                finished(YES, nil, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
}

- (void)changeShopInfo:(NSDictionary *)shopInfo finished:(void(^)(BOOL success,NSString * message))finished
{
    NSString *changeShopInfoUrl = CBURLWithPath(kChangeShopInfo);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:shopInfo];
    [params addEntriesFromDictionary:@{@"app_id":kAppID,
                                       @"token":[CBPassport userToken]}];
    
    NSString * sign = [self signWithDic:params];
    [params setObject:sign forKey:@"sign"];
    
    [_client postToURL:changeShopInfoUrl withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, kNetworkErrorString);
            return ;
        }
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            if (data) {
                finished(YES, nil);
            } else {
                finished(NO, kNetworkErrorString);
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

- (void)moreShopInfoResult:(void(^)(BOOL success,  WJMoreShopInfoModel * moreShopInfo , NSString *message))finished
{
    NSString *requestURL = CBURLWithPath(kMoreShopInfo);
    NSDictionary * dic = @{@"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"app_id":kAppID,
                           @"token":[CBPassport userToken]
                           };
    
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            WJMoreShopInfoModel * moreShopInfoModel = [[WJMoreShopInfoModel alloc] initWithDictionary:data[@"Val"]];
            
            if (data) {
                finished(YES, moreShopInfoModel, nil);
            } else {
                finished(YES, nil, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
}

- (void)shopPicturesRequestWithWidth:(CGFloat)width finish:(void(^)(BOOL success, NSArray * dic , NSString *message))finished
{
    NSString *requestURL = CBURLWithPath(kShopPicturesList);
    
    CGFloat height = 166.0 * width / 288.0;
    
    NSDictionary * dic = @{@"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"app_id":kAppID,
                           @"token":[CBPassport userToken],
                           @"width":[NSString stringWithFormat:@"%f",width],
                           @"height":[NSString stringWithFormat:@"%f",height]
                           };
    
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:requestURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                NSMutableArray * picArray = [NSMutableArray array];
                for (int i = 0; i < [data[@"Val"] count]; i++) {
                    WJPhotoesModel * photo = [[WJPhotoesModel alloc] initWithDictionary:[data[@"Val"] objectAtIndex:i]];
                    [picArray addObject:photo];
                }
                finished(YES, picArray, nil);
            } else {
                finished(YES, nil, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
}


- (void)shopBranchesRequestWithPage:(int)page finish:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished
{
    NSString * reqeustURL = CBURLWithPath(kShopBranches);
    
    NSDictionary * dic = @{@"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"app_id":kAppID,
                           @"token":[CBPassport userToken],
                           @"page":[NSString stringWithFormat:@"%d",page]
                           };
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client getFromURL:reqeustURL params:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, data[@"Val"], nil);
            } else {
                finished(YES, nil, kNetworkErrorString);
            }
        } else {
            if (meta) {
                finished(NO, nil, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }
    }];
    
    
}

- (void)shopRefundRequestWithPaymentNo:(NSString *)noStr finish:(void (^)(BOOL success,NSString * message))finished
{
    NSString * reqeustURL = CBURLWithPath(kShopRefund);
    
    NSDictionary * dic = @{@"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"app_id":kAppID,
                           @"userid":[NSString stringWithFormat:@"%d",[CBPassport userID]],
                           @"paymentno":noStr,
                           @"token":[CBPassport userToken],
                           };
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    [_client postToURL:reqeustURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, kNetworkErrorString);
            return ;
        }
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES, nil);
            } else {
                finished(NO, kNetworkErrorString);
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
