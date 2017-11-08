//
//  MainModel.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface MainModel : CBBaseModel

@property (nonatomic, strong)NSString * imageName;
@property (nonatomic, strong)NSString * titleName;

+ (instancetype )modelWithImageNmae:(NSString *)imageName titleName:(NSString *)titleName;

@end
