//
//  MainCell.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UIView
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;

- (instancetype)initWithImageNmae:(NSString *)imageName titleName:(NSString *)titleName;
@end
