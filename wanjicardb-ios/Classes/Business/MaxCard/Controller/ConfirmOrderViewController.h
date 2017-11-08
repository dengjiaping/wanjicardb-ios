//
//  ConfirmOrderViewController.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderViewController : UIViewController

@property(nonatomic,strong) UILabel* confirmOrderNumLabel;
@property(nonatomic,strong) UILabel* confirmPayUserPhoneLabel;
@property(nonatomic,strong) UILabel* confirmOrderAmountLabel;
@property(nonatomic,strong) UILabel* confirmPayOrNotLabel;
@property(nonatomic,strong) UIButton* confirmReTryButton;
@end
