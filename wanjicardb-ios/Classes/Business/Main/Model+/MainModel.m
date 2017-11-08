//
//  MainModel.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

+ (instancetype)modelWithImageNmae:(NSString *)imageName titleName:(NSString *)titleName
{
    MainModel * model = [[MainModel alloc] init];
    model.imageName = imageName;
    model.titleName = titleName;
    return model;
}

@end
