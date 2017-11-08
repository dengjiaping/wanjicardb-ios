//
//  CBPassport.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSInteger const kGuestUserID;

extern NSString *const kUserDefaultUserIDKey;
extern NSString *const kUserDefaultTokenKey;
extern NSString *const kUserDefaultSecretKey;

@class CBUser;
@class CBShopInfo;
@class WJMoreShopInfoModel;

@interface CBPassport : NSObject

+ (BOOL)isLogined;

+ (void)storageUserInfo:(CBUser *)userInfoModel;

+ (void)logout;

+ (int)userID;

+ (int)merID;

+ (void)setBranch:(NSArray *)dic;

+ (NSString *)balance;

+ (NSString *)todayPayNumber;

+ (NSString *)todayOrderNumber;

+ (NSString *)todayIncomeNumber;

+ (NSString *)productsNumber;

+ (NSString *)userToken;

+ (NSString *)userSecret;

+(NSString *)userName;

+ (NSDictionary *)shopInfo;

+ (void)storageShopInfo:(CBShopInfo *)shopModel;

+ (void)storageMoreShopInfo:(WJMoreShopInfoModel *)moreShop;

+ (void)changeShopAddress:(NSString *)address;

+ (NSString *)shopAddress;

+ (int)branchNumber;

+ (NSString *)businessTime;

+ (NSNumber *)status;

+ (void)storageStatus:(NSNumber *)status;

+ (NSString *)contacter;

+ (NSString *)detail;

+ (NSString *)cover;

+ (NSString *)shopID;

+ (int)galleryNumber;

+ (NSString *)introduction;

+ (BOOL)isMain;

+ (NSString *)latitude;

+ (NSString *)longitude;

+ (NSString *)shopName;

+ (NSString *)phone;

+ (NSString *)promotion;

+ (int)productNumber;

+ (int)totalSale;

+ (NSArray *)branchs;
+ (NSArray *)privileges;
+ (NSArray *)products;

@end
