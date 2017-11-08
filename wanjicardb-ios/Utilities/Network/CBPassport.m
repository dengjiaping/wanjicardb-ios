//
//  CBPassport.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBPassport.h"
#import "CBUser.h"
#import "CBShopInfo.h"
#import "CBCoredataHelper.h"

#import "AppDelegate.h"
#import "WJMoreShopInfoModel.h"


#define _UserDefault    [NSUserDefaults standardUserDefaults]

extern NSInteger const kGuestUserID = 0;

NSString *const kUserDefaultUserIDKey           = @"Id";
NSString *const kUserDefaultTokenKey            = @"token";
NSString *const kUserDefaultSecretKey           = @"secret";
NSString *const kUserDefaultAvatorKey           = @"avator";
NSString *const kUserDefaultNameKey             = @"username";
NSString *const kUserDefaultMerKey              = @"Merid";

NSString *const kUserDefaultShopInfoKey         = @"shopInfo";
NSString *const kUserDefaultShopIDKey           = @"shopInfoID";
NSString *const kUserDefaultShopBalanceKey      = @"shopBalance";
NSString *const kUserDefaultShopTodayOrderKey   = @"todayOrders";
NSString *const kUserDefaultShopTodayPayKey     = @"todayPay";
NSString *const kUserDefaultShopBranchesKey     = @"shopBranches";
NSString *const kUserDefaultShopProductsNumKey  = @"shopTodayProducts";
NSString *const kUserDefaultShopTodayIncomeKey  = @"shopTodayIncome";
NSString *const kUserDefaultShopNameKey         = @"shopName";
NSString *const kUserDefaultShopAddressKey      = @"shopAddress";
NSString *const kUserDefaultShopTotalSaleKey    = @"totalSale";
NSString *const kUserDefaultPrivilegesKey       = @"privileges";
NSString *const kUserDefaultPromotionKey        = @"promotion";
NSString *const kUserDefaultLatitudeKey         = @"latitude";
NSString *const kUserDefaultBusinessTimeKey     = @"businessTime";
NSString *const kUserDefaultIntroductionKey     = @"introduction";
NSString *const kUserDefaultPhoneNumKey         = @"shopPhoneKey";
NSString *const kUserDefaultBranchNumKey        = @"branchNum";
NSString *const kUserDefaultBranchKey           = @"branch";
NSString *const kUserDefaultProductKey          = @"product";
NSString *const kUserDefaultGalleryNumKey       = @"galleryNum";
NSString *const kUserDefaultLongitudeKey        = @"longitude";
NSString *const kUserDefaultIsMainKey           = @"isMain";
NSString *const kUserDefaultCoverKey            = @"cover";
NSString *const kUserDefaultProductNumKey       = @"productNumber";
NSString *const kUserDefaultContacterKey        = @"contacter";
NSString *const kUserDefaultStatusKey           = @"status";
NSString *const kUserDefaultDetailKey           = @"Detail";

@implementation CBPassport

+ (BOOL)isLogined
{
    //返回用户是否登录
    if ([self userID]) {
        return YES;
    }
    return NO;
}

+ (void)storageUserInfo:(CBUser *)userInfoModel
{
    //存储用户信息
    [_UserDefault setObject:userInfoModel.userID forKey:kUserDefaultUserIDKey];
    [_UserDefault setObject:userInfoModel.token forKey:kUserDefaultTokenKey];
    [_UserDefault setObject:userInfoModel.name forKey:kUserDefaultNameKey];
    [_UserDefault setObject:userInfoModel.merID forKey:kUserDefaultMerKey];
    [_UserDefault synchronize];
    //上传新的推送UserID
//    [[HJCommonInfoService shareCommonService]upLoadPushInfo];
}

+ (void)storageMoreShopInfo:(WJMoreShopInfoModel *)moreShop
{
    [_UserDefault setObject:moreShop.balance forKey:kUserDefaultShopBalanceKey];
    [_UserDefault setObject:moreShop.todayPayNumber forKey:kUserDefaultShopTodayPayKey];
    [_UserDefault setObject:moreShop.todayOrderNumber forKey:kUserDefaultShopTodayOrderKey];
    [_UserDefault setObject:moreShop.todayIncomeNumber forKey:kUserDefaultShopTodayIncomeKey];
    [_UserDefault setObject:moreShop.productsNumber forKey:kUserDefaultShopProductsNumKey];
}

+ (void)logout
{
    //清空用户存储信息
    [_UserDefault setObject:[NSNumber numberWithInt:kGuestUserID] forKey:kUserDefaultUserIDKey];
    [_UserDefault removeObjectForKey:kUserDefaultTokenKey];
    [_UserDefault removeObjectForKey:kUserDefaultSecretKey];
    [_UserDefault removeObjectForKey:kUserDefaultMerKey];
    [_UserDefault removeObjectForKey:kUserDefaultShopInfoKey];
    
    CBShopInfo * shopInfo = [[CBShopInfo alloc] init];
    [self storageShopInfo:shopInfo];
    
    WJMoreShopInfoModel * moreShopInfo = [[WJMoreShopInfoModel alloc]init];
    [self storageMoreShopInfo:moreShopInfo];
    CBUser * user = [[CBUser alloc] init];
    [self storageUserInfo:user];
    
    [_UserDefault synchronize];
}

+ (int)userID
{
    //返回userID 如果用户未登录返回 UNLOGIN_USERID
    NSNumber *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserIDKey];
    return [userID intValue];
}

+ (int)merID
{
    NSNumber *merID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultMerKey];
    return [merID intValue];
}


+ (NSString *)userToken
{
    //返回UserToken值
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultTokenKey];
    NSLog(@"TOKEN = %@",userToken);
    if (userToken && userToken.length > 0) {
        return userToken;
    }
    return @"";
}

+ (NSString *)userName
{
    //返回UserName
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNameKey];
    if (userName && userName.length > 0) {
        return userName;
    }
    return @"";
}

+ (NSString *)balance
{
    NSString *balance = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultShopBalanceKey];
    if (balance && balance.length > 0) {
        return balance;
    }
    return @"";
}

+ (NSString *)todayPayNumber
{
    NSString *todayPayNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultShopTodayPayKey];
    if (todayPayNumber && todayPayNumber.length > 0) {
        return todayPayNumber;
    }
    return @"";
}

+ (NSString *)todayOrderNumber
{
    NSString *todayOrderNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultShopTodayOrderKey];
    if (todayOrderNumber && todayOrderNumber.length > 0) {
        return todayOrderNumber;
    }
    return @"";
}

+ (NSString *)todayIncomeNumber
{
    NSString *todayIncomeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultShopTodayIncomeKey];
    if (todayIncomeNumber && todayIncomeNumber.length > 0) {
        return todayIncomeNumber;
    }
    return @"";
}

+ (NSString *)productsNumber
{
    NSString *productsNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultShopProductsNumKey];
    if (productsNumber && productsNumber.length > 0) {
        return productsNumber;
    }
    return @"";
}

+ (void)setBranch:(NSArray *)dic
{
    [_UserDefault setObject:dic forKey:kUserDefaultShopBranchesKey];
}

+ (NSString *)userSecret
{
    //返回UserSecret值
    NSString *userSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultSecretKey];
    if (userSecret && userSecret.length > 0) {
        return userSecret;
    }
    return @"";
}

+ (NSDictionary *)shopInfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultShopInfoKey];
}

+ (void)storageShopInfo:(CBShopInfo *)shopModel
{
    //    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kUserDefaultShopInfoKey];
    [_UserDefault setObject:shopModel.shopAddress forKey:kUserDefaultShopAddressKey];
    [_UserDefault setObject:shopModel.branchNum forKey:kUserDefaultBranchNumKey];
    [_UserDefault setObject:shopModel.businessTime forKey:kUserDefaultBusinessTimeKey];
    [_UserDefault setObject:shopModel.cover forKey:kUserDefaultCoverKey];
    [_UserDefault setObject:shopModel.galleryNum forKey:kUserDefaultGalleryNumKey];
    [_UserDefault setObject:shopModel.shopID forKey:kUserDefaultShopIDKey];
    [_UserDefault setObject:shopModel.introduction forKey:kUserDefaultIntroductionKey];
    [_UserDefault setObject:[NSString stringWithFormat:@"%d",shopModel.isMain] forKey:kUserDefaultIsMainKey];
    [_UserDefault setObject:shopModel.latitude forKey:kUserDefaultLatitudeKey];
    [_UserDefault setObject:shopModel.longitude forKey:kUserDefaultLongitudeKey];
    [_UserDefault setObject:shopModel.shopName forKey:kUserDefaultShopNameKey];
    [_UserDefault setObject:shopModel.phone forKey:kUserDefaultPhoneNumKey];
    [_UserDefault setObject:shopModel.productNum forKey:kUserDefaultProductNumKey];
    [_UserDefault setObject:shopModel.promotion forKey:kUserDefaultPromotionKey];
    [_UserDefault setObject:shopModel.totalSale forKey:kUserDefaultShopTotalSaleKey];
    [_UserDefault setObject:shopModel.branch forKey:kUserDefaultShopBranchesKey];
    [_UserDefault setObject:shopModel.contacter forKey:kUserDefaultContacterKey];
    [_UserDefault setObject:shopModel.status forKey:kUserDefaultStatusKey];
//    [_UserDefault setBool:([shopModel.status isEqual:@"30"]) ? 1 : 0 forKey:kUserDefaultStatusKey];
    [_UserDefault setObject:shopModel.detail forKey:kUserDefaultDetailKey];

    
    [[CBCoredataHelper alloc] save:kEntityNameBranch obj:shopModel.branch];
    [[CBCoredataHelper alloc] save:kEntityNamePrivileges obj:shopModel.privileges];
    [[CBCoredataHelper alloc] save:kEntityNameProduct obj:shopModel.product];
    
    AppDelegate * delegate =  ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    delegate.branchs = shopModel.branch;
    delegate.privileges = shopModel.privileges;
    delegate.products = shopModel.product;
    [_UserDefault synchronize];

}

+ (NSNumber *)status
{
    return [_UserDefault objectForKey:kUserDefaultStatusKey];
}

+ (void)storageStatus:(NSNumber *)status
{
    [_UserDefault setObject:status forKey:kUserDefaultStatusKey];
;
}

+ (NSString *)contacter
{
    return [_UserDefault objectForKey:kUserDefaultContacterKey];
}

+ (NSString *)detail
{
    return [_UserDefault objectForKey:kUserDefaultDetailKey];
}

+ (void)changeShopAddress:(NSString *)address
{
    [_UserDefault setObject:address forKey:kUserDefaultShopAddressKey];
}

+ (NSString *)shopAddress
{
    return [_UserDefault objectForKey:kUserDefaultShopAddressKey];
}

+ (int)branchNumber
{
    return [[_UserDefault objectForKey:kUserDefaultBranchNumKey] intValue];
}

+ (NSString *)businessTime
{
    return [_UserDefault objectForKey:kUserDefaultBusinessTimeKey];
}

+ (NSString *)cover
{
    return [_UserDefault objectForKey:kUserDefaultCoverKey];
}

+ (NSString *)shopID
{
    return [_UserDefault objectForKey:kUserDefaultShopIDKey];
}

+ (int)galleryNumber
{
    return [[_UserDefault objectForKey:kUserDefaultGalleryNumKey] intValue];
}

+ (NSString *)introduction
{
    return [_UserDefault objectForKey:kUserDefaultIntroductionKey];
}

+ (BOOL)isMain
{
    return [[_UserDefault objectForKey:kUserDefaultIsMainKey] boolValue];
}

+ (NSString *)latitude
{
    return [_UserDefault objectForKey:kUserDefaultLatitudeKey];
}

+ (NSString *)longitude
{
    return [_UserDefault objectForKey:kUserDefaultLongitudeKey];
}

+ (NSString *)shopName
{
    return [_UserDefault objectForKey:kUserDefaultShopNameKey];
}

+ (NSString *)phone
{
    return [_UserDefault objectForKey:kUserDefaultPhoneNumKey];
}

+ (NSString *)promotion
{
    return [_UserDefault objectForKey:kUserDefaultPromotionKey];
}

+ (int)productNumber
{
    return [[_UserDefault objectForKey:kUserDefaultProductNumKey] intValue];
}

+ (int)totalSale
{
    return [[_UserDefault objectForKey:kUserDefaultShopTotalSaleKey] intValue];
}

+ (NSArray *)branchs
{
    return [_UserDefault objectForKey:kUserDefaultShopBranchesKey];
}

+ (NSArray *)privileges
{
    return [[CBCoredataHelper alloc] read:kEntityNamePrivileges];
}

+ (NSArray *)products
{
    return [[CBCoredataHelper alloc] read:kEntityNameProduct];
}

@end
