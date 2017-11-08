//
//  OrdersTableViewCell.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/6.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * statusValueLabel;
@property (nonatomic, strong) UILabel * ordersNumberLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * numberValueLabel;
@property (nonatomic, strong) UILabel * ordersMoneyLabel;
@property (nonatomic, strong) UILabel * ordersMoneyValueLabel;
@property (nonatomic, strong) UILabel * buyerAccountLabel;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) NSDictionary * dic;

@property (nonatomic, strong) NSString * keyWord;

@end
