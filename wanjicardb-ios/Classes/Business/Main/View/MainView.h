//
//  MainView.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainHeaderView;
@class MainCell;
@interface MainView : UIView

@property (nonatomic, strong) MainHeaderView    *headerView;
@property (nonatomic, strong) MainCell          *maxcardCell;
@property (nonatomic, strong) MainCell          *quickMarkCell;
@property (nonatomic, strong) MainCell          *ordersCell;
@property (nonatomic, strong) MainCell          *consumptionCell;
@property (nonatomic, strong) MainCell          *goodsCell;
@property (nonatomic, strong) MainCell          *financeCell;

@end
