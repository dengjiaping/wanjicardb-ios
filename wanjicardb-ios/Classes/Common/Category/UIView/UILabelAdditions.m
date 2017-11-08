//
//  UILabelAdditions.m
//  MTFramework
//
//  Created by 陈晓亮 on 13-5-29.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import "UILabelAdditions.h"

@implementation UILabel (Helper)

+ (instancetype)labelWithFrame:(CGRect)frame font:(UIFont *)font andTextColor:(UIColor *)textColor
{
    CGFloat largestHeight = font.ascender - font.descender;
    if (frame.size.height < largestHeight) {
        frame.size.height = ceil(largestHeight);
    }
    UILabel *label = [[self alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    if (textColor) {
        label.textColor = textColor;
    }
    
    return label;
}

@end
