//
//  CBScan.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/3.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface CBScan : CBBaseModel<MTLJSONSerializing>

@property(strong,nonatomic) NSString* userId;
@property(strong,nonatomic) NSString* amount;
@property(strong,nonatomic) NSString* userName;
@property(nonatomic,strong) NSString* userPhone;
@property(nonatomic,strong) NSString* pictureAddress;
// confirm-order


@end
