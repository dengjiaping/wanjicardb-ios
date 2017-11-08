//
//  EventCenter.m
//  NewApp
//
//  Created by Lynn on 15/7/2.
//  Copyright (c) 2015年 NeoLynn. All rights reserved.
//

#import "EventCenter.h"
#import "Common.h"

@implementation EventCenter

+ (void)notifyEvent:(NSString *)event
{
    [kDefaultCenter postNotificationName:event object:nil userInfo:nil];
}

+ (void)notifyEvent:(NSString *)event
       withUserInfo:(NSDictionary *)userInfoDic
{
    [kDefaultCenter postNotificationName:event object:nil userInfo:userInfoDic];
}

@end
