//
//  CBShopInfoClient.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
#import <CoreGraphics/CoreGraphics.h>

@class CBShopInfo;
@interface CBShopInfoClient : RESTClient
//- (void)loginWithPhone:(NSString *)phone password:(NSString *)password finished:(void(^)(BOOL success, CBUser *userModel, NSString *message))finished;

- (void)updatesShopInfoWithLongitude:(NSString *)longitude Latitude:(NSString *)latitude Address:(NSString *)address finished:(void(^)(BOOL success,NSString * message))finished;

- (void)shopInfoWithStatus:(NSString *)status finished:(void(^)(BOOL success, NSString * message))finish;

- (void)shopinfoWithID:(NSString *)shopID finished:(void(^)(BOOL success, CBShopInfo *shopInfo, NSString *message))finished;

- (void)changeShopInfo:(NSDictionary *)shopInfo finished:(void(^)(BOOL success, NSString * message))finish;

- (void)moreShopInfoResult:(void(^)(BOOL success,  WJMoreShopInfoModel * moreShopInfo , NSString *message))finished;

- (void)shopPicturesRequestWithWidth:(CGFloat)width finish:(void(^)(BOOL success, NSArray * dic , NSString *message))finished;

- (void)shopBranchesRequestWithPage:(int)page finish:(void(^)(BOOL success, NSDictionary * dic , NSString *message))finished;

- (void)shopRefundRequestWithPaymentNo:(NSString *)noStr finish:(void (^)(BOOL success,NSString * message))finished;

@end
