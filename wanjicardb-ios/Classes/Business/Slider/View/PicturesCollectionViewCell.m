//
//  PicturesCollectionViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/23.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "PicturesCollectionViewCell.h"

@implementation PicturesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PictureDefault"]];
        [_imageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
