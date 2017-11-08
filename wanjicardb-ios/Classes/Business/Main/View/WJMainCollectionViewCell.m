//
//  WJMainCollectionViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMainCollectionViewCell.h"

@implementation WJMainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PictureAdd"]];
        [_imageView setFrame:CGRectMake(self.frame.size.width/2 - ALD(24), 30, ALD(48), ALD(48))];
        _imageView.userInteractionEnabled = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.top + _imageView.height, self.frame.size.width, 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = WJColorDardGray3;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}


@end
