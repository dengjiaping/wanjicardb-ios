//
//  MainCollectionReusableHeaderView.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "MainCollectionReusableHeaderView.h"
#import "Configure.h"

#define kHeaderImageViewGap     15.0
#define kHeaderImageViewWidth   46.0
#define kHeaderGap              10.0
#define kHeaderImageTopGap      10.0

#define kMoneyImageGap          20.0
#define kMoneyImageWidth        14.0
#define kMoneyImageHeight       14.0

@implementation MainCollectionReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 4;
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setTextColor:[UIColor blackColor]];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setTextColor:[UIHelper colorWithHexColorString:@"656565"]];
        [_addressLabel setFont:[UIFont systemFontOfSize:12]];
        
        
        //        [_nameLabel setBackgroundColor:[UIHelper randomColor]];
        //        [_addressLabel setBackgroundColor:[UIHelper randomColor]];
        //        _nameLabel.text = @"F工作室（总部）";
        //        _addressLabel.text = @"北京市朝阳区小营西路15号中乐大厦一层";
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor redColor];
        _moneyIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moneyIcon"]];
        _moneyTitleLabel = [[UILabel alloc] init];
        _moneyTitleLabel.text = @"账户余额";
        _moneyTitleLabel.textColor = [UIColor whiteColor];
        
        _moneyLabel = [[UILabel alloc] init];
        [_moneyLabel setFont:[UIFont systemFontOfSize:40]];
        [_moneyLabel setTextColor:[UIColor whiteColor]];
        [_moneyLabel setText:@"¥0"];//¥
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        
        _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawButton.layer.borderWidth = 1;
        _withdrawButton.layer.borderColor = [[UIColor whiteColor]  CGColor];
        _withdrawButton.backgroundColor = [UIColor redColor];
//        [_withdrawButton addTarget:self action:@selector(withdrawAction) forControlEvents:UIControlEventTouchUpInside];
//        _moneyLabel.backgroundColor = [UIHelper randomColor];
//        _withdrawButton.userInteractionEnabled = NO;
        [self addSubview:_headerImageView];
        [self addSubview:_nameLabel];
        [self addSubview:_addressLabel];
        [self addSubview:_backView];
        
        [_backView addSubview:_moneyIconImageView];
        [_backView addSubview:_moneyTitleLabel];
        [_backView addSubview:_moneyLabel];
//        [_backView addSubview:_withdrawButton];
        //        [self layoutUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [self layoutUI];
}


- (void)layoutUI
{
    [_headerImageView setFrame:CGRectMake( kHeaderImageViewGap, kHeaderImageTopGap, kHeaderImageViewWidth , kHeaderImageViewWidth)];
    [_nameLabel setFrame:CGRectMake(kHeaderImageViewWidth + kHeaderImageViewGap + kHeaderGap, kHeaderImageTopGap, kScreenWidth - 2 * kHeaderImageViewGap, 26)];
    [_addressLabel setFrame:CGRectMake(_nameLabel.left, _nameLabel.top + _nameLabel.height, _nameLabel.width, 20)];
    
    [_backView setFrame:CGRectMake(0, _headerImageView.top + _headerImageView.height + kHeaderImageTopGap, kScreenWidth, 100)];
    [_moneyIconImageView setFrame:CGRectMake(kHeaderImageViewGap, kMoneyImageGap, kMoneyImageWidth, kMoneyImageHeight)];
    
    [_moneyTitleLabel setFrame:CGRectMake(kHeaderImageViewGap + kMoneyImageWidth + 8, kMoneyImageGap, 100, kMoneyImageHeight)];
    
    [_moneyLabel setFrame:CGRectMake(kHeaderImageViewGap, kMoneyImageGap + kMoneyImageHeight + 16, 220, 34)];
    
    [_withdrawButton setFrame:CGRectMake(kScreenWidth - 90, _moneyLabel.top + 4, 70, 30)];
    
    [self setFrame:CGRectMake(0, 0, kScreenWidth, _moneyLabel.top + _moneyLabel.height +kMoneyImageGap)];
}

- (void)withdrawAction
{
    NSLog(@"%s",__func__);
}

@end
