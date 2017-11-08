//
//  MainView.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "MainView.h"
#import <UIKit/UIKit.h>
#import "Configure.h"
#import "MainCollectionViewCell.h"
#import "MainHeaderView.h"
#import "MainCell.h"

#define kHeaderVeiwHeight   160
#define kMaxHeight          110
static NSString *collectionCellID = @"collectionCellID";
static NSString *collectionHeaderViewID = @"collectionHeaderViewID";

@interface MainView()

@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
        _headerView = [[MainHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderVeiwHeight)];
        _maxcardCell = [[MainCell alloc] initWithImageNmae:@"maxcard" titleName:@"扫扫扣费"];
        _quickMarkCell = [[MainCell alloc] initWithImageNmae:@"quickMark" titleName:@"二维码"];
        _ordersCell = [[MainCell alloc] initWithImageNmae:@"orders" titleName:@"订单"];
        _consumptionCell = [[MainCell alloc] initWithImageNmae:@"consumption" titleName:@"消费"];
        _goodsCell = [[MainCell alloc] initWithImageNmae:@"goods" titleName:@"产品"];
        _financeCell = [[MainCell alloc] initWithImageNmae:@"finance" titleName:@"财务"];
        
        _maxcardCell.tag = 10000;
        _quickMarkCell.tag = 10001;
        _ordersCell.tag = 10002;
        _consumptionCell.tag = 10003;
        _goodsCell.tag = 10004;
        _financeCell.tag = 10005;
        
//        _maxcardCell.backgroundColor = [UIHelper randomColor];
//        _quickMarkCell.backgroundColor = [UIHelper randomColor];
//        
//        _ordersCell.backgroundColor = [UIHelper randomColor];
//        _consumptionCell.backgroundColor = [UIHelper randomColor];
//        _goodsCell.backgroundColor = [UIHelper randomColor];
//        _financeCell.backgroundColor = [UIHelper randomColor];
        
        [self addSubview:_headerView];
        [self addSubview:_maxcardCell];
        [self addSubview:_quickMarkCell];
        [self addSubview:_ordersCell];
        [self addSubview:_consumptionCell];
        [self addSubview:_goodsCell];
        [self addSubview:_financeCell];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [_headerView setFrame:CGRectMake(0, 0, kScreenWidth, kHeaderVeiwHeight)];
    [_maxcardCell setFrame:CGRectMake(0, kHeaderVeiwHeight + _headerView.top, kScreenWidth/2, kMaxHeight)];
    [_quickMarkCell setFrame:CGRectMake(kScreenWidth/2, kHeaderVeiwHeight, kScreenWidth/2, kMaxHeight)];
    
    [_ordersCell setFrame:CGRectMake(0, _maxcardCell.top + _maxcardCell.height +10, kScreenWidth/2, kMaxHeight)];
    [_consumptionCell setFrame:CGRectMake(kScreenWidth/2, _ordersCell.top, kScreenWidth/2, kMaxHeight)];
    [_goodsCell setFrame:CGRectMake(0,_ordersCell.top + _ordersCell.height , kScreenWidth/2, kMaxHeight)];
    [_financeCell setFrame:CGRectMake(kScreenWidth/2, _goodsCell.top, kScreenWidth/2, kMaxHeight)];
    [super layoutSubviews];
}


@end
