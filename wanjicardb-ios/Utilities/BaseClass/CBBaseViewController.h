//
//  CBBaseViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/16.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface CBBaseViewController : UIViewController

@property (nonatomic, strong) MBProgressHUD * progressHUD;

- (void)showHUDWithText:(NSString *)text;


@end
