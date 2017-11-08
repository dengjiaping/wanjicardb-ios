//
//  NSString+CBFactory.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "NSString+CBFactory.h"

CGFloat kWaterFallWorkImageWidth = 143.0f;
@implementation NSString (CBFactory)
+ (NSString *)avatarString:(NSString *)imageString
{
    return [NSString stringWithFormat:@"%@?imageView2/0/w/78/h/78", imageString];
}

+ (NSString *)feedThumbString:(NSString *)URLString
{
    return [NSString stringWithFormat:@"%@?imageMogr2/auto-orient/thumbnail/640x", URLString];
}

+ (NSString *)thumbURL:(NSString *)URL withWidth:(CGFloat)width
{
    int intWidth = floorf(width*2);
    return [NSString stringWithFormat:@"%@?imageMogr2/auto-orient/thumbnail/%dx", URL,intWidth];
}

+ (NSString *)stringWithPublishTime:(int)timestamp
{
    int interval = [[NSDate date] timeIntervalSince1970] - timestamp;
    if (interval/60 < 1) {
        return @"刚刚";
    } else if (interval/3600 < 1) {
        return [NSString stringWithFormat:@"%d分钟前",(int)interval/(60)];
    } else if (interval/(3600*24)<1){
        return [NSString stringWithFormat:@"%d小时前",(int)interval/3600];
    } else if (interval/(3600*24)<365) {
        return [NSString stringWithFormat:@"%d天前",(int)interval/(3600*24)];
    } else {
        int year = interval/3600/24/365;
        return [NSString stringWithFormat:@"%d年前",(int)year];
    }
}

@end
