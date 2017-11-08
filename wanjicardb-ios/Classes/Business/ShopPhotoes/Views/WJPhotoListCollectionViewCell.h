//
//  WJPhotoListCollectionViewCell.h
//  CardsBusiness
//
//  Created by 林有亮 on 16/2/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJAssetModel;

@interface WJPhotoListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)  WJAssetModel            * assetModel;

@property (nonatomic, strong)  UIImageView               * imageView;

@end
