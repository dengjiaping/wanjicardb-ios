//
//  MainCollectionReusableHeaderView.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionReusableHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIImageView    * headerImageView;
@property (nonatomic, strong) UILabel        * nameLabel;
@property (nonatomic, strong) UILabel        * addressLabel;

@property (nonatomic, strong) UIView         * backView;
@property (nonatomic, strong) UIImageView    * moneyIconImageView;
@property (nonatomic, strong) UILabel        * moneyTitleLabel;
@property (nonatomic, strong) UILabel        * moneyLabel;
@property (nonatomic, strong) UIButton       * withdrawButton;

@end
