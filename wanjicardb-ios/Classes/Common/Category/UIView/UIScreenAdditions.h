//
//  UIScreenAdditions.h
//  MTFramework
//
//  Created by xue hui on 3/21/13.
//  Copyright (c) 2013 Sankuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (mainScreen)

/**
 * @abstract main screen scale
 */

+ (CGFloat)mainScreenScale;

/**
 * @abstract if the main screen is retina,return YES。 retina is verified by scale
 */

+ (BOOL)isMainScreenRetina;

/**
 * @abstract screenResolution
 */
+ (NSString *)screenResolution;

@end
