//
//  FinanceTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "FinanceTableViewCell.h"
#import "Configure.h"

@interface FinanceTableViewCell()

@property (nonatomic, strong) UILabel   * moneyLabel;
@property (nonatomic, strong) UILabel   * moneyTipLabel;

@property (nonatomic, strong) UILabel   * timeLabel;
@property (nonatomic, strong) UILabel   *timeTipLabel;

@end

@implementation FinanceTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(8), kScreenWidth * 0.4, ALD(30))];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.textColor = WJColorDardGray3;
        _moneyLabel.font = WJFont18;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = WJColorDardGray3;
        _timeLabel.font = WJFont18;
        
        _moneyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_moneyLabel.frame), CGRectGetMaxY(_moneyLabel.frame), CGRectGetWidth(_moneyLabel.frame), ALD(18))];
        _moneyTipLabel.textAlignment = NSTextAlignmentLeft;
        _moneyTipLabel.font = WJFont12;
        _moneyTipLabel.textColor = WJColorDardGray9;
    
        _timeTipLabel = [[UILabel alloc] init];
        _timeTipLabel.textAlignment = NSTextAlignmentLeft;
        _timeTipLabel.font = WJFont12;
        _timeTipLabel.textColor = WJColorDardGray9;
        
        [self.contentView addSubview:_moneyLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_moneyTipLabel];
        [self.contentView addSubview:_timeTipLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLabel.text = self.dic[@"Date"];
    [self.timeLabel sizeToFit];
//    CGRectMake(kScreenWidth * 0.4, ALD(8), kScreenWidth * 0.6- ALD(30), ALD(30))
//    [self.timeLabel setFrame:CGRectMake(kScreenWidth - CGRectGetWidth(self.timeLabel.frame) - ALD(15), ALD(8), CGRectGetWidth(self.timeLabel.frame), ALD(30))];
    [self.timeLabel setFrame:CGRectMake(kScreenWidth - 160 - ALD(30), ALD(8), CGRectGetWidth(self.timeLabel.frame), ALD(30))];

    [self.timeTipLabel setFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame), CGRectGetMinY(_moneyTipLabel.frame), CGRectGetWidth(_timeLabel.frame), ALD(18))];
    NSString * cStr = @"";
    switch ([self.dic[@"Type"] intValue]) {
        case 10:
        {
            cStr = @"+";
            self.moneyTipLabel.text = @"售卡结算金额";
            self.timeTipLabel.text = @"售卡结算时间";
        }
            break;
        case 20:
        {
            cStr = @"-";
            self.moneyTipLabel.text = @"提现金额";
            self.timeTipLabel.text = @"提现时间";
        }
            break;
        default:
            break;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",cStr, [WJUtilityMethod floatNumberForMoneyFomatter:[self.dic[@"Amount"] floatValue]]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
