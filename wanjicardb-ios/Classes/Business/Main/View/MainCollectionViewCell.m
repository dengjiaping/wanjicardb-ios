//
//  MainCollectionViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/20.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import "Configure.h"

@implementation MainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/3 - ALD(24), ALD(35), ALD(48), ALD(48))];
        _imageView.userInteractionEnabled = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.top + _imageView.height, self.frame.size.width, ALD(30))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
