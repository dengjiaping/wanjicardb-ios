//
//  WJMainHeaderVIew.m
//  CardsBusiness
//
//  Created by Lynn on 15/12/28.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "WJMainHeaderView.h"

@interface WJMainHeaderView()
{
    UIImageView * orderNumberImageView;
    UILabel     * todaySaleLabel;
}

@end

@implementation WJMainHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SetupUI];
      
    }
    return self;
}

#pragma mark - Action
- (void) SetupUI
{
    self.backgroundColor = WJMainColor;
    
    orderNumberImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(130))/2, ALD(31), ALD(130), ALD(105))];
    orderNumberImageView.image = [UIImage imageNamed:@"main_orders_image"];
    
    todaySaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(30), CGRectGetMaxY(orderNumberImageView.frame) + ALD(38), kScreenWidth - ALD(60), ALD(24))];
//    todaySaleLabel.backgroundColor = [WJUtilityMethod randomColor];
    todaySaleLabel.font = [UIFont systemFontOfSize:12];
    todaySaleLabel.textAlignment = NSTextAlignmentCenter;
    todaySaleLabel.textColor = [UIColor whiteColor];
    todaySaleLabel.text = @"今日营业额( ¥ )";//¥
    
    [self addSubview:orderNumberImageView];
    [self addSubview:todaySaleLabel];
    [self addSubview:self.orderNumberLabel];
    [self addSubview:self.todaySaleMoneyLabel];
    
//    self.orderNumberLabel.backgroundColor = [WJUtilityMethod randomColor];
//    self.todaySaleMoneyLabel.backgroundColor = [WJUtilityMethod randomColor];
}


#pragma mark - Property
- (UILabel *)orderNumberLabel
{
    if (!_orderNumberLabel)
    {
        _orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(30), ALD(31+40), kScreenWidth - ALD(60), ALD(30))];
        _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
        _orderNumberLabel.font = [UIFont boldSystemFontOfSize:30];
        _orderNumberLabel.textColor = [UIColor whiteColor];
    }
    return _orderNumberLabel;
}

- (UILabel *)todaySaleMoneyLabel
{
    if (!_todaySaleMoneyLabel) {
        _todaySaleMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(30), ALD(19) + CGRectGetMaxY(todaySaleLabel.frame), self.orderNumberLabel.frame.size.width, ALD(50))];
        _todaySaleMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _todaySaleMoneyLabel.font = [UIFont boldSystemFontOfSize:50];
        _todaySaleMoneyLabel.textColor = [UIColor whiteColor];
    }
    return _todaySaleMoneyLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
