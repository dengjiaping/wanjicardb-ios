//
//  SugestViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBBaseViewController.h"
@class MBProgressHUD;

@interface SugestViewController : CBBaseViewController
@property(nonatomic ,strong) UILabel *adviceToplabel;
@property(nonatomic ,strong) UITextView *adviceTextView;
@property(nonatomic ,strong) UIButton *adviceCommitBtn;
@property(nonatomic ,strong) UIAlertView *adviceAlertButton;
@property(nonatomic,strong)  MBProgressHUD *adviceProgressButton;

- (void)showCustomDialog;
@end
