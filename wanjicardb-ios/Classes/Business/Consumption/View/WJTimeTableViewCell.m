//
//  WJTimeTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJTimeTableViewCell.h"

@implementation WJTimeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(16), 0, kScreenWidth / 2 - ALD(15), ALD(44))];
        self.tipLabel.font = WJFont13;
        self.tipLabel.textColor = WJColorDardGray3;
        [self.contentView addSubview:self.tipLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = WJFont13;
        self.timeLabel.textColor = WJColorDardGray9;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.timeLabel setFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2 - ALD(30), ALD(44))];
//        self.timeLabel.backgroundColor = [WJUtilityMethod randomColor];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

//_dataArray = @[@{@"titleText":((self.timeType == WJBusinessTime)?@"开店时间":@"起始时间"),@"time":@""},

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tipLabel.text = self.dic[@"titleText"];
    self.timeLabel.text = self.dic[@"time"];
    
    
}



@end
