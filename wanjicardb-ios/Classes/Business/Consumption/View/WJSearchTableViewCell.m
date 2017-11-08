//
//  WJSearchTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/20.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSearchTableViewCell.h"

@implementation WJSearchTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, kScreenWidth - ALD(30), ALD(44))];
        self.searchLabel.textColor = WJColorDardGray9;
        self.searchLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.searchLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
