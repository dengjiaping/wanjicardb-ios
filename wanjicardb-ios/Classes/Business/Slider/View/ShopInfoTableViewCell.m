//
//  ShopInfoTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ShopInfoTableViewCell.h"
#import "Configure.h"

#define kTitleLeft      14.0
#define kTitleTop       6.0
#define kTitleHeight    (self.height - 2 * kTitleTop)
#define kTitleWidth     60.0


@implementation ShopInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.backgroundColor = [UIHelper randomColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
        _textTF = [[UITextField alloc] init];
        _textTF.enabled = NO;
//        _textTF.backgroundColor = [UIHelper randomColor];
        _textTF.borderStyle = UITextBorderStyleNone;
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_textTF];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_nameLabel setFrame:CGRectMake(kTitleLeft, kTitleTop, kTitleWidth, kTitleHeight)];
    [_textTF setFrame:CGRectMake(kTitleLeft + kTitleWidth, kTitleTop, kScreenWidth - kTitleLeft - kTitleWidth, kTitleHeight)];

}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
