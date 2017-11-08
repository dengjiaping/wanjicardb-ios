//
//  Common.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/9.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#ifndef CardsBusiness_Common_h
#define CardsBusiness_Common_h

#define Localized(key)              NSLocalizedString(key, @"")
#define kDefaultCenter              [NSNotificationCenter defaultCenter]
#define kScreenWidth                [UIScreen mainScreen].bounds.size.width

//notification
#define kLeftSliderAction           @"leftSliderAction"
#define kMainRefreshAction          @"mainRefreshAction"
#define kMainLogoutAction           @"logoutAction"
#define kMainAddressAction          @"addressAction"
//Key
#define JPushKey                    @"348fd6caa3c9981afeedaa6e"


//url
#define kURLLogin                   @"/merchant/login"
#define kAppID                      @"10004"
#define kLoginAppKey                @"EptHGlu9LSFSAlJV3Xrd"
#define kShopInfo                   @"/merchant/info"
#define kMoreShopInfo               @"/merchant/extend"
#define kShopPicturesList           @"/merchant/gallery"
#define kChangeShopInfo             @"/merchant/Updateshopinfo"
#define kAddWithdraw                @"/merchant/addwithdrawal"
#define kSelectWithdrawHistory      @"/merchant/withdrawals"
#define kSyetemMessages             @"/merchant/messages"
#define kOrdersList                 @"/merchant/cardsales"
#define kConsumptionList            @"/merchant/payments"
#define kGoodsList                  @"/merchant/products"
#define kGoodsStatusUpdate          @"/product/updatestatus"
#define kFinanceList                @"/merchant/finance"
#define kUploadImage                @"/merchant/UploadImg"
#define kDeleteImage                @"/merchant/delphoto"
#define kSpendNconsume              @"/spend/nconsume"
#define kShopBranches               @"/merchant/branch"
#define kSendSMS                    @"/merchant/sendsms"
#define kVerifyCode                 @"/merchant/verifycode"
#define kFindPassword               @"/merchant/findpwd"
#define kUpdateshop                 @"/merchant/updateshop"
#define kUpdateshopinfo             @"/merchant/nupdateshopinfo"
#define kShopRefund                 @"/merchant/Refund"

//url-wzj
#define kCommitSuggest              @"/merchant/feedback"
#define kScanQRCode                 @"/spend/scan"
#define kBarQRcode                  @"/merchant/mcode"
#define KConfirmOrder               @"/spend/consume/"
#define KJpushConfirm               @"/merchant/update"
#define DeviceTokenStringKEY        @""

#define kLeftSliderWidth            kScreenWidth * 0.6

#endif
