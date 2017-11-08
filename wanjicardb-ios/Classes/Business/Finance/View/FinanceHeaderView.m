//
//  FinanceHeaderView.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "FinanceHeaderView.h"
#import "Configure.h"

#define kLeftGap     15
@interface FinanceHeaderView()

@property (nonatomic, strong)UILabel    *tipLabel;
@property (nonatomic, strong)UILabel    *moneyLabel;
@property (nonatomic, strong)UIButton  *withdrawButton;

@end

@implementation FinanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WJMainColor;
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(40), kScreenWidth - ALD(30), ALD(15))];
        _tipLabel.textColor = WJColorWhite;
        _tipLabel.text = @"可提现金额（ ¥ ）";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = WJFont12;
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(20)+CGRectGetMaxY(_tipLabel.frame), kScreenWidth - ALD(30), ALD(50))];
        _moneyLabel.textColor = WJColorWhite;
        _moneyLabel.text = [WJUtilityMethod moneyFormat:[CBPassport balance]];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = WJFont50;
        
        _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawButton setTitle:@"申请提现" forState:UIControlStateNormal];
        [_withdrawButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [_withdrawButton setFrame:CGRectMake(kScreenWidth/2 - ALD(60), ALD(48) +CGRectGetMaxY(_moneyLabel.frame) , ALD(120), ALD(40))];
        _withdrawButton.hidden = YES;
        [self addSubview:_tipLabel];
        [self addSubview:_moneyLabel];
        [self addSubview:_withdrawButton];
        
    }
    return self;
}

- (void)refreshMoney
{
    _moneyLabel.text = [WJUtilityMethod moneyFormat:[CBPassport balance]];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
