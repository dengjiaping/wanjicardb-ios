//
//  ConsumptionViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//




#import "WJViewController.h"

@class DZNSegmentedControl;

@interface ConsumptionViewController : WJViewController

@property (nonatomic, strong) DZNSegmentedControl * segmentControl;

@property (nonatomic, strong) NSString * startTime;

@property (nonatomic, strong) NSString * endTime;

@end
