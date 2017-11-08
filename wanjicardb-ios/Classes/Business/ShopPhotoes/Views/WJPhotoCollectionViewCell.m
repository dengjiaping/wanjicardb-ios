//
//  WJPhotoCollectionViewCell.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPhotoCollectionViewCell.h"

@interface WJPhotoCollectionViewCell()

@end

@implementation WJPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _alphaImageView = [[UIImageView alloc] initWithFrame:_photoesImageView.frame];
        _alphaImageView.backgroundColor = [UIColor whiteColor];
        _alphaImageView.alpha = .5;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"Photoes_Delete"] forState:UIControlStateNormal];
        [_deleteButton setFrame:CGRectMake(frame.size.width - ALD(22), 0, ALD(22), ALD(22))];
        [_deleteButton addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_photoesImageView];
        [self.contentView addSubview:_alphaImageView];
        [self.contentView addSubview:_deleteButton];
    }
    return self;
}

- (void)deletePhotoAction:(UIButton *)button
{
    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(deleteImageWithID:)]) {
        [self.delegate deleteImageWithID:[NSString stringWithFormat:@"%ld",self.tag - 10000]];
    }
}

- (void)buttonNeedHidden:(BOOL)isNeedHidden
{
    if (isNeedHidden) {
        self.alphaImageView.hidden = YES;
        self.deleteButton.hidden = YES;
    }else
    {
        self.alphaImageView.hidden= NO;
        self.deleteButton.hidden = NO;
    }
}


@end
