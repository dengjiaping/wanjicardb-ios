//
//  UIAlertView+MTFramework.h
//  MTFramework
//
//  Created by 陈晓亮 on 13-7-6.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MTAlertViewDismissBlock)(NSInteger buttonIndex);
typedef void (^MTAlertViewCancelBlock)();

@interface UIAlertView (MTFramework) <UIAlertViewDelegate>

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)titleArray
                              dismissed:(MTAlertViewDismissBlock)dismissBlock
                               canceled:(MTAlertViewCancelBlock)cancelBlock;

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message;

@end
