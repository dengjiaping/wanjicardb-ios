//
//  UIHelper.h
//  NewApp
//
//  Created by Lynn on 15/7/2.
//  Copyright (c) 2015年 NeoLynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenFrame [UIScreen mainScreen].bounds


#define ALD(x)      (CGFloat)(x * kScreenWidth/375.0)

@interface UIHelper : NSObject

+ (UIColor *)getColorFromImage:(UIImage *)image;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIColor *)mainTextColor;

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;

+ (UIColor *)getUIColorWithRed:(int)r
                         green:(int)g
                          blue:(int)b;

+ (UIColor *)getUIColorWithRed:(int)r
                         green:(int)g
                          blue:(int)b
                         alpha:(float)alpha;

+ (UIColor *)getMainBackgroundColor;
+ (UIColor *)getStatusBarTextColor;

+ (UINavigationController *)cbNavigationController;
@end
