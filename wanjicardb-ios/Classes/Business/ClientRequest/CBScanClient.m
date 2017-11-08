//
//  CBScanClient.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/3.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBScanClient.h"
#import "Configure.h"
#import "CBSecutityUtil.h"
#import "CBUser.h"
#import "MetaBarCodeValue.h"
@interface CBScanClient()

@property (strong,nonatomic) RESTClient *client;

@end

@implementation CBScanClient

-(instancetype)init
{
    self=[super init];
    if(self){
        _client=[RESTClient shareRESTClient];
    }
    return self;
}
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
-(void) barCodeAndQRcode:(NSString*) appId finished:(void(^)(BOOL success,CBMetaData *metaData,NSString * message))finished
{
    appId=kAppID;
    NSString *BarQRcodeUrl=CBURLWithPath(kBarQRcode);
   
    NSMutableString *sign=[NSMutableString stringWithFormat:@"app_id=%@token=%@%@",kAppID,[CBPassport userToken],kLoginAppKey];
    NSLog(@"====sign的值：：：%@",sign);

    NSDictionary *params=@{
                           @"app_id":kAppID,
                           @"token":[CBPassport userToken],
                           @"sign":[[CBSecutityUtil md5ForString:sign] lowercaseString]
                           };
    [_client postToURL:BarQRcodeUrl withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSError *decodeError = nil;
            NSLog(@"======:::::%@",data);
            NSLog(@"======:::::%@",[data valueForKey:@"mcode"]);
//            MetaBarCodeValue *meta = [MTLJSONAdapter modelOfClass:[MetaBarCodeValue class] fromJSONDictionary:data error:&decodeError];
            
            [meta setValue:[data valueForKey:@"mcode"] forKey:@"value"];
            if (!decodeError) {
                finished(YES, meta, nil);
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

-(void) getUserInfoWithScan:(NSString*) OnlyNumberToken finished:(void(^)(BOOL success,CBScan *CBScanModel,NSString * message))finished
{
    if([self isPureInt:OnlyNumberToken]) {
        
        NSString *ScanUserInfoUrl=CBURLWithPath(kScanQRCode);
        NSString *userToken=[CBPassport userToken];
        NSMutableString *sign=[NSMutableString stringWithFormat:@"app_id=%@code=%@token=%@%@",kAppID,OnlyNumberToken,userToken,kLoginAppKey];
        NSLog(@"====sign的值：：：%@",sign);
        
        NSDictionary *params=@{
                              @"app_id":kAppID,
                              @"code":OnlyNumberToken,
                              @"token":userToken,
                              @"sign":[[CBSecutityUtil md5ForString:sign] lowercaseString]
                              };
        [_client postToURL:ScanUserInfoUrl withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
            if (!meta) {
                finished(NO, nil, kNetworkErrorString);
                return ;
            }
            
            if ([meta.code intValue] == 0) {
                NSError *decodeError = nil;
                NSLog(@"======:::::%@",data);
                
                CBScan *CBScanModel = [MTLJSONAdapter modelOfClass:[CBScan class] fromJSONDictionary:data error:&decodeError];
                
                if (!decodeError) {
                    finished(YES, CBScanModel, nil);
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
        NSLog(@"这不是合法的付款码！");
        finished(NO,nil,@"不合法的付款码");
        return;
        
    }
}
-(void) suggestWithMerID:(NSString *)merID UserID:(NSString *) UserID content:(NSString *)content appname:(NSString *)appname appversion:(NSString *)appversion finished:(void(^)(BOOL success,CBUser *userModel,NSString * message))finished
{
    
    NSLog(@"已经进入方法....");
    if ([merID isEqualToString:@"0"]|| merID.length==0) {
        finished(NO,nil,@"商户id为空");
        return;
    }
    
    NSString *commitSuggestUrl = CBURLWithPath(kCommitSuggest);
    NSMutableString *sign = [NSMutableString stringWithFormat:@"app_id=%@appname=%@appversion=%@content=%@merid=%@token=%@userid=%@%@",kAppID,appname,appversion,content,merID,[CBPassport userToken],UserID,kLoginAppKey];
    NSLog(@"串的值为========：%@",sign);
    NSLog(@"userToken值为========：%@",[CBPassport userToken]);
    NSDictionary *params= @{
                            @"userid":UserID,
                            @"merid":merID,
                            @"content":content,
                            @"appname":appname,
                            @"appversion":appversion,
                            @"app_id":kAppID,
//                            @"sign":[[CBSecutityUtil md5ForString:sign] lowercaseString],
                            @"token": [CBPassport userToken]
                            };
    // NSString *sign=[_client signWithDic:pa];
    
    
    
    [_client postToURL:commitSuggestUrl withURLParams:nil bodyParams:[self haveSingDic:params] finished:^(CBMetaData *meta, id data, NSError *error) {
        
        if (!meta) {
            finished(NO, nil, kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSError *decodeError = nil;
            
            //
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回答abcd" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            [alert show];
            
            CBUser *userModel = [MTLJSONAdapter modelOfClass:[CBUser class] fromJSONDictionary:data error:&decodeError];
            
            if (!decodeError) {
                finished(YES, userModel, nil);
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
@end
