//
//  WJUtilityMethod.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJUtilityMethod : NSObject


+ (BOOL) createDirectoryIfNotPresent:(NSString *)dirName;

+ (UIColor *)randomColor;//测试专用

+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;

+ (NSString *)keyChainValue;

#pragma mark 图片处理
+ (UIImage *)imageFromColor:(UIColor *)color Width:(int)width Height:(int) height;
+ (UIImage *)imageFromView:(UIView *)view;

+ (NSAttributedString *)convertHtmlTextToAttributedString:(NSString *)htmlText;


#pragma mark - 图片与颜色转化
+ (UIColor *)getColorFromImage:(UIImage *)image;

+ (UIImage *)createImageWithColor:(UIColor *)color;

//图片裁剪
+ (UIImage *)getImageFromImage:(UIImage*)superImage
                  subImageSize:(CGSize)subImageSize
                  subImageRect:(CGRect)subImageRect;

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark -
+ (BOOL)whetherIsFirstLoadAfterInstalled;

+ (NSString *)floatNumberFomatter:(CGFloat)floatNumber;

+ (NSString *)floatNumberForMoneyFomatter:(CGFloat)floatNumber;

+ (NSString *)dateStringFromDate:(NSDate *)date
                 withFormatStyle:(NSString *)formatStyle;
+ (NSString *)filterHTML:(NSString *)html;

+ (NSString *)moneyFormat:(NSString *)money;

+ (NSString *)currentDateByFormatter:(NSString *)formaterStr;

+ (NSString *)versionNumber;

+ (NSString *)currentDay;
#pragma mark - 

+ (BOOL)isValidatePhone:(NSString *)phone;

+ (BOOL)isValidateVerifyCode:(NSString *)code;

+ (BOOL)isNotReachable;

@end

