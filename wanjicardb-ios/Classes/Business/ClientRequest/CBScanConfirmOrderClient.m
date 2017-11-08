//
//  CBScanConfirmOrderClient.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBScanConfirmOrderClient.h"
#import "Configure.h"
#import "CBSecutityUtil.h"
@interface CBScanConfirmOrderClient()

@property(nonatomic,strong) RESTClient *client;

@end

@implementation CBScanConfirmOrderClient
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        _client=[RESTClient shareRESTClient];
    }
    return self;
}

-(void) addConsumeOrderWithMerid:(NSString*) merid userId:(NSString*) userId Amount: (NSString*) amount payCode:(NSString*) paycode Token:(NSString*) token finished:(void(^)(BOOL success,CBConfirmOrder *confirmOrderModel,NSString * message))finished
{
    NSLog(@"----%@-----%d",merid,[CBPassport merID]);
    NSLog(@"----%@-----",userId);
    if(merid&&![merid isEqual:@""]&&userId&&![userId isEqual:@""])
    {
        if(token)
        {
            //判断非空后，执行的逻辑。。。
            NSString* confirmOrderUrl=CBURLWithPath(KConfirmOrder);
            
            NSMutableString *sign=[NSMutableString stringWithFormat:@"amount=%@app_id=%@merid=%@paycode=%@token=%@userid=%@%@",amount,kAppID,merid,paycode,token,userId,kLoginAppKey];
            NSLog(@"----sign::%@",sign);
            NSDictionary* params=@{
                                @"app_id":kAppID,
                                @"amount":amount,
                                @"merid":merid,
                                @"paycode":paycode,
                                @"token":token,
                                @"userid":userId,
                                @"sign":[[CBSecutityUtil md5ForString:sign] lowercaseString]
                                };
            
            [_client postToURL:confirmOrderUrl withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
                
                if (!meta) {
                    finished(NO, nil, kNetworkErrorString);
                    return ;
                }
                
                if ([meta.code intValue] == 0) {
                    NSError *decodeError = nil;
                    NSLog(@"======:::::%@",data);
                    
                    CBConfirmOrder *confirmOrder = [MTLJSONAdapter modelOfClass:[CBConfirmOrder class] fromJSONDictionary:data error:&decodeError];
                    
                    if (!decodeError) {
                        finished(YES, confirmOrder, nil);
                    } else {
                        finished(YES, nil, kNetworkErrorString);
                    }
                } else {
                    if (meta) {
                        finished(NO, nil, meta.message);
                        // return..支付码错误，请重新扫描;
                    } else {
                    }
                    
                }

                
            }];
            
        }
        else{
            NSLog(@"请先登录。。token is empty");
        }
    }
    else
    {
        NSLog(@"merid,userId 不能为空");
        return;
    }
}
@end
