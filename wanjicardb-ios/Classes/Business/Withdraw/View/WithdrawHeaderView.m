//
//  WithdrawHeaderView.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "WithdrawHeaderView.h"
#import "Configure.h"

#define kLeftGap        14
#define kTopGap         10
#define kCurrentHeight  20
#define kBackViewGap    15
#define kBackViewHeight 50
#define kButtonGap      20
#define kButtonHeight   44
#define kWithdrawWidth  40
//@property (nonatomic, strong) UILabel       * currentMoneyLabel;
//@property (nonatomic, strong) UILabel       * moneyLabel;
//@property (nonatomic, strong) UILabel       * withdrawLabel;
//@property (nonatomic, strong) UITextField   * withdrawTF;
//@property (nonatomic, strong) UIButton      * withdrawButton;
@interface WithdrawHeaderView()
{
    UIView      *backView;
}
@end

@implementation WithdrawHeaderView

- (instancetype) init
{
    if (self = [super init])
    {
        _currentMoneyLabel = [[UILabel alloc] init];
        _currentMoneyLabel.font = [UIFont systemFontOfSize:13.0];
        _currentMoneyLabel.textColor = [UIColor grayColor];
        _currentMoneyLabel.text = @"当前余额";
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:20.0];
        _moneyLabel.textColor = [UIHelper colorWithHexColorString:@"ee0944"];
        
        self.backgroundColor =  [UIHelper colorWithHexColorString:@"f6f6f9"];
        
        backView = [[UIView alloc] init];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [[UIColor grayColor] CGColor];
        _withdrawLabel = [[UILabel alloc] init];
        _withdrawLabel.text = @"金额";
        
        _withdrawTF = [[UITextField alloc] init];
        _withdrawTF.placeholder = @"输入提现金额";
        _withdrawTF.keyboardType = UIKeyboardTypeDecimalPad;
        
        _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawButton setTitle:@"申请转账" forState:UIControlStateNormal];
        [_withdrawButton setBackgroundColor:[UIHelper colorWithHexColorString:@"ee0944"]];
        _withdrawButton.layer.cornerRadius = 5;
        
        [self addSubview:_currentMoneyLabel];
        [self addSubview:_moneyLabel];
        [self addSubview:backView];

        [self addSubview:_withdrawButton];
        
        [backView addSubview:_withdrawLabel];
        [backView addSubview:_withdrawTF];
        [self setFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [_currentMoneyLabel setFrame:CGRectMake(kLeftGap, kTopGap, 200, kCurrentHeight)];
    [_moneyLabel setFrame:CGRectMake(kLeftGap, kTopGap + kCurrentHeight, 200, 30)];
    
    [backView setFrame:CGRectMake(0, _moneyLabel.top + _moneyLabel.height + kBackViewGap, kScreenWidth, kBackViewHeight)];
    [_withdrawButton setFrame:CGRectMake(kLeftGap, backView.top + backView.height + kButtonGap, kScreenWidth - kLeftGap * 2, kButtonHeight)];
    
    [_withdrawLabel setFrame:CGRectMake(kLeftGap, 0, kWithdrawWidth, backView.height)];
    [_withdrawTF setFrame:CGRectMake(kLeftGap + kWithdrawWidth, 0, kScreenWidth - kLeftGap - kWithdrawWidth, backView.height)];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
