//
//  NSString+CoculationSize.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CoculationSize)

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size;

//判断改字符串是否为手机号
- (BOOL)isMobilePhoneNumber;

- (NSString *)EncodeUTF8Str;

- (NSString *)chinaString:(NSString *)utfString;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

- (CGSize)sizeWithFont:(UIFont *)font;

- (NSString *)stringByReversed;

@end

