//
//  NSString+CBFactory.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat kWaterFallWorkImageWidth;

@interface NSString (CBFactory)

+ (NSString *)avatarString:(NSString *)imageString;
+ (NSString *)feedThumbString:(NSString *)URLString;

+ (NSString *)thumbURL:(NSString *)URL withWidth:(CGFloat)width;

+ (NSString *)stringWithPublishTime:(int)timestamp;

@end
