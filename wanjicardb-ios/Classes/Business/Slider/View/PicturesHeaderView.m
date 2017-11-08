//
//  PicturesHeaderView.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/23.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "PicturesHeaderView.h"
#import "Configure.h"

#define kLeft           12
#define kLabelHeight    40
#define kImageGap       12

@interface PicturesHeaderView()
{
    UIView  *backView;
    UILabel *shopLogoLabel;
    UIView  *line;
}

@end

@implementation PicturesHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        backView = [[UIView alloc] init];
        shopLogoLabel = [[UILabel alloc] init];
        line = [[UIView alloc] init];
        _shopLogoImageView = [[UIImageView alloc] init];
        _shopLogoImageView.userInteractionEnabled = YES;
        
        
        [self addSubview:backView];
        [self addSubview:shopLogoLabel];
        [self addSubview:line];
        [self addSubview:_shopLogoImageView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [backView setFrame:CGRectMake(0, 0, kScreenWidth, 64 + (kScreenWidth - kLeft * 2)*328.0/588.0)];
    [shopLogoLabel setFrame:CGRectMake(kLeft, 0, 200, kLabelHeight)];
    [line setFrame:CGRectMake(0, shopLogoLabel.top + shopLogoLabel.height , kScreenWidth, 1)];
    
    [_shopLogoImageView setFrame:CGRectMake(kLeft, line.top + line.height + kImageGap, kScreenWidth - kLeft * 2,  (kScreenWidth - kLeft * 2)*328.0/588.0)];
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
