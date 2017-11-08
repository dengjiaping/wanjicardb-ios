//
//  SlidingTableViewCell.h
//  RDMApp
//
//  Created by luther.cui on 14/12/3.
//  Copyright (c) 2014年 Youku.Inc. All rights reserved.
//
/**
 SlidingTableViewCell
 侧滑页面SlidingTableViewCell
 */
#import <UIKit/UIKit.h>

@interface SlidingTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *desLabel;

/**
 @brief setTitleStr 设置标题
 @param <string>
 @param <无>
 @return void
 @exception <无>
 */
-(void)setTitleStr:(NSString*)string;
/**
 *  @author cuiliangliang, 14-12-25 17:12:45
 *
 *  @brief  showSelectBackGround
 *
 *  @param isShow
 *
 *  @since 1.0
 */
-(void)showSelectBackGround:(BOOL)isShow;
@end
