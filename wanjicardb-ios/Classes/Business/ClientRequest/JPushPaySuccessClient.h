//
//  JPushPaySuccessClient.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/10.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configure.h"
#import "CBConfirmOrder.h"
@interface JPushPaySuccessClient : RESTClient



-(void) jpushConfirmPay:(NSString *) regid finished:(void(^)(BOOL success,CBMetaData *metaData,NSString * message))finished;
@end
