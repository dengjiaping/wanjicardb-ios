//
//  WJConstKey.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJConstKey_h
#define WanJiCard_WJConstKey_h


//JAVA Version
#define kSystemVersion      @"1.0"

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height
#define kTabbarHeight               49.0f
#define kStatusBarHeight            20.0f
#define kNavigationBarHeight        44.0f

#define kDefaultCenter              [NSNotificationCenter defaultCenter]

#define ALD(x)      (x * kScreenWidth/375.0)

#define AppGroups                  [NSString stringWithFormat:@"group.%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"]]   //  group id
#define AppVersioin         @"CFBundleShortVersionString"
#define AppBuildNumber      @"CFBundleVersion"

//keychain关键字
#define KeychainService         @"com.wjika.wjikaios"
#define KeychainAccount         @"uuid"
#define KAppURLScheme           @"wanjikaClient"


//通知关键字

#define kLaunchedApp                @"launchedApp"              //  是否打开过APP
#define kNotifyType                 @"notifyType"               //  通知类型
#define kLocalNotifyObject          @"LocalNotifyObject"        // 本地通知包含的数据Model
#define kNotifyTypeLocal            @"LocalNotifyType"          //  本地通知
#define kAppWillResignInactive      @"appWillResignInactive"
#define kCardRefresh                @"cardsNeedRefresh"         //卡包页面需要刷新
#define kShowShareFriendView        @"showShareFriendView"      //显示推荐好友
#define kNoLogin                    @"noLogin"                  //token失效
#define kUINotificationCallertoEnter        @"kUINotificationCallertoEnter"     //  电话呼入通知
#define kLocationUpdate             @"updateLocation"           //更新地理位置


#define NumberToString(a)          [NSString stringWithFormat:@"%@", @(a)]
#define ToString(x)  [x isKindOfClass:[NSString class]] ? x : ([x isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@", x] : nil)
#define ToNSNumber(x) [x isKindOfClass:[NSNumber class]] ? x : ([x isKindOfClass:[NSString class]] ? @([x doubleValue]) : @(INT32_MAX))


#define PlaceholderImage [UIImage imageNamed:@"card_defauld"]
//a 返回值  b 关键字   c 表单
#define NSLOCATION(a, b) NSLocalizedStringFromTable(a, key, b)

#define ALERT(a) [[TKAlertCenter defaultCenter] postAlertWithMessage:a]

#ifdef DEBUG
    #define NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
    #define WJLog(fmt, ...) {NSLog((@"LELOG --- " fmt), ##__VA_ARGS__);}
#else
    #define NSLog(format, ...)
    #define WJLog(...)
#endif




#endif
