//
//  GoodsTableViewCell.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/11.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsTableViewCell;
@protocol GoodsChangeStatusActionDelegate <NSObject>

- (void)goodsCell:(GoodsTableViewCell *)goodsCell status:(GoodsType)goodsType index:(NSInteger)index;

@end


@interface GoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary  *dic;
@property (nonatomic, strong) id<GoodsChangeStatusActionDelegate> goodsDelegate;

@end
