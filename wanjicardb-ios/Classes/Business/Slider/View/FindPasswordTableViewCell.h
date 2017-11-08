//
//  FindPasswordTableViewCell.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UITextField   *textDesTF;
@property (nonatomic, strong) UIButton      *securityCodeButton;

@property (nonatomic, assign) BOOL          isSecureityCode;

@end
