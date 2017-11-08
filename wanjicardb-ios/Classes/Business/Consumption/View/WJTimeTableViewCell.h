//
//  WJTimeTableViewCell.h
//  CardsBusiness
//
//  Created by Lynn on 16/1/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJTimeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel   * tipLabel;
@property (nonatomic, strong) UILabel   * timeLabel;
@property (nonatomic, strong) NSDictionary * dic;

@property (nonatomic, assign) BOOL      needShow;//是否需要显示三角号

@end
