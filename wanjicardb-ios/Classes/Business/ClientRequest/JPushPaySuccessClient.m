//
//  JPushPaySuccessClient.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/10.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "JPushPaySuccessClient.h"
#import "CBSecutityUtil.h"
@interface JPushPaySuccessClient()

@property(nonatomic,strong) RESTClient *client;

@end
@implementation JPushPaySuccessClient

-(instancetype)init
{
    self=[super init];
    if(self){
        _client=[RESTClient shareRESTClient];
    }
    return self;
}


-(void) jpushConfirmPay:(NSString *) regid finished:(void(^)(BOOL success,CBMetaData *metaData,NSString * message))finished
{
    if(regid)
    {
        NSString * jpushURL = CBURLWithPath(KJpushConfirm);
        NSString * token=[CBPassport userToken] ;
        
        NSMutableString * sign=[NSMutableString stringWithFormat:@"app_id=%@regid=%@token=%@%@",kAppID,regid,token,kLoginAppKey];
       
        NSLog(@"sing===%@",sign);
        NSDictionary * params=@{
                                @"app_id":kAppID,
                                @"regid":regid,
                                @"token":token,
                                @"sign":[[CBSecutityUtil md5ForString:sign] lowercaseString]
                                };
        [_client postToURL:jpushURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
            
            if (!meta) {
                finished(NO, nil, kNetworkErrorString);
                return ;
            }
            
            if ([meta.code intValue] == 0) {
                NSError *decodeError = nil;
                 NSLog(@"======meta.code:::::%@",meta.code);
                NSLog(@"======data:::::%@",data);
                
                CBMetaData *metaData = [MTLJSONAdapter modelOfClass:[CBMetaData class] fromJSONDictionary:data error:&decodeError];
                
                if (!decodeError) {
                    finished(YES, metaData, nil);
                } else {
                    finished(YES, nil, kNetworkErrorString);
                }
            } else {
                if (meta) {
                    finished(NO, nil, meta.message);
                } else {
                }
                
            }

        }];
        
    }
    else{
        NSLog(@"regid is null");
    }
}
@end
