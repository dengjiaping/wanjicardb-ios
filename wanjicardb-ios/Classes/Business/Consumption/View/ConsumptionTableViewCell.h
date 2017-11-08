//
//  ConsumptionTableViewCell.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/11.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsumptionWithdrawDelegate <NSObject>

- (void)withdrawIndex:(NSInteger)index;

@end

@interface ConsumptionTableViewCell : UITableViewCell

@property (nonatomic, strong)id<ConsumptionWithdrawDelegate> delegate;

@property (nonatomic, strong) NSDictionary * dic;

@property (nonatomic, strong) NSString * keyWord;
@end
