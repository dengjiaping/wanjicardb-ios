//
//  FindPasswordTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "FindPasswordTableViewCell.h"
#import "Configure.h"

#define kTitleLeft      14.0
#define kTitleTop       0.0
#define kTitleHeight    self.height
#define kTitleWidth     70.0
#define kDesLeft        90.0
#define kButtonWidth    140.0

@interface FindPasswordTableViewCell()
{
    UIView * line;
}
@end

@implementation FindPasswordTableViewCell

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
        
        
        _textDesTF = [[UITextField alloc] init];
        _textDesTF.font = [UIFont systemFontOfSize:20];
        [_textDesTF setBorderStyle:UITextBorderStyleNone];
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        
        _securityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_securityCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_securityCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//        _textDesTF.backgroundColor = [UIColor greenColor];
//        _securityCodeButton.backgroundColor = [UIColor blueColor];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_textDesTF];
        [self.contentView addSubview:line];
        [self.contentView addSubview:_securityCodeButton];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSecureity:(BOOL)isSecureity
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    _isSecureityCode = isSecureity;
    return self;
}

- (void)layoutSubviews
{
    [_titleLabel setFrame:CGRectMake(kTitleLeft, kTitleTop, kTitleWidth, kTitleHeight)];
    
    if (_isSecureityCode)
    {
        [_textDesTF setFrame:CGRectMake(kDesLeft, kTitleTop, kScreenWidth - kDesLeft - kButtonWidth, kTitleHeight)];
        [line setFrame:CGRectMake(kScreenWidth - kButtonWidth-1, 0, 1, kTitleHeight)];
        [_securityCodeButton setFrame:CGRectMake(kScreenWidth - kButtonWidth, 0, kButtonWidth, kTitleHeight)];
        
    }else
    {
        [_textDesTF setFrame:CGRectMake(kDesLeft, kTitleTop, kScreenWidth - kDesLeft,kTitleHeight)];
    }
    
    [super layoutSubviews];
}



@end
