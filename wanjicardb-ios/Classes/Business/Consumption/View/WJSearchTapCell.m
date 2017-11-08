//
//  WJSearchTapCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSearchTapCell.h"

@interface WJSearchTapCell()

@property (nonatomic, strong)UILabel        * titleLabel;
@property (nonatomic, strong)UIImageView    * moreImageView;

@end

@implementation WJSearchTapCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"333333"];
        self.titleLabel.font = WJFont14;

        self.moreImageView = [[UIImageView alloc] init];
        self.moreImageView.image = [UIImage imageNamed:@"search_default"];//10,10
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        self.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f8f8f8"];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.moreImageView];
    }
    return self;
}

- (void)setTapText:(NSString *)text
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(10000000, 100)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil]
                                     context:nil].size;
    
    CGFloat left = (self.frame.size.width - size.width - ALD(10)) / 2;
    CGFloat top = (self.frame.size.height - ALD(10)) / 2;
    self.titleLabel.text = text;
    [self.titleLabel setFrame:CGRectMake(left, 0, size.width, CGRectGetHeight(self.frame))];
    [self.moreImageView setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), top, ALD(10), ALD(10))];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    int index = (int)self.tag - 30000;
    if( [self.delegate respondsToSelector:@selector(searchTap:didSelectWithindex:)])
    {
//        self.titleLabel.textColor = WJMainColor;
        [self.delegate searchTap:self didSelectWithindex:index];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
//    if (!self.canSelected) {
//        return;
//    }
    
    if (isSelected == YES) {
        self.titleLabel.textColor = WJMainColor;
        self.moreImageView.image = [UIImage imageNamed:@"search_selected"];//10,10
    }else
    {
        self.titleLabel.textColor = WJColorDardGray3;
        self.moreImageView.image = [UIImage imageNamed:@"search_default"];//10,10
    }
    _isSelected = isSelected;
}


@end
