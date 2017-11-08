//
//  WithdrawTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "WithdrawTableViewCell.h"
#import "Configure.h"

@implementation WithdrawTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        
//        _moneyLabel.textColor = [UIColor blackColor];
        
        
        [self.contentView addSubview:_moneyLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_statusLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [_moneyLabel setFrame:CGRectMake(0, 0, kScreenWidth * 0.3, self.height)];
    [_timeLabel setFrame:CGRectMake(_moneyLabel.width, 0, kScreenWidth * 0.4, self.height)];
    [_statusLabel setFrame:CGRectMake(kScreenWidth * 0.7, 0, kScreenWidth *0.3, self.height)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
