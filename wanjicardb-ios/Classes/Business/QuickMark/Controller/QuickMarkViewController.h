//
//  QuickMarkViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseViewController.h"
@class MBProgressHUD;
#import "CBScanClient.h"
@interface QuickMarkViewController : CBBaseViewController

@property(nonatomic,strong) UIImageView * QRcodeView;

@property(nonatomic,strong) MBProgressHUD *payAlertHUD;
- (void)showCustomDialog:(NSString *)msg;

@end
