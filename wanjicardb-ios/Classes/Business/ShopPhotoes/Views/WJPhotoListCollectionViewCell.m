//
//  WJPhotoListCollectionViewCell.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/2/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPhotoListCollectionViewCell.h"
#import "WJAssetLibraryManager.h"
#import "WJAssetModel.h"

@interface WJPhotoListCollectionViewCell()

@end

@implementation WJPhotoListCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _imageView.backgroundColor = [WJUtilityMethod randomColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setAssetModel:(WJAssetModel *)photoModel
{
    _assetModel = photoModel;
    self.imageView.image = photoModel.image;
//    __weak WJPhotoListCollectionViewCell * weakSelf = self;
//     [[WJAssetLibraryManager alloc] imageByAssetURL:photoModel.assetUrl callback:^(UIImage *image, NSError *error) {
//         if (image) {
//             weakSelf.imageView.image = image;
//         } else {
//             weakSelf.imageView.image = nil;
//         }
//         
//    }];
    
}

@end
