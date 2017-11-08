//
//  AccountTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "Configure.h"

#define kTitleLeft      14.0
#define kTitleTop       14.0
#define kTitleHeight    20.0
#define kTitleWidth     40.0
#define kDesLeft        80.0


@implementation AccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        
        
        _textDesLabel = [[UILabel alloc] init];
        _textDesLabel.textColor = [UIHelper colorWithHexColorString:@"7c7c7c"];
        _textDesLabel.font = [UIFont systemFontOfSize:20];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_textDesLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [_titleLabel setFrame:CGRectMake(kTitleLeft, kTitleTop, kTitleWidth, kTitleHeight)];
    
    [_textDesLabel setFrame:CGRectMake(kDesLeft, kTitleTop, kScreenWidth - kDesLeft,kTitleHeight)];
    [super layoutSubviews];
}


@end
