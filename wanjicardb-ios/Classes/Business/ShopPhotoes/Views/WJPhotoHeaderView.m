//
//  WJPhotoHeaderView.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPhotoHeaderView.h"

@interface WJPhotoHeaderView()

@property(nonatomic, strong)UIImageView     * headerImageView;
@property(nonatomic, strong)UIButton            * deleteButton;

@end

@implementation WJPhotoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = WJColorViewBg;
        
        UIView * firstHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(40))];
        firstHeaderView.backgroundColor = WJColorViewBg2;
        
        UILabel * firstHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, kScreenWidth - ALD(30), ALD(40))];
        firstHeaderLabel.text = @"首图";
        firstHeaderLabel.font = WJFont13;
        firstHeaderLabel.textColor = WJColorDardGray3;
        [firstHeaderView addSubview:firstHeaderLabel];
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstHeaderView.frame), kScreenWidth, ALD(236))];
        _headerImageView.backgroundColor = WJColorWhite;
        
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[CBPassport cover]] placeholderImage:[UIImage imageNamed:@"defaultPhotoes"]];
        
        
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(kScreenWidth - ALD(22), CGRectGetMinY(_headerImageView.frame), ALD(22), ALD(22))];
        
        [_deleteButton  setImage:[UIImage imageNamed:@"Photoes_Delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * secondHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerImageView.frame) + ALD(15), kScreenWidth, ALD(40))];
        secondHeaderView.backgroundColor  = WJColorViewBg;
        
        
        self.secondtipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(0), CGRectGetMinY(secondHeaderView.frame), kScreenWidth - ALD(0), ALD(40))];
        self.secondtipLabel.textColor = WJColorDardGray3;
        self.secondtipLabel.font = WJFont13;
        self.secondtipLabel.backgroundColor = WJColorWhite;
        
        [self addSubview:firstHeaderView];
        [self addSubview:firstHeaderLabel];
        [self addSubview:_headerImageView];
//        [self addSubview:_deleteButton];
        [self addSubview:secondHeaderView];
        [self addSubview:self.secondtipLabel];
    }
    return self;
}

- (void)deleteImageAction:(UIButton *)button
{
    NSLog(@"%s",__func__);
}

@end
