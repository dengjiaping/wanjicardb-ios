//
//  payController.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/7/31.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJViewController.h"

@interface WJPayViewController :WJViewController

@property (nonatomic,strong) NSString * clientUserID;
@property (nonatomic,strong) NSString * amount;
@property (nonatomic,strong) NSString * payCode;

@end
