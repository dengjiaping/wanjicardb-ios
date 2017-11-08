//
//  CBScanClient.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/3.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
#import "CBScan.h"
@class CBUser;
@interface CBScanClient : RESTClient


- (BOOL)isPureInt:(NSString*)string;

-(void) getUserInfoWithScan:(NSString*) OnlyNumberToken finished:(void(^)(BOOL success,CBScan *userModel,NSString * message))finished;
//WZJ -意见反馈
-(void) suggestWithMerID:(NSString *)merID UserID:(NSString *) UserID content:(NSString *)content appname:(NSString *)appname appversion:(NSString *)appversion finished:(void(^)(BOOL success,CBUser *userModel,NSString * message))finished;
// wzj 重新生成条形码／二维码 内容
-(void) barCodeAndQRcode:(NSString*) appId finished:(void(^)(BOOL success,CBMetaData *metaData,NSString * message))finished;
@end
