//
//  EventCenter.h
//  NewApp
//
//  Created by Lynn on 15/7/2.
//  Copyright (c) 2015年 NeoLynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCenter : NSObject

+ (void)notifyEvent:(NSString *)event;

+ (void)notifyEvent:(NSString *)event
       withUserInfo:(NSDictionary *)userInfoDic;

@end
