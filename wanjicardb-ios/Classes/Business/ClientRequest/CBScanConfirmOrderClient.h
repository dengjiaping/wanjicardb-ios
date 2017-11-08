//
//  CBScanConfirmOrderClient.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
#import "CBConfirmOrder.h"
@interface CBScanConfirmOrderClient : RESTClient



-(void) addConsumeOrderWithMerid:(NSString*) merid userId:(NSString*) userId Amount: (NSString*) amount payCode:(NSString*) paycode Token:(NSString*) token finished:(void(^)(BOOL success,CBConfirmOrder *userModel,NSString * message))finished;

@end
