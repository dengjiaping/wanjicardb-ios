//
//  UILabelAdditions.h
//  MTFramework
//
//  Created by 陈晓亮 on 13-5-29.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Helper)

/*!
 * @abstract make a UILabel with clear background color and the specified frame, font and text color
 *
 * @param frame frame of UILabel, actual height may be larger, but never smaller
 * @param font font of UILabel
 * @param textColor text color of UILabel
 *
 * @discuss the returned UILabel will have a minimal height of (font.ascender - font.descender), if you
 * specify a smaller height. However, if you want a larger height, it just works.
 */
+ (instancetype)labelWithFrame:(CGRect)frame font:(UIFont *)font andTextColor:(UIColor *)textColor;

@end
