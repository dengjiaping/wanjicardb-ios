//
//  BranchModel.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/24.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface CBBranchModel : CBBaseModel

@property (nonatomic, strong)NSString * address;
@property (nonatomic, strong)NSString * businessTime;
@property (nonatomic, strong)NSArray  * category;
@property (nonatomic, strong)NSString * cover;
@property (nonatomic, strong)NSString * distance;
@property (nonatomic, strong)NSString * distanceStr;
@property (nonatomic, strong)NSString * branchID;
@property (nonatomic, strong)NSString * latitude;
@property (nonatomic, strong)NSString * longitude;
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * phone;
@property (nonatomic, strong)NSString * totalSale;

@end
