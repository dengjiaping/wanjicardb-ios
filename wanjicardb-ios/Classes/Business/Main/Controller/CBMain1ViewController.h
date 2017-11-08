//
//  CBMain1ViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/20.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseViewController.h"

//@class MainView;
@class MainCollectionReusableHeaderView;

@interface CBMain1ViewController : CBBaseViewController

@property (nonatomic, strong) MainCollectionReusableHeaderView * headerView;
@property (nonatomic, strong) UICollectionView * collectionView;

@end
