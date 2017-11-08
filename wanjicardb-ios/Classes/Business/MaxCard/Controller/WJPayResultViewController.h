//
//  WJPayResultViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/11/3.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJPayResultViewController : CBBaseViewController

@property (nonatomic, assign) BOOL result;

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * message;

@end
